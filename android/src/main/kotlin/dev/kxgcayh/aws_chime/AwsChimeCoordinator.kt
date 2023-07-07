package dev.kxgcayh.aws_chime

import android.content.Context
import android.app.Activity
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice
import com.amazonaws.services.chime.sdk.meetings.session.DefaultMeetingSession
import com.amazonaws.services.chime.sdk.meetings.session.MediaPlacement
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionConfiguration
import com.amazonaws.services.chime.sdk.meetings.session.CreateMeetingResponse
import com.amazonaws.services.chime.sdk.meetings.session.Meeting
import com.amazonaws.services.chime.sdk.meetings.session.CreateAttendeeResponse
import com.amazonaws.services.chime.sdk.meetings.session.Attendee
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import dev.kxgcayh.aws_chime.enums.MethodCallFlutter
import dev.kxgcayh.aws_chime.enums.ResponseEnum

class AwsChimeCoordinator(binaryMessenger: BinaryMessenger, activity: Activity) : AppCompatActivity() {
    val methodChannel : MethodChannel
    private lateinit var context: Context
    private val NULL_MEETING_SESSION_RESPONSE: MethodChannelResult = MethodChannelResult(
        false, ResponseEnum.MEETING_SESSION_IS_NULL
    )

    init {
        methodChannel = MethodChannel(binaryMessenger, "aws_chime")
        context = activity.applicationContext
    }

    fun callFlutterMethod(method: String, args: Any?) {
        methodChannel.invokeMethod(method, args)
    }

    fun join(call: MethodCall): MethodChannelResult {
        if (call.arguments == null) {
            return MethodChannelResult(false, ResponseEnum.INCORRECT_JOIN_RESPONSE_PARAMS)
        }
        val meetingId: String? = call.argument("MeetingId")
        val externalMeetingId: String? = call.argument("ExternalMeetingId")
        val mediaRegion: String? = call.argument("MediaRegion")
        val audioHostUrl: String? = call.argument("AudioHostUrl")
        val audioFallbackUrl: String? = call.argument("AudioFallbackUrl")
        val signalingUrl: String? = call.argument("SignalingUrl")
        val turnControlUrl: String? = call.argument("TurnControlUrl")
        val externalUserId: String? = call.argument("ExternalUserId")
        val attendeeId: String? = call.argument("AttendeeId")
        val joinToken: String? = call.argument("JoinToken")

        if (meetingId == null ||
            mediaRegion == null ||
            audioHostUrl == null ||
            externalMeetingId == null ||
            audioFallbackUrl == null ||
            signalingUrl == null ||
            turnControlUrl == null ||
            externalUserId == null ||
            attendeeId == null ||
            joinToken == null
        ) {
            return MethodChannelResult(false, ResponseEnum.INCORRECT_JOIN_RESPONSE_PARAMS)
        }

        val createMeetingResponse = CreateMeetingResponse(
            Meeting(
                externalMeetingId,
                MediaPlacement(audioFallbackUrl, audioHostUrl, signalingUrl, turnControlUrl),
                mediaRegion,
                meetingId
            )
        )
        val createAttendeeResponse = CreateAttendeeResponse(
            Attendee(attendeeId, externalUserId, joinToken)
        )
        val meetingSessionConfiguration = MeetingSessionConfiguration(
            createMeetingResponse, createAttendeeResponse
        )

        val meetingSession = DefaultMeetingSession(
            meetingSessionConfiguration, ConsoleLogger(), context
        )

        MeetingSessionManager.meetingSession = meetingSession
        return MeetingSessionManager.startMeeting(
            RealtimeObserver(this),
            VideoTileObserver(this),
            AudioVideoObserver(this)
        )
    }

    fun stop(): MethodChannelResult {
        return MeetingSessionManager.stop()
    }

    fun mute(): MethodChannelResult {
        val muted = MeetingSessionManager.meetingSession?.audioVideo?.realtimeLocalMute()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return if (muted) MethodChannelResult(
            true,
            ResponseEnum.MUTE_SUCCESSFUL
        ) else MethodChannelResult(false, ResponseEnum.MUTE_FAILED)
    }

    fun unmute(): MethodChannelResult {
        val unmuted = MeetingSessionManager.meetingSession?.audioVideo?.realtimeLocalUnmute()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return if (unmuted) MethodChannelResult(
            true,
            ResponseEnum.UNMUTE_SUCCESSFUL
        ) else MethodChannelResult(false, ResponseEnum.UNMUTE_FAILED)
    }

    fun startLocalVideo(): MethodChannelResult {
        MeetingSessionManager.meetingSession?.audioVideo?.startLocalVideo()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return MethodChannelResult(true, ResponseEnum.LOCAL_VIDEO_ON_SUCCESS)
    }

    fun stopLocalVideo(): MethodChannelResult {
        MeetingSessionManager.meetingSession?.audioVideo?.stopLocalVideo()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return MethodChannelResult(true, ResponseEnum.LOCAL_VIDEO_ON_SUCCESS)
    }

    fun initialAudioSelection(): MethodChannelResult {
        val device = MeetingSessionManager.meetingSession?.audioVideo?.getActiveAudioDevice()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return MethodChannelResult(true, device.label)
    }

    fun listAudioDevices(): MethodChannelResult {
        val audioDevices = MeetingSessionManager.meetingSession?.audioVideo?.listAudioDevices()
            ?: return NULL_MEETING_SESSION_RESPONSE
        val transform: (MediaDevice) -> String = { it.label }
        return MethodChannelResult(true, audioDevices.map(transform))
    }

    fun updateAudioDevice(call: MethodCall): MethodChannelResult {
        val device = call.arguments ?: return MethodChannelResult(
            false, ResponseEnum.NULL_AUDIO_DEVICE
        )

        val audioDevices = MeetingSessionManager.meetingSession?.audioVideo?.listAudioDevices()
            ?: return NULL_MEETING_SESSION_RESPONSE

        for (dev in audioDevices) {
            if (device == dev.label) {
                MeetingSessionManager.meetingSession?.audioVideo?.chooseAudioDevice(dev)
                    ?: return MethodChannelResult(false, ResponseEnum.AUDIO_DEVICE_UPDATE_FAILED)
                return MethodChannelResult(true, ResponseEnum.AUDIO_DEVICE_UPDATED)
            }
        }
        return MethodChannelResult(false, ResponseEnum.AUDIO_DEVICE_UPDATE_FAILED)
    }
}
