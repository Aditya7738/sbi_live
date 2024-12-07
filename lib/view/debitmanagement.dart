import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sbi/widget/drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constant.dart';
import '../services/service.dart';
import '../widget/appbar.dart';
import 'package:intl/intl.dart';

import '../widget/zoom.dart';

class DebitManagementPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  DebitManagementPage({Key? key}) : super(key: key);

  @override
  _DebitManagementPageState createState() => _DebitManagementPageState();
}

class _DebitManagementPageState extends State<DebitManagementPage>
    with SingleTickerProviderStateMixin {
  List<_ChartData> debtdata = [];
  late TabController tabController;
  RxBool isLoading = false.obs;
  RxBool iserror = false.obs;
  RxString date = "".obs;
  RxString errormsg = "".obs;
  RxString apidate = "".obs;
  DateTime selectedDate = DateTime.now();
  RxDouble totalamount = 0.0.obs;
  RxList tablesma1 = [].obs;
  RxList tablesma2 = [].obs;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    setState(() {
      date.value = DateFormat("MM/dd/yyyy")
          .format(DateTime.now().subtract(const Duration(days: 1)));
      getCompanyAllDebtManagement();
      getSMA1();
      getSMA2();
    });

    super.initState();
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        isLoading.value = true;
        selectedDate = picked;
        date.value = DateFormat("MM/dd/yyyy").format(picked);
        apidate.value = DateFormat("yyyy-MM-dd").format(picked);
        getCompanyDebtManagementFilter();
        getSMA1Filter();
        getSMA2Filter();
        isLoading.value = false;
      });
    }
  }

  List<_ChartData> debtData = [];
  List<_ChartData> debtfilterdateData = [];

  getCompanyDebtManagementFilter() async {
    isLoading.value = true;
    var data = await Service.getCompanyDebtManagementDate(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        for (var i in data["data"]) {
          debtData.add(
            _ChartData(
              i["NoOfAccount"].toString(),
              double.parse(
                i["Amount"].toString(),
              ),
              i["Product"],
            ),
          );
          print(debtData);
        }
      }
      isLoading.value = false;
      debtData.clear();

      flutterToastMsg("Error:No data found!");
      getCompanyAllDebtManagement();
      totalamount.value = 0;
    });
  }

  getCompanyAllDebtManagement() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getCompanyDebtManagement();
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        for (var i in data["data"]) {
          debtData.add(
            _ChartData(
              i["NoOfAccount"].toString(),
              double.parse(
                i["Amount"].toString(),
              ),
              i["Product"],
            ),
          );
          isLoading.value = false;
          print(debtData);
          totalamount.value += i["Amount"];
          print(totalamount.value);
          date.value = i["date"];
          print(date.value);
        }
      }
    });
    isLoading.value = false;
  }

  getSMA1() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getsma1("");
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablesma1.value = data["data"];
        print(tablesma1);
      }
    });
    isLoading.value = false;
  }

  getSMA2() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getsma2("");
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablesma2.value = data["data"];
        print(tablesma2);
      }
    });
    isLoading.value = false;
  }

  getSMA1Filter() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getsma1(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablesma1.value = data["data"];
        print(tablesma1);
      }
    });
    isLoading.value = false;
    tablesma1.clear();
    flutterToastMsg("Error:No data found!");
    await getSMA1();
  }

  getSMA2Filter() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getsma2(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablesma2.value = data["data"];
        print(tablesma2);
      }
    });
    isLoading.value = false;
    tablesma2.clear();
    flutterToastMsg("Error:No data found!");
    await getSMA2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: Obx(
        () {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBarWidget(
                  "Debt Management",
                  true,
                  true,
                ),
                TabBar(
                  labelColor: PURPLE,
                  indicatorColor: PINK,
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: const EdgeInsets.all(10),
                  labelStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const <Widget>[
                    Tab(
                      text: 'Overview',
                    ),
                    Tab(
                      text: 'SMA 1',
                    ),
                    Tab(
                      text: 'SMA 2',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: WHITE,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: GREY_DARK,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            date.value,
                            style: const TextStyle(),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectDate(context);
                                });
                              },
                              child: const Icon(
                                Icons.calendar_month,
                                color: PINK,
                                size: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                (isLoading.value)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: loadingWidget()),
                      )
                    : (debtData.isEmpty == true)
                        ? Center(
                            child: titleText(
                              "Error:No data found!",
                              RED,
                            ),
                          )
                        : Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                ZoomableWidget(
                                  child: SizedBox(
                                    // height: Get.height - 300,
                                    child: SfCircularChart(
                                      selectionGesture:
                                          ActivationMode.doubleTap,
                                      legend: const Legend(
                                        alignment: ChartAlignment.center,
                                        orientation:
                                            LegendItemOrientation.vertical,
                                        isVisible: true,
                                        shouldAlwaysShowScrollbar: false,
                                        position: LegendPosition.bottom,
                                        overflowMode:
                                            LegendItemOverflowMode.none,
                                        textStyle: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      annotations: <CircularChartAnnotation>[
                                        CircularChartAnnotation(
                                          widget: Container(
                                            child: Text(
                                              totalamount.value
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(
                                                color: BLACK,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      series: <CircularSeries<_ChartData,
                                          String>>[
                                        DoughnutSeries<_ChartData, String>(
                                          dataSource: debtData,
                                          xValueMapper: (_ChartData data, _) =>
                                              data.text.toString(),
                                          yValueMapper: (_ChartData data, _) =>
                                              data.y,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true,
                                                  labelPosition:
                                                      ChartDataLabelPosition
                                                          .outside,
                                                  textStyle: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                          legendIconType: LegendIconType.circle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                //sma1
                                (isLoading.value)
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: loadingWidget()),
                                      )
                                    : SingleChildScrollView(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            // dataRowMinHeight: 20.0,
                                            columnSpacing: 10.0,
                                            // horizontalMargin: 10,
                                            headingRowColor:
                                                WidgetStateColor.resolveWith(
                                                    (states) => PINK),
                                            border: const TableBorder(
                                              verticalInside: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                              horizontalInside: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                              top: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                              bottom: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                            ),
                                            showBottomBorder: true,
                                            dataTextStyle:
                                                const TextStyle(wordSpacing: 1),
                                            columns: [
                                              DataColumn(
                                                label: SizedBox(
                                                  // width: 100,
                                                  child: Text(
                                                      'CLIENT NAME'
                                                          .toUpperCase(),
                                                      maxLines: 3,
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  // alignment: Alignment.center,
                                                  width: 85,
                                                  child: Text(
                                                      'BUSINESS TYPE'
                                                          .toUpperCase(),
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                    'OVERDUE BUCKET'
                                                        .toUpperCase(),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: WHITE,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("BRANCH NAME",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("ACCOUNT LIMIT",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  width: 85,
                                                  child: const Text(
                                                      "FIU OUTSTANDING",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("SL OUTSTANDING",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "SL OUTSTANDING INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("FIU OVERDUE",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("FIU OVERDUE INR",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PENDING INTEREST AMOUNT",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                    "PENDING INTEREST AMOUNT INR",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: WHITE,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PENDING CHARGES AMOUNT",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PENDING CHARGES AMOUNT INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "INTEREST RECOVERED TILL DATE",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "MAX OVERDUE DAYS",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                      "DEBTOR NAMES WHEREIN SL OS",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("RECOURSE DAYS",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("PAN NO",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PRINCIPAL OUTSTANDING",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PRINCIPAL OUTSTANDING INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                            ],
                                            rows: [
                                              // Set the values to the columns
                                              for (var i in tablesma1)
                                                DataRow(
                                                  cells: [
                                                    DataCell(
                                                      SizedBox(
                                                        // width: 60,
                                                        child: Text(
                                                            i["CLIENT_NAME"]
                                                                .toString(),
                                                            // maxLines: 5,
                                                            textAlign: TextAlign
                                                                .center,
                                                            // overflow:
                                                            //     TextOverflow
                                                            //         .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color: BLACK,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["BUSINESS_TYPE"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["OVERDUE_BUCKET"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["REGION_NAME"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["ACCOUNT_LIMIT"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["FIU_OUTSTANDING"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["SL_OUTSTANDING"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["SL_OUTSTANDING_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                            TextAlign.right,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["FIU_OVERDUE"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["FIU_OVERDUE_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_INTEREST_AMT"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                            TextAlign.right,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_INTEREST_AMT_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_CHARGES_AMT"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_CHARGES_AMT_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["INTR_RECOVER_TILL_DT"]) ==
                                                                    null
                                                                ? "0"
                                                                : i["INTR_RECOVER_TILL_DT"]
                                                                    .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["MAX_OVERDUE_DAYS"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                            TextAlign.right,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["DEBTOR_NAMES_WHEREIN_SL_OS"] ==
                                                                    null
                                                                ? "0"
                                                                : i["DEBTOR_NAMES_WHEREIN_SL_OS"]
                                                                    .toString()),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["RECOURSE_DAYS"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PAN_NO"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            i["PRINC_OUTSTANDING"] ==
                                                                    null
                                                                ? "0"
                                                                : (i["PRINC_OUTSTANDING"])
                                                                    .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            i["PRINC_OUTSTANDING_INR"] ==
                                                                    null
                                                                ? "0"
                                                                : (i["PRINC_OUTSTANDING_INR"])
                                                                    .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                //sma2
                                (isLoading.value)
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: loadingWidget()),
                                      )
                                    : SingleChildScrollView(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            // dataRowMinHeight: 20.0,
                                            columnSpacing: 10.0,
                                            // horizontalMargin: 10,
                                            headingRowColor:
                                                WidgetStateColor.resolveWith(
                                                    (states) => PINK),
                                            border: const TableBorder(
                                              verticalInside: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                              horizontalInside: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                              top: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                              bottom: BorderSide(
                                                  color: GREY_DARK, width: 0.5),
                                            ),
                                            showBottomBorder: true,
                                            dataTextStyle:
                                                const TextStyle(wordSpacing: 1),
                                            columns: [
                                              DataColumn(
                                                label: SizedBox(
                                                  // width: 75,
                                                  child: Text(
                                                      'CLIENT NAME'
                                                          .toUpperCase(),
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      'BUSINESS TYPE'
                                                          .toUpperCase(),
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      'OVERDUE BUCKET'
                                                          .toUpperCase(),
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("BRANCH NAME",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("ACCOUNT LIMIT",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("FIU OUTSTANDING",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("SL OUTSTANDING",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "SL OUTSTANDING INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("FIU OVERDUE",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("FIU OVERDUE INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PENDING INTEREST AMOUNT",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PENDING INTEREST AMOUNT INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PENDING CHARGES AMOUNT",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PENDING CHARGES AMOUNT INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "INTEREST RECOVERED TILL DATE",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "MAX OVERDUE DAYS",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                      "DEBTOR NAMES WHEREIN SL OS",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                    "RECOURSE DAYS",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: WHITE,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text("PAN NO",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PRINCIPAL OUTSTANDING",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                              const DataColumn(
                                                label: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                      "PRINCIPAL OUTSTANDING INR",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: WHITE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ),
                                            ],
                                            rows: [
                                              // Set the values to the columns
                                              for (var i in tablesma2)
                                                DataRow(
                                                  cells: [
                                                    DataCell(
                                                      SizedBox(
                                                        // width: 60,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Text(
                                                              i["CLIENT_NAME"]
                                                                  .toString(),
                                                              maxLines: 5,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color: BLACK,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["BUSINESS_TYPE"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["OVERDUE_BUCKET"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["REGION_NAME"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["ACCOUNT_LIMIT"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["FIU_OUTSTANDING"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["SL_OUTSTANDING"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["SL_OUTSTANDING_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                            TextAlign.right,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["FIU_OVERDUE"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["FIU_OVERDUE_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_INTEREST_AMT"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                            TextAlign.right,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_INTEREST_AMT_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_CHARGES_AMT"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PENDING_CHARGES_AMT_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["INTR_RECOVER_TILL_DT"]) ==
                                                                    null
                                                                ? "0"
                                                                : i["INTR_RECOVER_TILL_DT"]
                                                                    .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["MAX_OVERDUE_DAYS"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                            TextAlign.right,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["DEBTOR_NAMES_WHEREIN_SL_OS"] ==
                                                                    null
                                                                ? "0"
                                                                : i["DEBTOR_NAMES_WHEREIN_SL_OS"]
                                                                    .toString()),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["RECOURSE_DAYS"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PAN_NO"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PRINC_OUTSTANDING"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: normaltext(
                                                            (i["PRINC_OUTSTANDING_INR"])
                                                                .toString(),
                                                            BLACK,
                                                            FontWeight.bold,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
              ],
            ),
          );
        },
      ),
      drawer: WeDrawer(),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, [this.text]);
  final String x;
  final num y;
  String? text;
}
