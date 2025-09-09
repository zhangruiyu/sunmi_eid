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

final eid = SunmiEid();

Future<void> initEid() async {
  final result = await eid.init('YOUR_APP_ID');
  // result contains: {"code": int, "msg": String}
  if (result['code'] == 0 || result['code'] == 1000 /* example success code */) {
    // initialized successfully
  } else {
    // handle error
  }
}
```

Notes:
- On Android, this calls `EidSDK.init(activity, appId, EidCall)` and returns the callback values to Flutter as a Map.
- If the SDK is missing at runtime, you'll receive `{code: -4, msg: 'EID SDK not found: ...'}`.
- The exact success code depends on `EidConstants.EID_INIT_SUCCESS` from the SDK.

