package dev.kxgcayh.aws_chime

import androidx.annotation.NonNull

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.platform.PlatformViewFactory
import dev.kxgcayh.aws_chime.managers.PermissionManager
import dev.kxgcayh.aws_chime.enums.MethodCallFlutter
import android.util.Log
import dev.kxgcayh.aws_chime.enums.ResponseEnum
import com.amazonaws.services.chime.sdk.meetings.session.DefaultMeetingSession
import com.amazonaws.services.chime.sdk.meetings.session.MediaPlacement
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionConfiguration
import com.amazonaws.services.chime.sdk.meetings.session.CreateMeetingResponse
import com.amazonaws.services.chime.sdk.meetings.session.Meeting
import com.amazonaws.services.chime.sdk.meetings.session.Attendee
import com.amazonaws.services.chime.sdk.meetings.session.CreateAttendeeResponse
import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger

/** AwsChimePlugin */
class AwsChimePlugin: FlutterPlugin, ActivityAware, MethodCallHandler, FlutterActivity() {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private lateinit var flutterEngine: FlutterEngine
  private lateinit var permissionsManager: PermissionManager

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
    Log.i(TAG, "1 -> onAttachedToEngine")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "aws_chime")
    channel.setMethodCallHandler(this)
    flutterEngine = flutterPluginBinding.flutterEngine
    configureFlutterEngine(flutterEngine)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    // Log.i(TAG, "Received MethodCall with method: ${call.method}")
    var callResult: MethodChannelResult? = null
    when (call.method) {
      MethodCallFlutter.GET_PLATFORM_VERSION -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      MethodCallFlutter.MANAGE_AUDIO_PERMISSIONS -> {
        permissionsManager.manageAudioPermissions(result)
      }
      MethodCallFlutter.MANAGE_VIDEO_PERMISSIONS -> {
        permissionsManager.manageVideoPermissions(result)
      }
      MethodCallFlutter.LIST_AUDIO_DEVICES -> {
        callResult = listAudioDevices()
        Log.i(TAG, "Received MethodCall with method: $callResult")
        result.success(callResult?.toFlutterCompatibleType())
      }
      else -> result.notImplemented()
    }
  }

  fun callFlutterMethod(method: String, args: Any?) {
    channel.invokeMethod(method, args)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.i(TAG, "2 -> onAttachedToActivity")
    activity = binding.activity
    permissionsManager = PermissionManager(activity)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {
    Log.i(TAG, "3 -> onDetachedFromEngine")
    channel.setMethodCallHandler(null)
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    Log.i(TAG, "4 -> configureFlutterEngine")
    super.configureFlutterEngine(flutterEngine)

    flutterEngine
      .platformViewsController
      .registry
      .registerViewFactory("videoTile", NativeViewFactory())
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissionsList: Array<String>,
    grantResults: IntArray
  ) {
    when (requestCode) {
      permissionsManager.AUDIO_PERMISSION_REQUEST_CODE -> {
        permissionsManager.audioCallbackReceived()
      }
      permissionsManager.VIDEO_PERMISSION_REQUEST_CODE -> {
        permissionsManager.videoCallbackReceived()
      }
    }
  }

  override fun onDetachedFromActivity() {}

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

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
    Log.i(TAG, "listAudioDevices()")
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

  private val NULL_MEETING_SESSION_RESPONSE: MethodChannelResult = MethodChannelResult(
    false, ResponseEnum.MEETING_SESSION_IS_NULL
  )

  companion object {
    const val TAG = "@AwsChimePlugin"
  }
}
