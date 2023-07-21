package dev.kxgcayh.amazon.realtime.managers

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import androidx.appcompat.app.AppCompatActivity
import dev.kxgcayh.amazon.realtime.AmazonChannelResponse

class PermissionManager(val activity: Activity): AppCompatActivity() {
    private var context: Context = activity.applicationContext
    private lateinit var permissionResult: MethodChannel.Result

    private fun audioCallbackReceived() {
        val callResult: AmazonChannelResponse
        if (hasPermissionsAlready(AUDIO_PERMISSIONS)) {
            callResult = AmazonChannelResponse(true, "Android: Audio Auth Granted")
            permissionResult.success(callResult.toFlutterCompatibleType())
        } else {
            callResult = AmazonChannelResponse(false, "Android: Audio Auth Not Granted")
            permissionResult.error("Failed", "Permission Error", callResult.toFlutterCompatibleType())
        }
    }

    fun manageAudioPermissions(result: MethodChannel.Result) {
        permissionResult = result
        if (hasPermissionsAlready(AUDIO_PERMISSIONS)) {
            audioCallbackReceived()
        } else {
            ActivityCompat.requestPermissions(
                activity,
                AUDIO_PERMISSIONS,
                AUDIO_PERMISSION_REQUEST_CODE
            )
        }
    }

    private fun hasPermissionsAlready(PERMISSIONS: Array<String>): Boolean {
        return PERMISSIONS.all {
            ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED
        }
    }

    companion object {
        const val VIDEO_PERMISSION_REQUEST_CODE = 1
        val VIDEO_PERMISSIONS = arrayOf(Manifest.permission.CAMERA)
        const val AUDIO_PERMISSION_REQUEST_CODE = 2
        val AUDIO_PERMISSIONS = arrayOf(
            Manifest.permission.MODIFY_AUDIO_SETTINGS,
            Manifest.permission.RECORD_AUDIO,
        )
    }
}