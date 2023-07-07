// interface
import 'src/aws_chime_platform_interface.dart';

class AwsChime {
  Future<String?> getPlatformVersion() {
    return AwsChimePlatform.instance.getPlatformVersion();
  }
}
