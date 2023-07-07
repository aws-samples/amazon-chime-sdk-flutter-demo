/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:aws_chime/src/models/video_tile_model.dart';

class VideoTileInterface {
  void videoTileDidAdd(String attendeeId, VideoTileModel videoTile) {
    // Gets called when a video tile is added
  }

  void videoTileDidRemove(String attendeeId, VideoTileModel videoTile) {
    // Gets called when a video tile is removed
  }
}
