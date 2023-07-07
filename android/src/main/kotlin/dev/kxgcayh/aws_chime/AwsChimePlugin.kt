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
  private lateinit var flutterPluginBinding: FlutterPluginBinding
  private lateinit var coordinator: AwsChimeCoordinator

  override fun onAttachedToEngine(@NonNull pluginBinding: FlutterPluginBinding) {
    channel = MethodChannel(pluginBinding.binaryMessenger, "aws_chime")
    channel.setMethodCallHandler(this)
    flutterPluginBinding = pluginBinding;
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
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
      else -> result.notImplemented()
    }
  }

  fun callFlutterMethod(method: String, args: Any?) {
    channel.invokeMethod(method, args)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    permissionsManager = PermissionManager(activity)
    flutterEngine = flutterPluginBinding.flutterEngine
    configureFlutterEngine(flutterEngine)
    coordinator = AwsChimeCoordinator(flutterPluginBinding.binaryMessenger, activity)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
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
}
