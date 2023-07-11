import 'dart:convert';
import 'dart:developer';

import 'package:aws_chime/src/constants/method_call_options.dart';
import 'package:aws_chime/src/models/attendee_model.dart';
import 'package:aws_chime/src/models/method_channel_response.dart';
import 'package:aws_chime/src/models/video_tile_model.dart';
import 'package:flutter/services.dart';

import 'aws_chime_platform_interface.dart';
import 'controllers/facades/observer_controller_facade.dart';
import 'controllers/observer_controller.dart';

/// An implementation of [AwsChimePlatform] that uses method channels.
class MethodChannelAwsChime implements AwsChimePlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('aws_chime');

  final ObserverControllerFacade _obeserver = ObserverController();
  ObserverControllerFacade get observer => _obeserver;

  @override
  void initializeMethodCallHandler() {
    methodChannel.setMethodCallHandler(methodCallHandler);
  }

  @override
  Future<void> methodCallHandler(MethodCall call) async {
    log(
      "Recieved method call ${call.method} with arguments: ${call.arguments}",
    );
    switch (call.method) {
      case MethodCallOption.JOIN:
        observer.realtimeObserver?.attendeeDidJoin(
          Attendee.fromEncode(call.arguments),
        );
        break;
      case MethodCallOption.LEAVE:
        observer.realtimeObserver?.attendeeDidLeave(
          Attendee.fromEncode(call.arguments),
          didDrop: false,
        );
        break;
      case MethodCallOption.DROP:
        observer.realtimeObserver?.attendeeDidLeave(
          Attendee.fromEncode(call.arguments),
          didDrop: true,
        );
        break;
      case MethodCallOption.MUTE:
        observer.realtimeObserver?.attendeeDidMute(
          Attendee.fromEncode(call.arguments),
        );
        break;
      case MethodCallOption.UNMUTE:
        observer.realtimeObserver?.attendeeDidUnmute(
          Attendee.fromEncode(call.arguments),
        );
        break;
      case MethodCallOption.VIDEO_TILE_ADD:
        final Map<String, dynamic> json = jsonDecode(call.arguments);
        observer.videoTileObserver?.videoTileDidAdd(
          json['attendeeId'],
          VideoTileModel.fromJson(json),
        );
        break;
      case MethodCallOption.VIDEO_TILE_REMOVE:
        final Map<String, dynamic> json = jsonDecode(call.arguments);
        observer.videoTileObserver?.videoTileDidRemove(
          json['attendeeId'],
          VideoTileModel.fromJson(json),
        );
        break;
      case MethodCallOption.AUDIO_SESSION_DID_STOP:
        observer.audioVideoObserver?.audioSessionDidStop();
        break;
      default:
      // case MethodCallOption.INITIAL_AUDIO_SELECTION:
      //   break;
      // case MethodCallOption.STOP:
      //   observer.realtimeObserver?.attendeeDidLeave(call.arguments);
      //   break;
      // case MethodCallOption.LOCAL_VIDEO_ON:
      //   break;
      // case MethodCallOption.LOCAL_VIDEO_OFF:
      //   break;
      // case MethodCallOption.LIST_AUDIO_DEVICES:
      //   break;
      // case MethodCallOption.UPDATE_AUDIO_DEVICE:
      //   break;
      // case MethodCallOption.AUDIO_SESSION_DID_DROP:
      //   break;
    }
  }

  @override
  Future<MethodChannelResponse> callMethod(String methodName, [args]) async {
    try {
      dynamic response = await methodChannel.invokeMethod(methodName, args);
      return MethodChannelResponse.fromJson(response);
    } catch (e) {
      return MethodChannelResponse(false, null);
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      MethodCallOption.GET_PLATFORM_VERSION,
    );
    return version;
  }

  @override
  Future<String?> initialAudioSelection() async {
    MethodChannelResponse? device = await callMethod(
      MethodCallOption.INITIAL_AUDIO_SELECTION,
    );
    return device.arguments as String?;
  }
}
