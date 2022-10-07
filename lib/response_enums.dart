/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

// ignore_for_file: constant_identifier_names

class Response {
  static const String audio_and_video_permission_denied = "ERROR audio and video permissions not authorized.";
  static const String audio_not_authorized = "ERROR audio permissions not authorized.";
  static const String video_not_authorized = "ERROR video permissions not authorized.";

  // API
  static const String not_connected_to_internet = "ERROR device is not connected to the internet.";
  static const String api_response_null = "ERROR api response is null";
  static const String api_call_failed = "ERROR api call has returned incorrect status";

  // Meeting
  static const String empty_parameter = "ERROR empty meeting or attendee";
  static const String invalid_attendee_or_meeting = "ERROR meeting or attendee are too short or long.";
  static const String null_join_response = "ERROR join response is null.";
  static const String null_meeting_data = "ERROR meeting data is null";
  static const String null_local_attendee = "ERROR local attendee is null";
  static const String null_remote_attendee = "ERROR remote attendee is null";
  static const String stop_response_null = "ERROR stop response is null";

  // Observers
  static const String null_realtime_observers = "WARNING realtime observer is null";
  static const String null_audiovideo_observers = "WARNING audiovideo observer is null";
  static const String null_videotile_observers = "WARNING videotile observer is null";

  // Mute
  static const String mute_response_null = "ERROR mute response is null.";
  static const String unmute_response_null = "ERROR unmute response is null.";

  // Video
  static const String video_start_response_null = "ERROR video start response is null";
  static const String video_stopped_response_null = "ERROR video stop response is null";

  // Audio Device
  static const String null_initial_audio_device = "ERROR failed to get initial audio device";
  static const String null_audio_device_list = "ERROR audio device list is null";
  static const String null_audio_device_update = "ERROR audio device update is null.";
}

class MethodCallOption {
  static const String manageAudioPermissions = "manageAudioPermissions";
  static const String manageVideoPermissions = "manageVideoPermissions";
  static const String initialAudioSelection = "initialAudioSelection";
  static const String join = "join";
  static const String stop = "stop";
  static const String leave = "leave";
  static const String drop = "drop";
  static const String mute = "mute";
  static const String unmute = "unmute";
  static const String localVideoOn = "startLocalVideo";
  static const String localVideoOff = "stopLocalVideo";
  static const String videoTileAdd = "videoTileAdd";
  static const String videoTileRemove = "videoTileRemove";
  static const String listAudioDevices = "listAudioDevices";
  static const String updateAudioDevice = "updateAudioDevice";
  static const String audioSessionDidDrop = "audioSessionDidDrop";
  static const String audioSessionDidStop = "audioSessionDidStop";
}
