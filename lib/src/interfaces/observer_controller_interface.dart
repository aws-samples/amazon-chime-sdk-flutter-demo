import 'package:amazon_realtime/src/interfaces/amazon_realtime_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/audiovideo_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/data_message_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/realtime_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/video_tile_observer_interface.dart';

abstract class ObserverController {
  RealtimeObserverInterface? realTime;
  VideoTileObserverInterface? videoTile;
  AudioVideoObserverInterface? audioVideo;
  DataMessageObserverInterface? dataMessage;

  void initializeObservers(AmazonRealtimeObserverInterface observer) {
    throw UnimplementedError(
        'initializeObservers(AmazonRealtimeObserverInterface observer) has not been implemented');
  }

  void disposeObservers() {
    throw UnimplementedError('disposeObservers() has not been implemented');
  }
}
