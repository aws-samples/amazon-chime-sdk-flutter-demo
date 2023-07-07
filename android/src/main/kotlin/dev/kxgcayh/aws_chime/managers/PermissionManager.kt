/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.aws_chime.managers

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import dev.kxgcayh.aws_chime.MethodChannelResult
import dev.kxgcayh.aws_chime.enums.ResponseEnum

class PermissionManager(val activity: Activity) : AppCompatActivity() {
    val context: Context

    val VIDEO_PERMISSION_REQUEST_CODE = 1
    val VIDEO_PERMISSIONS = arrayOf(
        Manifest.permission.CAMERA
    )

    val AUDIO_PERMISSION_REQUEST_CODE = 2
    val AUDIO_PERMISSIONS = arrayOf(
        Manifest.permission.MODIFY_AUDIO_SETTINGS,
        Manifest.permission.RECORD_AUDIO,
    )

    var audioResult: MethodChannel.Result? = null
    var videoResult: MethodChannel.Result? = null

    init {
        context = activity.applicationContext
    }

    fun manageAudioPermissions(result: MethodChannel.Result) {
        audioResult = result
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

    fun manageVideoPermissions(result: MethodChannel.Result) {
        videoResult = result
        if (hasPermissionsAlready(VIDEO_PERMISSIONS)) {
            videoCallbackReceived()
        } else {
            ActivityCompat.requestPermissions(
                activity,
                VIDEO_PERMISSIONS,
                VIDEO_PERMISSION_REQUEST_CODE
            )
        }
    }

    fun audioCallbackReceived() {
        val callResult: MethodChannelResult
        if (hasPermissionsAlready(AUDIO_PERMISSIONS)) {
            callResult = MethodChannelResult(true, ResponseEnum.AUDIO_AUTH_GRANTED)
            audioResult?.success(callResult.toFlutterCompatibleType())
        } else {
            callResult = MethodChannelResult(false, ResponseEnum.AUDIO_AUTH_NOT_GRANTED)
            audioResult?.error("Failed", "Permission Error", callResult.toFlutterCompatibleType())
        }
        audioResult = null
    }

    fun videoCallbackReceived() {
        val callResult: MethodChannelResult
        if (hasPermissionsAlready(VIDEO_PERMISSIONS)) {
            callResult = MethodChannelResult(true, ResponseEnum.VIDEO_AUTH_GRANTED)
            videoResult?.success(callResult.toFlutterCompatibleType())
        } else {
            callResult = MethodChannelResult(false, ResponseEnum.VIDEO_AUTH_NOT_GRANTED)
            videoResult?.error("Failed", "Permission Error", callResult.toFlutterCompatibleType())
        }
        videoResult = null
    }

    private fun hasPermissionsAlready(PERMISSIONS: Array<String>): Boolean {
        return PERMISSIONS.all {
            ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED
        }
    }
}