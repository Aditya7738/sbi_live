import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:sbi/SharedPrefrence.dart';
import 'package:sbi/view/home.dart';
import '../constant.dart';
import '../services/local_auth_services.dart';
import '../services/service.dart';
import '../view/login.dart';

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
          login(checkLogin: true);
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

  login({bool checkLogin = false}) async {
    if (checkLogin || fbKeyLogin.currentState!.saveAndValidate()) {
      isLoading.value = true;
      var data = await Service.login(
        Service.userNameController.text,
        Service.passwordController.text,
      );

      if (data["result"]["outcome"]["outcomeId"] == 1) {
        SharePreferencesManager.instance.setString("usercode", "${Service.userNameController.text}~${Service.passwordController.text}");
        SharePreferencesManager.instance.setString("password", Service.passwordController.text);
        await Service.storage.write(key: 'token', value: data["result"]["outcome"]["tokens"].toString());
        await Service.storage.write(key: 'loginid', value: data["result"]["data"]["login_id"].toString());
        await Service.storage.write(key: 'companyId', value: data["result"]["data"]["com_id"].toString());
        isLoading.value = false;
        flutterToastMsg(
          "Login Successfully",
        );
        await LocalAuth.authenticate();
        Get.to(() => MyHomePage());
      } else if (data["result"]["outcome"]["outcomeId"] == 0) {
        flutterToastMsg(data["result"]["outcome"]["outcomeDetail"]);
        update();
      }
      isLoading.value = false;
    }
  }
}
