import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sunmi_eid/sunmi_eid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _sunmiEidPlugin = SunmiEid();

  @override
  void initState() {
    super.initState();
  }

  String? reqId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  // Request necessary runtime permissions that correspond to AndroidManifest declarations
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.camera, // CAMERA
                    Permission.storage, // READ/WRITE_EXTERNAL_STORAGE (legacy)
                    Permission.phone, // READ_PHONE_STATE
                    Permission.location, // ACCESS_FINE_LOCATION / ACCESS_COARSE_LOCATION
                  ].request();
                  await _sunmiEidPlugin.init("e95f682ba8de4f339bd2011e124be654");
                  print('成功初始化');
                },
                child: const Text('初始化')),
            ElevatedButton(
                onPressed: () {
                  StreamSubscription? s;
                  s = _sunmiEidPlugin.startCheckCard().listen((event) async {
                    if (event.code == EidConstants.READ_CARD_SUCCESS) {
                      reqId = event.msg;
                      s?.cancel();
                      await _sunmiEidPlugin.stopCheckCard();
                    }
                    print('startCheckCard event ${event}');
                  });
                },
                child: const Text('读取')),
            ElevatedButton(
                onPressed: () async {
                  if (reqId == null) {
                    print("请先读取身份证");
                    return;
                  }
                  final r = await _sunmiEidPlugin.getIDCardInfo(
                      reqId: reqId!,
                      appKey: '702b4aadef0748af86b7b8caff527a62');
                  if (r?.code == EidConstants.DECODE_SUCCESS) {
                    final data = ResultInfo.fromJson(jsonDecode(r!.data));
                    ///这里获取后调用parseCardPhoto
                    final image = await _sunmiEidPlugin.parseCardPhoto(data.picture!);
                  }
                  print(r);
                },
                child: const Text('getIDCardInfo')),
            ElevatedButton(
                onPressed: () async {
                  final r = await _sunmiEidPlugin.parseCardPhoto("");
                },
                child: const Text('解析图片')),
            ElevatedButton(
                onPressed: () async {
                  final r = await _sunmiEidPlugin.onDestroy();
                },
                child: const Text('销毁')),
          ],
        ),
      ),
    );
  }
}
