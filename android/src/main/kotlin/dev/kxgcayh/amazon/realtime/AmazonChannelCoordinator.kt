package dev.kxgcayh.amazon.realtime

import com.google.gson.Gson
import android.app.Activity
import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import dev.kxgcayh.amazon.realtime.constants.ResponseMessage
import dev.kxgcayh.amazon.realtime.constants.MethodCallFlutter
import dev.kxgcayh.amazon.realtime.utils.MeetingSessionManager
import dev.kxgcayh.amazon.realtime.observers.AudioVideoObserver
import dev.kxgcayh.amazon.realtime.observers.DataMessageObserver
import dev.kxgcayh.amazon.realtime.observers.RealtimeObserver
import dev.kxgcayh.amazon.realtime.observers.VideoTileObserver
import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice
import com.amazonaws.services.chime.sdk.meetings.session.Attendee
import com.amazonaws.services.chime.sdk.meetings.session.Meeting
import com.amazonaws.services.chime.sdk.meetings.session.MediaPlacement
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import com.amazonaws.services.chime.sdk.meetings.session.DefaultMeetingSession
import com.amazonaws.services.chime.sdk.meetings.session.CreateMeetingResponse
import com.amazonaws.services.chime.sdk.meetings.session.CreateAttendeeResponse
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionConfiguration

class AmazonChannelCoordinator(channel: MethodChannel, context: Context): MethodCallHandler, AppCompatActivity() {
    private val gson = Gson()
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    init {
        this.channel = channel
        this.context = context
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        var callResult: AmazonChannelResponse = AmazonChannelResponse(false, ResponseMessage.METHOD_NOT_IMPLEMENTED)
        callResult = when (call.method) {
            MethodCallFlutter.GET_PLATFORM_VERSION -> {
                AmazonChannelResponse(true, "Android ${android.os.Build.VERSION.RELEASE}")
            }
            MethodCallFlutter.JOIN -> {
                join(call)
            }
            MethodCallFlutter.LIST_AUDIO_DEVICES -> {
                listAudioDevices()
            }
            MethodCallFlutter.INITIAL_AUDIO_SELECTION -> {
                initialAudioSelection()
            }
            MethodCallFlutter.UPDATE_AUDIO_DEVICE -> {
                updateAudioDevice(call)
            }
            MethodCallFlutter.MUTE -> {
                mute()
            }
            MethodCallFlutter.UNMUTE -> {
                unmute()
            }
            MethodCallFlutter.STOP -> {
                MeetingSessionManager.stop()
            }
            MethodCallFlutter.START_LOCAL_VIDEO -> {
                startLocalVideo()
            }
            MethodCallFlutter.STOP_LOCAL_VIDEO -> {
                stopLocalVideo()
            }
            else -> AmazonChannelResponse(false, ResponseMessage.METHOD_NOT_IMPLEMENTED)
        }

        if (callResult.result) {
            result.success(callResult.toFlutterCompatibleType())
        } else {
            result.error(
                "Failed",
                "MethodChannelHandler failed",
                callResult.toFlutterCompatibleType()
            )
        }
    }

    fun callFlutterMethod(method: String, args: Any?) {
        channel.invokeMethod(method, args)
    }

    fun join(call: MethodCall): AmazonChannelResponse {
        val arguments = call.arguments as? Map<String, String>
        if (arguments == null) {
            return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        }

        val meetingId: String = arguments["MeetingId"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val externalMeetingId: String = arguments["ExternalMeetingId"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val mediaRegion: String = arguments["MediaRegion"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val audioHostUrl: String = arguments["AudioHostUrl"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val audioFallbackUrl: String = arguments["AudioFallbackUrl"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val signalingUrl: String = arguments["SignalingUrl"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val turnControlUrl: String = arguments["TurnControlUrl"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val externalUserId: String = arguments["ExternalUserId"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val attendeeId: String = arguments["AttendeeId"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)
        val joinToken: String = arguments["JoinToken"] ?: return AmazonChannelResponse(false, ResponseMessage.INCORRECT_JOIN_RESPONSE_PARAMS)

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

        val meetingSessionConfiguration: MeetingSessionConfiguration = MeetingSessionConfiguration(createMeetingResponse, createAttendeeResponse)

        val meetingSession = DefaultMeetingSession(meetingSessionConfiguration, ConsoleLogger(), context)

        MeetingSessionManager.meetingSession = meetingSession
        return MeetingSessionManager.startMeeting(
            AudioVideoObserver(this),
            DataMessageObserver(this),
            RealtimeObserver(this),
            VideoTileObserver(this),
        )
    }

    fun initialAudioSelection(): AmazonChannelResponse {
        val device = MeetingSessionManager.meetingSession.audioVideo.getActiveAudioDevice()
            ?: return NULL_MEETING_SESSION_RESPONSE
        return AmazonChannelResponse(true, gson.toJson(mediaDeviceToMap(device)))
    }

    fun listAudioDevices(): AmazonChannelResponse {
        val audioDevices = MeetingSessionManager.meetingSession.audioVideo.listAudioDevices()
        val audioDeviceMapJson = audioDevices.map { device: MediaDevice ->
            mediaDeviceToMap(device)
        }
        return AmazonChannelResponse(true, gson.toJson(audioDeviceMapJson))
    }

    fun updateAudioDevice(call: MethodCall): AmazonChannelResponse {
        val arguments = call.arguments as? Map<String, String>
        if (arguments == null) {
            return AmazonChannelResponse(false, ResponseMessage.NULL_AUDIO_DEVICE)
        }
        val device: String = arguments["device"] ?: return AmazonChannelResponse(false, ResponseMessage.NULL_AUDIO_DEVICE)
        val audioDevices = MeetingSessionManager.meetingSession.audioVideo.listAudioDevices()

        for (dev in audioDevices) {
            if (device == dev.label) {
                MeetingSessionManager.meetingSession.audioVideo.chooseAudioDevice(dev)
                    ?: return AmazonChannelResponse(false, ResponseMessage.AUDIO_DEVICE_UPDATE_FAILED)
                return AmazonChannelResponse(true, ResponseMessage.AUDIO_DEVICE_UPDATED)
            }
        }

        return AmazonChannelResponse(false, ResponseMessage.AUDIO_DEVICE_UPDATE_FAILED)
    }

    fun mute(): AmazonChannelResponse {
        val muted = MeetingSessionManager.meetingSession.audioVideo.realtimeLocalMute()
        return if (muted) AmazonChannelResponse(
            true,
            ResponseMessage.MUTE_SUCCESSFUL
        ) else AmazonChannelResponse(false, ResponseMessage.MUTE_FAILED)
    }

    fun unmute(): AmazonChannelResponse {
        val unmuted = MeetingSessionManager.meetingSession.audioVideo.realtimeLocalUnmute()
        return if (unmuted) AmazonChannelResponse(
            true,
            ResponseMessage.UNMUTE_SUCCESSFUL
        ) else AmazonChannelResponse(false, ResponseMessage.UNMUTE_FAILED)
    }

    fun startLocalVideo(): AmazonChannelResponse {
        MeetingSessionManager.meetingSession.audioVideo.startLocalVideo()
        return AmazonChannelResponse(true, ResponseMessage.LOCAL_VIDEO_ON_SUCCESS)
    }

    fun stopLocalVideo(): AmazonChannelResponse {
        MeetingSessionManager.meetingSession.audioVideo.stopLocalVideo()
        return AmazonChannelResponse(true, ResponseMessage.LOCAL_VIDEO_OFF_SUCCESS)
    }

    private fun mediaDeviceToMap(mediaDevice: MediaDevice) : Map<String, String?> {
        return mapOf(
            "label" to mediaDevice.label,
            "type" to mediaDevice.type.toString(),
            "id" to mediaDevice.id
        )
    }

    private val NULL_MEETING_SESSION_RESPONSE: AmazonChannelResponse = AmazonChannelResponse(false, ResponseMessage.MEETING_SESSION_IS_NULL)
}