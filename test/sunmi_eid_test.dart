import 'package:flutter_test/flutter_test.dart';
import 'package:sunmi_eid/sunmi_eid.dart';
import 'package:sunmi_eid/sunmi_eid_platform_interface.dart';
import 'package:sunmi_eid/sunmi_eid_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSunmiEidPlatform
    with MockPlatformInterfaceMixin
    implements SunmiEidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SunmiEidPlatform initialPlatform = SunmiEidPlatform.instance;

  test('$MethodChannelSunmiEid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSunmiEid>());
  });

  test('getPlatformVersion', () async {
    SunmiEid sunmiEidPlugin = SunmiEid();
    MockSunmiEidPlatform fakePlatform = MockSunmiEidPlatform();
    SunmiEidPlatform.instance = fakePlatform;

    expect(await sunmiEidPlugin.getPlatformVersion(), '42');
  });
}
