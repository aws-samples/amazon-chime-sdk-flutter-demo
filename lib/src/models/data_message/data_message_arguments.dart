import 'dart:convert';

class DataMessageArguments {
  final String topic;
  final String data;
  final int lifeTimeMs;

  const DataMessageArguments({
    required this.topic,
    required this.data,
    required this.lifeTimeMs,
  });

  DataMessageArguments copyWith({
    String? topic,
    String? data,
    int? lifeTimeMs,
  }) {
    return DataMessageArguments(
      topic: topic ?? this.topic,
      data: data ?? this.data,
      lifeTimeMs: lifeTimeMs ?? this.lifeTimeMs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'topic': topic,
      'data': data,
      'lifeTimeMs': lifeTimeMs,
    };
  }

  factory DataMessageArguments.fromMap(Map<String, dynamic> map) {
    return DataMessageArguments(
      topic: map['topic'] as String,
      data: map['data'] as String,
      lifeTimeMs: map['lifeTimeMs'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataMessageArguments.fromJson(String source) =>
      DataMessageArguments.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DataMessageArguments(topic: $topic, data: $data, lifeTimeMs: $lifeTimeMs)';

  @override
  bool operator ==(covariant DataMessageArguments other) {
    if (identical(this, other)) return true;

    return other.topic == topic &&
        other.data == data &&
        other.lifeTimeMs == lifeTimeMs;
  }

  @override
  int get hashCode => topic.hashCode ^ data.hashCode ^ lifeTimeMs.hashCode;
}
