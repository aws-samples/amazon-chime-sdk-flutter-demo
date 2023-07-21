/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.amazon.realtime.observers

import com.google.gson.Gson
import dev.kxgcayh.amazon.realtime.AmazonChannelCoordinator
import dev.kxgcayh.amazon.realtime.constants.MethodCallFlutter
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.RemoteVideoSource
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionStatus


class AudioVideoObserver(val methodChannel: AmazonChannelCoordinator) : AudioVideoObserver {
    private val gson = Gson()

    override fun onAudioSessionStartedConnecting(reconnecting: Boolean) {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.AUDIO_SESSION_STARTED_CONNECTING,
            gson.toJson(mapOf("reconnecting" to reconnecting))
        )
    }

    override fun onAudioSessionCancelledReconnect() {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.AUDIO_SESSION_CANCELLED_RECONNECT, null
        )
    }

    override fun onAudioSessionDropped() {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.AUDIO_SESSION_STARTED_CONNECTING, null
        )
    }

    override fun onAudioSessionStarted(reconnecting: Boolean) {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.AUDIO_SESSION_STARTED,
            gson.toJson(mapOf("reconnecting" to reconnecting))
        )
    }

    override fun onAudioSessionStopped(sessionStatus: MeetingSessionStatus) {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.AUDIO_SESSION_DID_STOP, null
        )
    }

    override fun onConnectionBecamePoor() {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.CONNECTION_BECAME_POOR, null
        )
    }

    override fun onConnectionRecovered() {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.CONNECTION_RECOVERED, null
        )
    }

    override fun onRemoteVideoSourceAvailable(sources: List<RemoteVideoSource>) {
        for (source in sources) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.REMOTE_VIDEO_SOURCE_AVAILABLE,
                remoteVideoSourceToJson(source)
            )
        }
    }

    override fun onRemoteVideoSourceUnavailable(sources: List<RemoteVideoSource>) {
        for (source in sources) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.REMOTE_VIDEO_SOURCE_UNAVAILABLE,
                remoteVideoSourceToJson(source)
            )
        }
    }

    override fun onVideoSessionStarted(sessionStatus: MeetingSessionStatus) {
        if (sessionStatus.statusCode != null) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.VIDEO_SESSION_STARTED,
                gson.toJson(mapOf("statusCode" to sessionStatus.statusCode?.value))
            )
        }
    }

    override fun onVideoSessionStartedConnecting() {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.VIDEO_SESSION_STARTED_CONNECTING, null
        )
    }

    override fun onVideoSessionStopped(sessionStatus: MeetingSessionStatus) {
        if (sessionStatus.statusCode != null) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.VIDEO_SESSION_STOPPED,
                gson.toJson(mapOf("statusCode" to sessionStatus.statusCode?.value))
            )
        }
    }

    override fun onCameraSendAvailabilityUpdated(available: Boolean) {
        // App will not handle this method
    }

    private fun remoteVideoSourceToJson(source: RemoteVideoSource): String {
        return gson.toJson(mapOf("attendeeId" to source.attendeeId))
    }
}