import 'package:amazon_realtime/src/interfaces/audio_video_handler_interface.dart';
import 'package:amazon_realtime/src/interfaces/audiovideo_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/data_message_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/realtime_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/video_tile_observer_interface.dart';

abstract class AmazonRealtimeObserverInterface
    implements
        RealtimeObserverInterface,
        VideoTileObserverInterface,
        AudioVideoObserverInterface,
        DataMessageObserverInterface,
        AudioVideoHandlerInterface {}
