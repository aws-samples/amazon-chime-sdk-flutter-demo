// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aws_chime/src/models/join_info_model.dart';
import 'package:aws_chime/src/models/roster_model.dart';

class MeetingDataSource {
  final JoinInfoModel joinInfo;
  final List<RosterModel> rosters;

  const MeetingDataSource({
    required this.joinInfo,
    this.rosters = const <RosterModel>[],
  });
}
