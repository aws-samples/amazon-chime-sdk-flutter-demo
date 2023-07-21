import 'dart:convert';

import 'package:amazon_realtime/src/models/signal_update/signal_strength.dart';
import 'package:amazon_realtime/src/models/volume_update/volume_level.dart';

class RosterAttendee {
  final String attendeeId;
  final String name;
  final VolumeLevel volumeLevel;
  final SignalStrength signalStrength;
  final bool isActiveSpeaker;

  const RosterAttendee({
    required this.attendeeId,
    required this.name,
    this.volumeLevel = VolumeLevel.notSpeaking,
    this.signalStrength = SignalStrength.high,
    this.isActiveSpeaker = false,
  });

  RosterAttendee copyWith({
    String? attendeeId,
    String? name,
    VolumeLevel? volumeLevel,
    SignalStrength? signalStrength,
    bool? isActiveSpeaker,
  }) {
    return RosterAttendee(
      attendeeId: attendeeId ?? this.attendeeId,
      name: name ?? this.name,
      volumeLevel: volumeLevel ?? this.volumeLevel,
      signalStrength: signalStrength ?? this.signalStrength,
      isActiveSpeaker: isActiveSpeaker ?? this.isActiveSpeaker,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendeeId': attendeeId,
      'name': name,
      'volumeLevel': volumeLevel.value,
      'signalStrength': signalStrength.value,
      'isActiveSpeaker': isActiveSpeaker,
    };
  }

  factory RosterAttendee.fromMap(Map<String, dynamic> map) {
    return RosterAttendee(
      attendeeId: map['attendeeId'] as String,
      name: map['name'] != null
          ? map['name'] as String
          : map['attendeeName'] != null
              ? map['attendeeName'] as String
              : 'Unknown',
      volumeLevel: map['volumeLevel'] == null
          ? VolumeLevel.notSpeaking
          : VolumeLevel.values.firstWhere((level) {
              return level.value == map['volumeLevel'];
            }),
      signalStrength: map['signalStrength'] == null
          ? SignalStrength.high
          : SignalStrength.values.firstWhere((strength) {
              return strength.value == map[['signalStrength']];
            }),
      isActiveSpeaker: map['isActiveSpeaker'] != null
          ? map['isActiveSpeaker'] as bool
          : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory RosterAttendee.fromJson(String source) =>
      RosterAttendee.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RosterAttendee(attendeeId: $attendeeId, name: $name, volumeLevel: $volumeLevel, signalStrength: $signalStrength, isActiveSpeaker: $isActiveSpeaker)';
  }

  @override
  bool operator ==(covariant RosterAttendee other) {
    if (identical(this, other)) return true;

    return other.attendeeId == attendeeId &&
        other.name == name &&
        other.volumeLevel == volumeLevel &&
        other.signalStrength == signalStrength &&
        other.isActiveSpeaker == isActiveSpeaker;
  }

  @override
  int get hashCode {
    return attendeeId.hashCode ^
        name.hashCode ^
        volumeLevel.hashCode ^
        signalStrength.hashCode ^
        isActiveSpeaker.hashCode;
  }
}
