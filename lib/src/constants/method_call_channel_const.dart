class MethodCallChannel {
  static const String GET_PLATFORM_VERSION = 'getPlatformVersion';
  static const String MANAGE_AUDIO_PERMISSIONS = 'manageAudioPermissions';
  static const String MANAGE_VIDEO_PERMISSIONS = 'manageVideoPermissions';
  static const String INITIAL_AUDIO_SELECTION = 'initialAudioSelection';
  static const String JOIN = 'join';
  static const String STOP = 'stop';
  static const String LEAVE = 'leave';
  static const String DROP = 'drop';
  static const String MUTE = 'mute';
  static const String UNMUTE = 'unmute';
  static const String START_LOCAL_VIDEO = 'startLocalVideo';
  static const String STOP_LOCAL_VIDEO = 'stopLocalVideo';
  static const String VIDEO_TILE_ADD = 'videoTileAdd';
  static const String VIDEO_TILE_REMOVE = 'videoTileRemove';
  static const String LIST_AUDIO_DEVICES = 'listAudioDevices';
  static const String UPDATE_AUDIO_DEVICE = 'updateAudioDevice';
  static const String AUDIO_SESSION_DID_STOP = 'audioSessionDidStop';
  static const String VOLUME_CHANGED = 'volumeChanged';
  static const String SIGNAL_STRENGTH_CHANGED = 'signalStrengthChanged';
  static const String AUDIO_SESSION_STARTED_CONNECTING =
      'audioSessionStartedConnecting';
  static const String AUDIOSESSION_DROPPED = 'audiosessionDropped';
  static const String AUDIO_SESSION_STARTED = 'audioSessionStarted';
  static const String CONNECTION_RECOVERED = 'connectionRecovered';
  static const String AUDIO_SESSION_CANCELLED_RECONNECT =
      'audioSessionCancelledReconnect';
  static const String CONNECTION_BECAME_POOR = 'connectionBecamePoor';
  static const String VIDEO_SESSION_STARTED_CONNECTING =
      'videoSessionStartedConnecting';
  static const String VIDEO_SESSION_STARTED = 'videoSessionStarted';
  static const String VIDEO_SESSION_STOPPED = 'videoSessionStopped';
  static const String REMOTE_VIDEO_SOURCE_AVAILABLE =
      'remoteVideoSourceAvailable';
  static const String REMOTE_VIDEO_SOURCE_UNAVAILABLE =
      'remoteVideoSourceUnavailable';
  static const String DATA_MESSAGE_RECEIVED = 'dataMessageReceived';
  static const String SEND_DATA_MESSAGE = 'sendDataMessage';
  static const String PAUSE_VIDEO_TILE = "pauseVideoTile";
  static const String RESUME_VIDEO_TILE = "resumeVideoTile";
}
