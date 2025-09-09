package com.sunmi.sunmi_eid

import android.app.Activity
import com.sunmi.eidlibrary.EidConstants
import com.sunmi.eidlibrary.EidSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.graphics.Bitmap
import android.util.Base64
import java.io.ByteArrayOutputStream


/** SunmiEidPlugin */
class SunmiEidPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var activity: Activity? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sunmi_eid")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "sunmi_eid/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "init" -> handleInit(call, result)
            "startCheckCard" -> handleStartCheckCard(result, call.argument("param"))
            "getIDCardInfo" -> handleGetIDCardInfo(call, result)
            "stopCheckCard" -> handleStopCheckCard(result)
            "parseCardPhoto" -> handleParseCardPhoto(call, result)
            else -> result.notImplemented()
        }
    }

    private fun handleInit(call: MethodCall, result: Result) {
        val appId = call.argument<String>("appId")
        val act = activity
        if (appId.isNullOrEmpty()) {
            result.success(false)
            return
        }
        if (act == null) {
            result.error("NO_ACTIVITY", "Activity not attached", null)
            return
        }
        EidSDK.init(act, appId) { code, msg ->
            if (code == EidConstants.EID_INIT_SUCCESS) {
                result.success(true)
            } else {
                result.error(code.toString(), msg, null)
            }
        }
    }

    private fun handleStartCheckCard(result: Result, param: Map<String, Object>?) {
        val act = activity
        if (act == null) {
            result.error("NO_ACTIVITY", "Activity not attached", null)
            return
        }
        EidSDK.startCheckCard(act, { code, msg ->
            eventSink?.success(mapOf("code" to code, "msg" to (msg ?: "")))
        }, param)
        result.success(null)
    }

    private fun handleGetIDCardInfo(call: MethodCall, result: Result) {
        val reqId = call.argument<String>("reqId")
        val appKey = call.argument<String>("appKey")
        if (reqId.isNullOrEmpty() || appKey.isNullOrEmpty()) {
            result.error("BAD_ARGUMENTS", "Missing reqId or appKey", null)
            return
        }
        EidSDK.getIDCardInfo(reqId, appKey) { code, data ->
            // Always return { code, data } where data is the JSON string on success, or error message on failure
            result.success(
                mapOf(
                    "code" to code,
                    "data" to (data ?: "")
                )
            )
        }
    }

    private fun handleStopCheckCard(result: Result) {
        val act = activity
        if (act == null) {
            result.error("NO_ACTIVITY", "Activity not attached", null)
            return
        }
        try {
            EidSDK.stopCheckCard(act)
            result.success(true)
        } catch (e: Exception) {
            result.error("STOP_FAILED", e.message, null)
        }
    }

    private fun handleParseCardPhoto(call: MethodCall, result: Result) {
        val picture = call.argument<String>("picture")
        if (picture.isNullOrEmpty()) {
            result.error("BAD_ARGUMENTS", "Missing picture", null)
            return
        }
        try {
            val photo = EidSDK.parseCardPhoto(picture)
            val stream = ByteArrayOutputStream()
            photo.compress(Bitmap.CompressFormat.PNG, 100, stream)
            val bytes = stream.toByteArray()
            result.success(bytes)
        } catch (e: Exception) {
            result.error("PARSE_PHOTO_FAILED", e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    // ActivityAware
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    // EventChannel.StreamHandler
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
