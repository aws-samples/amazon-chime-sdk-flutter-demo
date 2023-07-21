// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_realtime/src/models/attendee/attendee_info.dart';

class JoinRoomResponse {
  final int? code;
  final String? message;
  final MeetingInfo data;

  JoinRoomResponse({
    this.code,
    this.message,
    required this.data,
  });

  factory JoinRoomResponse.fromJson(Map<String, dynamic> json) {
    return JoinRoomResponse(
      code: json["code"],
      message: json["message"],
      data: MeetingInfo.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"code": code, "message": message, "data": data};
  }

  @override
  String toString() =>
      'JoinRoomResponse(code: $code, message: $message, data: $data)';
}

class MeetingInfo {
  final MeetingData meeting;
  final AttendeeInfo attendee;

  const MeetingInfo({required this.meeting, required this.attendee});

  Map<String, dynamic> toChannelJson() {
    return {
      "MeetingId": meeting.meetingId,
      "ExternalMeetingId": meeting.externalMeetingId,
      "MediaRegion": meeting.mediaRegion,
      "AudioHostUrl": meeting.mediaPlacement.audioHostUrl,
      "AudioFallbackUrl": meeting.mediaPlacement.audioFallbackUrl,
      "SignalingUrl": meeting.mediaPlacement.signalingUrl,
      "TurnControlUrl": meeting.mediaPlacement.turnControlUrl,
      "ExternalUserId": attendee.externalUserId,
      "AttendeeId": attendee.attendeeId,
      "JoinToken": attendee.joinToken
    };
  }

  factory MeetingInfo.fromJson(Map<String, dynamic> json) {
    return MeetingInfo(
      meeting: MeetingData.fromJson(json["Meeting"]),
      attendee: AttendeeInfo.fromMap(json["Attendee"]),
    );
  }
}

class MeetingData {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;
  final String? meetingHostId;
  final MeetingFeatures? meetingFeatures;
  final List<dynamic>? tenantIds;
  final String? meetingArn;

  const MeetingData({
    required this.meetingId,
    required this.externalMeetingId,
    required this.mediaRegion,
    required this.mediaPlacement,
    this.meetingHostId,
    this.meetingFeatures,
    this.tenantIds,
    this.meetingArn,
  });

  factory MeetingData.fromJson(Map<String, dynamic> json) {
    return MeetingData(
      meetingId: json["MeetingId"],
      externalMeetingId: json["ExternalMeetingId"],
      mediaRegion: json["MediaRegion"],
      mediaPlacement: MediaPlacement.fromJson(json["MediaPlacement"]),
      meetingHostId: json["MeetingHostId"],
      meetingFeatures: json["MeetingFeatures"] != null
          ? MeetingFeatures.fromJson(json["MeetingFeatures"])
          : null,
      tenantIds: json["TenantIds"] == null
          ? []
          : List<dynamic>.from(json["TenantIds"]!.map((x) => x)),
      meetingArn: json["MeetingArn"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "MeetingId": meetingId,
      "MeetingHostId": meetingHostId,
      "ExternalMeetingId": externalMeetingId,
      "MediaRegion": mediaRegion,
      "MediaPlacement": mediaPlacement.toJson(),
      "MeetingFeatures": meetingFeatures?.toJson(),
      "TenantIds": tenantIds == null
          ? []
          : List<dynamic>.from(tenantIds!.map((tenant) => tenant)),
      "MeetingArn": meetingArn,
    };
  }
}

class MediaPlacement {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControlUrl;
  final String? screenDataUrl;
  final String? screenViewingUrl;
  final String? screenSharingUrl;
  final String? eventIngestionUrl;

  const MediaPlacement({
    required this.audioHostUrl,
    required this.audioFallbackUrl,
    required this.signalingUrl,
    required this.turnControlUrl,
    this.screenDataUrl,
    this.screenViewingUrl,
    this.screenSharingUrl,
    this.eventIngestionUrl,
  });

  factory MediaPlacement.fromJson(Map<String, dynamic> json) {
    return MediaPlacement(
      audioHostUrl: json["AudioHostUrl"],
      audioFallbackUrl: json["AudioFallbackUrl"],
      signalingUrl: json["SignalingUrl"],
      turnControlUrl: json["TurnControlUrl"],
      screenDataUrl: json["ScreenDataUrl"],
      screenViewingUrl: json["ScreenViewingUrl"],
      screenSharingUrl: json["ScreenSharingUrl"],
      eventIngestionUrl: json["EventIngestionUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "AudioHostUrl": audioHostUrl,
      "AudioFallbackUrl": audioFallbackUrl,
      "SignalingUrl": signalingUrl,
      "TurnControlUrl": turnControlUrl,
      "ScreenDataUrl": screenDataUrl,
      "ScreenViewingUrl": screenViewingUrl,
      "ScreenSharingUrl": screenSharingUrl,
      "EventIngestionUrl": eventIngestionUrl,
    };
  }
}

class MeetingFeatures {
  final AudioFeature? audio;

  const MeetingFeatures({this.audio});

  factory MeetingFeatures.fromJson(Map<String, dynamic> json) {
    final dynamic jsonAudio = json["Audio"];
    return MeetingFeatures(
      audio: jsonAudio == null ? null : AudioFeature.fromJson(jsonAudio),
    );
  }
  Map<String, dynamic> toJson() => {"Audio": audio?.toJson()};
}

class AudioFeature {
  final String? echoReduction;

  const AudioFeature({this.echoReduction});

  factory AudioFeature.fromJson(Map<String, dynamic> json) {
    return AudioFeature(echoReduction: json["EchoReduction"]);
  }

  Map<String, dynamic> toJson() => {"EchoReduction": echoReduction};
}
