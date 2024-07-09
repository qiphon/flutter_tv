import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'pages/home.dart';

void main() {
  // runApp(const MyApp());
  FlutterError.onError = (details, {bool forceReport = false}) {
    log('$details');
  };

  runZonedGuarded(() => runApp(const App()), (err, stack) {
    log('$err');
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    log('enable wakelock');
    Wakelock.enable();
    return MaterialApp(
      // ios 下没有显示的地方，Android 应用管理面板显示的名字
      title: 'TV lives',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeWithNav(),
    );
  }
}
