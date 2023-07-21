import 'package:amazon_realtime/src/models/data_message/data_message_arguments.dart';
import 'package:amazon_realtime/src/models/data_source/meeting_info_model.dart';
import 'package:amazon_realtime/src/models/response/amazon_channel_response.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amazon_realtime_method_channel.dart';
import 'src/interfaces/amazon_realtime_observer_interface.dart';

abstract class AmazonRealtimePlatform extends PlatformInterface {
  /// Constructs a AmazonRealtimePlatform.
  AmazonRealtimePlatform() : super(token: _token);

  static final Object _token = Object();

  static AmazonRealtimePlatform _instance = MethodChannelAmazonRealtime();

  /// The default instance of [AmazonRealtimePlatform] to use.
  ///
  /// Defaults to [MethodChannelAmazonRealtime].
  static AmazonRealtimePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmazonRealtimePlatform] when
  /// they register themselves.
  static set instance(AmazonRealtimePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void initializeMethodCallHandler() {
    throw UnimplementedError(
        'initializeMethodCallHandler() has not been implemented.');
  }

  void removeObservers() {
    throw UnimplementedError('removeObservers() has not been implemented.');
  }

  void initializeObservers(AmazonRealtimeObserverInterface observer) {
    throw UnimplementedError(
        'initializeObservers(AmazonRealtimeObserverInterface observer) has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<AmazonChannelResponse> getAudioPermission() {
    throw UnimplementedError('getAudioPermission() has not been implemented.');
  }

  Future<AmazonChannelResponse> getVideoPermission() {
    throw UnimplementedError('getAudioPermission() has not been implemented.');
  }

  Future<AmazonChannelResponse> join(MeetingInfo info) {
    throw UnimplementedError('join(MeetingInfo info) has not been implemented');
  }

  Future<AmazonChannelResponse> stop() {
    throw UnimplementedError('stop() has not been implemented');
  }

  Future<AmazonChannelResponse> getAudioDevices() {
    throw UnimplementedError('getAudioDevices() has not been implemented');
  }

  Future<AmazonChannelResponse> getInitialAudioDevice() {
    throw UnimplementedError(
        'getInitialAudioDevice() has not been implemented');
  }

  Future<AmazonChannelResponse> updateCurrentDevice(String device) {
    throw UnimplementedError(
        'updateCurrentDevice(String device) has not been implemented');
  }

  Future<AmazonChannelResponse> enableLocalVideo() {
    throw UnimplementedError('enableLocalVideo() has not been implemented');
  }

  Future<AmazonChannelResponse> disableLocalVideo() {
    throw UnimplementedError('disableLocalVideo() has not been implemented');
  }

  Future<AmazonChannelResponse> localMute() {
    throw UnimplementedError('localMute() has not been implemented');
  }

  Future<AmazonChannelResponse> localUnmute() {
    throw UnimplementedError('localUnmute() has not been implemented');
  }

  Future<AmazonChannelResponse> sendDataMessage(DataMessageArguments message) {
    throw UnimplementedError(
        'sendDataMessage(DataMessageArguments message) has not been implemented');
  }

  Future<AmazonChannelResponse> pauseRemoteVideoTile(int tileId) async {
    throw UnimplementedError(
        'pauseRemoteVideoTile(int tileId) has not been implemented');
  }

  Future<AmazonChannelResponse> resumeRemoteVideoTile(int tileId) async {
    throw UnimplementedError(
        'resumeRemoteVideoTile(int tileId) has not been implemented');
  }
}
