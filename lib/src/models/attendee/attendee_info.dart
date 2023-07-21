// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_realtime/src/models/signal_update/signal_strength.dart';
import 'package:amazon_realtime/src/models/volume_update/volume_level.dart';

class AttendeeInfo {
  final String attendeeId;
  final String externalUserId;
  final String? joinToken;
  final bool isVideoOn;
  final SignalStrength signalStrength;
  final VolumeLevel volumeLevel;

  const AttendeeInfo({
    required this.attendeeId,
    required this.externalUserId,
    this.joinToken,
    this.isVideoOn = false,
    this.signalStrength = SignalStrength.high,
    this.volumeLevel = VolumeLevel.notSpeaking,
  });

  AttendeeInfo copyWith({
    String? attendeeId,
    String? externalUserId,
    String? joinToken,
    bool? isVideoOn,
    SignalStrength? signalStrength,
    VolumeLevel? volumeLevel,
  }) {
    return AttendeeInfo(
      attendeeId: attendeeId ?? this.attendeeId,
      externalUserId: externalUserId ?? this.externalUserId,
      joinToken: joinToken ?? this.joinToken,
      isVideoOn: isVideoOn ?? this.isVideoOn,
      signalStrength: signalStrength ?? this.signalStrength,
      volumeLevel: volumeLevel ?? this.volumeLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendeeId': attendeeId,
      'ExternalUserId': externalUserId,
      'JoinToken': joinToken,
      'isVideoOn': isVideoOn,
      'signalStrength': signalStrength.value,
      'volumeLevel': volumeLevel.value,
    };
  }

  factory AttendeeInfo.fromMap(Map<String, dynamic> map) {
    return AttendeeInfo(
      attendeeId: map['attendeeId'] as String,
      externalUserId: map['ExternalUserId'] as String,
      joinToken: map['JoinToken'] != null ? map['JoinToken'] as String : null,
      isVideoOn: map['isVideoOn'] != null ? map['isVideoOn'] as bool : false,
      signalStrength: map['signalStrength'] == null
          ? SignalStrength.high
          : SignalStrength.values.firstWhere((signal) {
              return signal.value == map['signalStrength'] as int;
            }),
      volumeLevel: map['volumeLevel'] == null
          ? VolumeLevel.high
          : VolumeLevel.values.firstWhere((volume) {
              return volume.value == map['volumeLevel'] as int;
            }),
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendeeInfo.fromJson(String source) {
    return AttendeeInfo.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'AttendeeInfo(attendeeId: $attendeeId, externalUserId: $externalUserId, joinToken: $joinToken, isVideoOn: $isVideoOn, signalStrength: $signalStrength, volumeLevel: $volumeLevel)';
  }

  @override
  bool operator ==(covariant AttendeeInfo other) {
    if (identical(this, other)) return true;

    return other.attendeeId == attendeeId &&
        other.externalUserId == externalUserId &&
        other.joinToken == joinToken &&
        other.isVideoOn == isVideoOn &&
        other.signalStrength == signalStrength &&
        other.volumeLevel == volumeLevel;
  }

  @override
  int get hashCode {
    return attendeeId.hashCode ^
        externalUserId.hashCode ^
        joinToken.hashCode ^
        isVideoOn.hashCode ^
        signalStrength.hashCode ^
        volumeLevel.hashCode;
  }
}
