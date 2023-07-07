/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.aws_chime

import com.google.gson.Gson
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.RemoteVideoSource
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionStatus
import dev.kxgcayh.aws_chime.enums.MethodCallFlutter

class AudioVideoObserver(val coordinator: AwsChimePlugin) : AudioVideoObserver {
    private val gson: Gson = Gson()

    override fun onAudioSessionStartedConnecting(reconnecting: Boolean) {
        coordinator.callFlutterMethod(MethodCallFlutter.AUDIO_SESSION_STARTED_CONNECTING, mapOf("reconnecting" to reconnecting))
    }

    override fun onAudioSessionCancelledReconnect() {
        coordinator.callFlutterMethod(MethodCallFlutter.AUDIO_SESSION_CANCELLED_RECONNECT, null)
    }

    override fun onAudioSessionDropped() {
        coordinator.callFlutterMethod(MethodCallFlutter.AUDIO_SESSION_STARTED_CONNECTING, null)
    }

    override fun onAudioSessionStarted(reconnecting: Boolean) {
        coordinator.callFlutterMethod(MethodCallFlutter.AUDIO_SESSION_STARTED, mapOf("reconnecting" to reconnecting))
    }

    override fun onAudioSessionStopped(sessionStatus: MeetingSessionStatus) {
        coordinator.callFlutterMethod(MethodCallFlutter.AUDIO_SESSION_DID_STOP, null)
    }

    override fun onConnectionBecamePoor() {
        coordinator.callFlutterMethod(MethodCallFlutter.CONNECTION_BECAME_POOR, null)
    }

    override fun onConnectionRecovered() {
        coordinator.callFlutterMethod(MethodCallFlutter.CONNECTION_RECOVERED, null)
    }

    override fun onRemoteVideoSourceAvailable(sources: List<RemoteVideoSource>) {
        coordinator.callFlutterMethod(
            MethodCallFlutter.REMOTE_VIDEO_SOURCE_AVAILABLE,
            gson.toJson(remoteVideoSourceListToMap(sources))
        )
    }

    override fun onRemoteVideoSourceUnavailable(sources: List<RemoteVideoSource>) {
        coordinator.callFlutterMethod(
            MethodCallFlutter.REMOTE_VIDEO_SOURCE_UNAVAILABLE,
            gson.toJson(remoteVideoSourceListToMap(sources))
        )
    }

    override fun onVideoSessionStarted(sessionStatus: MeetingSessionStatus) {
        if (sessionStatus.statusCode != null) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.VIDEO_SESSION_STARTED,
                mapOf("statusCode" to sessionStatus.statusCode?.value)
            )
        }
    }

    override fun onVideoSessionStartedConnecting() {
        coordinator.callFlutterMethod(MethodCallFlutter.VIDEO_SESSION_STARTED_CONNECTING, null)
    }

    override fun onVideoSessionStopped(sessionStatus: MeetingSessionStatus) {
        if (sessionStatus.statusCode != null) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.VIDEO_SESSION_STOPPED,
                mapOf("statusCode" to sessionStatus.statusCode?.value)
            )
        }
    }

    private fun remoteVideoSourceListToMap(sources: List<RemoteVideoSource>): Map<String, List<Map<String, String>>> {
        return mapOf("sources" to sources.map {
            mapOf("attendeeId" to it.attendeeId)
        })
    }
}