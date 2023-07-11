import 'dart:developer';

import 'package:aws_chime/aws_chime.dart';
import 'package:aws_chime/src/controllers/aws_channel_controller.dart';
import 'package:aws_chime/src/controllers/facades/aws_chime_controller_facade.dart';
import 'package:flutter/foundation.dart';

class AwsChimeController extends ChangeNotifier
    implements AwsChimeControllerFacade {
  //
  AwsChimeController({MeetingDataSource? dataSource}) {
    if (dataSource != null) initializeMeetingData(dataSource);
  }

  final AwsChannelController _channel = AwsChannelController();

  MeetingDataSource? dataSource;
  List<String> deviceList = <String>[];
  String? selectedAudioDevice;

  void initializeMeetingData(MeetingDataSource meetingDataSource) {
    if (!isInitialized) {
      dataSource = meetingDataSource;
      notifyListeners();
    }
  }

  Future<bool> joinMeeting() async {
    if (isInitialized) {
      final response = await _channel.join(dataSource!.joinInfo);
      if (!response) return false;
      await listAudioDevices();
      await initialAudioSelection();
    }
    return true;
  }

  @override
  void attendeeDidJoin(Attendee attendee) {
    if (isInitialized) {
      // TODO: implement attendeeDidJoin
      notifyListeners();
    }
  }

  @override
  void attendeeDidLeave(Attendee attendee, {required bool didDrop}) {
    if (isInitialized) {
      // TODO: implement attendeeDidLeave
      notifyListeners();
    }
  }

  @override
  void attendeeDidMute(Attendee attendee) {
    if (isInitialized) {
      // TODO: implement attendeeDidMute
      notifyListeners();
    }
  }

  @override
  void attendeeDidUnmute(Attendee attendee) {
    if (isInitialized) {
      // TODO: implement attendeeDidUnmute
      notifyListeners();
    }
  }

  @override
  void audioSessionDidStop() {
    if (isInitialized) {
      // TODO: implement audioSessionDidStop
      notifyListeners();
    }
  }

  @override
  Future<void> initialAudioSelection() async {
    if (isInitialized) {
      selectedAudioDevice = await _channel.initialAudio();
      notifyListeners();
    }
  }

  @override
  Future<void> listAudioDevices() async {
    if (isInitialized) {
      deviceList = await _channel.getAudioDevices();
      notifyListeners();
    }
  }

  @override
  void updateCurrentDevice(String device) {
    if (isInitialized) {
      // TODO: implement updateCurrentDevice
      notifyListeners();
    }
  }

  @override
  void videoTileDidAdd(String attendeeId, VideoTileModel videoTile) {
    if (isInitialized) {
      // TODO: implement videoTileDidAdd
      notifyListeners();
    }
  }

  @override
  void videoTileDidRemove(String attendeeId, VideoTileModel videoTile) {
    if (isInitialized) {
      // TODO: implement videoTileDidRemove
      notifyListeners();
    }
  }
}

extension AwsChimeControllerHelper on AwsChimeController {
  bool get isInitialized {
    if (dataSource == null) {
      log('Error: MeetingDataSource is not initialized');
      return false;
    }
    return true;
  }
}
