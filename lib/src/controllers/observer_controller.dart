import 'package:aws_chime/src/controllers/facades/aws_chime_controller_facade.dart';
import 'package:aws_chime/src/interfaces/audio_devices_interface.dart';
import 'package:aws_chime/src/interfaces/audio_video_interface.dart';
import 'package:aws_chime/src/interfaces/realtime_interface.dart';
import 'package:aws_chime/src/interfaces/video_tile_interface.dart';
import 'package:aws_chime/src/controllers/facades/observer_controller_facade.dart';

class ObserverController implements ObserverControllerFacade {
  @override
  AudioDevicesInterface? audioDeviceInterface;

  @override
  AudioVideoInterface? audioVideoObserver;

  @override
  RealtimeInterface? realtimeObserver;

  @override
  VideoTileInterface? videoTileObserver;

  @override
  void initializeObservers(AwsChimeControllerFacade chimeController) {
    initializeRealtimeObserver(chimeController);
    initializeAudioVideoObserver(chimeController);
    initializeVideoTileObserver(chimeController);
    initializeAudioDevicesINterface(chimeController);
  }

  @override
  void initializeAudioVideoObserver(AudioVideoInterface audioVideoInterface) {
    audioVideoObserver = audioVideoInterface;
  }

  @override
  void initializeRealtimeObserver(RealtimeInterface interface) {
    realtimeObserver = interface;
  }

  @override
  void initializeVideoTileObserver(VideoTileInterface interface) {
    videoTileObserver = interface;
  }

  void initializeAudioDevicesINterface(AudioDevicesInterface interface) {
    audioDeviceInterface = interface;
  }
}
