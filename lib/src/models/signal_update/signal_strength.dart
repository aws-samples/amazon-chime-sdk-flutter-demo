enum SignalStrength { none, low, high }

extension SignalStrengthExtension on SignalStrength {
  int get value {
    switch (this) {
      case SignalStrength.none:
        return 0;
      case SignalStrength.low:
        return 1;
      case SignalStrength.high:
        return 2;
    }
  }

  static SignalStrength from(int intValue) {
    for (var value in SignalStrength.values) {
      if (value.value == intValue) return value;
    }
    return SignalStrength.none;
  }
}
