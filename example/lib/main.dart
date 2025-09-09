import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
  String _platformVersion = 'Unknown';
  final _sunmiEidPlugin = SunmiEid();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _sunmiEidPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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
                onPressed: () {
                  _sunmiEidPlugin.init("e95f682ba8de4f339bd2011e124be654");
                },
                child: const Text('初始化')),
            ElevatedButton(
                onPressed: () {
                  _sunmiEidPlugin.startCheckCard().listen((event) async {
                    if (event.code == EidConstants.READ_CARD_SUCCESS) {
                      reqId = event.msg;
                      await _sunmiEidPlugin.stopCheckCard();
                    }
                    print(event);
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
                  }
                  print(r);
                },
                child: const Text('getIDCardInfo')),
          ],
        ),
      ),
    );
  }
}
