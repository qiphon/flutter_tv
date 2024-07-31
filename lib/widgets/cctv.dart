/// @file 央视 webview
///

library;

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CCTV extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CCTV();
}

class _CCTV extends State<CCTV> {
  WebViewController? controller;
  @override
  void initState() {
    final ctrller = WebViewController()
      ..setUserAgent(
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36")
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://yangshipin.cn/tv/home?pid=600001859'))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('------${progress}');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _onLoad();
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    setState(() {
      controller = ctrller;
    });
    super.initState();
  }

  _onLoad() {
    if (controller == null) return;
    controller!.runJavaScript('''
        const style = document.createElement('style');
        style.innerHTML = `
          .tv .volume-muted-tip-container > div:nth-child(1) {
            display: none !important;
          }
          .tv .volume-muted-tip-container > div:nth-child(2) {
            display: none !important;
          }
        `;
        document.body.appendChild(style);
    ''');
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
        body: Container(
            child: Stack(children: [
      (Platform.isAndroid || Platform.isIOS)
          ? WebViewWidget(controller: controller!)
          : const Text('目前仅支持 Android 和 iOS'),
      Positioned(
          right: 10,
          bottom: 100,
          child: ElevatedButton(
            child: const Text('刷新'),
            onPressed: () {
              controller!.reload();
            },
          ))
    ])));
  }
}
