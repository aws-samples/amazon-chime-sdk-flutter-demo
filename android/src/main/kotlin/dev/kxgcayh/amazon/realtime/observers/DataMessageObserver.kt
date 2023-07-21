/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.amazon.realtime.observers

import com.google.gson.Gson
import dev.kxgcayh.amazon.realtime.AmazonChannelCoordinator
import dev.kxgcayh.amazon.realtime.constants.MethodCallFlutter
import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessage
import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessageObserver

class DataMessageObserver(val methodChannel: AmazonChannelCoordinator) : DataMessageObserver {
    private val gson = Gson()

    override fun onDataMessageReceived(dataMessage: DataMessage) {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.DATA_MESSAGE_RECEIVED,
            gson.toJson(mapOf(
                "timestampMs" to dataMessage.timestampMs,
                "topic" to dataMessage.topic,
                "data" to dataMessage.data.toList().map { it.toInt() },
                "senderAttendeeId" to dataMessage.senderAttendeeId,
                "senderExternalUserId" to dataMessage.senderExternalUserId,
                "throttled" to dataMessage.throttled
            ))
        )
    }
}

