
import 'sunmi_eid_platform_interface.dart';
import 'src/eid_event.dart';

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
}
