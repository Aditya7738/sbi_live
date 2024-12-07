// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbi/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharePreferencesManager {
  SharePreferencesManager._privateConstructor();

  static final SharePreferencesManager instance = SharePreferencesManager._privateConstructor();

  // Future<LoginModel> getlogindetails() async {
  //   SharedPreferences prefs=await SharedPreferences.getInstance();
  //   print(prefs.getString("loginmodel"));
  //   var result= Map<String, dynamic>.from(json.decode(prefs.getString("loginmodel")??""));
  //   return LoginModel.fromJson(result);
  // }





  setString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? "";
  }


  logout() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.clear();
    Get.deleteAll();
    Get.offAll(LoginPage());
    //return myPrefs.clear();
  }




}
