/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
import Foundation

enum Response : String{
    case video_auth_not_granted = "iOS: ERROR video authorization not granted."
    case audio_auth_not_granted = "iOS: ERROR audio authorization not granted."
    case create_meeting_failed =  "iOS: ERROR failed to create meetingSession."
    case create_meeting_success = "iOS: meetingSession created successfully."
    case meeting_start_failed = "iOS: ERROR failed to start meeting."
    case incorrect_join_response_params = "iOS: ERROR api response has incorrect/missing parameters."
    case meeting_stopped_successfully = "iOS: meetingSession successfuly stopped."
}
