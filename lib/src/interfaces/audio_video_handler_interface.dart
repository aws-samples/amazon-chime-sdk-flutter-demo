import 'package:amazon_realtime/src/models/data_source/data_source_model.dart';
import 'package:amazon_realtime/src/models/media_device/media_device.dart';

abstract class AudioVideoHandlerInterface {
  void initialize([MeetingDataSource? source]);
  Future<void> setupDataSource(MeetingDataSource source);
  Future<void> stopCurrentMeeting([String? reason]);
  Future<void> pauseVideoTile(int tileId);
  Future<void> resumeVideoTile(int tileId);
  Future<void> listAudioDevices();
  Future<void> initialAudioSelection();
  Future<void> updateAudioDevice(MediaDevice mediaDevice);
  Future<void> mute();
  Future<void> unmute();
  Future<void> updateLocalVideo();
}
