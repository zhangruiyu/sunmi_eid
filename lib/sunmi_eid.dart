import 'dart:typed_data';
import 'sunmi_eid_platform_interface.dart';
import 'src/eid_event.dart';
import 'src/id_card_info_result.dart';

class SunmiEid {
  Future<String?> getPlatformVersion() {
    return SunmiEidPlatform.instance.getPlatformVersion();
  }

  Future<bool> init(String appId) {
    return SunmiEidPlatform.instance.init(appId);
  }

  Stream<EidEvent> startCheckCard() {
    return SunmiEidPlatform.instance.startCheckCard();
  }

  Future<void> stopCheckCard() {
    return SunmiEidPlatform.instance.stopCheckCard();
  }

  Future<IDCardInfoResult?> getIDCardInfo(
      {required String reqId, required String appKey}) async {
    return SunmiEidPlatform.instance
        .getIDCardInfo(reqId: reqId, appKey: appKey);
  }

  Future<Uint8List?> parseCardPhoto(String picture) {
    return SunmiEidPlatform.instance.parseCardPhoto(picture);
  }

  Future<bool> onDestroy() {
    return SunmiEidPlatform.instance.onDestroy();
  }
}
