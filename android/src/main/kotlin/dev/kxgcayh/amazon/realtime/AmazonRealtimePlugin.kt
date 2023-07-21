package dev.kxgcayh.amazon.realtime

import android.util.Log
import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import dev.kxgcayh.amazon.realtime.managers.PermissionManager
import dev.kxgcayh.amazon.realtime.utils.AndroidViewFactory
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** AmazonRealtimePlugin */
class AmazonRealtimePlugin: FlutterPlugin, ActivityAware{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var channel: MethodChannel
  private lateinit var permissionManager: PermissionManager
  private lateinit var methodCallHandler: AmazonChannelCoordinator

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.kxgcayh.amazon.realtime.plugin")
    context = flutterPluginBinding.applicationContext
    methodCallHandler = AmazonChannelCoordinator(channel, context)
    channel.setMethodCallHandler(methodCallHandler)
    flutterPluginBinding.platformViewRegistry.registerViewFactory("videoTile", AndroidViewFactory())
    permissionManager = PermissionManager(activity)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    // super.configureFlutterEngine(flutterEngine)
    // channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.kxgcayh.amazon.realtime.plugin")
    // methodCallHandler = AmazonChannelCoordinator(channel, context)
    // flutterEngine.platformViewsController.registry
    //   .registerViewFactory("videoTile", AndroidViewFactory())
  // }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {}

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  companion object {
    private const val TAG = "AmazonRealtimePlugin"
  }
}
