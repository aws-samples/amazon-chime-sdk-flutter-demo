/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice
import com.amazonaws.services.chime.sdk.meetings.session.DefaultMeetingSession
import com.amazonaws.services.chime.sdk.meetings.session.MediaPlacement
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionConfiguration
import com.amazonaws.services.chime.sdk.meetings.session.CreateMeetingResponse
import com.amazonaws.services.chime.sdk.meetings.session.Meeting
import com.amazonaws.services.chime.sdk.meetings.session.CreateAttendeeResponse
import com.amazonaws.services.chime.sdk.meetings.session.Attendee
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import com.amazonaws.services.chime.flutterdemo.MethodCall as MethodCallFlutter
import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.MethodChannel

class MethodChannelCoordinator(binaryMessenger: BinaryMessenger, activity: Activity) :
    AppCompatActivity() {
    val methodChannel: MethodChannel
    val context: Context
    var permissionsManager: PermissionManager = PermissionManager(activity)

    init {
        methodChannel =
            MethodChannel(binaryMessenger, "com.amazonaws.services.chime.flutterDemo.methodChannel")
        context = activity.applicationContext
    }

    private val NULL_MEETING_SESSION_RESPONSE: MethodChannelResult =
        MethodChannelResult(false, Response.meeting_session_is_null.msg)

    fun setupMethodChannel() {
        methodChannel.setMethodCallHandler { call, result ->
            val callResult: MethodChannelResult
            when (call.method) {
                MethodCallFlutter.manageAudioPermissions.call -> {
                    permissionsManager.manageAudioPermissions(result)
                    return@setMethodCallHandler
                }
                MethodCallFlutter.manageVideoPermissions.call -> {
                    permissionsManager.manageVideoPermissions(result)
                    return@setMethodCallHandler
                }
                MethodCallFlutter.join.call -> {
                    callResult = join(call)
                }
                MethodCallFlutter.stop.call -> {
                    callResult = stop()
                }
                MethodCallFlutter.mute.call -> {
                    callResult = mute()
                }
                MethodCallFlutter.unmute.call -> {
                    callResult = unmute()
                }
                MethodCallFlutter.startLocalVideo.call -> {
                    callResult = startLocalVideo()
                }
                MethodCallFlutter.stopLocalVideo.call -> {
                    callResult = stopLocalVideo()
                }
                MethodCallFlutter.initialAudioSelection.call -> {
                    callResult = initialAudioSelection()
                }
                MethodCallFlutter.listAudioDevices.call -> {
                    callResult = listAudioDevices()
                }
                MethodCallFlutter.updateAudioDevice.call -> {
                    callResult = updateAudioDevice(call)
                }
                else -> callResult = MethodChannelResult(false, Response.method_not_implemented)
            }

            if (callResult.result) {
                result.success(callResult.toFlutterCompatibleType())
            } else {
                result.error(
                    "Failed",
                    "MethodChannelHandler failed",
                    callResult.toFlutterCompatibleType()
                )
            }
        }
    }

    fun callFlutterMethod(method: MethodCallFlutter, args: Any?) {
        methodChannel.invokeMethod(method.call, args)
    }

    fun join(call: MethodCall): MethodChannelResult {
        if (call.arguments == null) {
            return MethodChannelResult(false, Response.incorrect_join_response_params.msg)
        }
        val meetingId: String? = call.argument("MeetingId")
        val externalMeetingId: String? = call.argument("ExternalMeetingId")
        val mediaRegion: String? = call.argument("MediaRegion")
        val audioHostUrl: String? = call.argument("AudioHostUrl")
        val audioFallbackUrl: String? = call.argument("AudioFallbackUrl")
        val signalingUrl: String? = call.argument("SignalingUrl")
        val turnControlUrl: String? = call.argument("TurnControlUrl")
        val externalUserId: String? = call.argument("ExternalUserId")
        val attendeeId: String? = call.argument("AttendeeId")
        val joinToken: String? = call.argument("JoinToken")

        if (meetingId == null ||
            mediaRegion == null ||
            audioHostUrl == null ||
            externalMeetingId == null ||
            audioFallbackUrl == null ||
            signalingUrl == null ||
            turnControlUrl == null ||
            externalUserId == null ||
            attendeeId == null ||
            joinToken == null
        ) {
            return MethodChannelResult(false, Response.incorrect_join_response_params.msg)
        }

        val createMeetingResponse = CreateMeetingResponse(
            Meeting(
                externalMeetingId,
                MediaPlacement(audioFallbackUrl, audioHostUrl, signalingUrl, turnControlUrl),
                mediaRegion,
                meetingId
            )
        )
        val createAttendeeResponse =
            CreateAttendeeResponse(Attendee(attendeeId, externalUserId, joinToken))
        val meetingSessionConfiguration =
            MeetingSessionConfiguration(createMeetingResponse, createAttendeeResponse)

        val meetingSession =
            DefaultMeetingSession(meetingSessionConfiguration, ConsoleLogger(), context)

        MeetingSessionManager.meetingSession = meetingSession
        return MeetingSessionManager.startMeeting(
            RealtimeObserver(this),
            VideoTileObserver(this),
            AudioVideoObserver(this)
        )
    }

    fun stop(): MethodChannelResult {
        return MeetingSessionManager.stop()
    }

    fun mute(): MethodChannelResult {
        val muted = MeetingSessionManager.meetingSession?.audioVideo?.realtimeLocalMute()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return if (muted) MethodChannelResult(
            true,
            Response.mute_successful.msg
        ) else MethodChannelResult(false, Response.mute_failed.msg)
    }

    fun unmute(): MethodChannelResult {
        val unmuted = MeetingSessionManager.meetingSession?.audioVideo?.realtimeLocalUnmute()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return if (unmuted) MethodChannelResult(
            true,
            Response.unmute_successful.msg
        ) else MethodChannelResult(false, Response.unmute_failed.msg)
    }

    fun startLocalVideo(): MethodChannelResult {
        MeetingSessionManager.meetingSession?.audioVideo?.startLocalVideo()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return MethodChannelResult(true, Response.local_video_on_success.msg)
    }

    fun stopLocalVideo(): MethodChannelResult {
        MeetingSessionManager.meetingSession?.audioVideo?.stopLocalVideo()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return MethodChannelResult(true, Response.local_video_on_success.msg)
    }

    fun initialAudioSelection(): MethodChannelResult {
        val device =
            MeetingSessionManager.meetingSession?.audioVideo?.getActiveAudioDevice()
                ?: return NULL_MEETING_SESSION_RESPONSE
        return MethodChannelResult(true, device.label)
    }

    fun listAudioDevices(): MethodChannelResult {
        val audioDevices = MeetingSessionManager.meetingSession?.audioVideo?.listAudioDevices()
            ?: return NULL_MEETING_SESSION_RESPONSE
        val transform: (MediaDevice) -> String = { it.label }
        return MethodChannelResult(true, audioDevices.map(transform))
    }

    fun updateAudioDevice(call: MethodCall): MethodChannelResult {
        val device =
            call.arguments ?: return MethodChannelResult(false, Response.null_audio_device.msg)

        val audioDevices = MeetingSessionManager.meetingSession?.audioVideo?.listAudioDevices()
            ?: return NULL_MEETING_SESSION_RESPONSE

        for (dev in audioDevices) {
            if (device == dev.label) {
                MeetingSessionManager.meetingSession?.audioVideo?.chooseAudioDevice(dev)
                    ?: return MethodChannelResult(false, Response.audio_device_update_failed.msg)
                return MethodChannelResult(true, Response.audio_device_updated.msg)
            }
        }
        return MethodChannelResult(false, Response.audio_device_update_failed.msg)
    }
}
