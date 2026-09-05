package com.example.manage_state

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.SurfaceTexture
import android.net.Uri
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
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import com.facebook.CallbackManager
import com.facebook.FacebookCallback
import com.facebook.FacebookException
import com.facebook.login.LoginManager
import com.facebook.login.LoginResult
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.manage_state/camera"
    private val FILE_CHANNEL = "com.example.manage_state/file"
    private val AUTH_CHANNEL = "com.example.manage_state/auth"
    private val CAMERA_REQUEST_CODE = 1001
    private val FILE_PICKER_REQUEST_CODE = 1002
    private val GOOGLE_SIGN_IN_REQUEST_CODE = 1003

    private var callbackManager: CallbackManager? = null
    private lateinit var googleSignInClient: GoogleSignInClient
    private lateinit var auth: FirebaseAuth

    private var pendingResult: MethodChannel.Result? = null
    private var pendingFileResult: MethodChannel.Result? = null
    private var pendingGoogleResult: MethodChannel.Result? = null

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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FILE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "pickFile") {
                pendingFileResult = result
                val intent = Intent(Intent.ACTION_GET_CONTENT)
                intent.type = "*/*"
                startActivityForResult(intent, FILE_PICKER_REQUEST_CODE)
            } else if (call.method == "saveFile") {
                val tempPath = call.argument<String>("tempPath")
                val fileName = call.argument<String>("fileName")
                if (tempPath != null && fileName != null) {
                    try {
                        val tempFile = File(tempPath)
                        val permFile = File(filesDir, fileName)
                        tempFile.copyTo(permFile, overwrite = true)
                        result.success(permFile.absolutePath)
                    } catch (e: Exception) {
                        result.error("FILE_ERROR", "Failed to copy file", e.message)
                    }
                } else {
                    result.error("INVALID_ARGS", "Missing arguments", null)
                }
            } else {
                result.notImplemented()
            }
        }

        auth = FirebaseAuth.getInstance()
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken(getString(R.string.default_web_client_id))
            .requestEmail()
            .build()
        googleSignInClient = GoogleSignIn.getClient(this, gso)

        callbackManager = CallbackManager.Factory.create()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUTH_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "loginWithFacebook") {
                val permissions = call.argument<List<String>>("permissions") ?: listOf("public_profile")
                
                LoginManager.getInstance().registerCallback(callbackManager!!,
                    object : FacebookCallback<LoginResult> {
                        override fun onSuccess(loginResult: LoginResult) {
                            result.success(loginResult.accessToken.token)
                        }

                        override fun onCancel() {
                            result.error("CANCELLED", "Facebook login cancelled", null)
                        }

                        override fun onError(error: FacebookException) {
                            result.error("ERROR", error.message, null)
                        }
                    })

                LoginManager.getInstance().logInWithReadPermissions(this, permissions)
            } else if (call.method == "loginWithGoogle") {
                pendingGoogleResult = result
                googleSignInClient.signOut().addOnCompleteListener {
                    val signInIntent = googleSignInClient.signInIntent
                    startActivityForResult(signInIntent, GOOGLE_SIGN_IN_REQUEST_CODE)
                }
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        callbackManager?.onActivityResult(requestCode, resultCode, data)
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == GOOGLE_SIGN_IN_REQUEST_CODE) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            try {
                val account = task.getResult(ApiException::class.java)
                val credential = GoogleAuthProvider.getCredential(account?.idToken, null)
                auth.signInWithCredential(credential)
                    .addOnCompleteListener(this) { authTask ->
                        if (authTask.isSuccessful) {
                            authTask.result?.user?.getIdToken(true)?.addOnCompleteListener { tokenTask ->
                                if (tokenTask.isSuccessful) {
                                    pendingGoogleResult?.success(tokenTask.result?.token)
                                } else {
                                    pendingGoogleResult?.error("ERROR", "Failed to get Firebase token", tokenTask.exception?.message)
                                }
                                pendingGoogleResult = null
                            }
                        } else {
                            pendingGoogleResult?.error("ERROR", "Firebase auth failed", authTask.exception?.message)
                            pendingGoogleResult = null
                        }
                    }
            } catch (e: ApiException) {
                pendingGoogleResult?.error("ERROR", "Google sign in failed", e.message)
                pendingGoogleResult = null
            }
        } else if (requestCode == FILE_PICKER_REQUEST_CODE) {
            if (resultCode == RESULT_OK && data != null) {
                val uri: Uri? = data.data
                if (uri != null) {
                    val filePath = copyFileToCache(uri)
                    if (filePath != null) {
                        pendingFileResult?.success(filePath)
                    } else {
                        pendingFileResult?.error("FILE_ERROR", "Failed to get file path", null)
                    }
                } else {
                    pendingFileResult?.error("FILE_ERROR", "No file selected", null)
                }
            } else {
                pendingFileResult?.success(null)
            }
            pendingFileResult = null
        }
    }

    private fun copyFileToCache(uri: Uri): String? {
        try {
            val inputStream: InputStream? = contentResolver.openInputStream(uri)
            if (inputStream != null) {
                val tempFile = File(cacheDir, "picked_file_${System.currentTimeMillis()}")
                val outputStream = FileOutputStream(tempFile)
                val buffer = ByteArray(4 * 1024)
                var read: Int
                while (inputStream.read(buffer).also { read = it } != -1) {
                    outputStream.write(buffer, 0, read)
                }
                outputStream.flush()
                outputStream.close()
                inputStream.close()
                return tempFile.absolutePath
            }
        } catch (e: Exception) {
            Log.e("NativeFile", "Failed to copy file", e)
        }
        return null
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
