// ignore_for_file: depend_on_referenced_packages, no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbi/view/home.dart';

import '../constant.dart';
import '../services/service.dart';
import '../view/clientservice.dart';
import '../view/debitmanagement.dart';
import '../view/financialperformance.dart';
import '../view/treasury.dart';
import 'popup.dart';

class WeDrawer extends StatefulWidget {
  WeDrawer({super.key}) {}
  @override
  _WeDrawerState createState() => _WeDrawerState();
}

class _WeDrawerState extends State<WeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Drawer(
          width: 270,
          backgroundColor: WHITE,
          child: ListView(
            // padding: EdgeInsets.zero,
            children: [
              Service.isLoading.value
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: loadingWidget(),
                    ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/sbilogo.png',
                            width: 120,
                          ),
                        ),
                      ],
                    ),
              Container(
                height: 4,
                width: Get.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        PURPLE,
                        PINK,
                      ],
                      begin: const FractionalOffset(0.2, 0.0),
                      end: const FractionalOffset(0.5, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                horizontalTitleGap: 0.5,
                leading: const Icon(
                  Icons.home_outlined,
                  color: PINK,
                  size: 20,
                ),
                title: normaltext(
                  'Dashboard',
                  BLACK,
                ),
                onTap: () {
                  Get.to(() => MyHomePage());
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                horizontalTitleGap: 0.5,
                leading: const Icon(
                  Icons.card_travel_sharp,
                  color: PINK,
                  size: 20,
                ),
                title: normaltext(
                  'Client Service',
                  BLACK,
                ),
                onTap: () {
                  Get.to(() => ClientServicePage());
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                horizontalTitleGap: 0.5,
                leading: const Icon(
                  Icons.account_tree_sharp,
                  color: PINK,
                  size: 20,
                ),
                title: normaltext(
                  'Treasury',
                  BLACK,
                ),
                onTap: () {
                  Get.to(() => TreasuryPage());
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                horizontalTitleGap: 0.5,
                leading: const Icon(
                  Icons.account_balance_rounded,
                  color: PINK,
                  size: 20,
                ),
                title: normaltext(
                  'Financial Performance',
                  BLACK,
                ),
                onTap: () {
                  Get.to(() => FinancialPerformancePage());
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                horizontalTitleGap: 0.5,
                leading: const Icon(
                  Icons.volcano_outlined,
                  color: PINK,
                  size: 20,
                ),
                title: normaltext(
                  'Debt Management',
                  BLACK,
                ),
                onTap: () {
                  Get.to(() => DebitManagementPage());
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                horizontalTitleGap: 0.5,
                leading: const Icon(
                  Icons.logout_outlined,
                  color: PINK,
                  size: 20,
                ),
                title: normaltext(
                  'Logout',
                  PINK,
                ),
                onTap: () {
                  showMyDialog("", "Are you sure want to ", "Logout ", "Logout",
                      () {
                    Service.logout();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
