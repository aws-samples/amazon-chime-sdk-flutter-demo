enum VolumeLevel { muted, notSpeaking, low, medium, high }

extension VolumeLevelExtension on VolumeLevel {
  int get value {
    switch (this) {
      case VolumeLevel.muted:
        return -1;
      case VolumeLevel.notSpeaking:
        return 0;
      case VolumeLevel.low:
        return 1;
      case VolumeLevel.medium:
        return 2;
      case VolumeLevel.high:
        return 3;
    }
  }

  static VolumeLevel from(int intValue) {
    for (var value in VolumeLevel.values) {
      if (value.value == intValue) {
        return value;
      }
    }
    return VolumeLevel.notSpeaking;
  }
}
