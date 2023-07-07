import 'package:aws_chime/src/controllers/facades/aws_chime_controller_facade.dart';
import 'package:aws_chime/src/interfaces/audio_devices_interface.dart';
import 'package:aws_chime/src/interfaces/audio_video_interface.dart';
import 'package:aws_chime/src/interfaces/realtime_interface.dart';
import 'package:aws_chime/src/interfaces/video_tile_interface.dart';

abstract class ObserverControllerFacade {
  AudioDevicesInterface? audioDeviceInterface;
  AudioVideoInterface? audioVideoObserver;
  RealtimeInterface? realtimeObserver;
  VideoTileInterface? videoTileObserver;

  void initializeMethodCallHandler() {
    throw UnimplementedError(
      'initializeMethodCallHandler() has not been implemented',
    );
  }

  void initializeObservers(AwsChimeControllerFacade controller) {
    throw UnimplementedError(
      'initializeObservers(AwsChimeControllerFacade controller) has not been implemented',
    );
  }

  void initializeRealtimeObserver(RealtimeInterface realtimeInterface) {
    throw UnimplementedError(
      'initializeRealtimeObserver(RealtimeInterface realtimeInterface) has not been implemented',
    );
  }

  void initializeAudioVideoObserver(AudioVideoInterface audioVideoInterface) {
    throw UnimplementedError(
      'initializeAudioVideoObserver(AudioVideoInterface audioVideoInterface) has not been implemented',
    );
  }

  void initializeVideoTileObserver(VideoTileInterface videoTileInterface) {
    throw UnimplementedError(
      'initializeVideoTileObserver(VideoTileInterface videoTileInterface) has not been implemented',
    );
  }
}
