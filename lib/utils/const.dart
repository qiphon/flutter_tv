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
      {this.playAddr =
          // 原地址因 flutter 不能访问中文域名而弃用，使用复制后的文件
          'https://raw.githubusercontent.com/qiphon/learn/master/docs/tv/tv_resource.json',
      this.weatherAddr = '北京'});

  factory defaultSysCfg.fromJson(Map<String, dynamic> data) {
    if (!data.containsKey('weatherAddr') || !data.containsKey('playAddr')) {
      throw ArgumentError('Missing defaultSysCfg args');
    }

    return defaultSysCfg(
        playAddr: data['playAddr'], weatherAddr: data['weatherAddr']);
  }

  Future<defaultSysCfg> getValues() {
    return localStore.create(LocalStoreKeyType.systemConfig).then((store) {
      String? val = store.getValue();
      if (val != null && val.isNotEmpty) {
        dynamic decodeVal = jsonDecode(val);
        final res = defaultSysCfg.fromJson(decodeVal);
        return res;
      }
      return defaultSysCfg();
    }).catchError((onError) {
      return defaultSysCfg();
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
