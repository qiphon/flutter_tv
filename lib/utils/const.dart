enum LocalStoreKeyType {
  /// 首页天气显示
  weather,

  /// 缓存的直播数据
  channel,
}

class defaultSysCfg {
  final String playAddr;
  final String weatherAddr;

  defaultSysCfg(
      {this.playAddr = 'https://盒子迷.top/禁止贩卖', this.weatherAddr = '北京'});
}
