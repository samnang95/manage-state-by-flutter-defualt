package com.example.manage_state

import android.Manifest
import android.content.pm.PackageManager
import android.graphics.SurfaceTexture
import android.util.Log
import android.view.Surface
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.manage_state/camera"
    private val CAMERA_REQUEST_CODE = 1001

    private var pendingResult: MethodChannel.Result? = null

    private var isFrontCamera = false
    private var cameraProvider: ProcessCameraProvider? = null
    private var preview: Preview? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startCamera") {
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                    startCameraFeed(flutterEngine, result)
                } else {
                    pendingResult = result
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), CAMERA_REQUEST_CODE)
                }
            } else if (call.method == "switchCamera") {
                isFrontCamera = !isFrontCamera
                bindCamera()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == CAMERA_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                this.flutterEngine?.let { engine ->
                    pendingResult?.let { result ->
                        startCameraFeed(engine, result)
                    }
                }
            } else {
                pendingResult?.error("PERMISSION_DENIED", "Camera permission denied", null)
            }
            pendingResult = null
        }
    }

    private fun startCameraFeed(flutterEngine: FlutterEngine, result: MethodChannel.Result) {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            try {
                cameraProvider = cameraProviderFuture.get()

                // Create a Flutter Texture
                val textureEntry: TextureRegistry.SurfaceTextureEntry = flutterEngine.renderer.createSurfaceTexture()
                val surfaceTexture: SurfaceTexture = textureEntry.surfaceTexture()

                preview = Preview.Builder().build().also {
                    it.setSurfaceProvider { request ->
                        surfaceTexture.setDefaultBufferSize(request.resolution.width, request.resolution.height)
                        val surface = Surface(surfaceTexture)
                        request.provideSurface(surface, ContextCompat.getMainExecutor(this)) {
                            surface.release()
                        }
                    }
                }

                bindCamera()

                // Return texture ID to Flutter
                result.success(textureEntry.id())
            } catch (exc: Exception) {
                Log.e("NativeCamera", "Use case binding failed", exc)
                result.error("CAMERA_ERROR", exc.message, null)
            }
        }, ContextCompat.getMainExecutor(this))
    }
    private fun bindCamera() {
        val provider = cameraProvider ?: return
        val currentPreview = preview ?: return

        val cameraSelector = if (isFrontCamera) {
            CameraSelector.DEFAULT_FRONT_CAMERA
        } else {
            CameraSelector.DEFAULT_BACK_CAMERA
        }

        provider.unbindAll()
        provider.bindToLifecycle(this, cameraSelector, currentPreview)
    }
}
