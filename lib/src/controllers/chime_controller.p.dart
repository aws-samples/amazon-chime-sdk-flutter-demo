part of 'chime_controller.dart';

extension ChimeControlHelper on ChimeController {
  bool get isInitialized => source != null;
  String? get localAttendeeId => source?.meetingInfo.attendee.attendeeId;

  AttendeeInfo? get localAttendee {
    if (localAttendeeId == null) return null;
    if (!attendees.isContain(localAttendeeId!)) return null;
    return attendees
        .firstWhere((attendee) => attendee.attendeeId == localAttendeeId);
  }

  VideoTileState? get localVideoTile {
    if (localAttendeeId == null) return null;
    if (!videoTilesAttendee.isContain(localAttendeeId!)) return null;
    return videoTilesAttendee
        .firstWhere((attendee) => attendee.attendeeId == localAttendeeId);
  }

  void updateLocalAttendee({
    String? externalUserId,
    String? joinToken,
    bool? isVideoOn,
    SignalStrength? signalStrength,
    VolumeLevel? volumeLevel,
    bool force = false,
  }) {
    if (localAttendeeId != null) {
      attendees.replace(
        localAttendeeId!,
        externalUserId: externalUserId,
        joinToken: joinToken,
        isVideoOn: isVideoOn,
        signalStrength: signalStrength,
        volumeLevel: volumeLevel,
        force: force,
      );
    }
  }
}

extension AttendeesHelper on List<AttendeeInfo> {
  bool isContain(String attendeeId) {
    return where((attendee) => attendee.attendeeId == attendeeId).isNotEmpty;
  }

  AttendeeInfo get(String attendeeId) {
    return where((attendee) => attendee.attendeeId == attendeeId).first;
  }

  void delete(String attendeeId) {
    return removeWhere((attendee) => attendee.attendeeId == attendeeId);
  }

  void replace(
    String attendeeKey, {
    String? attendeeId,
    String? externalUserId,
    String? joinToken,
    bool? isVideoOn,
    SignalStrength? signalStrength,
    VolumeLevel? volumeLevel,
    bool force = false,
  }) {
    final AttendeeInfo attendeeInfo = get(attendeeKey);
    delete(attendeeKey);
    add(attendeeInfo.copyWith(
      attendeeId: force ? attendeeId : attendeeId ?? attendeeInfo.attendeeId,
      externalUserId: force
          ? externalUserId
          : externalUserId ?? attendeeInfo.externalUserId,
      joinToken: force ? joinToken : joinToken ?? attendeeInfo.joinToken,
      isVideoOn: force ? isVideoOn : isVideoOn ?? attendeeInfo.isVideoOn,
      signalStrength: force
          ? signalStrength
          : signalStrength ?? attendeeInfo.signalStrength,
      volumeLevel:
          force ? volumeLevel : volumeLevel ?? attendeeInfo.volumeLevel,
    ));
  }
}

extension VideoTileStateHelper on List<VideoTileState> {
  bool isContain(String attendeeId) {
    return where((attendee) => attendee.attendeeId == attendeeId).isNotEmpty;
  }

  VideoTileState? get(String attendeeId) {
    if (!isContain(attendeeId)) return null;
    return where((attendee) => attendee.attendeeId == attendeeId).first;
  }

  void delete(String attendeeId) {
    return removeWhere((attendee) => attendee.attendeeId == attendeeId);
  }

  void replace(
    String attendeeKey, {
    int? tileId,
    String? attendeeId,
    int? videoStreamContentWidth,
    int? videoStreamContentHeight,
    bool? isLocalTile,
    bool? isContent,
    VideoPauseState? videoPauseState,
    bool force = false,
  }) {
    final VideoTileState? videoTileState = get(attendeeKey);
    if (videoTileState != null) {
      delete(attendeeKey);
      add(videoTileState.copyWith(
        tileId: force ? tileId : tileId ?? videoTileState.tileId,
        attendeeId:
            force ? attendeeId : attendeeId ?? videoTileState.attendeeId,
        videoStreamContentWidth: force
            ? videoStreamContentWidth
            : videoStreamContentWidth ?? videoTileState.videoStreamContentWidth,
        videoStreamContentHeight: force
            ? videoStreamContentHeight
            : videoStreamContentHeight ??
                videoTileState.videoStreamContentHeight,
        isLocalTile:
            force ? isLocalTile : isLocalTile ?? videoTileState.isLocalTile,
        isContent: force ? isContent : isContent ?? videoTileState.isContent,
        videoPauseState: force
            ? videoPauseState
            : videoPauseState ?? videoTileState.videoPauseState,
      ));
    }
  }
}

extension HiglightAttendee on Map<AttendeeInfo, VideoTileState?> {
  void replace(AttendeeInfo attendeeInfo, {VideoTileState? videoTileState}) {
    clear();
    this[attendeeInfo] = videoTileState;
  }
}

class HighlightedAttendee {
  const HighlightedAttendee({
    required this.attendeeInfo,
    this.videoTile,
  });

  final AttendeeInfo attendeeInfo;
  final VideoTileState? videoTile;

  HighlightedAttendee copyWith({
    AttendeeInfo? attendeeInfo,
    VideoTileState? videoTile,
  }) {
    return HighlightedAttendee(
      attendeeInfo: attendeeInfo ?? this.attendeeInfo,
      videoTile: videoTile ?? this.videoTile,
    );
  }

  @override
  bool operator ==(covariant HighlightedAttendee other) {
    if (identical(this, other)) return true;

    return other.attendeeInfo == attendeeInfo && other.videoTile == videoTile;
  }

  @override
  int get hashCode => attendeeInfo.hashCode ^ videoTile.hashCode;

  @override
  String toString() =>
      'HighlightedAttendee(attendeeInfo: $attendeeInfo, videoTile: $videoTile)';
}
