# sunmi_eid

Flutter plugin wrapper for Sunmi EID SDK (Android).

## Install

Add to your pubspec.yaml:

```
sunmi_eid:
  path: ../sunmi_eid
```

Android build.gradle already includes dependency:
```
implementation "com.sunmi:SunmiEID-SDK:1.3.20"
```
Ensure your project has access to repositories listed in this plugin's android/build.gradle.

## Usage

```dart
import 'package:sunmi_eid/sunmi_eid.dart';
import 'package:sunmi_eid/src/eid_event.dart';
import 'package:sunmi_eid/src/eid_constants.dart';

final eid = SunmiEid();

Future<void> initEid() async {
  final ok = await eid.init('YOUR_APP_ID');
  // ok is true when EidConstants.EID_INIT_SUCCESS
}

void startReading() {
  eid.startCheckCard().listen((EidEvent e) async {
    // e.code and e.msg
    // Handle states like ERR_NFC_NOT_SUPPORT, ERR_NETWORK_NOT_CONNECTED,
    // READ_CARD_READY, READ_CARD_START,
    // READ_CARD_SUCCESS (msg=reqId), READ_CARD_FAILED, etc.
    if (e.code == /* EidConstants.READ_CARD_SUCCESS */ 10007) {
      final reqId = e.msg; // SDK returns reqId as msg on success
      // WARNING: Passing appKey from client can leak keys. Prefer a server-to-server (cloud-to-cloud) flow.
      final info = await eid.getIDCardInfo(reqId: reqId, appKey: 'YOUR_APP_KEY');
      // info is an IDCardInfoResult object with fields: code and data (data is JSON string on success or error message)
      // To map the JSON to a typed model:
      //   final resultInfo = ResultInfo.fromJson(jsonDecode(info.data));
    }
  });
}
```

Notes:
- On Android, this calls `EidSDK.init(activity, appId, EidCall)` directly (no reflection required).
- Use `startCheckCard()` to begin reading. Listen to Stream<EidEvent> and react per the Sunmi docs (NFC not supported/closed, network not connected, READ_CARD_READY/START/SUCCESS/FAILED, etc.).
- The exact success/ready codes are provided by `EidConstants` in the SDK.

