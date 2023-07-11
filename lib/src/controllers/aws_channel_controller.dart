import 'package:aws_chime/aws_chime.dart';
import 'package:aws_chime/src/aws_chime_method_channel.dart';
import 'package:aws_chime/src/aws_chime_platform_interface.dart';

class AwsChannelController {
  AwsChannelController() : super();

  final AwsChimePlatform _channel = MethodChannelAwsChime();

  Future<bool> join(JoinInfoModel data) async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.JOIN,
      data.toChannelJson(),
    );
    return response.result;
  }

  Future<String> initialAudio() async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.INITIAL_AUDIO_SELECTION,
    );
    return response.arguments;
  }

  Future<List<String>> getAudioDevices() async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.LIST_AUDIO_DEVICES,
    );
    return List<String>.from(
      List<String>.from(response.arguments.map((device) {
        if (device != null) return device.toString();
      }).toList()),
    );
  }

  Future<bool> changeAudioDevice(String device) async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.UPDATE_AUDIO_DEVICE,
      device,
    );
    return response.result;
  }

  Future<bool> enableVideo() async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.LOCAL_VIDEO_ON,
    );
    return response.result;
  }

  Future<bool> disableVideo() async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.LOCAL_VIDEO_OFF,
    );
    return response.result;
  }

  Future<bool> mute() async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.MUTE,
    );
    return response.result;
  }

  Future<bool> unmute() async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.UNMUTE,
    );
    return response.result;
  }

  Future<bool> stop() async {
    final MethodChannelResponse response = await _channel.callMethod(
      MethodCallOption.STOP,
    );
    return response.result;
  }
}
