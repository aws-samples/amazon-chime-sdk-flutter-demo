export 'src/controllers/chime_controller.dart';
export 'src/models/data_source/data_source_model.dart';
export 'src/models/data_source/meeting_info_model.dart';
export 'src/models/attendee/attendee_info.dart';
export 'src/models/media_device/media_device.dart';
export 'src/models/media_device/media_device_type.dart';
export 'src/models/video_tile/video_tile_state.dart';
export 'src/models/video_tile/video_pause_state.dart';
export 'src/models/data_message/data_message.dart';
export 'src/models/data_message/data_message_arguments.dart';
export 'src/models/signal_update/signal_strength.dart';
export 'src/models/volume_update/volume_level.dart';
export 'src/interfaces/amazon_realtime_observer_interface.dart';

import 'amazon_realtime_platform_interface.dart';

class AmazonRealtime {
  Future<String?> getPlatformVersion() {
    return AmazonRealtimePlatform.instance.getPlatformVersion();
  }
}
