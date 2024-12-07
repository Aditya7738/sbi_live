import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constant.dart';
import '../services/service.dart';

Future<void> showMyDialog(var data, String title1, String title2,
    String btntext, Function onPressed) async {
  return showDialog<void>(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: normaltext("$title2 ", RED),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              RichText(
                text: TextSpan(
                  text: title1,
                  style: TextStyle(color: BLACK),
                  children: <TextSpan>[
                    TextSpan(
                        text: title2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: BLACK,
                        )),
                    TextSpan(text: '?'),
                  ],
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: normaltext(
              'Cancel',
              RED,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: normaltext(
              btntext,
              RED,
            ),
            onPressed: () {
              onPressed.call();
              Get.back();
            },
          ),
        ],
      );
    },
  );
}

Future<bool> onWillPopHome({bool? canBackClose}) async {
  bool? exitResult = await Get.dialog(
    WillPopScope(
      onWillPop: () async {
        if (canBackClose == null) {
          return false;
        }
        return true;
      },
      child: AlertDialog(
        title: const Text('Please Confirm'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            onPressed: () => Get.back(canPop: false),
            child: const Text(
              'No',
              style: TextStyle(color: BLUE),
            ),
          ),
          TextButton(
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(BLUE)),
            onPressed: () => Service.logout(),
            child: const Text(
              'Yes',
              style: TextStyle(color: WHITE),
            ),
          ),
        ],
      ),
    ),
  );
  return exitResult ?? false;
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/get_rx.dart';

// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// import '../constant.dart';
// import '../service.dart';
// import '../widget/appbar.dart';
// import '../widget/drawer.dart';

// class _SalesData {
//   _SalesData(this.year, this.fiu);

//   final String year;
//   final double fiu;
// }

// class MyHomePage extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     setState(() {
//       getCompanyGrowth();
//     });
//     super.initState();
//   }

//   double dataCount = 0.0;
//   List<_SalesData> fiuBarData = [];
//   RxBool isLoading = false.obs;
//   List yearBarData = [];
//   List<_PieData> pieData = [
//     _PieData('2018-19', 111, "11.12%"),
//     _PieData('2019-20', 222, "12.22%"),
//     _PieData('2020-21', 121, "13.33%"),
//     _PieData('2021-22', 333, "16.44%"),
//     _PieData('2022-23', 444, "34.55%"),
//     _PieData('2023-24', 111, "89.66%")
//   ];

//   // List<_SalesData> fiudata = [
//   //   // _SalesData([], []),
//   //   // _SalesData('2019-20', 222.212),
//   //   // _SalesData('2020-21', 121.213),
//   //   // _SalesData('2021-22', 333.214),
//   //   // _SalesData('2022-23', 444.213),
//   //   // _SalesData('2023-24', 111.216)
//   // ];
//   getCompanyGrowth() async {
//     var data = await Service.getCompanyGrowth();
//     print(data);
//     setState(() {
//       if (data["outcome"]["outcomeId"] == 1) {
//         //  final String jsonString = await getJsonFromAssets();
//         // final dynamic jsonResponse = json.decode(jsonString);

//         for (var i in data["data"]) {
//           // var a = [];

//           //  var a = [
//           //       _SalesData(i["g_particulars"],
//           //           double.parse(i["g_fiu"].toString().replaceAll(",", ""))),
//           //     ];

//           fiuBarData.add(_SalesData(i["g_particulars"],
//               double.parse(i["g_fiu"].toString().replaceAll(",", ""))));
//           print(fiuBarData);
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // HomeController homeController = Get.put(HomeController());
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Dashboard SBI Global Factors'),
//       // ),
//       body: Obx(() {
//         return SafeArea(
//           child: Column(
//             children: [
//               AppBarWidget(
//                 "Dashboard-SBI Global Factors",
//                 true,
//                 true,
//               ),
//               Center(
//                 child: titleText(
//                   "Company Growth-FIU",
//                   BLACK,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               (isLoading.value)
//                   ? Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Center(child: loadingWidget()),
//                     )
//                   : Container(
//                       height: 300,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         //Initialize the spark charts widget
//                         child: SfSparkBarChart.custom(
                          
//                           // axisLineWidth: 20,
//                           axisLineColor: BLUE,
//                           // axisLineDashArray: [1, 2, 3, 4, 5, 6],
//                           color: BLUE,
//                           //Enable the trackball

//                           trackball: SparkChartTrackball(
//                               activationMode: SparkChartActivationMode.tap,
//                               dashArray: [
//                                 1.1,
//                                 1.2,
//                                 1.3,
//                                 1.4,
//                                 1.5,
//                                 1.6,
//                               ]),
//                           //Enable marker
//                           // marker: SparkC
//                           //
//                           // hartMarker(
//                           //     displayMode: SparkChartMarkerDisplayMode.all),
//                           //Enable data label
//                           labelDisplayMode: SparkChartLabelDisplayMode.all,
//                           xValueMapper: (int index) => fiuBarData[index].year,
//                           yValueMapper: (int index) => fiuBarData[index].fiu,
//                           dataCount: 6,
//                         ),
//                       ),
//                     ),

//               // Expanded(
//               //   child: Padding(
//               //       padding: const EdgeInsets.all(8.0),
//               //       //Initialize the spark charts widget
//               //       child: SfCircularChart(
//               //           title: const ChartTitle(text: 'Sales by sales person'),
//               //           legend: const Legend(isVisible: true),
//               //           series: <PieSeries<_PieData, String>>[
//               //             PieSeries<_PieData, String>(
//               //                 explode: false,
//               //                 explodeIndex: 0,
//               //                 dataSource: pieData,
//               //                 xValueMapper: (_PieData data, _) => data.xData,
//               //                 yValueMapper: (_PieData data, _) => data.yData,
//               //                 dataLabelMapper: (_PieData data, _) => data.text,
//               //                 dataLabelSettings:
//               //                     const DataLabelSettings(isVisible: true)),
//               //           ])),
//               // )
//             ],
//           ),
//         );
//       }),
//       drawer: WeDrawer(),
//     );
//   }
// }

// class _PieData {
//   _PieData(this.xData, this.yData, [this.text]);
//   final String xData;
//   final num yData;
//   String? text;
// }

// // class _SalesData {
// //   _SalesData(this.year, this.sales);

// //   final String year;
// //   final double sales;
// // }
// class GrowthFIUData {
//   GrowthFIUData(this.year, this.fiu);

//   final String year;
//   final int fiu;

//   // factory GrowthFIUData.fromJson(Map<String, dynamic> parsedJson) {
//   //   return GrowthFIUData(
//   //     parsedJson['g_particulars'].toString(),
//   //     parsedJson['g_fiu'],
//   //   );
//   // }
//   // GrowthFIUData(this.year, this.amount);

//   // final String year;
//   // final double amount;
//   // factory GrowthFIUData.fromJson(Map<String, dynamic> parsedJson) {
//   //   return GrowthFIUData(
//   //     parsedJson['month'].toString(),
//   //     parsedJson['sales'],
//   //   );
//   // }
// }
