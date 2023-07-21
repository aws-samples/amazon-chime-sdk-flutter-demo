import 'package:amazon_realtime/src/models/video_tile/video_tile_state.dart';

abstract class VideoTileObserverInterface {
  /// Called whenever an attendee starts sharing the video.
  Future<void> videoTileAdded(VideoTileState tileState);

  /// Called whenever any attendee stops sharing the video.
  Future<void> videoTileRemoved(VideoTileState tileState);

  /// Called whenever an attendee tile pauseState changes from [VideoPauseState.Unpaused].
  Future<void> videoTilePaused(VideoTileState tileState);

  /// Called whenever an attendee tile pauseState changes to [VideoPauseState.Unpaused].
  Future<void> videoTileResumed(VideoTileState tileState);
}
