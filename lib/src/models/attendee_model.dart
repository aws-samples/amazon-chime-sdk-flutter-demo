// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:convert';

import 'package:aws_chime/src/models/video_tile_model.dart';

class Attendee {
  final String attendeeId;
  final String externalUserId;
  final bool muteStatus;
  final bool isVideoOn;
  final VideoTileModel? videoTile;

  const Attendee({
    required this.attendeeId,
    required this.externalUserId,
    this.muteStatus = false,
    this.isVideoOn = false,
    this.videoTile,
  });

  factory Attendee.fromJson(dynamic json) {
    return Attendee(
      attendeeId: json["attendeeId"],
      externalUserId: json["externalUserId"],
    );
  }

  factory Attendee.fromEncode(String encode) {
    final Map<String, dynamic> json = jsonDecode(encode);
    return Attendee.fromJson(json);
  }

  Attendee copyWith({
    String? attendeeId,
    String? externalUserId,
    bool? muteStatus,
    bool? isVideoOn,
    VideoTileModel? videoTile,
  }) {
    return Attendee(
      attendeeId: attendeeId ?? this.attendeeId,
      externalUserId: externalUserId ?? this.externalUserId,
      muteStatus: muteStatus ?? this.muteStatus,
      isVideoOn: isVideoOn ?? this.isVideoOn,
      videoTile: videoTile ?? this.videoTile,
    );
  }

  @override
  bool operator ==(covariant Attendee other) {
    if (identical(this, other)) return true;

    return other.attendeeId == attendeeId &&
        other.externalUserId == externalUserId &&
        other.muteStatus == muteStatus &&
        other.isVideoOn == isVideoOn &&
        other.videoTile == videoTile;
  }

  @override
  int get hashCode {
    return attendeeId.hashCode ^
        externalUserId.hashCode ^
        muteStatus.hashCode ^
        isVideoOn.hashCode ^
        videoTile.hashCode;
  }

  @override
  String toString() {
    return 'Attendee(attendeeId: $attendeeId, externalUserId: $externalUserId, muteStatus: $muteStatus, isVideoOn: $isVideoOn, videoTile: $videoTile)';
  }
}
