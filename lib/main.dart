import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tv_flutter/api/index.dart';
import 'package:wakelock/wakelock.dart';
import 'package:toastification/toastification.dart';

import 'pages/home.dart';

void main() async {
  // runApp(const App());
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (
      details,
    ) {
      log('err ----- onError');
      log('$details');
    };
    addRequestCatch();
    return runApp(const ToastificationWrapper(child: App()));
  }, (err, stack) async {
    log('err ----- runZonedGuarded');
    log('$err');
    log(stack.toString());
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
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
        ),
      ),
      home: const HomeWithNav(),
    );
  }
}
