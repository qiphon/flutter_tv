import 'dart:developer';

import 'package:dio/dio.dart';

const RequestHeaders = {
  'Cache-Control': 'no-cache',
  // 'DNT': 1,
  'Accept':
      'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
  'Accept-Language': 'zh,en;q=0.9,zh-CN;q=0.8',
  'sec-ch-ua-platform': 'macOS',
  'Sec-Fetch-Mode': 'navigate',
  'sec-ch-ua':
      'flutter_tv Google Chrome";v="125", "Chromium";v="125", "Not.A/Brand";v="24',
  'User-Agent':
      'flutter_tv Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36',
};

BaseOptions options =
    BaseOptions(headers: RequestHeaders); //Options(headers: Headers());

final request = Dio(options);

void addRequestCatch() {
  request.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
        // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        log('request error -----------------');
        log(error.toString());
        log('request error end -----------------');
        // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
        return handler.next(error);
      },
    ),
  );
}
