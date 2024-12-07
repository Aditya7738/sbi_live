import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sbi/SharedPrefrence.dart';

import '../constant.dart';
import '../view/login.dart';

class Service extends GetConnect {
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static RxBool isLoading = false.obs;
  static final showPass = false.obs;

  static const FlutterSecureStorage storage = FlutterSecureStorage(
      // aOptions: AndroidOptions(
      //   encryptedSharedPreferences: true,
      // ),
      );
  // static String baseURL = "https://dashboard.sbiglobal.in/sbigflmaster/api";
  static String baseURL = "https://115.124.123.87/sbigflmaster/api";
  // static String baseURL = "115.124.123.87";
  // static String baseURL = "https://sbimaster.initialinfinity.com/api";
  static Future<String?> getCompanyId() async {
    return await storage.read(key: 'companyId');
  }

  static Future<String?> getToken() async {
    return await Service.storage.read(key: 'token');
  }

  static Future<String?> getLoginId() async {
    return await Service.storage.read(key: 'loginid');
  }

  static Future<dynamic> login(
    String username,
    String password,
  ) async {
    var response = await http.post(
      Uri.parse("$baseURL/LoginDetails"),
      headers: {
        "Content-Type": 'application/json',
      },
      body: convert.jsonEncode({
        "contact_no": username,
        "com_password": password,
      }),
    );

    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'companyId');
    await storage.delete(key: 'loginid');
    userNameController.text = "";
    passwordController.text = "";
    flutterToastMsg("Logout Successfully");
    SharePreferencesManager.instance.logout();
    Get.off(() => const LoginPage());


    // String? token = await Service.getToken();

    // var companyid = await getCompanyId();
    // var loginid = await getLoginId();
    // print(jsonEncode({
    //   "LoginId": loginid.toString(),
    //   "com_id": companyid.toString(),
    // }));
    // var response = await http.post(
    //   Uri.parse("$baseURL/LoginDetails/LogOut"),
    //   headers: {
    //     "Content-Type": "application/json",
    //   },
    //   body: convert.jsonEncode({
    //     "LoginId": loginid.toString(),
    //     "com_id": companyid.toString(),
    //   }),
    // );
    // var resp = convert.jsonDecode(response.body);
    // if (resp["outcomeId"] == 1) {
    //   await storage.delete(key: 'token');
    //   await storage.delete(key: 'companyId');
    //   await storage.delete(key: 'loginid');
    //   userNameController.text = "";
    //   passwordController.text = "";
    //   flutterToastMsg("Logout Successfully");
    //   Get.off(() => const LoginPage());
    // }

    // return resp;
  }

  static Future<dynamic> getCompanyGrowthFIU() async {
    // String? token = await Service.getToken();
    // var loginid = await getLoginId();
    var companyid = await getCompanyId();
    var response = await http.get(
      Uri.parse("$baseURL/Dashboard/GetGrowthFIU?user_id=$companyid"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCompanyTurnover(List data, List npaData, String date) async {
    if (data.isEmpty == true) {
      data = ["RF", "DF", "EF", "LCDM", "Treds", "Gold Pool"];
    }
    if (npaData.isEmpty == true) {
      npaData = ["0", "1"];
    }
    var companyid = await getCompanyId();
    var response = await http.post(
      Uri.parse("$baseURL/Dashboard/GetTurnover"),
      headers: {
        "Content-Type": "application/json",
      },
      body: convert.jsonEncode(
        (date == "")
            ? <String, dynamic>{
                "UserId": companyid.toString(),
                // "date": date.toString(), // "2024-03-11",
                "client_npa": npaData,
                "Product": data
              }
            : <String, dynamic>{
                "UserId": companyid.toString(),
                "date": date.toString(), // "2024-03-11",
                "client_npa": npaData,
                "Product": data
              },
      ),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCompanyFIU(List data, List clientNPA, String date) async {
    if (data.isEmpty == true) {
      data = ["RF", "DF", "EF", "LCDM", "Treds", "Gold Pool"];
    }
    if (clientNPA.isEmpty == true) {
      clientNPA = [
        "0",
      ];
    }
    var companyid = await getCompanyId();
    var response = await http.post(
      Uri.parse("$baseURL/Dashboard/GetFIU"),
      headers: {
        "Content-Type": "application/json",
      },
      body: convert.jsonEncode(
        (date == "")
            ? <String, dynamic>{
                "UserId": companyid.toString(),
                // "date": date.toString(), // "2024-03-11",
                "client_npa": clientNPA,
                "Product": data
              }
            : <String, dynamic>{
                "UserId": companyid.toString(),
                "date": date.toString(), // "2024-03-11",
                "client_npa": clientNPA,
                "Product": data
              },
      ),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCompanyDebtManagement() async {
    // String? token = await Service.getToken();
    // var loginid =  A await getLoginId();
    var companyid = await getCompanyId();
    var response = await http.get(
      Uri.parse("$baseURL/Debt/GetAllVal?user_id=$companyid"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCompanyDebtManagementDate(date) async {
    // String? token = await Service.getToken();
    // var loginid = await getLoginId();
    var companyid = await getCompanyId();
    var response = await http.get(
      Uri.parse("$baseURL/Debt/GetAllVal?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCompanytreasury(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(
      date == ""
          ? Uri.parse("$baseURL/UploadBorroRFR/GetBorrow?user_id=$companyid&date")
          : Uri.parse("$baseURL/UploadBorroRFR/GetBorrow?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getFIUTurnoverClientService(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(
      date == ""
          ? Uri.parse("$baseURL/Customer/GetFIU_Turnover?user_id=$companyid")
          : Uri.parse("$baseURL/Customer/GetFIU_Turnover?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getFIUOutstandingClientService(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(
      date == ""
          ? Uri.parse("$baseURL/Customer/GetFIU_Outstanding?user_id=$companyid")
          : Uri.parse("$baseURL/Customer/GetFIU_Outstanding?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getFIUBranchwiseClientService(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(
      date == ""
          ? Uri.parse("$baseURL/Customer/GetBranchwise_FIU?user_id=$companyid")
          : Uri.parse("$baseURL/Customer/GetBranchwise_FIU?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getRFR() async {
    var companyid = await getCompanyId();
    var response = await http.get(
      Uri.parse("$baseURL/UploadBorroRFR/GetRFR?user_id=$companyid"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCreditRating() async {
    var companyid = await getCompanyId();
    var response = await http.get(
      Uri.parse("$baseURL/CreditRating/GetAll?user_id=$companyid"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCreditPRR() async {
    var companyid = await getCompanyId();
    var response = await http.get(
      Uri.parse("$baseURL/CreditRating/GetAllPRR?user_id=$companyid"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getCreditCOB() async {
    var companyid = await getCompanyId();
    var response = await http.get(
      Uri.parse("$baseURL/CostOfBorrowing/GetAll?user_id=$companyid"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getassetsandliabilities(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(
      date == ""
          ? Uri.parse("$baseURL/AssetsLiabilities/GetAssests?user_id=$companyid&date=")
          : Uri.parse("$baseURL/AssetsLiabilities/GetAssests?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getsma1(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(
      date == "" ? Uri.parse("$baseURL/Debt/GetAllSME1?user_id=$companyid") : Uri.parse("$baseURL/Debt/GetAllSME1?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getsma2(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(
      date == "" ? Uri.parse("$baseURL/Debt/GetAllSME2?user_id=$companyid") : Uri.parse("$baseURL/Debt/GetAllSME2?user_id=$companyid&date=$date"),
    );
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getHighlights(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(date == ""
        ? Uri.parse("$baseURL/AccountDashboard/GetHighlights?user_id=$companyid&date")
        : Uri.parse("$baseURL/AccountDashboard/GetHighlights?user_id=$companyid&date=$date"));
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getFinancialHighlights(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(date == ""
        ? Uri.parse("$baseURL/AccountDashboard/GetAllFinhighlights?user_id=$companyid")
        : Uri.parse("$baseURL/AccountDashboard/GetAllFinhighlights?user_id=$companyid&date=$date"));
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getFinancialBudgetAndActual(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(date == ""
        ? Uri.parse("$baseURL/AccountDashboard/GetAllMourevised?user_id=$companyid&date")
        : Uri.parse("$baseURL/AccountDashboard/GetAllMourevised?user_id=$companyid&date=$date"));
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getFinancialYield(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(date == ""
        ? Uri.parse("$baseURL/AccountDashboard/GetAllYeild?user_id=$companyid&date")
        : Uri.parse("$baseURL/AccountDashboard/GetAllYeild?user_id=$companyid&date=$date"));
    var resp = convert.jsonDecode(response.body);

    return resp;
  }

  static Future<dynamic> getFinancialEfficiency(String date) async {
    var companyid = await getCompanyId();
    var response = await http.get(date == ""
        ? Uri.parse("$baseURL/AccountDashboard/GetAllEffratio?user_id=$companyid&date")
        : Uri.parse("$baseURL/AccountDashboard/GetAllEffratio?user_id=$companyid&date=$date"));
    var resp = convert.jsonDecode(response.body);

    return resp;
  }
}
