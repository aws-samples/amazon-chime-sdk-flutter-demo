import 'dart:async';
import 'dart:convert';

import 'package:amazon_realtime/amazon_realtime_platform_interface.dart';
import 'package:amazon_realtime/src/constants/method_call_channel_const.dart';
import 'package:amazon_realtime/src/controllers/default_observer_controller.dart';
import 'package:amazon_realtime/src/interfaces/amazon_realtime_observer_interface.dart';
import 'package:amazon_realtime/src/interfaces/observer_controller_interface.dart';
import 'package:amazon_realtime/src/models/attendee/attendee_info.dart';
import 'package:amazon_realtime/src/models/data_message/data_message.dart';
import 'package:amazon_realtime/src/models/data_message/data_message_arguments.dart';
import 'package:amazon_realtime/src/models/data_source/meeting_info_model.dart';
import 'package:amazon_realtime/src/models/meeting_session/meeting_session_status_code.dart';
import 'package:amazon_realtime/src/models/response/amazon_channel_response.dart';
import 'package:amazon_realtime/src/models/video_tile/video_tile_state.dart';
import 'package:amazon_realtime/src/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [AmazonRealtimePlatform] that uses method channels.
class MethodChannelAmazonRealtime implements AmazonRealtimePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel(
    'dev.kxgcayh.amazon.realtime.plugin',
  );

  final ObserverController observer = DefaultObserverController();

  @override
  void initializeMethodCallHandler() {
    methodChannel.setMethodCallHandler(methodCallHandler);
    lg.d("Flutter Method Call Handler initialized.");
  }

  @override
  void initializeObservers(AmazonRealtimeObserverInterface observer) {
    this.observer.initializeObservers(observer);
    lg.d("AmazonRealtimeObserver initialized.");
  }

  @override
  void removeObservers() => observer.disposeObservers();

  Future<AmazonChannelResponse> callMethod(
    String method, [
    dynamic args,
  ]) async {
    try {
      lg.d("Calling $method through method channel with args: $args");
      dynamic response = await methodChannel.invokeMethod(method, args);
      lg.d("Result of calling $method: $response");
      return AmazonChannelResponse.fromJson(response);
    } on PlatformException {
      return AmazonChannelResponse(
        false,
        "Failed to Call Method: $method from PlatformException",
      );
    } catch (error, stack) {
      lg.e("Failed to Call Method: $method(${args ?? ''})", error, stack);
      return const AmazonChannelResponse(false, 'Something went wrong');
    }
  }

  Future<void> methodCallHandler(MethodCall call) async {
    try {
      Map<String, dynamic> arguments = {};
      if (call.arguments != null) arguments = jsonDecode(call.arguments);
      // lg.d(
      //   'MethodCallHandler Received on ${call.method} args: $arguments',
      // );
      switch (call.method) {
        // ? --- Realtime Handler --- //
        case MethodCallChannel.JOIN:
          await observer.realTime
              ?.attendeeJoined(AttendeeInfo.fromMap(arguments));
          break;
        case MethodCallChannel.LEAVE:
          await observer.realTime
              ?.attendeeLeft(AttendeeInfo.fromMap(arguments));
          break;
        case MethodCallChannel.DROP:
          await observer.realTime
              ?.attendeeDropped(AttendeeInfo.fromMap(arguments));
          break;
        case MethodCallChannel.MUTE:
          await observer.realTime
              ?.attendeeMuted(AttendeeInfo.fromMap(arguments));
          break;
        case MethodCallChannel.UNMUTE:
          await observer.realTime
              ?.attendeeUnmuted(AttendeeInfo.fromMap(arguments));
          break;
        case MethodCallChannel.VOLUME_CHANGED:
          try {
            await observer.realTime
                ?.attendeeVolumeChanged(AttendeeInfo.fromMap(arguments));
          } catch (error, stack) {
            lg.e('attendeeVolumeChanged', error, stack);
          }
          break;
        case MethodCallChannel.SIGNAL_STRENGTH_CHANGED:
          await observer.realTime
              ?.attendeeSignalStrengthChanged(AttendeeInfo.fromMap(arguments));
          break;

        // ? --- Video Tile Handler --- //
        case MethodCallChannel.VIDEO_TILE_ADD:
          await observer.videoTile
              ?.videoTileAdded(VideoTileState.fromMap(arguments));
          break;
        case MethodCallChannel.VIDEO_TILE_REMOVE:
          await observer.videoTile
              ?.videoTileRemoved(VideoTileState.fromMap(arguments));
          break;
        case MethodCallChannel.PAUSE_VIDEO_TILE:
          await observer.videoTile
              ?.videoTilePaused(VideoTileState.fromMap(arguments));
          break;
        case MethodCallChannel.RESUME_VIDEO_TILE:
          await observer.videoTile
              ?.videoTileResumed(VideoTileState.fromMap(arguments));
          break;

        // ? --- Audio Video Handler --- //
        case MethodCallChannel.AUDIO_SESSION_STARTED_CONNECTING:
          await observer.audioVideo
              ?.audioSessionStartedConnecting(arguments['reconnecting']);
          break;
        case MethodCallChannel.AUDIO_SESSION_STARTED:
          await observer.audioVideo
              ?.audioSessionStarted(arguments['reconnecting']);
          break;
        case MethodCallChannel.AUDIOSESSION_DROPPED:
          await observer.audioVideo?.audioSessionDropped();
          break;
        case MethodCallChannel.AUDIO_SESSION_CANCELLED_RECONNECT:
          await observer.audioVideo?.audioSessionCancelledReconnect();
          break;
        case MethodCallChannel.CONNECTION_RECOVERED:
          await observer.audioVideo?.connectionRecovered();
          break;
        case MethodCallChannel.CONNECTION_BECAME_POOR:
          await observer.audioVideo?.connectionBecamePoor();
          break;
        case MethodCallChannel.REMOTE_VIDEO_SOURCE_AVAILABLE:
          await observer.audioVideo
              ?.remoteVideoSourceAvailable(arguments['attendeeId']);
          break;
        case MethodCallChannel.REMOTE_VIDEO_SOURCE_UNAVAILABLE:
          await observer.audioVideo
              ?.remoteVideoSourceUnavailable(arguments['attendeeId']);
          break;
        case MethodCallChannel.VIDEO_SESSION_STARTED:
          MeetingSessionStatusCode statusCode = MeetingSessionStatusCode.ok;
          for (var status in MeetingSessionStatusCode.values) {
            if (status.value == arguments['sessionStatus']) statusCode = status;
          }
          await observer.audioVideo?.videoSessionStarted(statusCode);
          break;
        case MethodCallChannel.VIDEO_SESSION_STARTED_CONNECTING:
          await observer.audioVideo?.videoSessionStartedConnecting();
          break;
        case MethodCallChannel.VIDEO_SESSION_STOPPED:
          MeetingSessionStatusCode statusCode = MeetingSessionStatusCode.ok;
          for (var status in MeetingSessionStatusCode.values) {
            if (status.value == arguments['sessionStatus']) statusCode = status;
          }
          await observer.audioVideo?.videoSessionStopped(statusCode);
          break;

        // ? --- Data Messasge Handler --- //
        case MethodCallChannel.DATA_MESSAGE_RECEIVED:
          await observer.dataMessage
              ?.dataMessageReceived(DataMessage.fromMap(arguments));
          break;
        default:
          lg.w(
            'MethodCallHandler Received on ${call.method} is not implemented',
          );
          break;
      }
    } on PlatformException {
      lg.e("Failed to Call Method: ${call.method} from PlatformException");
    } catch (error, stack) {
      lg.e(
        'MethodCallHandler Failed on ${call.method} args:${call.arguments}',
        error,
        stack,
      );
    }
  }

  @override
  Future<AmazonChannelResponse> disableLocalVideo() async {
    return await callMethod(MethodCallChannel.STOP_LOCAL_VIDEO);
  }

  @override
  Future<AmazonChannelResponse> enableLocalVideo() async {
    return await callMethod(MethodCallChannel.START_LOCAL_VIDEO);
  }

  @override
  Future<AmazonChannelResponse> getAudioDevices() async {
    return await callMethod(MethodCallChannel.LIST_AUDIO_DEVICES);
  }

  @override
  Future<AmazonChannelResponse> getAudioPermission() async {
    return await callMethod(MethodCallChannel.MANAGE_AUDIO_PERMISSIONS);
  }

  @override
  Future<AmazonChannelResponse> getInitialAudioDevice() async {
    return await callMethod(MethodCallChannel.INITIAL_AUDIO_SELECTION);
  }

  @override
  Future<String?> getPlatformVersion() async {
    final result = await callMethod(MethodCallChannel.GET_PLATFORM_VERSION);
    return result.arguments;
  }

  @override
  Future<AmazonChannelResponse> getVideoPermission() async {
    return await callMethod(MethodCallChannel.MANAGE_VIDEO_PERMISSIONS);
  }

  @override
  Future<AmazonChannelResponse> join(MeetingInfo info) async {
    return await callMethod(MethodCallChannel.JOIN, info.toChannelJson());
  }

  @override
  Future<AmazonChannelResponse> localMute() async {
    return await callMethod(MethodCallChannel.MUTE);
  }

  @override
  Future<AmazonChannelResponse> localUnmute() async {
    return await callMethod(MethodCallChannel.UNMUTE);
  }

  @override
  Future<AmazonChannelResponse> sendDataMessage(
    DataMessageArguments message,
  ) async {
    return await callMethod(
        MethodCallChannel.SEND_DATA_MESSAGE, message.toMap());
  }

  @override
  Future<AmazonChannelResponse> stop() async {
    return await callMethod(MethodCallChannel.STOP);
  }

  @override
  Future<AmazonChannelResponse> updateCurrentDevice(String device) async {
    return await callMethod(
      MethodCallChannel.UPDATE_AUDIO_DEVICE,
      {'device': device},
    );
  }

  @override
  Future<AmazonChannelResponse> pauseRemoteVideoTile(int tileId) async {
    return await callMethod(
        MethodCallChannel.PAUSE_VIDEO_TILE, {'tileId': tileId});
  }

  @override
  Future<AmazonChannelResponse> resumeRemoteVideoTile(int tileId) async {
    return await callMethod(
        MethodCallChannel.RESUME_VIDEO_TILE, {'tileId': tileId});
  }
}
