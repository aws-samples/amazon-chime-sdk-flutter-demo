enum MeetingSessionStatusCode {
  ok,
  left,
  audioJoinedFromAnotherDevice,
  audioDisconnectAudio,
  audioAuthenticationRejected,
  audioCallAtCapacity,
  audioCallEnded,
  audioInternalServerError,
  audioServiceUnavailable,
  audioDisconnected,
  connectionHealthReconnect,
  networkBecamePoor,
  videoServiceFailed,
  videoAtCapacityViewOnly,
  audioOutputDeviceNotResponding,
  audioInputDeviceNotResponding
}

extension MeetingSessionStatusCodeExtension on MeetingSessionStatusCode {
  String get message {
    switch (this) {
      case MeetingSessionStatusCode.ok:
        return 'Joined meeting session.';
      case MeetingSessionStatusCode.left:
        return 'Left meeting session';
      case MeetingSessionStatusCode.audioJoinedFromAnotherDevice:
        return 'Audio joined from another device';
      case MeetingSessionStatusCode.audioDisconnectAudio:
        return 'Audio suddenly disconnected';
      case MeetingSessionStatusCode.audioAuthenticationRejected:
        return 'Audio authentication rejected';
      case MeetingSessionStatusCode.audioCallAtCapacity:
        return 'Audio call at capacity';
      case MeetingSessionStatusCode.audioCallEnded:
        return 'Audio call ended';
      case MeetingSessionStatusCode.audioInternalServerError:
        return 'Audio internal server error';
      case MeetingSessionStatusCode.audioServiceUnavailable:
        return 'Audio service unavailable';
      case MeetingSessionStatusCode.audioDisconnected:
        return 'Audio disconnected';
      case MeetingSessionStatusCode.connectionHealthReconnect:
        return 'Connection health reconnect';
      case MeetingSessionStatusCode.networkBecamePoor:
        return 'Network became poor';
      case MeetingSessionStatusCode.videoServiceFailed:
        return 'Video service failed';
      case MeetingSessionStatusCode.videoAtCapacityViewOnly:
        return 'Video at capacity view only';
      case MeetingSessionStatusCode.audioOutputDeviceNotResponding:
        return 'Audio output device not responding';
      case MeetingSessionStatusCode.audioInputDeviceNotResponding:
        return 'Audio input device not responding';
    }
  }

  int get value {
    switch (this) {
      case MeetingSessionStatusCode.ok:
        return 0;
      case MeetingSessionStatusCode.left:
        return 1;
      case MeetingSessionStatusCode.audioJoinedFromAnotherDevice:
        return 2;
      case MeetingSessionStatusCode.audioDisconnectAudio:
        return 3;
      case MeetingSessionStatusCode.audioAuthenticationRejected:
        return 4;
      case MeetingSessionStatusCode.audioCallAtCapacity:
        return 5;
      case MeetingSessionStatusCode.audioCallEnded:
        return 6;
      case MeetingSessionStatusCode.audioInternalServerError:
        return 7;
      case MeetingSessionStatusCode.audioServiceUnavailable:
        return 8;
      case MeetingSessionStatusCode.audioDisconnected:
        return 9;
      case MeetingSessionStatusCode.connectionHealthReconnect:
        return 10;
      case MeetingSessionStatusCode.networkBecamePoor:
        return 11;
      case MeetingSessionStatusCode.videoServiceFailed:
        return 12;
      case MeetingSessionStatusCode.videoAtCapacityViewOnly:
        return 13;
      case MeetingSessionStatusCode.audioOutputDeviceNotResponding:
        return 14;
      case MeetingSessionStatusCode.audioInputDeviceNotResponding:
        return 15;
    }
  }

  static MeetingSessionStatusCode from(int intValue) {
    for (var value in MeetingSessionStatusCode.values) {
      if (value.value == intValue) return value;
    }
    return MeetingSessionStatusCode.ok;
  }
}
