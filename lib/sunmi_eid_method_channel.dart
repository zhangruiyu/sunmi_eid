import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/eid_event.dart';
import 'sunmi_eid_platform_interface.dart';
import 'src/id_card_info_result.dart';

/// An implementation of [SunmiEidPlatform] that uses method channels.
class MethodChannelSunmiEid extends SunmiEidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sunmi_eid');
  final EventChannel _eventChannel = const EventChannel('sunmi_eid/events');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> init(String appId) async {
    final res = await methodChannel.invokeMethod<bool>('init', {
      'appId': appId,
    });
    return res ?? false;
  }

  @override
  Stream<EidEvent> startCheckCard() {
    methodChannel.invokeMethod('startCheckCard');
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => EidEvent.fromMap(event as Map));
  }

  @override
  Future<IDCardInfoResult?> getIDCardInfo({required String reqId, required String appKey}) async {
    final res = await methodChannel.invokeMapMethod<String, dynamic>('getIDCardInfo', {
      'reqId': reqId,
      'appKey': appKey,
    });
    return res != null ? IDCardInfoResult.fromMap(res):null;
  }
}
