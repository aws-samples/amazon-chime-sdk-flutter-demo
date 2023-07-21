import 'package:flutter/foundation.dart';

import 'package:amazon_realtime/src/models/data_source/meeting_info_model.dart';
import 'package:amazon_realtime/src/models/roster/roster_attendee.dart';

class MeetingDataSource {
  final MeetingInfo meetingInfo;
  final List<RosterAttendee> rosters;

  const MeetingDataSource({
    required this.meetingInfo,
    this.rosters = const <RosterAttendee>[],
  });

  @override
  bool operator ==(covariant MeetingDataSource other) {
    if (identical(this, other)) return true;

    return other.meetingInfo == meetingInfo &&
        listEquals(other.rosters, rosters);
  }

  @override
  int get hashCode => meetingInfo.hashCode ^ rosters.hashCode;

  MeetingDataSource copyWith({
    MeetingInfo? meetingInfo,
    List<RosterAttendee>? rosters,
  }) {
    return MeetingDataSource(
      meetingInfo: meetingInfo ?? this.meetingInfo,
      rosters: rosters ?? this.rosters,
    );
  }

  @override
  String toString() =>
      'MeetingDataSource(meetingInfo: $meetingInfo, rosters: $rosters)';
}
