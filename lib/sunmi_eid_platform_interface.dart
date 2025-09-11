import 'dart:typed_data';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sunmi_eid_method_channel.dart';
import 'src/eid_event.dart';
import 'src/id_card_info_result.dart';

abstract class SunmiEidPlatform extends PlatformInterface {
  /// Constructs a SunmiEidPlatform.
  SunmiEidPlatform() : super(token: _token);

  static final Object _token = Object();

  static SunmiEidPlatform _instance = MethodChannelSunmiEid();

  /// The default instance of [SunmiEidPlatform] to use.
  ///
  /// Defaults to [MethodChannelSunmiEid].
  static SunmiEidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SunmiEidPlatform] when
  /// they register themselves.
  static set instance(SunmiEidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> init(String appId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Stream<EidEvent> startCheckCard(Map<String, dynamic>? param);

  Future<void> stopCheckCard();

  Future<IDCardInfoResult?> getIDCardInfo({required String reqId, required String appKey});

  Future<Uint8List?> parseCardPhoto(String picture);


  Future<bool> onDestroy();
}
