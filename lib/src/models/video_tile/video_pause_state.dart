enum VideoPauseState {
  unpaused,
  pausedByUserRequest,
  pausedForPoorConnection,
}

extension VideoPauseStateExtension on VideoPauseState {
  int get value {
    switch (this) {
      case VideoPauseState.unpaused:
        return 0;
      case VideoPauseState.pausedByUserRequest:
        return 1;
      case VideoPauseState.pausedForPoorConnection:
        return 2;
      default:
        throw Exception("Unknown video pause state");
    }
  }

  static VideoPauseState? fromValue(int value) {
    switch (value) {
      case 0:
        return VideoPauseState.unpaused;
      case 1:
        return VideoPauseState.pausedByUserRequest;
      case 2:
        return VideoPauseState.pausedForPoorConnection;
      default:
        return null;
    }
  }
}
