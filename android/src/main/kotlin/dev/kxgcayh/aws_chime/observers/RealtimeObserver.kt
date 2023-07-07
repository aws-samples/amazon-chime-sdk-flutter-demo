/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.aws_chime

import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.SignalUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeLevel
import dev.kxgcayh.aws_chime.enums.MethodCallFlutter
import dev.kxgcayh.aws_chime.AwsChimeCoordinator

class RealtimeObserver(val coordinator: AwsChimeCoordinator) : RealtimeObserver {

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>) {
        for (currentVolumeUpdate in volumeUpdates) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.VOLUME_CHANGED,
                volumeUpdateToMap(currentVolumeUpdate),
            )
        }
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>) {
        for (currentSignalUpdate in signalUpdates) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.SIGNAL_STRENGTH_CHANGED,
                signalUpdateToMap(currentSignalUpdate),
            )
        }
    }

    override fun onAttendeesDropped(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.DROP,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesJoined(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.JOIN,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesLeft(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.LEAVE,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesMuted(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            coordinator.callFlutterMethod(MethodCallFlutter.MUTE, attendeeInfoToMap(currentAttendeeInfo))
        }
    }

    override fun onAttendeesUnmuted(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            coordinator.callFlutterMethod(
                MethodCallFlutter.UNMUTE,
                attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    private fun attendeeInfoToMap(attendee: AttendeeInfo): Map<String, Any?> {
        return mapOf(
            "attendeeId" to attendee.attendeeId,
            "ExternalUserId" to attendee.externalUserId
        )
    }

    private fun volumeUpdateToMap(volumeUpdate: VolumeUpdate): Map<String, Any?> {
        return mapOf(
            "volumeLevel" to volumeUpdate.volumeLevel.value,
            "attendee" to attendeeInfoToMap(volumeUpdate.attendeeInfo)
        )
    }

    private fun signalUpdateToMap(signalUpdate: SignalUpdate): Map<String, Any?> {
        return mapOf(
            "signalStrength" to signalUpdate.signalStrength.value,
            "attendee" to attendeeInfoToMap(signalUpdate.attendeeInfo)
        )
    }
}