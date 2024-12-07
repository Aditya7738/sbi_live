// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:get/get.dart';
// import 'package:sbibank/view/home.dart';

// import '../constant.dart';
// import '../service.dart';
// import '../view/login.dart';

// class GrowthFIUData {
//   GrowthFIUData(this.year, this.amount);

//   final String year;
//   final double amount;
// }

// class HomeController extends GetxController {
//   RxBool isLoading = false.obs;
//   // RxList<GrowthFIUData> barData = GrowthFIUData[].obs;

//   @override
//   void onInit() {
//     getCompanyGrowth();
//     super.onInit();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   getCompanyGrowth() async {
//     var data = await Service.getCompanyGrowth();
//     print(data);
//     if (data["outcome"]["outcomeId"] == 1) {}
//   }
// }
