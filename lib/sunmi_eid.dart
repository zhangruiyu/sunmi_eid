
import 'sunmi_eid_platform_interface.dart';

class SunmiEid {
  Future<String?> getPlatformVersion() {
    return SunmiEidPlatform.instance.getPlatformVersion();
  }

  Future<bool> init(String appId) {
    return SunmiEidPlatform.instance.init(appId);
  }
}
