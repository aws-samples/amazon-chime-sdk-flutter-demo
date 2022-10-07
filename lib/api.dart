/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:convert';
import 'package:flutter_demo_chime_sdk/api_config.dart';
import 'package:http/http.dart' as http;

import 'logger.dart';

class Api {
  final String _baseUrl = ApiConfig.apiUrl;
  final String _region = ApiConfig.region;

  Future<ApiResponse?> join(String meetingId, String attendeeId) async {
    String url = "${_baseUrl}join?title=$meetingId&name=$attendeeId&region=$_region";

    try {
      final http.Response response = await http.post(Uri.parse(url));

      logger.d("STATUS: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        logger.i("POST - join api call successful!");
        Map<String, dynamic> joinInfoMap = jsonDecode(response.body);
        JoinInfo joinInfo = JoinInfo.fromJson(joinInfoMap);
        return ApiResponse(response: true, content: joinInfo);
      }
    } catch (e) {
      logger.e("join request Failed. Status: ${e.toString()}");
      return ApiResponse(response: false, error: e.toString());
    }
    return null;
  }

  Map<String, dynamic> joinInfoToJSON(JoinInfo info) {
    Map<String, dynamic> flattenedJSON = {
      "MeetingId": info.meeting.meetingId,
      "ExternalMeetingId": info.meeting.externalMeetingId,
      "MediaRegion": info.meeting.mediaRegion,
      "AudioHostUrl": info.meeting.mediaPlacement.audioHostUrl,
      "AudioFallbackUrl": info.meeting.mediaPlacement.audioFallbackUrl,
      "SignalingUrl": info.meeting.mediaPlacement.signalingUrl,
      "TurnControlUrl": info.meeting.mediaPlacement.turnControllerUrl,
      "ExternalUserId": info.attendee.externalUserId,
      "AttendeeId": info.attendee.attendeeId,
      "JoinToken": info.attendee.joinToken
    };

    return flattenedJSON;
  }
}

class JoinInfo {
  final Meeting meeting;

  final AttendeeInfo attendee;

  JoinInfo(this.meeting, this.attendee);

  factory JoinInfo.fromJson(Map<String, dynamic> json) {
    return JoinInfo(Meeting.fromJson(json), AttendeeInfo.fromJson(json));
  }
}

class Meeting {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;

  Meeting(this.meetingId, this.externalMeetingId, this.mediaRegion, this.mediaPlacement);

  factory Meeting.fromJson(Map<String, dynamic> json) {
    // TODO zmauricv: Look into JSON Serialization Solutions
    var meetingMap = json['JoinInfo']['Meeting']['Meeting'];

    return Meeting(
      meetingMap['MeetingId'],
      meetingMap['ExternalMeetingId'],
      meetingMap['MediaRegion'],
      MediaPlacement.fromJson(json),
    );
  }
}

class MediaPlacement {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControllerUrl;

  MediaPlacement(this.audioHostUrl, this.audioFallbackUrl, this.signalingUrl, this.turnControllerUrl);

  factory MediaPlacement.fromJson(Map<String, dynamic> json) {
    var mediaPlacementMap = json['JoinInfo']['Meeting']['Meeting']['MediaPlacement'];
    return MediaPlacement(mediaPlacementMap['AudioHostUrl'], mediaPlacementMap['AudioFallbackUrl'],
        mediaPlacementMap['SignalingUrl'], mediaPlacementMap['TurnControlUrl']);
  }
}

class AttendeeInfo {
  final String externalUserId;
  final String attendeeId;
  final String joinToken;

  AttendeeInfo(this.externalUserId, this.attendeeId, this.joinToken);

  factory AttendeeInfo.fromJson(Map<String, dynamic> json) {
    var attendeeMap = json['JoinInfo']['Attendee']['Attendee'];

    return AttendeeInfo(attendeeMap['ExternalUserId'], attendeeMap['AttendeeId'], attendeeMap['JoinToken']);
  }
}

class ApiResponse {
  final bool response;
  final JoinInfo? content;
  final String? error;

  ApiResponse({required this.response, this.content, this.error});
}
