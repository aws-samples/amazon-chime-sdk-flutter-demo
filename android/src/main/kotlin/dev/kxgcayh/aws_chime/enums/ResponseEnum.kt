/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.aws_chime.enums

class ResponseEnum {
    companion object {
        const val AUDIO_AUTH_GRANTED = "Android: Audio usage authorized"
        const val AUDIO_AUTH_NOT_GRANTED = "Android: Failed to authorize audio"
        const val VIDEO_AUTH_GRANTED = "Android: Video usage authorized"
        const val VIDEO_AUTH_NOT_GRANTED = "Android: Failed to authorize video"
        const val INCORRECT_JOIN_RESPONSE_PARAMS = "Android: ERROR api response has incorrect/missing parameters"
        const val CREATE_MEETING_SUCCESS = "Android: meetingSession created successfully"
        const val MEETING_STOPPED_SUCCESSFULLY = "Android: meetingSession stopped successfully"
        const val MEETING_SESSION_IS_NULL = "Android: ERROR Meeting session is null"
        const val MUTE_SUCCESSFUL = "Android: Successfully muted user"
        const val MUTE_FAILED = "Android: ERROR failed to mute user"
        const val UNMUTE_SUCCESSFUL = "Android: Successfully unmuted user"
        const val UNMUTE_FAILED = "Android: ERROR failed to unmute user"
        const val LOCAL_VIDEO_ON_SUCCESS = "Android: Started local video"
        const val AUDIO_DEVICE_UPDATED = "Android: Audio device updated"
        const val AUDIO_DEVICE_UPDATE_FAILED = "Android: Failed to update audio device"
        const val NULL_AUDIO_DEVICE = "Android: ERROR received null as audio device"
        const val METHOD_NOT_IMPLEMENTED = "Android: ERROR method not implemented"
    }
}
