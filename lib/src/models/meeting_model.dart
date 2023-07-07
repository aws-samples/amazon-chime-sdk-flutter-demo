import 'package:aws_chime/src/models/media_placement_model.dart';

class MeetingModel {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacementModel mediaPlacement;

  MeetingModel(
    this.meetingId,
    this.externalMeetingId,
    this.mediaRegion,
    this.mediaPlacement,
  );

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    var meetingMap = json['JoinInfo']['Meeting']['Meeting'];

    return MeetingModel(
      meetingMap['MeetingId'],
      meetingMap['ExternalMeetingId'],
      meetingMap['MediaRegion'],
      MediaPlacementModel.fromJson(json),
    );
  }

  @override
  String toString() {
    return 'MeetingModel(meetingId: $meetingId, externalMeetingId: $externalMeetingId, mediaRegion: $mediaRegion, mediaPlacement: $mediaPlacement)';
  }
}
