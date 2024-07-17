import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tv_flutter/api/weather.dart';
import 'package:tv_flutter/utils/const.dart';
import 'package:tv_flutter/utils/store.dart';
import 'package:tv_flutter/widgets/flexWithGaps.dart';

enum FetchResult { error, fetching, success }

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherWidget();
}

class _WeatherWidget extends State<WeatherWidget> {
  localStore<List<Weather>>? weather;
  FetchResult fetchResult = FetchResult.fetching;
  List<Weather> weatherDatas = [];

  @override
  initState() {
    localStore
        .create<List<Weather>>(LocalStoreKeyType.weather.toString())
        .then((w) {
      String? storeWeather = w.getValue();
      bool isNeedFetch = storeWeather == null;
      if (storeWeather != null) {
        try {
          List<Weather> wea =
              (jsonDecode(storeWeather) as List<dynamic>).map((item) {
            return Weather.fromJson(item);
          }).toList();
          isNeedFetch = DateTime.now()
              .subtract(const Duration(minutes: 30))
              .isAfter(
                  DateTime.fromMillisecondsSinceEpoch(wea.first.updateTime));

          if (!isNeedFetch) {
            setState(() {
              fetchResult = FetchResult.success;
              weatherDatas = wea;
            });
          }
        } catch (e) {
          log('parse store weather error --- ${e.toString()}');
          isNeedFetch = true;
        }
      }

      if (isNeedFetch) {
        setState(() {
          weather = w;
          if (storeWeather == null) {
            fetchResult = FetchResult.fetching;
          }
        });

        Weather.getWeather(store: w).then((fetchRes) {
          if (fetchRes == null) {
            setState(() {
              fetchResult = FetchResult.error;
            });
          } else {
            setState(() {
              fetchResult = FetchResult.success;
              weatherDatas = fetchRes;
            });
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
    // final weatherEmpty = weather?.isEmpty ?? true;
    // log('is ${weatherEmpty}');
    return FetchResult.fetching == fetchResult
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : FlexWithGaps(
            direction: Axis.vertical,
            gap: 32,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlexWithGaps(
                mainAxisAlignment: MainAxisAlignment.center,
                gap: 20,
                children: [
                  _TextSmall(DateTime.fromMillisecondsSinceEpoch(
                          weatherDatas.first.updateTime)
                      .toLocal()
                      .toString()
                      .substring(0, 16)),
                  _TextSmall('北京今天天气'),
                  _TextSmall('空气质量：${weatherDatas.first.airQuality ?? '无数据'}'),
                  _TextSmall(
                      '天气预警：${weatherDatas.first.weatherAlert ?? '无数据'}'),
                ],
              ),
              _renderWeatherItem()
            ],
          );
  }

  Widget _TextSmall(String data) {
    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Text(
            style: const TextStyle(
              fontSize: 18,
            ),
            data));
  }

  Widget _renderWeatherItem() {
    return FlexWithGaps(
        gap: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: weatherDatas
            .map((item) => Column(
                  children: [
                    _TextSmall(item.week),
                    item.date.isNotEmpty
                        ? _TextSmall(item.date)
                        : const SizedBox(),
                    _TextSmall(item.temperature),
                    _TextSmall(item.weather),
                    item.image.isEmpty
                        ? const SizedBox()
                        : Image.network(
                            item.image,
                            width: 90,
                            height: 90,
                          )
                  ],
                ))
            .toList());
  }
}
