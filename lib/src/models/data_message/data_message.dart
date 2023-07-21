import 'dart:convert';

import 'package:flutter/foundation.dart';

class DataMessage {
  final int? timestampMs;
  final String? topic;
  final List<int> data;
  final String senderAttendeeId;
  final String senderExternalUserId;
  final bool throttled;

  const DataMessage({
    this.timestampMs,
    this.topic,
    required this.data,
    required this.senderAttendeeId,
    required this.senderExternalUserId,
    this.throttled = false,
  });

  DataMessage copyWith({
    int? timestampMs,
    String? topic,
    List<int>? data,
    String? senderAttendeeId,
    String? senderExternalUserId,
    bool? throttled,
  }) {
    return DataMessage(
      timestampMs: timestampMs ?? this.timestampMs,
      topic: topic ?? this.topic,
      data: data ?? this.data,
      senderAttendeeId: senderAttendeeId ?? this.senderAttendeeId,
      senderExternalUserId: senderExternalUserId ?? this.senderExternalUserId,
      throttled: throttled ?? this.throttled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestampMs': timestampMs,
      'topic': topic,
      'data': data,
      'senderAttendeeId': senderAttendeeId,
      'senderExternalUserId': senderExternalUserId,
      'throttled': throttled,
    };
  }

  factory DataMessage.fromMap(Map<String, dynamic> map) {
    return DataMessage(
      timestampMs:
          map['timestampMs'] != null ? map['timestampMs'] as int : null,
      topic: map['topic'] != null ? map['topic'] as String : null,
      data: List<int>.from(map["data"]).map((x) => x).toList(),
      senderAttendeeId: map['senderAttendeeId'] as String,
      senderExternalUserId: map['senderExternalUserId'] as String,
      throttled: map['throttled'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  String text() => String.fromCharCodes(data);

  factory DataMessage.fromJson(String source) =>
      DataMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataMessage(timestampMs: $timestampMs, topic: $topic, data: $data, senderAttendeeId: $senderAttendeeId, senderExternalUserId: $senderExternalUserId, throttled: $throttled)';
  }

  @override
  bool operator ==(covariant DataMessage other) {
    if (identical(this, other)) return true;

    return other.timestampMs == timestampMs &&
        other.topic == topic &&
        listEquals(other.data, data) &&
        other.senderAttendeeId == senderAttendeeId &&
        other.senderExternalUserId == senderExternalUserId &&
        other.throttled == throttled;
  }

  @override
  int get hashCode {
    return timestampMs.hashCode ^
        topic.hashCode ^
        data.hashCode ^
        senderAttendeeId.hashCode ^
        senderExternalUserId.hashCode ^
        throttled.hashCode;
  }
}
