///
/// @file
///

library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_flutter/utils/const.dart';

class localStore<Value> {
  String keyName;
  DateTime? updateTime;
  late SharedPreferences prefs;

  localStore._internal(
    this.keyName,
  ) {}

  static Future<localStore<Value>> create<Value>(
      LocalStoreKeyType keyName) async {
    final store = localStore<Value>._internal(keyName.toString());
    final s = await SharedPreferences.getInstance();
    store.prefs = s;
    return store;
  }

  // get lastUpdateTime => updateTime;

  getValue() {
    return prefs.get(keyName);
  }

  clear() {
    prefs.remove(keyName);
  }

  _updateTime() {
    // update time to store!!!
    this.updateTime = DateTime.now().toUtc();
  }

  Future<dynamic> setValue(Value value) async {
    await prefs.setString(keyName, jsonEncode(value));
    _updateTime();
  }
}
