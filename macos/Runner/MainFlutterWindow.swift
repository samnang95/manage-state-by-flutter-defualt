import Cocoa
import FlutterMacOS
import AVFoundation

class MainFlutterWindow: NSWindow {
  private var cameraHandler: CameraStreamHandler?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let cameraChannel = FlutterMethodChannel(
      name: "com.example.manage_state/camera",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    cameraHandler = CameraStreamHandler(textureRegistry: flutterViewController.engine)

    cameraChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "startCamera" {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .notDetermined {
          AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
              if granted {
                if let textureId = self?.cameraHandler?.startCamera() {
                  result(textureId)
                } else {
                  result(FlutterError(code: "CAMERA_ERROR", message: "Failed to start camera", details: nil))
                }
              } else {
                result(FlutterError(code: "PERMISSION_DENIED", message: "Camera permission denied", details: nil))
              }
            }
          }
        } else if status == .authorized {
          if let textureId = self?.cameraHandler?.startCamera() {
            result(textureId)
          } else {
            result(FlutterError(code: "CAMERA_ERROR", message: "Failed to start camera", details: nil))
          }
        } else {
          result(FlutterError(code: "PERMISSION_DENIED", message: "Camera permission not granted", details: nil))
        }
      } else if call.method == "switchCamera" {
        self?.cameraHandler?.switchCamera()
        result(self?.cameraHandler?.isMirrorEnabled)
      } else if call.method == "toggleMirror" {
        let isMirrored = self?.cameraHandler?.toggleMirror() ?? false
        result(isMirrored)
      } else if call.method == "stopCamera" {
        self?.cameraHandler?.stopCamera()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    super.awakeFromNib()
  }
}

class CameraStreamHandler: NSObject, FlutterTexture, AVCaptureVideoDataOutputSampleBufferDelegate {
  private weak var textureRegistry: FlutterTextureRegistry?
  private var textureId: Int64?
  private var captureSession: AVCaptureSession?
  private var currentInput: AVCaptureDeviceInput?
  private var latestPixelBuffer: CVPixelBuffer?
  private var currentDeviceIndex = 0
  var isMirrorEnabled: Bool = true

  init(textureRegistry: FlutterTextureRegistry) {
    self.textureRegistry = textureRegistry
    super.init()
  }

  private var availableDevices: [AVCaptureDevice] {
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInWideAngleCamera, .externalUnknown],
      mediaType: .video,
      position: .unspecified
    )
    return discoverySession.devices
  }

  func startCamera() -> Int64? {
    if let id = textureId {
      return id
    }

    let session = AVCaptureSession()
    captureSession = session

    session.beginConfiguration()
    if session.canSetSessionPreset(.vga640x480) {
      session.sessionPreset = .vga640x480
    } else if session.canSetSessionPreset(.medium) {
      session.sessionPreset = .medium
    }

    setupCameraInput(session: session)

    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.alwaysDiscardsLateVideoFrames = true
    videoOutput.videoSettings = [
      kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
    ]

    let queue = DispatchQueue(label: "camera_frame_queue_macos")
    videoOutput.setSampleBufferDelegate(self, queue: queue)

    if session.canAddOutput(videoOutput) {
      session.addOutput(videoOutput)
    }

    if let connection = videoOutput.connection(with: .video) {
      if connection.isVideoMirroringSupported {
        connection.automaticallyAdjustsVideoMirroring = false
        connection.isVideoMirrored = isMirrorEnabled
      }
    }

    session.commitConfiguration()

    DispatchQueue.global(qos: .userInitiated).async {
      session.startRunning()
    }

    if let registry = textureRegistry {
      textureId = registry.register(self)
    }

    return textureId
  }

  private func setupCameraInput(session: AVCaptureSession) {
    if let current = currentInput {
      session.removeInput(current)
      currentInput = nil
    }

    let devices = availableDevices
    let device: AVCaptureDevice?
    if !devices.isEmpty {
      device = devices[currentDeviceIndex % devices.count]
    } else {
      device = AVCaptureDevice.default(for: .video)
    }

    guard let targetDevice = device else {
      print("No video capture devices found on macOS")
      return
    }

    do {
      let input = try AVCaptureDeviceInput(device: targetDevice)
      if session.canAddInput(input) {
        session.addInput(input)
        currentInput = input
      }
    } catch {
      print("Failed to initialize camera input on macOS: \(error)")
    }
  }

  func switchCamera() {
    guard let session = captureSession else { return }
    let devices = availableDevices
    guard devices.count > 1 else { return }

    currentDeviceIndex = (currentDeviceIndex + 1) % devices.count

    session.beginConfiguration()
    setupCameraInput(session: session)
    updateMirroring()
    session.commitConfiguration()
  }

  func toggleMirror() -> Bool {
    isMirrorEnabled = !isMirrorEnabled
    updateMirroring()
    return isMirrorEnabled
  }

  private func updateMirroring() {
    guard let session = captureSession,
          let output = session.outputs.first as? AVCaptureVideoDataOutput,
          let connection = output.connection(with: .video) else { return }
    if connection.isVideoMirroringSupported {
      connection.automaticallyAdjustsVideoMirroring = false
      connection.isVideoMirrored = isMirrorEnabled
    }
  }

  func stopCamera() {
    if let session = captureSession {
      if session.isRunning {
        session.stopRunning()
      }
      for input in session.inputs {
        session.removeInput(input)
      }
      for output in session.outputs {
        session.removeOutput(output)
      }
      captureSession = nil
    }
    currentInput = nil
    if let id = textureId {
      textureRegistry?.unregisterTexture(id)
      textureId = nil
    }
    latestPixelBuffer = nil
  }

  // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
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
