/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
import Foundation

enum MethodCall: String {
    case manageAudioPermissions
    case manageVideoPermissions
    case initialAudioSelection
    case join
    case stop
    case leave
    case drop
    case mute
    case unmute
    case startLocalVideo
    case stopLocalVideo
    case videoTileAdd
    case videoTileRemove
    case listAudioDevices
    case updateAudioDevice
    case audioSessionDidStop
}

enum Response: String {
    // Authorization
    case audio_authorized = "iOS: Audio authorized."
    case video_authorized = "iOS: Video authorized."
    case video_auth_not_granted = "iOS: ERROR video authorization not granted."
    case audio_auth_not_granted = "iOS: ERROR audio authorization not granted."
    case audio_restricted = "iOS: ERROR audio restricted."
    case video_restricted = "iOS: ERROR video restricted."
    case unknown_audio_authorization_status = "iOS: ERROR unknown audio authorization status."
    case unknown_video_authorization_status = "iOS: ERROR unknown video authorization status."
    
    // Meeting
    case incorrect_join_response_params = "iOS: ERROR api response has incorrect/missing parameters."
    case create_meeting_success = "iOS: meetingSession created successfully."
    case create_meeting_failed = "iOS: ERROR failed to create meetingSession."
    case meeting_start_failed = "iOS: ERROR failed to start meeting."
    case meeting_stopped_successfully = "iOS: meetingSession stopped successfuly."
    
    // Mute
    case mute_successful = "iOS: Successfully muted user"
    case mute_failed = "iOS: Could not mute user"
    case unmute_successful = "iOS: Successfully unmuted user"
    case unmute_failed = "iOS: ERROR Could not unmute user"
    
    // Video
    case local_video_on_success = "iOS: Started local video."
    case local_video_on_failed = "iOS: ERROR could not start local video."
    case local_video_off_success = "iOS: Stopped local video."
    
    // Audio Device
    case audio_device_updated = "iOS: Audio device updated."
    case failed_to_get_initial_audio_device = "iOS: Failed to get initial audio device"
    case audio_device_update_failed = "iOS: Failed to update audio device."
    case failed_to_list_audio_devices = "iOS: ERROR failed to list audio devices."
    
    // Method Channel
    case method_not_implemented = "iOS: ERROR method not implemented."
}
