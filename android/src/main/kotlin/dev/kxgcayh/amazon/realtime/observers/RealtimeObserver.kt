/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.amazon.realtime.observers

import com.google.gson.Gson
import dev.kxgcayh.amazon.realtime.AmazonChannelCoordinator
import dev.kxgcayh.amazon.realtime.constants.MethodCallFlutter
import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.SignalUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeLevel

class RealtimeObserver(val methodChannel: AmazonChannelCoordinator) : RealtimeObserver {
    private val gson = Gson()

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>) {
        for (currentVolumeUpdate in volumeUpdates) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.VOLUME_CHANGED,
                volumeUpdateToAttendeeJson(currentVolumeUpdate),
            )
        }
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>) {
        for (currentSignalUpdate in signalUpdates) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.SIGNAL_STRENGTH_CHANGED,
                signalUpdateToJson(currentSignalUpdate),
            )
        }
    }

    override fun onAttendeesDropped(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.DROP,
                attendeeInfoToJson(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesJoined(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.JOIN,
                attendeeInfoToJson(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesLeft(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.LEAVE,
                attendeeInfoToJson(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesMuted(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.MUTE,
                attendeeInfoToJson(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesUnmuted(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                MethodCallFlutter.UNMUTE,
                attendeeInfoToJson(currentAttendeeInfo)
            )
        }
    }

    private fun attendeeInfoToJson(attendee: AttendeeInfo): String {
        return gson.toJson(mapOf(
            "attendeeId" to attendee.attendeeId,
            "ExternalUserId" to attendee.externalUserId
        ))
    }

    private fun volumeUpdateToAttendeeJson(volumeUpdate: VolumeUpdate): String {
        return gson.toJson(mapOf(
            "attendeeId" to volumeUpdate.attendeeInfo.attendeeId,
            "ExternalUserId" to volumeUpdate.attendeeInfo.externalUserId,
            "volumeLevel" to volumeUpdate.volumeLevel.value
        ))
    }

    private fun signalUpdateToJson(signalUpdate: SignalUpdate): String {
        return gson.toJson(mapOf(
            "attendeeId" to signalUpdate.attendeeInfo.attendeeId,
            "ExternalUserId" to signalUpdate.attendeeInfo.externalUserId,
            "signalStrength" to signalUpdate.signalStrength.value
        ))
    }
}