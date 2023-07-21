import 'package:amazon_realtime/src/models/attendee/attendee_info.dart';
import 'package:amazon_realtime/src/models/signal_update/signal_strength.dart';

abstract class RealtimeObserverInterface {
  /// Handles volume changes for attendees whose [VolumeLevel] has changed.
  Future<void> attendeeVolumeChanged(AttendeeInfo attendeeInfo);

  /// Handles signal strength changes for attendees whose [SignalStrength] has changed.
  Future<void> attendeeSignalStrengthChanged(AttendeeInfo attendeeInfo);

  /// Handles attendee(s) being added.
  Future<void> attendeeJoined(AttendeeInfo attendeeInfo);

  /// Handles attendee(s) being removed.
  Future<void> attendeeLeft(AttendeeInfo attendeeInfo);

  /// Handles attendee(s) being dropped due to network.
  Future<void> attendeeDropped(AttendeeInfo attendeeInfo);

  /// Handles attendee(s) whose [VolumeLevel] has changed to muted.
  Future<void> attendeeMuted(AttendeeInfo attendeeInfo);

  /// Handles attendee(s) whose [VolumeLevel] has changed from muted.
  Future<void> attendeeUnmuted(AttendeeInfo attendeeInfo);
}
