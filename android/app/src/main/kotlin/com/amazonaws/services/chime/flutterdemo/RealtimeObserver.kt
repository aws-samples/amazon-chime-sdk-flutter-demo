/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.SignalUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeUpdate

class RealtimeObserver(val methodChannel: MethodChannelCoordinator) : RealtimeObserver {

    override fun onAttendeesDropped(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCall.drop,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesJoined(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCall.join,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesLeft(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCall.leave,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesMuted(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(MethodCall.mute, attendeeInfoToMap(currentAttendeeInfo))
        }
    }

    override fun onAttendeesUnmuted(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCall.unmute,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>) {
        // Out of Scope
    }

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>) {
        // Out of Scope
    }

    private fun attendeeInfoToMap(attendee: AttendeeInfo): Map<String, Any?> {
        return mapOf(
            "attendeeId" to attendee.attendeeId,
            "externalUserId" to attendee.externalUserId
        )
    }
}