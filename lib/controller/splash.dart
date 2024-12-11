import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:sbi/SharedPrefrence.dart';
import 'package:sbi/view/home.dart';
import '../constant.dart';
import '../services/local_auth_services.dart';
import '../services/service.dart';
import '../view/login.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SplashController extends GetxController {
  late final Timer? timer;

  final fbKeyLogin = GlobalKey<FormBuilderState>();
  RxBool isLoading = false.obs;
  LocalAuth auth = LocalAuth();
  @override
  void onInit() {
    timer = Timer(const Duration(seconds: 3), () async {
      SharePreferencesManager.instance.getString("usercode").then((v) async {
        if (v.isNotEmpty) {
          print(v);
          Service.userNameController.text = v.split("~").first;
          Service.passwordController.text = v.split("~").last;
          login(checkLogin: true); //it should uncomment
          //Get.to(() => LoginPage());
          // await LocalAuth.authenticate();
          // Get.to(() => MyHomePage());
        } else {
          Get.to(() => LoginPage());
        }
      });
    });

    super.onInit();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  // static String baseURL = "https://dashboard.sbiglobal.in/sbigflmaster/api";
  static String baseURL = "https://115.124.123.87/sbigflmaster/api";
  // static String baseURL = "115.124.123.87";
  // static String baseURL = "https://sbimaster.initialinfinity.com/api";

  login({bool checkLogin = false}) async {
    if (checkLogin || fbKeyLogin.currentState!.saveAndValidate()) {
      isLoading.value = true;
      // var data = await Service.login(
      //   Service.userNameController.text,
      //   Service.passwordController.text,
      // );

      try {
        var response = await http.post(
          Uri.parse("$baseURL/LoginDetails"),
          headers: {
            "Content-Type": 'application/json',
          },
          body: convert.jsonEncode({
            "contact_no": Service.userNameController.text,
            "com_password": Service.passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          print(response.body);
          var resp = convert.jsonDecode(response.body);
          if (resp["result"]["outcome"]["outcomeId"] == 1) {
            SharePreferencesManager.instance.setString("usercode",
                "${Service.userNameController.text}~${Service.passwordController.text}");
            SharePreferencesManager.instance
                .setString("password", Service.passwordController.text);
            await Service.storage.write(
                key: 'token',
                value: resp["result"]["outcome"]["tokens"].toString());
            await Service.storage.write(
                key: 'loginid',
                value: resp["result"]["data"]["login_id"].toString());
            await Service.storage.write(
                key: 'companyId',
                value: resp["result"]["data"]["com_id"].toString());
            isLoading.value = false;
            flutterToastMsg(
              "Login Successfully",
            );
            await LocalAuth.authenticate();

            Get.to(() => MyHomePage());
          } else if (resp["result"]["outcome"]["outcomeId"] == 0) {
            flutterToastMsg(resp["result"]["outcome"]["outcomeDetail"]);
            update();
          }
          isLoading.value = false;
        } else {
          print(response.body);
          flutterToastMsg("Server Error status code ${response.statusCode}");
          isLoading.value = false;
          // return;
        }
      } catch (e) {
        print("error: $e");
        flutterToastMsg("Server Error");
        isLoading.value = false;
      }
    }
  }
}
