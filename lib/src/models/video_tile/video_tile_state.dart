import 'dart:convert';

import 'package:amazon_realtime/src/models/video_tile/video_pause_state.dart';

class VideoTileState {
  final int tileId;
  final String attendeeId;
  final int videoStreamContentWidth;
  final int videoStreamContentHeight;
  final bool isLocalTile;
  final bool isContent;
  final VideoPauseState videoPauseState;

  const VideoTileState({
    required this.tileId,
    required this.attendeeId,
    required this.videoStreamContentWidth,
    required this.videoStreamContentHeight,
    this.isLocalTile = false,
    this.isContent = false,
    this.videoPauseState = VideoPauseState.unpaused,
  });

  VideoTileState copyWith({
    int? tileId,
    String? attendeeId,
    int? videoStreamContentWidth,
    int? videoStreamContentHeight,
    bool? isLocalTile,
    bool? isContent,
    VideoPauseState? videoPauseState,
  }) {
    return VideoTileState(
      tileId: tileId ?? this.tileId,
      attendeeId: attendeeId ?? this.attendeeId,
      videoStreamContentWidth:
          videoStreamContentWidth ?? this.videoStreamContentWidth,
      videoStreamContentHeight:
          videoStreamContentHeight ?? this.videoStreamContentHeight,
      isLocalTile: isLocalTile ?? this.isLocalTile,
      isContent: isContent ?? this.isContent,
      videoPauseState: videoPauseState ?? this.videoPauseState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tileId': tileId,
      'attendeeId': attendeeId,
      'videoStreamContentWidth': videoStreamContentWidth,
      'videoStreamContentHeight': videoStreamContentHeight,
      'isLocalTile': isLocalTile,
      'isContent': isContent,
      'videoPauseState': videoPauseState.value,
    };
  }

  factory VideoTileState.fromMap(Map<String, dynamic> map) {
    return VideoTileState(
      tileId: map['tileId'] as int,
      attendeeId: map['attendeeId'] as String,
      videoStreamContentWidth: map['videoStreamContentWidth'] as int,
      videoStreamContentHeight: map['videoStreamContentHeight'] as int,
      isLocalTile: map['isLocalTile'] as bool,
      isContent: map['isContent'] as bool,
      videoPauseState: VideoPauseState.values.firstWhere(
        (state) => state.value == map['videoPauseState'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoTileState.fromJson(String source) =>
      VideoTileState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoTileState(tileId: $tileId, attendeeId: $attendeeId, videoStreamContentWidth: $videoStreamContentWidth, videoStreamContentHeight: $videoStreamContentHeight, isLocalTile: $isLocalTile, isContent: $isContent, videoPauseState: $videoPauseState)';
  }

  @override
  bool operator ==(covariant VideoTileState other) {
    if (identical(this, other)) return true;

    return other.tileId == tileId &&
        other.attendeeId == attendeeId &&
        other.videoStreamContentWidth == videoStreamContentWidth &&
        other.videoStreamContentHeight == videoStreamContentHeight &&
        other.isLocalTile == isLocalTile &&
        other.isContent == isContent &&
        other.videoPauseState == videoPauseState;
  }

  @override
  int get hashCode {
    return tileId.hashCode ^
        attendeeId.hashCode ^
        videoStreamContentWidth.hashCode ^
        videoStreamContentHeight.hashCode ^
        isLocalTile.hashCode ^
        isContent.hashCode ^
        videoPauseState.hashCode;
  }
}
