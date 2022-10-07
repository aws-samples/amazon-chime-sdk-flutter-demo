/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import '../video_tile.dart';

class VideoTileInterface {
  void videoTileDidAdd(String attendeeId, VideoTile videoTile) {
    // Gets called when a video tile is added
  }

  void videoTileDidRemove(String attendeeId, VideoTile videoTile) {
    // Gets called when a video tile is removed
  }
}
