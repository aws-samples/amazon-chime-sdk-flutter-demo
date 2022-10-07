/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

enum class Response(val msg: String) {
    // Authorization
    audio_auth_granted("Android: Audio usage authorized."),
    audio_auth_not_granted("Android: Failed to authorize audio."),
    video_auth_granted("Android: Video usage authorized."),
    video_auth_not_granted("Android: Failed to authorize video."),

    // Meeting
    incorrect_join_response_params("Android: ERROR api response has incorrect/missing parameters."),
    create_meeting_success("Android: meetingSession created successfully."),
    meeting_stopped_successfully("Android: meetingSession stopped successfully."),
    meeting_session_is_null("Android: ERROR Meeting session is null."),

    // Mute
    mute_successful("Android: Successfully muted user"),
    mute_failed("Android: ERROR failed to mute user"),
    unmute_successful("Android: Successfully unmuted user"),
    unmute_failed("Android: ERROR failed to unmute user"),

    // Video
    local_video_on_success("Android: Started local video."),

    // Audio Device
    audio_device_updated("Android: Audio device updated"),
    audio_device_update_failed("Android: Failed to update audio device."),
    null_audio_device("Android: ERROR received null as audio device."),

    // Method Channel
    method_not_implemented("Android: ERROR method not implemented.")
}
