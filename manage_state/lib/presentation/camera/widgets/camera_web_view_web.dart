// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'camera_web_view_stub.dart';
export 'camera_web_view_stub.dart' show WebCameraController;

Widget createWebCameraView({Key? key, dynamic controllerKey}) {
  return WebCameraPreview(
    key: (controllerKey is Key) ? controllerKey : key,
  );
}

class WebCameraPreview extends StatefulWidget {
  const WebCameraPreview({super.key});

  @override
  State<WebCameraPreview> createState() => WebCameraPreviewState();
}

class WebCameraPreviewState extends State<WebCameraPreview> implements WebCameraController {
  html.VideoElement? _videoElement;
  html.MediaStream? _stream;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isFrontCamera = true;
  bool _isMirrored = true;
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'web-camera-view-${DateTime.now().millisecondsSinceEpoch}';
    final video = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.transform = 'scaleX(-1)';
    _videoElement = video;

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _videoElement!,
    );

    _initCamera();
  }

  Future<void> _initCamera() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _stopStream();

    try {
      final constraints = {
        'video': {
          'facingMode': _isFrontCamera ? 'user' : 'environment',
        },
        'audio': false,
      };

      final stream = await html.window.navigator.mediaDevices?.getUserMedia(constraints);
      if (!mounted) {
        if (stream != null) {
          for (final track in stream.getTracks()) {
            track.stop();
          }
        }
        return;
      }
      if (stream != null) {
        _stream = stream;
        _globalWebStream = stream;
        _globalVideoElement = _videoElement;
        _videoElement?.srcObject = stream;
        _applyMirror();

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No camera device found.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Camera access error: $e\nPlease grant camera permissions in your browser.';
        });
      }
    }
  }

  void _applyMirror() {
    _videoElement?.style.transform = _isMirrored ? 'scaleX(-1)' : 'none';
  }

  @override
  bool toggleMirror() {
    _isMirrored = !_isMirrored;
    _applyMirror();
    return _isMirrored;
  }

  @override
  void switchCamera() {
    _isFrontCamera = !_isFrontCamera;
    _isMirrored = _isFrontCamera;
    _applyMirror();
    _initCamera();
  }

  @override
  Future<Uint8List?> takePhoto() async {
    try {
      if (_videoElement == null) {
        debugPrint('takePhoto error: _videoElement is null');
        return null;
      }
      final width = _videoElement!.videoWidth > 0
          ? _videoElement!.videoWidth
          : (_videoElement!.clientWidth > 0 ? _videoElement!.clientWidth : 640);
      final height = _videoElement!.videoHeight > 0
          ? _videoElement!.videoHeight
          : (_videoElement!.clientHeight > 0 ? _videoElement!.clientHeight : 480);

      final canvas = html.CanvasElement(width: width, height: height);
      final ctx = canvas.context2D;
      if (_isMirrored) {
        ctx.translate(width, 0);
        ctx.scale(-1, 1);
      }
      ctx.drawImage(_videoElement!, 0, 0);
      final dataUrl = canvas.toDataUrl('image/jpeg', 0.92);
      final commaIndex = dataUrl.indexOf(',');
      if (commaIndex != -1) {
        final base64String = dataUrl.substring(commaIndex + 1);
        final bytes = base64Decode(base64String);
        // Turn off camera hardware immediately after photo capture!
        _stopStream();
        return bytes;
      }
      return null;
    } catch (e, stack) {
      debugPrint('takePhoto exception: $e\n$stack');
      return null;
    }
  }

  @override
  void savePhotoLocally(Uint8List bytes, String filename) {
    saveWebPhotoLocally(bytes, filename);
  }

  void _stopStream() {
    stopWebCamera();
    if (_videoElement != null) {
      try {
        _videoElement!.pause();
        _videoElement!.srcObject = null;
      } catch (_) {}
    }
    if (_stream != null) {
      try {
        for (final track in _stream!.getTracks()) {
          track.stop();
        }
      } catch (_) {}
      _stream = null;
    }
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off, color: Colors.white54, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initCamera,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return HtmlElementView(viewType: _viewType);
  }
}

void saveWebPhotoLocally(Uint8List bytes, String filename) {
  final blob = html.Blob([bytes], 'image/jpeg');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = filename
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  Future.delayed(const Duration(seconds: 2), () {
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  });
}

html.MediaStream? _globalWebStream;
html.VideoElement? _globalVideoElement;

void stopWebCamera() {
  if (_globalVideoElement != null) {
    try {
      _globalVideoElement!.pause();
      _globalVideoElement!.srcObject = null;
    } catch (_) {}
    _globalVideoElement = null;
  }
  if (_globalWebStream != null) {
    try {
      for (final track in _globalWebStream!.getTracks()) {
        track.stop();
      }
    } catch (_) {}
    _globalWebStream = null;
  }
}
