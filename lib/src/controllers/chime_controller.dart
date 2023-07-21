import 'dart:convert';

import 'package:amazon_realtime/amazon_realtime_platform_interface.dart';
import 'package:amazon_realtime/src/interfaces/amazon_realtime_observer_interface.dart';
import 'package:amazon_realtime/src/models/attendee/attendee_info.dart';
import 'package:amazon_realtime/src/models/data_message/data_message.dart';
import 'package:amazon_realtime/src/models/data_source/data_source_model.dart';
import 'package:amazon_realtime/src/models/media_device/media_device.dart';
import 'package:amazon_realtime/src/models/meeting_session/meeting_session_status_code.dart';
import 'package:amazon_realtime/src/models/signal_update/signal_strength.dart';
import 'package:amazon_realtime/src/models/video_tile/video_pause_state.dart';
import 'package:amazon_realtime/src/models/video_tile/video_tile_state.dart';
import 'package:amazon_realtime/src/models/volume_update/volume_level.dart';
import 'package:amazon_realtime/src/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'chime_controller.p.dart';

class ChimeController extends ChangeNotifier
    implements AmazonRealtimeObserverInterface {
  ChimeController([MeetingDataSource? dataSource]) {
    initialize(dataSource);
  }

  MeetingDataSource? source;
  MediaDevice? selectedMediaDevice;
  HighlightedAttendee? highlighted;
  List<AttendeeInfo> attendees = <AttendeeInfo>[];
  List<VideoTileState> videoTilesAttendee = <VideoTileState>[];
  List<DataMessage> messages = <DataMessage>[];
  List<MediaDevice> mediaDevices = <MediaDevice>[];

  @override
  void initialize([MeetingDataSource? source]) async {
    if (!isInitialized) {
      plugin.initializeObservers(this);
      plugin.initializeMethodCallHandler();
      final cameraPermission = await Permission.camera.status;
      final microphonePermission = await Permission.microphone.status;
      if (cameraPermission.isDenied || microphonePermission.isDenied) {
        await [Permission.camera, Permission.microphone].request();
      } else if (cameraPermission.isPermanentlyDenied ||
          microphonePermission.isPermanentlyDenied) {
        openAppSettings();
      }
      if (source != null) setupDataSource(source);
    }
  }

  @override
  Future<void> setupDataSource(
    MeetingDataSource source, {
    bool ready = true,
  }) async {
    if (ready) {
      this.source = source;
      await plugin.join(source.meetingInfo);
      await listAudioDevices();
      await initialAudioSelection();
      notifyListeners();
    }
  }

  @override
  Future<void> initialAudioSelection() async {
    if (!isInitialized) return;
    final channelResponse = await plugin.getInitialAudioDevice();
    selectedMediaDevice = MediaDevice.fromJson(
      jsonDecode(channelResponse.arguments),
    );
  }

  @override
  Future<void> listAudioDevices() async {
    if (!isInitialized) return;
    final channelResponse = await plugin.getAudioDevices();
    if (channelResponse.result) {
      final arguments = jsonDecode(channelResponse.arguments ?? '[]') as List;
      mediaDevices.addAll(
        arguments.map((device) => MediaDevice.fromJson(device)),
      );
    }
  }

  @override
  Future<void> updateAudioDevice(MediaDevice mediaDevice) async {
    if (!isInitialized) return;
    final response = await plugin.updateCurrentDevice(mediaDevice.label);
    if (response.result) {
      selectedMediaDevice = mediaDevice;
      notifyListeners();
    }
  }

  @override
  Future<void> mute() async => await plugin.localMute();

  @override
  Future<void> unmute() async => await plugin.localUnmute();

  @override
  Future<void> stopCurrentMeeting([String? reason]) async {
    if (isInitialized) {
      if (reason != null) {
        // TODO: Display reason to user
      }
      await plugin.stop().then((_) {
        selectedMediaDevice = null;
        attendees.clear();
        highlighted = null;
        videoTilesAttendee.clear();
        mediaDevices.clear();
        messages.clear();
        plugin.removeObservers();
        source = null;
        notifyListeners();
      });
    }
  }

  @override
  Future<void> attendeeDropped(AttendeeInfo attendeeInfo) async {
    if (!isInitialized) return;
    if (attendees.isContain(attendeeInfo.attendeeId)) {
      attendees.delete(attendeeInfo.attendeeId);
      notifyListeners();
    }
  }

  @override
  Future<void> attendeeJoined(AttendeeInfo attendeeInfo) async {
    if (!isInitialized) return;
    if (!attendees.isContain(attendeeInfo.attendeeId)) {
      attendees.add(attendeeInfo);
      notifyListeners();
    }
  }

  @override
  Future<void> attendeeLeft(AttendeeInfo attendeeInfo) async {
    if (!isInitialized) return;
    if (attendees.isContain(attendeeInfo.attendeeId)) {
      attendees.delete(attendeeInfo.attendeeId);
      notifyListeners();
    }
  }

  @override
  Future<void> attendeeMuted(AttendeeInfo attendeeInfo) async {
    if (!isInitialized) return;
    if (attendees.isContain(attendeeInfo.attendeeId)) {
      attendees.replace(attendeeInfo.attendeeId,
          volumeLevel: attendeeInfo.volumeLevel);
      notifyListeners();
    }
  }

  @override
  Future<void> attendeeSignalStrengthChanged(AttendeeInfo attendeeInfo) async {
    if (!isInitialized) return;
    if (attendees.isContain(attendeeInfo.attendeeId)) {
      attendees.replace(
        attendeeInfo.attendeeId,
        signalStrength: attendeeInfo.signalStrength,
      );
      notifyListeners();
    }
  }

  @override
  Future<void> attendeeUnmuted(AttendeeInfo attendeeInfo) async {
    if (!isInitialized) return;
    if (attendees.isContain(attendeeInfo.attendeeId)) {
      attendees.replace(
        attendeeInfo.attendeeId,
        volumeLevel: attendeeInfo.volumeLevel,
      );
      notifyListeners();
    }
  }

  @override
  Future<void> attendeeVolumeChanged(AttendeeInfo attendeeInfo) async {
    try {
      if (!isInitialized) return;
      if (attendees.isContain(attendeeInfo.attendeeId)) {
        attendees.replace(
          attendeeInfo.attendeeId,
          volumeLevel: attendeeInfo.volumeLevel,
        );
        if (attendeeInfo.attendeeId != localAttendeeId) {
          highlighted = HighlightedAttendee(
            attendeeInfo: attendees.get(attendeeInfo.attendeeId),
            videoTile: videoTilesAttendee.get(attendeeInfo.attendeeId),
          );
        }
        notifyListeners();
      }
    } catch (error, stack) {
      lg.e('ERROR: attendeeVolumeChanged', error, stack);
    }
  }

  @override
  Future<void> videoTileAdded(VideoTileState tileState) async {
    if (!isInitialized) return;
    final String attendeeKey = tileState.attendeeId;
    if (attendees.isContain(attendeeKey) &&
        !videoTilesAttendee.isContain(attendeeKey)) {
      attendees.replace(attendeeKey, isVideoOn: true);
      videoTilesAttendee.add(tileState.copyWith(
        isLocalTile: attendeeKey == localAttendeeId,
      ));
      if (tileState.attendeeId != localAttendeeId && !tileState.isLocalTile) {
        highlighted = highlighted?.copyWith(
          videoTile: tileState,
        );
      }
      notifyListeners();
    }
  }

  @override
  Future<void> videoTilePaused(VideoTileState tileState) async {
    if (!isInitialized) return;
    final String attendeeKey = tileState.attendeeId;
    if (attendees.isContain(attendeeKey) &&
        videoTilesAttendee.isContain(attendeeKey)) {
      attendees.replace(attendeeKey, isVideoOn: false);
      videoTilesAttendee.replace(
        attendeeKey,
        videoPauseState: tileState.videoPauseState,
        isLocalTile: attendeeKey == localAttendeeId,
      );
      notifyListeners();
    }
  }

  @override
  Future<void> videoTileRemoved(VideoTileState tileState) async {
    if (!isInitialized) return;
    final String attendeeKey = tileState.attendeeId;
    if (attendees.isContain(attendeeKey) &&
        videoTilesAttendee.isContain(attendeeKey)) {
      attendees.replace(attendeeKey, isVideoOn: false);
      videoTilesAttendee.delete(attendeeKey);

      if (tileState.tileId == highlighted?.videoTile?.tileId) {
        highlighted = HighlightedAttendee(
            attendeeInfo: attendees.get(tileState.attendeeId));
      }

      notifyListeners();
    }
  }

  @override
  Future<void> videoTileResumed(VideoTileState tileState) async {
    if (!isInitialized) return;
    final String attendeeKey = tileState.attendeeId;
    if (attendees.isContain(attendeeKey) &&
        videoTilesAttendee.isContain(attendeeKey)) {
      attendees.replace(attendeeKey, isVideoOn: true);
      videoTilesAttendee.replace(
        attendeeKey,
        videoPauseState: tileState.videoPauseState,
        isLocalTile: attendeeKey == localAttendeeId,
      );
      notifyListeners();
    }
  }

  @override
  Future<void> connectionBecamePoor() async {
    if (!isInitialized && localAttendeeId != null) return;
    updateLocalAttendee(signalStrength: SignalStrength.low);
    notifyListeners();
  }

  @override
  Future<void> connectionRecovered() async {
    if (!isInitialized && localAttendeeId != null) return;
    updateLocalAttendee(signalStrength: SignalStrength.high);
    notifyListeners();
  }

  @override
  Future<void> audioSessionStopped(
    MeetingSessionStatusCode sessionStatus,
  ) async {
    if (!isInitialized) return;
    await stopCurrentMeeting(sessionStatus.message);
  }

  @override
  Future<void> pauseVideoTile(int tileId) async {
    if (!isInitialized) return;
    await plugin.pauseRemoteVideoTile(tileId);
  }

  @override
  Future<void> resumeVideoTile(int tileId) async {
    if (!isInitialized) return;
    await plugin.resumeRemoteVideoTile(tileId);
  }

  @override
  Future<void> dataMessageReceived(DataMessage dataMessage) async {
    if (!isInitialized) return;
    if (attendees.isContain(dataMessage.senderAttendeeId)) {
      messages.add(dataMessage);
      notifyListeners();
    }
  }

  @override
  Future<void> audioSessionCancelledReconnect() async {
    if (!isInitialized) return;
  }

  @override
  Future<void> audioSessionDropped() async {
    if (!isInitialized) return;
  }

  @override
  Future<void> audioSessionStarted(bool reconnecting) async {
    if (!isInitialized) return;
  }

  @override
  Future<void> audioSessionStartedConnecting(bool reconnecting) async {
    if (!isInitialized) return;
  }

  @override
  Future<void> cameraSendAvailabilityUpdated(bool available) async {
    if (!isInitialized) return;
  }

  @override
  Future<void> remoteVideoSourceAvailable(String attendeeId) async {
    if (!isInitialized) return;
  }

  @override
  Future<void> remoteVideoSourceUnavailable(String attendeeId) async {
    if (!isInitialized) return;
  }

  @override
  Future<void> videoSessionStarted(
    MeetingSessionStatusCode sessionStatus,
  ) async {
    if (!isInitialized) return;
  }

  @override
  Future<void> videoSessionStartedConnecting() async {
    if (!isInitialized) return;
  }

  @override
  Future<void> videoSessionStopped(
    MeetingSessionStatusCode sessionStatus,
  ) async {
    if (!isInitialized) return;
  }

  @override
  Future<void> updateLocalVideo() async {
    if (!isInitialized) return;
    if (localAttendee?.isVideoOn ?? false) {
      await plugin.disableLocalVideo();
    } else {
      await plugin.enableLocalVideo();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    stopCurrentMeeting();
    super.dispose();
  }

  AmazonRealtimePlatform get plugin => AmazonRealtimePlatform.instance;
}
