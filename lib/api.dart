// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

class Api {
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

  @override
  String toString() => 'JoinInfo(meeting: $meeting, attendee: $attendee)';
}

class Meeting {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;

  Meeting(this.meetingId, this.externalMeetingId, this.mediaRegion,
      this.mediaPlacement);

  factory Meeting.fromJson(Map<String, dynamic> json) {
    var meetingMap = json['JoinInfo']['Meeting']['Meeting'];

    return Meeting(
      meetingMap['MeetingId'],
      meetingMap['ExternalMeetingId'],
      meetingMap['MediaRegion'],
      MediaPlacement.fromJson(json),
    );
  }

  @override
  String toString() {
    return 'Meeting(meetingId: $meetingId, externalMeetingId: $externalMeetingId, mediaRegion: $mediaRegion, mediaPlacement: $mediaPlacement)';
  }
}

class MediaPlacement {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControllerUrl;

  MediaPlacement(this.audioHostUrl, this.audioFallbackUrl, this.signalingUrl,
      this.turnControllerUrl);

  factory MediaPlacement.fromJson(Map<String, dynamic> json) {
    var mediaPlacementMap =
        json['JoinInfo']['Meeting']['Meeting']['MediaPlacement'];
    return MediaPlacement(
      mediaPlacementMap['AudioHostUrl'],
      mediaPlacementMap['AudioFallbackUrl'],
      mediaPlacementMap['SignalingUrl'],
      mediaPlacementMap['TurnControlUrl'],
    );
  }
}

class AttendeeInfo {
  final String externalUserId;
  final String attendeeId;
  final String joinToken;

  AttendeeInfo(this.externalUserId, this.attendeeId, this.joinToken);

  factory AttendeeInfo.fromJson(Map<String, dynamic> json) {
    var attendeeMap = json['JoinInfo']['Attendee']['Attendee'];

    return AttendeeInfo(
      attendeeMap['ExternalUserId'],
      attendeeMap['AttendeeId'],
      attendeeMap['JoinToken'],
    );
  }

  @override
  String toString() =>
      'AttendeeInfo(externalUserId: $externalUserId, attendeeId: $attendeeId, joinToken: $joinToken)';
}

class ApiResponse {
  final bool response;
  final JoinInfo? content;
  final String? error;

  ApiResponse({required this.response, this.content, this.error});
}
