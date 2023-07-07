import 'package:aws_chime/src/controllers/facades/aws_chime_controller_facade.dart';
import 'package:aws_chime/src/models/attendee_model.dart';
import 'package:aws_chime/src/models/video_tile_model.dart';
import 'package:flutter/foundation.dart';

class AwsChimeController extends ChangeNotifier
    implements AwsChimeControllerFacade {
  @override
  void attendeeDidJoin(Attendee attendee) {
    // TODO: implement attendeeDidJoin
  }

  @override
  void attendeeDidLeave(Attendee attendee, {required bool didDrop}) {
    // TODO: implement attendeeDidLeave
  }

  @override
  void attendeeDidMute(Attendee attendee) {
    // TODO: implement attendeeDidMute
  }

  @override
  void attendeeDidUnmute(Attendee attendee) {
    // TODO: implement attendeeDidUnmute
  }

  @override
  void audioSessionDidStop() {
    // TODO: implement audioSessionDidStop
  }

  @override
  void initialAudioSelection() {
    // TODO: implement initialAudioSelection
  }

  @override
  void listAudioDevices() {
    // TODO: implement listAudioDevices
  }

  @override
  void updateCurrentDevice(String device) {
    // TODO: implement updateCurrentDevice
  }

  @override
  void videoTileDidAdd(String attendeeId, VideoTileModel videoTile) {
    // TODO: implement videoTileDidAdd
  }

  @override
  void videoTileDidRemove(String attendeeId, VideoTileModel videoTile) {
    // TODO: implement videoTileDidRemove
  }
}
