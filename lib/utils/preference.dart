import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static String profile = 'profile';

  static Future<bool> saveString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  static Future<bool> saveInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt(key, value);
  }

  static Future<bool> saveDouble(String key, double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setDouble(key, value);
  }

  static Future<bool> saveBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(key, value);
  }

  static Future<String?> getString(String key, String defaultValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? defaultValue;
  }

  static Future<int?> getInt(String key, int defaultValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? defaultValue;
  }

  static Future<double?> getDouble(String key, double defaultValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(key) ?? defaultValue;
  }

  static Future<bool?> getBool(String key, bool defaultValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? defaultValue;
  }

  static Future<bool> saveList(String key, List<dynamic> list) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(list);
    return preferences.setString(key, jsonString);
  }

  static Future<List<dynamic>> getList(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jsonString = preferences.getString(key) ?? '[]';
    List<dynamic> list = jsonDecode(jsonString);
    return list;
  }

  static Future<bool> saveObject(
      String key, Map<String, dynamic> object) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(object);
    return preferences.setString(key, jsonString);
  }

  static Future<Map<String, dynamic>> getObject(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jsonString = preferences.getString(key) ?? '{}';
    Map<String, dynamic> object = jsonDecode(jsonString);
    return object;
  }
}
