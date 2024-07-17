import 'dart:convert';

import 'package:tv_flutter/utils/store.dart';

enum LocalStoreKeyType {
  /// 首页天气显示
  weather,

  /// 缓存的直播数据
  channel,

  /// 系统配置
  systemConfig
}

class defaultSysCfg {
  String playAddr;
  String weatherAddr;

  defaultSysCfg(
      {this.playAddr = 'https://盒子迷.top/禁止贩卖', this.weatherAddr = '北京'});

  factory defaultSysCfg.fromJson(Map<String, dynamic> data) {
    if (!data.containsKey('weatherAddr') || !data.containsKey('playAddr')) {
      throw ArgumentError('Missing defaultSysCfg args');
    }

    return defaultSysCfg(
        playAddr: data['playAddr'], weatherAddr: data['weatherAddr']);
  }

  Future<defaultSysCfg?> getValues() {
    return localStore.create(LocalStoreKeyType.systemConfig).then((store) {
      String? val = store.getValue();
      if (val != null && val.isNotEmpty) {
        dynamic decodeVal = jsonDecode(val);
        final res = defaultSysCfg.fromJson(decodeVal);
        return res;
      }
      return null;
    }).catchError((onError) {
      return null;
    });
  }

  Future<dynamic> setValues(defaultSysCfg config) {
    return localStore.create(LocalStoreKeyType.systemConfig).then((store) {
      store.setValue(config);
    });
  }

  Map<String, String> toJson() {
    return {'playAddr': playAddr, 'weatherAddr': weatherAddr};
  }
}
