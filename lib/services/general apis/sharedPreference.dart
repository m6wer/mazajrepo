
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

saveData({String saved, String key}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, saved);
}

readData({String key}) async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.get(key) ?? null;
  return value;
}
