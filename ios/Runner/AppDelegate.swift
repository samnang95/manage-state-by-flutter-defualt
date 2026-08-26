import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var cameraHandler: CameraStreamHandler?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let registrar = self.registrar(forPlugin: "com.example.manage_state")!
    let cameraChannel = FlutterMethodChannel(name: "com.example.manage_state/camera",
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

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
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
