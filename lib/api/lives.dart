///
/// @file 获取播放源
///

library;

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tv_flutter/api/index.dart';
import 'package:tv_flutter/utils/const.dart';
import 'package:tv_flutter/utils/index.dart';

/// 频道数据模型
class Channel {
  static Future<List<Channel>?> getConfigFromApi(String addr) async {
    final config = await request.get<String>(addr,
        options:
            Options(headers: {'content-type': 'application/octet-stream'}));
    if (config.data != null && config.data!.isNotEmpty) {
      List<Channel> resultChannel = [];
      try {
        // tvbox 源
        Map<String, dynamic> tvCfg = jsonDecode(config!.data!);
        List<Channel> channels = [];
        if (tvCfg.containsKey('lives') && tvCfg['lives'] is List) {
          List<dynamic> livesCfg = tvCfg['lives'];

          if (livesCfg.isNotEmpty) {
            await Future.wait(livesCfg.map((item) {
              String? sourceUrl = Util.testKey<String>(item, 'url');
              if (sourceUrl != null) {
                return request
                    .get<String>(sourceUrl)
                    .then((val) => val.data)
                    .catchError((err) {
                  log('download list file ${sourceUrl} error');
                });
              }
              return Future.value(null);
            })).then((listVal) {
              Map<String, Channel> category = {};

              listVal.forEach((stringResult) {
                if (stringResult != null) {
                  // #EXTINF 形式资源
                  if (stringResult.contains('#EXTINF')) {
                    if (!stringResult.contains('video://https:')) {
                      // video://https: 这种形式无法解析，不是正确的视频播放地址
                      List<String> videoRow = stringResult.split('\n');
                      for (int idx = 0; idx < videoRow.length; idx++) {
                        final str = videoRow[idx];
                        final trimStr = str.trim();
                        // 这行是分组
                        if (trimStr.startsWith('#EXTINF') &&
                            trimStr.contains('tvg-name=') &&
                            trimStr.contains('group-title=')) {
                          List<String> nameList = trimStr.split(' ');
                          String name = '';
                          String group = '';
                          for (var i = 0; i < nameList.length; i++) {
                            if (name.isNotEmpty && group.isNotEmpty) break;
                            String trimName = nameList[i].trim();
                            if (trimName.isNotEmpty &&
                                trimName.startsWith('tvg-name=')) {
                              name = trimName.substring(
                                  'tvg-name="'.length, trimName.length - 1);
                            } else if (trimName.isNotEmpty &&
                                trimName.startsWith('group-title=')) {
                              group = trimName.substring(
                                  'group-title="'.length, trimName.length - 1);
                              if (group.contains(',')) {
                                group = group.split(',')[0];

                                group = group.endsWith('"')
                                    ? group.substring(0, group.length - 1)
                                    : group;
                              }
                            }
                          }
                          String categoryGroupName = '${group}@@${name}';
                          String nextLine = videoRow[idx + 1].trim();
                          if (nextLine.startsWith('http')) {
                            String url = nextLine;
                            Channel? currentChannel =
                                category[categoryGroupName];
                            if (currentChannel == null) {
                              category[categoryGroupName] = Channel(
                                  name: name, urls: [url], groupName: group);
                            } else {
                              currentChannel.urls.add(url);
                            }
                          }
                        }
                      }
                    }
                  } else {
                    // 纯文本资源
                    List<String> videoRow = stringResult.split('\n');
                    String group = '';

                    for (int idx = 0; idx < videoRow.length; idx++) {
                      String trimRow = videoRow[idx].trim();
                      List<String> sepreateData = trimRow.split(',');
                      if (sepreateData.isEmpty || trimRow.isEmpty) continue;
                      String first = '';
                      String sec = '';
                      try {
                        first = sepreateData[0].trim();
                        sec = sepreateData[1].trim();
                      } catch (err) {
                        log('get play url error');
                      }
                      if (sec.contains('#genre#')) {
                        group = first;
                      } else if (sec.startsWith('http')) {
                        String categoryGroupName = '${group}@@${first}';
                        Channel? currentCate = category[categoryGroupName];
                        if (currentCate == null) {
                          category[categoryGroupName] = Channel(
                              name: first, urls: [sec], groupName: group);
                        } else {
                          currentCate.urls.add(sec);
                        }
                      }
                    }
                  }
                }
              });
              channels = category.values.toList();
              Channel.setValues(channels);
            });
          }
        }
        if (channels.isEmpty) return null;
        setValues(channels);
        resultChannel = channels;
      } catch (err) {
        log('直播源解析错误');
        log(err.toString());
      }
      return resultChannel;
    }
    return null;
  }

  static parseM3u8String() {}

  Channel({required this.name, required this.urls, required this.groupName});

  final String name;
  List<String> urls;
  final String groupName;

  factory Channel.fromJson(Map<String, dynamic> data) {
    if (!data.containsKey('name') ||
        !data.containsKey('urls') ||
        !data.containsKey('groupName')) {
      throw ArgumentError('channel arg missing');
    }
    return Channel(
      name: data['name'],
      urls: data['urls'].cast<String>(),
      groupName: data['groupName'],
    );
  }

  toJson() {
    return {'name': name, 'groupName': groupName, 'urls': urls};
  }

  static Future<void> setValues(List<Channel>? data) {
    GetStorage box = GetStorage();
    return box.write(LocalStoreKeyType.channel.toString(),
        data != null ? jsonEncode(data) : '');
  }

  static Future<List<Channel>?> getAllValues() async {
    GetStorage box = GetStorage();
    final cacheChannel = box.read<String>(LocalStoreKeyType.channel.toString());
    if (cacheChannel != null && cacheChannel.isNotEmpty) {
      List<dynamic> result = jsonDecode(cacheChannel);

      return transformJson(result);
    }
    return defaultSysCfg().getValues().then((addrCfg) {
      return Channel.getConfigFromApi(addrCfg.playAddr);
    });
  }

  static List<Channel> transformJson(List<dynamic> data) {
    List<Channel> val = [];

    for (var item in data) {
      if (!item.containsKey('name') ||
          !item.containsKey('urls') ||
          !item.containsKey('groupName')) continue;

      Channel channel = Channel.fromJson(item);

      val.add(channel);
    }

    return val;
  }
}
