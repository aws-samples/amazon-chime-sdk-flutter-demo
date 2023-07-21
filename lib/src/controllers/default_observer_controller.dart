import 'package:amazon_realtime/src/interfaces/amazon_realtime_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/audiovideo_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/data_message_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/observer_controller_interface.dart';
import 'package:amazon_realtime/src/interfaces/realtime_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/video_tile_observer_interface.dart';
import 'package:flutter/foundation.dart';

class DefaultObserverController extends ChangeNotifier
    implements ObserverController {
  DefaultObserverController() : super();

  @override
  RealtimeObserverInterface? realTime;
  @override
  VideoTileObserverInterface? videoTile;
  @override
  AudioVideoObserverInterface? audioVideo;
  @override
  DataMessageObserverInterface? dataMessage;

  @override
  void initializeObservers(AmazonRealtimeObserverInterface observer) {
    realTime = observer;
    videoTile = observer;
    audioVideo = observer;
    dataMessage = observer;
    notifyListeners();
  }

  @override
  void disposeObservers() {
    realTime = null;
    videoTile = null;
    audioVideo = null;
    dataMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    disposeObservers();
    super.dispose();
  }
}
