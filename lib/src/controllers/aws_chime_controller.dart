import 'dart:developer';

import 'package:aws_chime/aws_chime.dart';
import 'package:aws_chime/src/aws_chime_method_channel.dart';
import 'package:aws_chime/src/aws_chime_platform_interface.dart';
import 'package:aws_chime/src/controllers/facades/aws_chime_controller_facade.dart';
import 'package:flutter/foundation.dart';

class AwsChimeController extends ChangeNotifier
    implements AwsChimeControllerFacade {
  //
  AwsChimeController({MeetingDataSource? dataSource}) {
    if (dataSource != null) initializeMeetingData(dataSource);
  }

  AwsChimePlatform get channel => MethodChannelAwsChime();

  MeetingDataSource? dataSource;
  List<String> deviceList = <String>[];

  void initializeMeetingData(MeetingDataSource meetingDataSource) {
    if (!isInitialized) {
      dataSource = meetingDataSource;
      notifyListeners();
    }
  }

  Future<bool> joinMeeting() async {
    listAudioDevices();
    if (isInitialized) {
      // final response = await channel.callMethod(
      //   MethodCallOption.JOIN,
      //   dataSource?.joinInfo.toChannelJson(),
      // );

      // if (response?.result == false) return false;
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
  void initialAudioSelection() {
    if (isInitialized) {
      // TODO: implement initialAudioSelection
      notifyListeners();
    }
  }

  @override
  void listAudioDevices() async {
    if (isInitialized) {
      try {
        List<String> deviceList = <String>[];
        MethodChannelResponse? response = await channel.callMethod(
          MethodCallOption.LIST_AUDIO_DEVICES,
        );
        if (response?.arguments != null) {
          final iterables = response!.arguments.map(
            (device) => device.toString(),
          );
          for (final item in iterables) {
            deviceList.add(item);
          }
        }
        notifyListeners();
      } catch (e, s) {
        log('ERROR: $e, $s');
      }
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
  bool get isInitialized => dataSource != null;
}
