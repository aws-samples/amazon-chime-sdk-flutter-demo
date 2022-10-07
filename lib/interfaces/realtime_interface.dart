/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import '../attendee.dart';

class RealtimeInterface {
  void attendeeDidJoin(Attendee attendee) {
    // Gets called when an attendee joins the meeting
  }

  void attendeeDidLeave(Attendee attendee, {required bool didDrop}) {
    // Gets called when an attendee leaves or drops the meeting
  }

  void attendeeDidMute(Attendee attendee) {
    // Gets called when an mutes themselves
  }

  void attendeeDidUnmute(Attendee attendee) {
    // Gets called when an unmutes themselves
  }
}
