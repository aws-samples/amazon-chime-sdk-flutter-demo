import 'package:aws_chime/src/interfaces/audio_devices_interface.dart';
import 'package:aws_chime/src/interfaces/audio_video_interface.dart';
import 'package:aws_chime/src/interfaces/realtime_interface.dart';
import 'package:aws_chime/src/interfaces/video_tile_interface.dart';

abstract class AwsChimeControllerFacade
    implements
        RealtimeInterface,
        VideoTileInterface,
        AudioDevicesInterface,
        AudioVideoInterface {}
