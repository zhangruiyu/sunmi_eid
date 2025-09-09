
import 'sunmi_eid_platform_interface.dart';

class SunmiEid {
  Future<String?> getPlatformVersion() {
    return SunmiEidPlatform.instance.getPlatformVersion();
  }
}
