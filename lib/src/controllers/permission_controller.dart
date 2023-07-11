import 'package:aws_chime/src/aws_chime_method_channel.dart';
import 'package:aws_chime/src/constants/method_call_options.dart';
import 'package:aws_chime/src/controllers/facades/permission_controller_facade.dart';

class PermissionController implements PermissionControllerFacade {
  final _channel = MethodChannelAwsChime();

  @override
  Future<bool> audio() async {
    final response = await _channel.callMethod(
      MethodCallOption.MANAGE_AUDIO_PERMISSIONS,
    );
    return response.result;
  }

  @override
  Future<bool> video() async {
    final response = await _channel.callMethod(
      MethodCallOption.MANAGE_VIDEO_PERMISSIONS,
    );
    return response.result;
  }
}
