import 'package:amazon_realtime/src/models/meeting_session/meeting_session_status_code.dart';

abstract class AudioVideoObserverInterface {
  /// Called when the audio session is connecting or reconnecting.
  Future<void> audioSessionStartedConnecting(bool reconnecting);

  /// Called when the audio session has started.
  Future<void> audioSessionStarted(bool reconnecting);

  /// Called when audio session got dropped due to poor network conditions.
  /// There will be an automatic attempt of reconnecting it.
  /// If the reconnection is successful, [audioSessionStarted] will be called with value of reconnecting as true
  Future<void> audioSessionDropped();

  /// Called when the audio session has stopped with the reason
  /// provided in the status. This callback implies that audio client has stopped permanently for this session and there will be
  /// no attempt of reconnecting it.
  Future<void> audioSessionStopped(MeetingSessionStatusCode sessionStatus);

  /// Called when audio session cancelled reconnecting.
  Future<void> audioSessionCancelledReconnect();

  /// Called when the connection health is recovered.
  Future<void> connectionRecovered();

  /// Called when connection became poor.
  Future<void> connectionBecamePoor();

  /// Called when the video session is connecting or reconnecting.
  Future<void> videoSessionStartedConnecting();

  /// Called when the video session has started. Sometimes there is a non fatal error such as
  /// trying to send local video when the capacity was already reached. However, user can still
  /// receive remote video in the existing video session.
  Future<void> videoSessionStarted(MeetingSessionStatusCode sessionStatus);

  /// Called when the video session has stopped from a started state with the reason
  /// provided in the status.
  Future<void> videoSessionStopped(MeetingSessionStatusCode sessionStatus);

  /// Called when remote video source(s) is/are no longer available.
  Future<void> remoteVideoSourceUnavailable(String attendeeId);

  /// Called when remote video source(s) is/are now available.
  Future<void> remoteVideoSourceAvailable(String attendeeId);

  /// Called when video capacity status is updated.
  Future<void> cameraSendAvailabilityUpdated(bool available);
}
