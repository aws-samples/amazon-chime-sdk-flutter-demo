// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_realtime/src/models/media_device/media_device_type.dart';

class MediaDevice {
  final String label;
  final MediaDeviceType type;
  final String? id;

  int get order {
    switch (type) {
      case MediaDeviceType.AUDIO_BLUETOOTH:
        return 0;
      case MediaDeviceType.AUDIO_WIRED_HEADSET:
      case MediaDeviceType.AUDIO_USB_HEADSET:
        return 1;
      case MediaDeviceType.AUDIO_BUILTIN_SPEAKER:
        return 2;
      case MediaDeviceType.AUDIO_HANDSET:
        return 3;
      case MediaDeviceType.VIDEO_FRONT_CAMERA:
        return 4;
      case MediaDeviceType.VIDEO_BACK_CAMERA:
        return 5;
      case MediaDeviceType.VIDEO_EXTERNAL_CAMERA:
        return 6;
      default:
        return 99;
    }
  }

  static MediaDeviceType fromShortString(String shortString) {
    switch (shortString) {
      case "Bluetooth":
        return MediaDeviceType.AUDIO_BLUETOOTH;
      case "Wired Headset":
        return MediaDeviceType.AUDIO_WIRED_HEADSET;
      case "USB Headset":
        return MediaDeviceType.AUDIO_USB_HEADSET;
      case "Builtin Speaker":
        return MediaDeviceType.AUDIO_BUILTIN_SPEAKER;
      case "Handset":
        return MediaDeviceType.AUDIO_HANDSET;
      case "Front Camera":
        return MediaDeviceType.VIDEO_FRONT_CAMERA;
      case "Back Camera":
        return MediaDeviceType.VIDEO_BACK_CAMERA;
      case "External Camera":
        return MediaDeviceType.VIDEO_EXTERNAL_CAMERA;
      default:
        return MediaDeviceType.OTHER;
    }
  }

  const MediaDevice(this.label, this.type, {this.id});

  factory MediaDevice.fromJson(Map<String, dynamic> json) {
    return MediaDevice(
      json["label"],
      json["type"] == null
          ? MediaDeviceType.OTHER
          : fromShortString(json["type"]),
      id: json["id"],
    );
  }

  @override
  String toString() => 'MediaDevice(label: $label, type: $type, id: $id)';

  @override
  bool operator ==(covariant MediaDevice other) {
    if (identical(this, other)) return true;

    return other.label == label && other.type == type && other.id == id;
  }

  @override
  int get hashCode => label.hashCode ^ type.hashCode ^ id.hashCode;
}
