import 'package:aws_chime/src/models/method_channel_response.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'aws_chime_method_channel.dart';

abstract class AwsChimePlatform extends PlatformInterface {
  /// Constructs a AwsChimePlatform.
  AwsChimePlatform() : super(token: _token);

  static final Object _token = Object();

  static AwsChimePlatform _instance = MethodChannelAwsChime();

  /// The default instance of [AwsChimePlatform] to use.
  ///
  /// Defaults to [MethodChannelAwsChime].
  static AwsChimePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AwsChimePlatform] when
  /// they register themselves.
  static set instance(AwsChimePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void initializeMethodCallHandler() {
    throw UnimplementedError(
      'initializeMethodCallHandler() has not been implemented',
    );
  }

  Future<void> methodCallHandler(MethodCall call) async {
    throw UnimplementedError(
      'methodCallHandler(MethodCall call) has not been implemented',
    );
  }

  Future<MethodChannelResponse> callMethod(
    String methodName, [
    dynamic args,
  ]) async {
    throw UnimplementedError(
      'callMethod(String methodName, [dynamic args]) has not been implemented',
    );
  }

  Future<String?> initialAudioSelection() async {
    throw UnimplementedError(
      'initialAudioSelection() has not been implemented',
    );
  }
}
