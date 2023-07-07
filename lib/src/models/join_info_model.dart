import 'package:aws_chime/src/models/attendee_info_model.dart';
import 'package:aws_chime/src/models/meeting_model.dart';

class JoinInfoModel {
  final MeetingModel meeting;
  final AttendeeInfoModel attendee;

  JoinInfoModel(this.meeting, this.attendee);

  factory JoinInfoModel.fromJson(Map<String, dynamic> json) {
    return JoinInfoModel(
      MeetingModel.fromJson(json),
      AttendeeInfoModel.fromJson(json),
    );
  }

  Map<String, dynamic> toChannelJson() {
    return {
      "MeetingId": meeting.meetingId,
      "ExternalMeetingId": meeting.externalMeetingId,
      "MediaRegion": meeting.mediaRegion,
      "AudioHostUrl": meeting.mediaPlacement.audioHostUrl,
      "AudioFallbackUrl": meeting.mediaPlacement.audioFallbackUrl,
      "SignalingUrl": meeting.mediaPlacement.signalingUrl,
      "TurnControlUrl": meeting.mediaPlacement.turnControllerUrl,
      "ExternalUserId": attendee.externalUserId,
      "AttendeeId": attendee.attendeeId,
      "JoinToken": attendee.joinToken
    };
  }

  @override
  String toString() => 'JoinInfo(meeting: $meeting, attendee: $attendee)';
}
