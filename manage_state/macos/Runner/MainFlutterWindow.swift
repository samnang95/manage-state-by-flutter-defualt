import Cocoa
import FlutterMacOS
import AVFoundation
import CoreImage

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
      } else if call.method == "takePhoto" {
        if let photoData = self?.cameraHandler?.takePhoto() {
          result(photoData)
        } else {
          result(FlutterError(code: "CAPTURE_ERROR", message: "Failed to capture photo frame", details: nil))
        }
      } else if call.method == "resumeCamera" {
        self?.cameraHandler?.resumeCamera()
        result(nil)
      } else if call.method == "stopCamera" {
        self?.cameraHandler?.stopCamera()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    let fileChannel = FlutterMethodChannel(
      name: "com.example.manage_state/file",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    fileChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "saveImageBytes" {
        guard let args = call.arguments as? [String: Any],
              let fileName = args["fileName"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing arguments", details: nil))
          return
        }
        let data: Data
        if let typedData = args["bytes"] as? FlutterStandardTypedData {
          data = typedData.data
        } else if let rawData = args["bytes"] as? Data {
          data = rawData
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing or invalid bytes", details: nil))
          return
        }
        let fileManager = FileManager.default
        let candidates: [FileManager.SearchPathDirectory] = [.picturesDirectory, .downloadsDirectory, .documentDirectory]
        var savedPath: String?
        var lastError: Error?

        for dir in candidates {
          if let dirUrl = try? fileManager.url(for: dir, in: .userDomainMask, appropriateFor: nil, create: true) {
            let fileUrl = dirUrl.appendingPathComponent(fileName)
            do {
              try data.write(to: fileUrl, options: .atomic)
              savedPath = fileUrl.path
              break
            } catch {
              lastError = error
            }
          }
        }

        if let path = savedPath {
          result(path)
        } else {
          result(FlutterError(code: "FILE_ERROR", message: "Failed to save image: \(lastError?.localizedDescription ?? "Unknown error")", details: nil))
        }
      } else if call.method == "revealInFinder" {
        guard let args = call.arguments as? [String: Any],
              let filePath = args["path"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing path", details: nil))
          return
        }
        let url = URL(fileURLWithPath: filePath)
        NSWorkspace.shared.activateFileViewerSelecting([url])
        result(true)
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
          result(FlutterError(code: "FILE_ERROR", message: "Failed to save file: \(error.localizedDescription)", details: nil))
        }
      } else if call.method == "pickFile" {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        if panel.runModal() == .OK, let url = panel.url {
          result(url.path)
        } else {
          result(nil)
        }
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
  private var isConnectionMirrored: Bool = false
  private let bufferLock = NSLock()

  init(textureRegistry: FlutterTextureRegistry) {
    self.textureRegistry = textureRegistry
    super.init()
  }

  private var availableDevices: [AVCaptureDevice] {
    var deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera]
    if #available(macOS 14.0, *) {
      deviceTypes.append(.external)
      deviceTypes.append(.continuityCamera)
    } else {
      deviceTypes.append(.externalUnknown)
    }
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: deviceTypes,
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
    if session.canSetSessionPreset(.hd1280x720) {
      session.sessionPreset = .hd1280x720
    } else if session.canSetSessionPreset(.vga640x480) {
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
        isConnectionMirrored = isMirrorEnabled
      } else {
        isConnectionMirrored = false
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
      isConnectionMirrored = isMirrorEnabled
    } else {
      isConnectionMirrored = false
    }
  }

  func resumeCamera() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      if let session = self?.captureSession, !session.isRunning {
        session.startRunning()
      }
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
    bufferLock.lock()
    latestPixelBuffer = nil
    bufferLock.unlock()
  }

  // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    bufferLock.lock()
    latestPixelBuffer = pixelBuffer
    bufferLock.unlock()

    if let id = textureId {
      textureRegistry?.textureFrameAvailable(id)
    }
  }

  // MARK: - FlutterTexture
  func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    bufferLock.lock()
    defer { bufferLock.unlock() }
    if let buffer = latestPixelBuffer {
      return Unmanaged.passRetained(buffer)
    }
    return nil
  }

  func takePhoto() -> FlutterStandardTypedData? {
    bufferLock.lock()
    let buffer = latestPixelBuffer
    bufferLock.unlock()

    guard let buffer = buffer else { return nil }
    var ciImage = CIImage(cvPixelBuffer: buffer)
    if isMirrorEnabled && !isConnectionMirrored {
      ciImage = ciImage.transformed(by: CGAffineTransform(scaleX: -1, y: 1).translatedBy(x: -ciImage.extent.width, y: 0))
    }
    let context = CIContext(options: nil)
    guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
          let jpegData = context.jpegRepresentation(of: ciImage, colorSpace: colorSpace, options: [:]) else {
      return nil
    }

    // Clean hardware shutdown: Stop the capture session so the webcam and LED indicator turn off immediately
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      if let session = self?.captureSession, session.isRunning {
        session.stopRunning()
      }
    }

    return FlutterStandardTypedData(bytes: jpegData)
  }
}
