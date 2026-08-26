import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, UIDocumentPickerDelegate {
  private var cameraHandler: CameraStreamHandler?
  private var pendingFileResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let registrar = self.registrar(forPlugin: "com.example.manage_state")!
    let cameraChannel = FlutterMethodChannel(name: "com.example.manage_state/camera",
                                             binaryMessenger: registrar.messenger())
    let fileChannel = FlutterMethodChannel(name: "com.example.manage_state/file",
                                           binaryMessenger: registrar.messenger())
    
    cameraHandler = CameraStreamHandler(textureRegistry: registrar.textures())
    
    cameraChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "startCamera" {
        if let textureId = self?.cameraHandler?.startCamera() {
          result(textureId)
        } else {
          result(FlutterError(code: "CAMERA_ERROR", message: "Failed to start camera", details: nil))
        }
      } else if call.method == "switchCamera" {
        self?.cameraHandler?.switchCamera()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    fileChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "pickFile" {
        self?.pendingFileResult = result
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPicker.delegate = self
        var rootVC = self?.window?.rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }
                .first?.rootViewController
        }
        if rootVC == nil {
            rootVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
        }

        if let viewController = rootVC {
          viewController.present(documentPicker, animated: true, completion: nil)
        } else {
          result(FlutterError(code: "UI_ERROR", message: "Could not find root view controller", details: nil))
          self?.pendingFileResult = nil
        }
      } else if call.method == "saveFile" {
        guard let args = call.arguments as? [String: Any],
              let tempPath = args["tempPath"] as? String,
              let fileName = args["fileName"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing arguments", details: nil))
          return
        }
        
        let fileManager = FileManager.default
        let tempUrl = URL(fileURLWithPath: tempPath)
        
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let permanentUrl = documentDirectory.appendingPathComponent(fileName)
            
            if fileManager.fileExists(atPath: permanentUrl.path) {
                try fileManager.removeItem(at: permanentUrl)
            }
            
            try fileManager.copyItem(at: tempUrl, to: permanentUrl)
            result(permanentUrl.path)
        } catch {
            result(FlutterError(code: "FILE_ERROR", message: "Failed to save file", details: error.localizedDescription))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // MARK: - UIDocumentPickerDelegate
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let url = urls.first else {
      pendingFileResult?(nil)
      pendingFileResult = nil
      return
    }
    
    // .import mode already copies the file to a temporary location accessible by the app.
    // We can just return the path.
    pendingFileResult?(url.path)
    pendingFileResult = nil
  }
  
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pendingFileResult?(nil)
    pendingFileResult = nil
  }
}

class CameraStreamHandler: NSObject, FlutterTexture, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession: AVCaptureSession?
    private var currentInput: AVCaptureDeviceInput?
    private var latestPixelBuffer: CVPixelBuffer?
    private var textureRegistry: FlutterTextureRegistry?
    private var textureId: Int64?
    
    private var isFrontCamera = false
    
    init(textureRegistry: FlutterTextureRegistry) {
        self.textureRegistry = textureRegistry
        super.init()
    }
    
    func startCamera() -> Int64? {
        // Request permissions
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .notDetermined {
            let semaphore = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .video) { _ in
                semaphore.signal()
            }
            semaphore.wait()
        } else if status != .authorized {
            return nil
        }
        
        captureSession = AVCaptureSession()
        guard let session = captureSession else { return nil }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        
        setupCameraInput(session: session)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
        ]
        
        let queue = DispatchQueue(label: "camera_frame_queue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        // Ensure proper orientation
        if let connection = videoOutput.connection(with: .video) {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
        
        // Register texture with Flutter
        if let registry = textureRegistry {
            textureId = registry.register(self)
        }
        
        return textureId
    }
    
    private func setupCameraInput(session: AVCaptureSession) {
        if let current = currentInput {
            session.removeInput(current)
        }
        
        let position: AVCaptureDevice.Position = isFrontCamera ? .front : .back
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
                currentInput = input
            }
        } catch {
            print("Failed to set camera input: \(error)")
        }
    }
    
    func switchCamera() {
        guard let session = captureSession else { return }
        isFrontCamera = !isFrontCamera
        
        session.beginConfiguration()
        setupCameraInput(session: session)
        
        if let output = session.outputs.first as? AVCaptureVideoDataOutput,
           let connection = output.connection(with: .video) {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = isFrontCamera
            }
        }
        
        session.commitConfiguration()
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        latestPixelBuffer = pixelBuffer
        
        if let id = textureId {
            textureRegistry?.textureFrameAvailable(id)
        }
    }
    
    // MARK: - FlutterTexture
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        if let buffer = latestPixelBuffer {
            return Unmanaged.passRetained(buffer)
        }
        return nil
    }
}
