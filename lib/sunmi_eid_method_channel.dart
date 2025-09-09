import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sunmi_eid_platform_interface.dart';

/// An implementation of [SunmiEidPlatform] that uses method channels.
class MethodChannelSunmiEid extends SunmiEidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sunmi_eid');

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
}
