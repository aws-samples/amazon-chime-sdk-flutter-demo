// interface
import 'src/aws_chime_platform_interface.dart';
// models
export 'src/models/attendee_info_model.dart';
export 'src/models/attendee_model.dart';
export 'src/models/join_info_model.dart';
export 'src/models/media_placement_model.dart';
export 'src/models/meeting_datasource_model.dart';
export 'src/models/meeting_model.dart';
export 'src/models/method_channel_response.dart';
export 'src/models/roster_model.dart';
export 'src/models/video_tile_model.dart';
// controllers
export 'src/controllers/aws_chime_controller.dart';
export 'src/controllers/observer_controller.dart';
export 'src/controllers/permission_controller.dart';
// constants
export 'src/constants/method_call_options.dart';

class AwsChime {
  Future<String?> getPlatformVersion() {
    return AwsChimePlatform.instance.getPlatformVersion();
  }
}
