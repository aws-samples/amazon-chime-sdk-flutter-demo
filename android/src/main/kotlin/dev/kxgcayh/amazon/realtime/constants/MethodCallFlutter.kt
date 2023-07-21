/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.amazon.realtime.constants

class MethodCallFlutter {
    companion object {
        const val GET_PLATFORM_VERSION = "getPlatformVersion"
        const val MANAGE_AUDIO_PERMISSIONS = "manageAudioPermissions"
        const val MANAGE_VIDEO_PERMISSIONS = "manageVideoPermissions"
        const val INITIAL_AUDIO_SELECTION = "initialAudioSelection"
        const val JOIN = "join"
        const val STOP = "stop"
        const val LEAVE = "leave"
        const val DROP = "drop"
        const val MUTE = "mute"
        const val UNMUTE = "unmute"
        const val START_LOCAL_VIDEO = "startLocalVideo"
        const val STOP_LOCAL_VIDEO = "stopLocalVideo"
        const val VIDEO_TILE_ADD = "videoTileAdd"
        const val VIDEO_TILE_REMOVE = "videoTileRemove"
        const val LIST_AUDIO_DEVICES = "listAudioDevices"
        const val UPDATE_AUDIO_DEVICE = "updateAudioDevice"
        const val AUDIO_SESSION_DID_STOP = "audioSessionDidStop"
        const val VOLUME_CHANGED = "volumeChanged"
        const val SIGNAL_STRENGTH_CHANGED = "signalStrengthChanged"
        const val DATA_MESSAGE_RECEIVED = "dataMessageReceived"
        const val AUDIO_SESSION_STARTED_CONNECTING = "audioSessionStartedConnecting"
        const val AUDIO_SESSION_STARTED = "audioSessionStarted"
        const val AUDIO_SESSION_DROPPED = "audioSessionDropped"
        const val AUDIO_SESSION_CANCELLED_RECONNECT = "audioSessionCancelledReconnect"
        const val CONNECTION_RECOVERED = "connectionRecovered"
        const val CONNECTION_BECAME_POOR = "connectionBecamePoor"
        const val REMOTE_VIDEO_SOURCE_UNAVAILABLE = "remoteVideoSourceUnavailable"
        const val REMOTE_VIDEO_SOURCE_AVAILABLE = "remoteVideoSourceAvailable"
        const val VIDEO_SESSION_STARTED = "videoSessionStarted"
        const val VIDEO_SESSION_STARTED_CONNECTING = "videoSessionStartedConnecting"
        const val VIDEO_SESSION_STOPPED = "videoSessionStopped"
        const val PAUSE_VIDEO_TILE = "pauseVideoTile"
        const val RESUME_VIDEO_TILE = "resumeVideoTile"
    }
}
