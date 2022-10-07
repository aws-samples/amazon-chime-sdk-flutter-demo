/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.RemoteVideoSource
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionStatus

class AudioVideoObserver(val methodChannel: MethodChannelCoordinator) : AudioVideoObserver {
    override fun onAudioSessionCancelledReconnect() {
        // Out of Scope
    }

    override fun onAudioSessionDropped() {
        // Out of Scope
    }

    override fun onAudioSessionStarted(reconnecting: Boolean) {
        // Out of Scope
    }

    override fun onAudioSessionStartedConnecting(reconnecting: Boolean) {
        // Out of Scope
    }

    override fun onAudioSessionStopped(sessionStatus: MeetingSessionStatus) {
        methodChannel.callFlutterMethod(MethodCall.audioSessionDidStop, null)
    }

    override fun onConnectionBecamePoor() {
        // Out of Scope
    }

    override fun onConnectionRecovered() {
        // Out of Scope
    }

    override fun onRemoteVideoSourceAvailable(sources: List<RemoteVideoSource>) {
        // Out of Scope
    }

    override fun onRemoteVideoSourceUnavailable(sources: List<RemoteVideoSource>) {
        // Out of Scope
    }

    override fun onVideoSessionStarted(sessionStatus: MeetingSessionStatus) {
        // Out of Scope
    }

    override fun onVideoSessionStartedConnecting() {
        // Out of Scope
    }

    override fun onVideoSessionStopped(sessionStatus: MeetingSessionStatus) {
        // Out of Scope
    }
}