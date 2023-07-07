class AttendeeInfoModel {
  final String externalUserId;
  final String attendeeId;
  final String joinToken;

  AttendeeInfoModel(this.externalUserId, this.attendeeId, this.joinToken);

  factory AttendeeInfoModel.fromJson(Map<String, dynamic> json) {
    var attendeeMap = json['JoinInfo']['Attendee']['Attendee'];

    return AttendeeInfoModel(
      attendeeMap['ExternalUserId'],
      attendeeMap['AttendeeId'],
      attendeeMap['JoinToken'],
    );
  }

  @override
  String toString() =>
      'AttendeeInfoModel(externalUserId: $externalUserId, attendeeId: $attendeeId, joinToken: $joinToken)';
}
