/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel

class PermissionManager(
    val activity: Activity
) : AppCompatActivity() {
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
            callResult = MethodChannelResult(true, Response.audio_auth_granted.msg)
            audioResult?.success(callResult.toFlutterCompatibleType())
        } else {
            callResult = MethodChannelResult(false, Response.audio_auth_not_granted.msg)
            audioResult?.error("Failed", "Permission Error", callResult.toFlutterCompatibleType())
        }
        audioResult = null
    }

    fun videoCallbackReceived() {
        val callResult: MethodChannelResult
        if (hasPermissionsAlready(VIDEO_PERMISSIONS)) {
            callResult = MethodChannelResult(true, Response.video_auth_granted.msg)
            videoResult?.success(callResult.toFlutterCompatibleType())
        } else {
            callResult = MethodChannelResult(false, Response.video_auth_not_granted.msg)
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