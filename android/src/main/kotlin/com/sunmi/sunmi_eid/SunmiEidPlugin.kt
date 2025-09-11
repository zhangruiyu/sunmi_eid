package com.sunmi.sunmi_eid

import android.app.Activity
import android.graphics.Bitmap
import com.sunmi.eidlibrary.EidConstants
import com.sunmi.eidlibrary.EidReader
import com.sunmi.eidlibrary.EidSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream


/** SunmiEidPlugin */
class SunmiEidPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var activity: Activity? = null
    private var eventSink: EventChannel.EventSink? = null
    private var eidReader: EidReader? = null

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
            "onDestroy" -> handleOnDestroy(call, result)
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
        EidSDK.setDebuggable(true)
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
            // Only emit documented constants; otherwise map to READ_CARD_FAILED and carry original info in msg
            val safeCode = when (code) {
                EidConstants.READ_CARD_READY,
                EidConstants.READ_CARD_START,
                EidConstants.READ_CARD_SUCCESS,
                EidConstants.READ_CARD_FAILED,
                EidConstants.READ_CARD_DELAY,
                EidConstants.READ_CARD_DELAY_FAILED,
                EidConstants.INIT_SUCCESS,
                EidConstants.INIT_FAIL,
                EidConstants.EID_INIT_SUCCESS,
                EidConstants.DECODE_SUCCESS,
                EidConstants.ERR_APP_ID_NULL,
                EidConstants.ERR_DNS_EXCEPTION,
                EidConstants.ERR_NETWORK_EXCEPTION,
                EidConstants.ERR_INNER_CID,
                EidConstants.ERR_NETWORK_CONNECT_TIMEOUT,
                EidConstants.ERR_IDCARD_DATA_NULL,
                EidConstants.ERR_IDCARD_DATA_DECODE_EXCEPTION,
                EidConstants.ERR_NETWORK_NOT_CONNECTED,
                EidConstants.ERR_DEVICE_INFO_NULL,
                EidConstants.ERR_NFC_NOT_SUPPORT,
                EidConstants.ERR_NFC_CLOSED,
                EidConstants.ERR_PERMISSION_NOT_GRANTED,
                EidConstants.FINANCE_SDK_NOT_FOUND,
                EidConstants.HTTP_UNKNOWN_ERROR,
                EidConstants.ERR_NOT_INIT,
                EidConstants.ERR_TRAVEL_PARAMS_ERROR,
                EidConstants.ERR_ACCOUNT_EXCEPTION -> code
                else -> EidConstants.READ_CARD_FAILED
            }
            val safeMsg = if (safeCode == EidConstants.READ_CARD_FAILED && code != EidConstants.READ_CARD_FAILED) {
                "${msg ?: ""} (originalCode=$code)"
            } else (msg ?: "")
            eventSink?.success(mapOf("code" to safeCode, "msg" to safeMsg))
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
        EidConstants.ERR_NETWORK_NOT_CONNECTED
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

    private fun handleOnDestroy(call: MethodCall, result: Result) {
        EidSDK.destroy()
        result.success(true)
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
