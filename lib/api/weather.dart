///
/// @file 获取天气信息
///

library;

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:tv_flutter/api/index.dart';
import 'package:tv_flutter/utils/const.dart';
import 'package:html/parser.dart' show parse;
import 'package:tv_flutter/utils/store.dart';

class Weather {
  final String date;
  final String weather;
  final String week;

  /// 天气图标
  final String image;
  final String temperature;

  /// 空气质量
  final String? airQuality;

  /// 天气预警
  final String? weatherAlert;
  final int updateTime;
  final String cityName;

  Weather(
      {this.airQuality,
      required this.date,
      required this.updateTime,
      required this.image,
      required this.temperature,
      required this.weather,
      this.weatherAlert,
      required this.cityName,
      required this.week});

  factory Weather.fromJson(Map<String, dynamic> data) {
    // 确保所有必需的字段都存在
    if (!data.containsKey('date') ||
        !data.containsKey('weather') ||
        !data.containsKey('week') ||
        !data.containsKey('image') ||
        !data.containsKey('updateTime') ||
        !data.containsKey('cityName') ||
        !data.containsKey('temperature')) {
      throw ArgumentError('Missing required fields in the JSON data');
    }

    // 从映射中读取数据
    return Weather(
      date: data['date']!,
      weather: data['weather']!,
      week: data['week']!,
      image: data['image']!,
      temperature: data['temperature']!,
      airQuality: data['airQuality'],
      cityName: data['cityName'],
      weatherAlert: data['weatherAlert'],
      updateTime: data['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airQuality': airQuality,
      'date': date,
      'updateTime': updateTime,
      'image': image,
      'temperature': temperature,
      'weather': weather,
      'weatherAlert': weatherAlert,
      'week': week,
      'cityName': cityName
    };
  }

// Future<List<Weather>>
  ////** 获取天气信息 */
  static Future<List<Weather>?> getWeather(
      {String? cityName, required localStore<List<Weather>> store}) async {
    final addr = cityName ?? defaultSysCfg().weatherAddr;

    log(addr);
    // const
    try {
      final url = 'https://www.so.com/s?q=${addr}天气&src=360portal&_re=0';

      Response<String> htmlStr = await request.get(url);
      String? data = htmlStr.data;
      if (data != null) {
        Document dom = parse(data);
        // 移动端页面是这个
        List<Element> weatherCard = dom
            .querySelectorAll('#mohe-m-entity--weather_city .mh-weather-weeks');

        // web 端天气获取完成
        if (weatherCard.isEmpty) {
          List<Element> weatherItems = dom.querySelectorAll(
            '#mohe-weather .mh-tab-cont.js-mh-tab-cont .g-slider-item.js-mh-item',
          );
          if (weatherItems.isEmpty) {
            return null;
          }

          int todayWeatherItemIndex = weatherItems.indexWhere((item) {
            return item.querySelector('.mh-week')?.text?.contains('今天') ??
                false;
          });
          if (weatherItems.isEmpty || todayWeatherItemIndex <= 0) return null;
          int index = 0;
          List<Weather> list7Day = List.filled(7, 0, growable: true).map((i) {
            int idx = index;
            Element todayItem = weatherItems[todayWeatherItemIndex + idx];

            index = index + 1;
            String airQuality = dom
                    .querySelector(
                        '#mohe-weather .mh-pm25 span.mh-desc-item-txt')
                    ?.text ??
                '';
            String weatherAlert = dom
                    .querySelector(
                        '#mohe-weather .mh-alert span.mh-desc-item-txt')
                    ?.text ??
                '';
            return Weather(
                date: todayItem.querySelector('.mh-des-date')?.text ?? '',
                image: todayItem
                        .querySelector('.mh-bg-weather')
                        ?.attributes['src'] ??
                    '',
                temperature:
                    todayItem.querySelector('.mh-des-temperature-num')?.text ??
                        '',
                weather:
                    todayItem.querySelector('.mh-des-temperature')?.text ?? '',
                week: todayItem.querySelector('.mh-week')?.text ?? '',
                airQuality: airQuality,
                weatherAlert: weatherAlert,
                updateTime: DateTime.now().millisecondsSinceEpoch,
                cityName: addr);
          }).toList();
          await store.setValue(list7Day);
          return list7Day;
        }
      }
    } catch (err) {
      log('get weather error $err');
    }

    return null;
  }
}
