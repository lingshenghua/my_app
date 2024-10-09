import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    UmengCommonSdk.initCommon(
        '66d80229cac2a664dea2231d', '662a2280940d5a4c49485242', 'Umeng');
    UmengCommonSdk.setPageCollectionModeManual();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await UmengCommonSdk.platformVersion)!;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Running on: $_platformVersion'),
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text("注册"),
                    onPressed: () {
                      UmengCommonSdk.onEvent('reg', {'reg_type': 'username'});
                    },
                  ),
                  ElevatedButton(
                    child: const Text("进入直播间"),
                    onPressed: () {
                      UmengCommonSdk.onEvent('live_detail',
                          {'live_id': '74364482', 'live_url': 'www.10086.com'});
                    },
                  ),
                ]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance), label: '主页'),
              BottomNavigationBarItem(icon: Icon(Icons.contacts), label: '列表'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_music), label: '个人')
            ],
          )),
    );
  }
}
