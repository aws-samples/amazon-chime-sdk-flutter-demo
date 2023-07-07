class RosterModel {
  final String? atendeeId;
  final String? name;
  final String? avatar;

  const RosterModel({
    this.atendeeId,
    this.name,
    this.avatar,
  });

  @override
  bool operator ==(covariant RosterModel other) {
    if (identical(this, other)) return true;

    return other.atendeeId == atendeeId &&
        other.name == name &&
        other.avatar == avatar;
  }

  @override
  int get hashCode => atendeeId.hashCode ^ name.hashCode ^ avatar.hashCode;

  RosterModel copyWith({
    String? atendeeId,
    String? name,
    String? avatar,
  }) {
    return RosterModel(
      atendeeId: atendeeId ?? this.atendeeId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() {
    return 'RosterModel(atendeeId: $atendeeId, name: $name, avatar: $avatar)';
  }
}
