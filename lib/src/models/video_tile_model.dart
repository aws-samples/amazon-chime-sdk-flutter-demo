// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:convert';

class VideoTileModel {
  final int tileId;
  final int videoStreamContentWidth;
  final int videoStreamContentHeight;
  final bool isLocalTile;
  final bool isContentShare;

  const VideoTileModel({
    required this.tileId,
    required this.videoStreamContentWidth,
    required this.videoStreamContentHeight,
    this.isLocalTile = false,
    this.isContentShare = false,
  });

  factory VideoTileModel.fromJson(Map<String, dynamic> json) {
    return VideoTileModel(
      tileId: json["tileId"],
      videoStreamContentWidth: json["videoStreamContentWidth"],
      videoStreamContentHeight: json["videoStreamContentHeight"],
      isLocalTile: json["isLocalTile"],
      isContentShare: json["isContent"],
    );
  }

  factory VideoTileModel.fromEncode(String encode) {
    final Map<String, dynamic> json = jsonDecode(encode);
    return VideoTileModel.fromJson(json);
  }

  VideoTileModel copyWith({
    int? tileId,
    int? videoStreamContentWidth,
    int? videoStreamContentHeight,
    bool? isLocalTile,
    bool? isContentShare,
  }) {
    return VideoTileModel(
      tileId: tileId ?? this.tileId,
      videoStreamContentWidth:
          videoStreamContentWidth ?? this.videoStreamContentWidth,
      videoStreamContentHeight:
          videoStreamContentHeight ?? this.videoStreamContentHeight,
      isLocalTile: isLocalTile ?? this.isLocalTile,
      isContentShare: isContentShare ?? this.isContentShare,
    );
  }

  @override
  bool operator ==(covariant VideoTileModel other) {
    if (identical(this, other)) return true;

    return other.tileId == tileId &&
        other.videoStreamContentWidth == videoStreamContentWidth &&
        other.videoStreamContentHeight == videoStreamContentHeight &&
        other.isLocalTile == isLocalTile &&
        other.isContentShare == isContentShare;
  }

  @override
  int get hashCode {
    return tileId.hashCode ^
        videoStreamContentWidth.hashCode ^
        videoStreamContentHeight.hashCode ^
        isLocalTile.hashCode ^
        isContentShare.hashCode;
  }

  @override
  String toString() {
    return 'VideoTileModel(tileId: $tileId, videoStreamContentWidth: $videoStreamContentWidth, videoStreamContentHeight: $videoStreamContentHeight, isLocalTile: $isLocalTile, isContentShare: $isContentShare)';
  }
}
