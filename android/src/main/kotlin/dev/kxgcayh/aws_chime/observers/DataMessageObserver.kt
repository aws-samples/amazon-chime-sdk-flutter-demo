package dev.kxgcayh.aws_chime

import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessage
import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessageObserver
import dev.kxgcayh.aws_chime.enums.MethodCallFlutter
import dev.kxgcayh.aws_chime.AwsChimeCoordinator

class DataMessageObserver(val coordinator: AwsChimeCoordinator) : DataMessageObserver {
    override fun onDataMessageReceived(dataMessage: DataMessage) {
        coordinator.callFlutterMethod(
            MethodCallFlutter.DATA_MESSAGE_RECEIVED,
            mapOf(
                "timestampMs" to dataMessage.timestampMs,
                "topic" to dataMessage.topic,
                "data" to dataMessage.data.toList().map { it.toInt() },
                "senderAttendeeId" to dataMessage.senderAttendeeId,
                "senderExternalUserId" to dataMessage.senderExternalUserId,
                "throttled" to dataMessage.throttled
            )
        )
    }
}

