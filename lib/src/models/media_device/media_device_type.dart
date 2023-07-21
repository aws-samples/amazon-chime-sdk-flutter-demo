enum MediaDeviceType {
  AUDIO_BLUETOOTH,
  AUDIO_WIRED_HEADSET,
  AUDIO_USB_HEADSET,
  AUDIO_BUILTIN_SPEAKER,
  AUDIO_HANDSET,
  VIDEO_FRONT_CAMERA,
  VIDEO_BACK_CAMERA,
  VIDEO_EXTERNAL_CAMERA,
  OTHER,
}

extension MediaDeviceTypeToString on MediaDeviceType {
  String toShortString() {
    switch (this) {
      case MediaDeviceType.AUDIO_BLUETOOTH:
        return "Bluetooth";
      case MediaDeviceType.AUDIO_WIRED_HEADSET:
        return "Wired Headset";
      case MediaDeviceType.AUDIO_USB_HEADSET:
        return "USB Headset";
      case MediaDeviceType.AUDIO_BUILTIN_SPEAKER:
        return "Builtin Speaker";
      case MediaDeviceType.AUDIO_HANDSET:
        return "Handset";
      case MediaDeviceType.VIDEO_FRONT_CAMERA:
        return "Front Camera";
      case MediaDeviceType.VIDEO_BACK_CAMERA:
        return "Back Camera";
      case MediaDeviceType.VIDEO_EXTERNAL_CAMERA:
        return "External Camera";
      case MediaDeviceType.OTHER:
        return "Other";
    }
  }
}
