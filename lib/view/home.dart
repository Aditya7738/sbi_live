import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constant.dart';
import '../services/service.dart';
import '../widget/appbar.dart';
import '../widget/drawer.dart';
import '../widget/popup.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../widget/zoom.dart';

class _GrowthData {
  _GrowthData(this.year, this.fiu);

  final String year;
  final double fiu;
}

class _TurnOverData {
  _TurnOverData(this.date, this.payment);

  final String date;
  final double payment;
}

class _FIUData {
  _FIUData(this.clientArea, this.payment);

  final String clientArea;
  final double payment;
}

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  // RxString fiudate = "".obs;
  // RxString turnoverdate = "".obs;
  RxString apidateFIU = "".obs;
  RxString datetitle = "".obs;
  RxString apidateTurnover = "".obs;
  DateTime selectedDate = DateTime.now();
  double dataCount = 0.0;
  List<_GrowthData> fiuBarData = [];
  List<_GrowthData> turnoverGrowthBarData = [];
  List<_GrowthData> patGrowthBarData = [];
  List<_TurnOverData> turnoverBarData = [];
  List<_FIUData> branchwisefiuBarData = [];
  RxBool isLoading = false.obs;
  List yearBarData = [];
  final TextEditingController product = TextEditingController();
  final TextEditingController selectproduct = TextEditingController();
  RxList<String> productList = <String>[
    "DF",
    "PF",
    "GOLD POOL",
    "LCDM",
    "LCEX",
    "RF",
    "Treds",
  ].obs;
  RxList<String> selectedProductFIUdata = <String>[].obs;
  RxList<String> selectedNPAFIUdata = <String>[].obs;
  RxList<String> selectedProductTurnoverdata = <String>[].obs;
  RxList<String> selectedNPATurnoverdata = <String>[].obs;
  final TextEditingController clientNPA = TextEditingController();
  final TextEditingController selectclientNPA = TextEditingController();
  RxList<String> clientNPAList = <String>[
    "0",
    "1",
  ].obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble totalAmountTurnover = 0.0.obs;
  @override
  void initState() {
    setState(() {
      tabController = TabController(length: 3, vsync: this);
      // date.value = DateFormat("dd/MM/yyyy").format(DateTime.now());
      // date.value = DateFormat("dd/MM/yyyy").format(DateTime.now());
      // apidateFIU.value = DateFormat("yyyy-MM-dd").format(DateTime.now());
      // apidateTurnover.value = DateFormat("yyyy-MM-dd").format(DateTime.now());
      getCompanyGrowthFIU();
      getCompanyTurnover();
      getCompanyFIU();
    });
    super.initState();
  }

  _selectDateFIU(BuildContext context) async {
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
        // date.value = DateFormat("MM/dd/yyyy").format(picked);
        apidateFIU.value = DateFormat("yyyy-MM-dd").format(picked);
        branchwisefiuBarData.clear();
        getCompanyFIU();

        isLoading.value = false;
      });
    }
  }

  _selectDateTurnover(BuildContext context) async {
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
        // date.value = DateFormat("MM/dd/yyyy").format(picked);

        apidateTurnover.value = DateFormat("yyyy-MM-dd").format(picked);
        turnoverBarData.clear();
        getCompanyTurnover();

        isLoading.value = false;
      });
    }
  }

  getCompanyGrowthFIU() async {
    var data = await Service.getCompanyGrowthFIU();
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        for (var i in data["data"]) {
          fiuBarData.add(_GrowthData(i["g_particulars"],
              double.parse(i["g_fiu"].toString().replaceAll(",", ""))));
          turnoverGrowthBarData.add(_GrowthData(i["g_particulars"],
              double.parse(i["g_turnover"].toString().replaceAll(",", ""))));
          patGrowthBarData.add(_GrowthData(i["g_particulars"],
              double.parse(i["g_pat"].toString().replaceAll(",", ""))));
          print(turnoverGrowthBarData);
          datetitle.value = i["g_updateddate"];
          print(datetitle.value);
        }
      }
    });
  }

  getCompanyTurnover() async {
    isLoading.value = true;
    var data = await Service.getCompanyTurnover(
        selectedProductTurnoverdata.value,
        selectedNPATurnoverdata.value,
        apidateTurnover.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        var sum1 = 0.0;
        for (var i in data["data"]) {
          turnoverBarData.add(
              _TurnOverData(i["Client_Area_New"].toString(), i["FIU_IN_CR"]));
          print(turnoverBarData);
          sum1 += i["FIU_IN_CR"];

          print(sum1);
          totalAmountTurnover.value = sum1;
          print(totalAmountTurnover);

          isLoading.value = false;
          // apidateTurnover.value = i["filedate"];
          DateTime dateh = DateFormat("yyyy-MM-dd").parse(i["filedate"]);
          apidateTurnover.value = DateFormat("MM/dd/yyyy").format(dateh);
        }
      }
    });
    isLoading.value = false;

    // }
  }

  getCompanyFIU() async {
    isLoading.value = true;
    var data = await Service.getCompanyFIU(selectedProductFIUdata.value,
        selectedNPAFIUdata.value, apidateFIU.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        var sum1 = 0.0;
        for (var i in data["data"]) {
          branchwisefiuBarData.add(
            _FIUData(
              i["Client_Area_New"].toString(),
              i["FIU_IN_CR"],
            ),
          );
          sum1 += i["FIU_IN_CR"];
          print(sum1);
          totalAmount.value = sum1;

          // apidateFIU.value = i["filedate"];
          // print(apidateFIU.value);
          DateTime dateh = DateFormat("yyyy-MM-dd").parse(i["filedate"]);
          apidateFIU.value = DateFormat("MM/dd/yyyy").format(dateh);
          // date.value = i["filedate"];
          // print(date.value);
          isLoading.value = false;
        }
      }
    });
    isLoading.value = false;

    // }
  }

  @override
  Widget build(BuildContext context) {
    if (false
        //Platform.isAndroid
        ) {
      return Scaffold(
        backgroundColor: GREY,
        body: Obx(
          () {
            return PopScope(
              onPopInvoked: (didPop) async {
                onWillPopHome();
              },
              child: SafeArea(
                child: Column(
                  children: [
                    AppBarWidget(
                      "Dashboard-SBI Global Factors",
                      true,
                      true,
                    ),
                    TabBar(
                      labelColor: PURPLE,
                      indicatorColor: PINK,
                      controller: tabController,
                      labelStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const <Widget>[
                        Tab(
                          text: 'Branchwise FIU',
                        ),
                        Tab(
                          text: 'Branchwise Turnover',
                        ),
                        Tab(
                          text: 'Company Growth',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          (isLoading.value)
                              ? Center(
                                  child: loadingWidget(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: MultiSelectDialogField(
                                            // dialogWidth: Get.width,
                                            buttonIcon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: BLACK,
                                            ),
                                            buttonText:
                                                normaltext("Product", BLACK),
                                            decoration: BoxDecoration(
                                              color: WHITE,
                                              border: Border.all(
                                                color: GREY,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            items: productList
                                                .map((e) =>
                                                    MultiSelectItem(e, e))
                                                .toList(),
                                            listType: MultiSelectListType.LIST,
                                            onConfirm: (values) {
                                              setState(() {
                                                branchwisefiuBarData.clear();
                                                isLoading.value = true;
                                                selectedProductFIUdata.value =
                                                    values;
                                                print(selectedProductFIUdata);
                                                getCompanyFIU();
                                                isLoading.value = false;
                                              });
                                            },
                                            title: normaltext(
                                              "Product",
                                              BLACK,
                                              FontWeight.bold,
                                            ),
                                            searchHint: "Product",
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: SizedBox(
                                                child: MultiSelectDialogField(
                                                  // dialogWidth: Get.width,
                                                  buttonIcon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: BLACK,
                                                  ),
                                                  buttonText: normaltext(
                                                      "Client NPA", BLACK),
                                                  decoration: BoxDecoration(
                                                    color: WHITE,
                                                    border: Border.all(
                                                      color: GREY,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  items: clientNPAList
                                                      .map((e) =>
                                                          MultiSelectItem(e, e))
                                                      .toList(),
                                                  listType:
                                                      MultiSelectListType.LIST,
                                                  onConfirm: (values) {
                                                    setState(() {
                                                      branchwisefiuBarData
                                                          .clear();
                                                      isLoading.value = true;
                                                      selectedNPAFIUdata.value =
                                                          values;
                                                      print(selectedNPAFIUdata);

                                                      getCompanyFIU();
                                                      isLoading.value = false;
                                                    });
                                                  },
                                                  title: normaltext(
                                                    "Client NPA",
                                                    BLACK,
                                                    FontWeight.bold,
                                                  ),
                                                  searchHint: "Client NPA",
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: WHITE,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: GREY,
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        apidateFIU.value,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectDateFIU(
                                                                  context);
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: PINK,
                                                            size: 18,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        (branchwisefiuBarData.isEmpty == true)
                                            ? Center(
                                                child: titleText(
                                                  "Error:No data found!",
                                                  RED,
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  SfCartesianChart(
                                                    zoomPanBehavior:
                                                        ZoomPanBehavior(
                                                      enablePinching: true,
                                                      zoomMode: ZoomMode.xy,
                                                      enablePanning: true,
                                                    ),
                                                    primaryXAxis:
                                                        const CategoryAxis(
                                                      interval: 1,
                                                      title: AxisTitle(
                                                        text: 'Year',
                                                        textStyle: TextStyle(
                                                            fontSize: 12,
                                                            color: PINK),
                                                      ),
                                                      labelPlacement:
                                                          LabelPlacement
                                                              .betweenTicks,
                                                      labelPosition:
                                                          ChartDataLabelPosition
                                                              .outside,
                                                      labelStyle: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    primaryYAxis:
                                                        const NumericAxis(
                                                      labelStyle: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      title: AxisTitle(
                                                          text: 'Amount in Cr.',
                                                          textStyle: TextStyle(
                                                              fontSize: 10,
                                                              color: PINK)),
                                                    ),
                                                    enableSideBySideSeriesPlacement:
                                                        true,
                                                    enableAxisAnimation: true,
                                                    series: <CartesianSeries<
                                                        _FIUData, dynamic>>[
                                                      ColumnSeries(
                                                        dataLabelSettings:
                                                            const DataLabelSettings(
                                                          isVisible: true,
                                                          textStyle: TextStyle(
                                                              fontSize: 7,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        color: GREEN,
                                                        dataSource:
                                                            branchwisefiuBarData,
                                                        xValueMapper:
                                                            (_FIUData data,
                                                                    _) =>
                                                                data.clientArea,
                                                        yValueMapper:
                                                            (_FIUData data,
                                                                    _) =>
                                                                data.payment,
                                                        width: 0.8,
                                                        spacing: 0.2,
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ZoomableWidget(
                                                    child: SizedBox(
                                                      height: 300,
                                                      child: SfCircularChart(
                                                        legend: const Legend(
                                                          textStyle: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          alignment:
                                                              ChartAlignment
                                                                  .center,
                                                          orientation:
                                                              LegendItemOrientation
                                                                  .vertical,
                                                          isVisible: true,
                                                          shouldAlwaysShowScrollbar:
                                                              true,
                                                          position:
                                                              LegendPosition
                                                                  .bottom,
                                                          overflowMode:
                                                              LegendItemOverflowMode
                                                                  .wrap,
                                                        ),
                                                        annotations: <CircularChartAnnotation>[
                                                          CircularChartAnnotation(
                                                            widget: Text(
                                                              totalAmount.value
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: const TextStyle(
                                                                  color: BLACK,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                        series: <CircularSeries<
                                                            _FIUData, String>>[
                                                          DoughnutSeries<
                                                              _FIUData, String>(
                                                            dataSource:
                                                                branchwisefiuBarData,
                                                            xValueMapper: (_FIUData
                                                                        data,
                                                                    _) =>
                                                                data.clientArea,
                                                            yValueMapper:
                                                                (_FIUData data,
                                                                        _) =>
                                                                    data.payment,
                                                            dataLabelMapper:
                                                                (_FIUData data,
                                                                        _) =>
                                                                    "${data.payment}%",
                                                            dataLabelSettings:
                                                                const DataLabelSettings(
                                                              isVisible: true,
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              labelPosition:
                                                                  ChartDataLabelPosition
                                                                      .outside,
                                                            ),
                                                            legendIconType:
                                                                LegendIconType
                                                                    .circle,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                          (isLoading.value)
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: loadingWidget()),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: MultiSelectDialogField(
                                            // dialogWidth: Get.width,
                                            buttonIcon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: BLACK,
                                            ),
                                            buttonText:
                                                normaltext("Product", BLACK),
                                            decoration: BoxDecoration(
                                              color: WHITE,
                                              border: Border.all(
                                                color: GREY,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            items: productList
                                                .map((e) =>
                                                    MultiSelectItem(e, e))
                                                .toList(),
                                            listType: MultiSelectListType.LIST,
                                            onConfirm: (values) {
                                              setState(() {
                                                turnoverBarData.clear();
                                                isLoading.value = true;
                                                selectedProductTurnoverdata
                                                    .value = values;
                                                print(
                                                    selectedProductTurnoverdata);

                                                getCompanyTurnover();
                                                isLoading.value = false;
                                              });
                                            },
                                            title: normaltext(
                                              "Product",
                                              BLACK,
                                              FontWeight.bold,
                                            ),
                                            searchHint: "Product",
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: MultiSelectDialogField(
                                                // dialogWidth: Get.width,
                                                buttonIcon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: BLACK,
                                                ),
                                                buttonText: normaltext(
                                                    "Client NPA", BLACK),
                                                decoration: BoxDecoration(
                                                  color: WHITE,
                                                  border: Border.all(
                                                    color: GREY,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                items: clientNPAList
                                                    .map((e) =>
                                                        MultiSelectItem(e, e))
                                                    .toList(),
                                                listType:
                                                    MultiSelectListType.LIST,
                                                onConfirm: (values) {
                                                  setState(() {
                                                    turnoverBarData.clear();
                                                    isLoading.value = true;
                                                    selectedNPATurnoverdata
                                                        .value = values;
                                                    print(
                                                        selectedNPATurnoverdata);

                                                    getCompanyTurnover();
                                                    isLoading.value = false;
                                                  });
                                                },
                                                title: normaltext(
                                                  "Client NPA",
                                                  BLACK,
                                                  FontWeight.bold,
                                                ),
                                                searchHint: "Client NPA",
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: WHITE,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: GREY,
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        apidateTurnover.value,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectDateTurnover(
                                                                  context);
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: PINK,
                                                            size: 18,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        (turnoverBarData.isEmpty == true)
                                            ? Center(
                                                child: titleText(
                                                  "Error:No data found!",
                                                  RED,
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  SfCartesianChart(
                                                    primaryXAxis:
                                                        const CategoryAxis(
                                                      arrangeByIndex: true,
                                                      interval: 1,
                                                      title: AxisTitle(
                                                        text: 'Year',
                                                        textStyle: TextStyle(
                                                            fontSize: 12,
                                                            color: PINK),
                                                      ),
                                                      labelPlacement:
                                                          LabelPlacement
                                                              .betweenTicks,
                                                      labelPosition:
                                                          ChartDataLabelPosition
                                                              .outside,
                                                      labelStyle: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    primaryYAxis:
                                                        const NumericAxis(
                                                      labelStyle: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),

                                                      title: AxisTitle(
                                                          text: 'Amount in Cr.',
                                                          textStyle: TextStyle(
                                                              fontSize: 10,
                                                              color: PINK)),
                                                      // rangePadding:
                                                      //     ChartRangePadding.additional,
                                                    ),
                                                    enableSideBySideSeriesPlacement:
                                                        true,
                                                    enableAxisAnimation: true,
                                                    zoomPanBehavior:
                                                        ZoomPanBehavior(
                                                      enablePinching: true,
                                                      zoomMode: ZoomMode.xy,
                                                      enablePanning: true,
                                                    ),
                                                    series: <CartesianSeries<
                                                        _TurnOverData,
                                                        dynamic>>[
                                                      ColumnSeries(
                                                        dataLabelSettings:
                                                            const DataLabelSettings(
                                                          isVisible: true,
                                                          textStyle: TextStyle(
                                                              fontSize: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        color: Colors
                                                            .tealAccent[200],
                                                        dataSource:
                                                            turnoverBarData,
                                                        // xAxisName: "Year",
                                                        // yAxisName: "Amount in Cr",
                                                        xValueMapper:
                                                            (_TurnOverData data,
                                                                    _) =>
                                                                data.date,
                                                        yValueMapper:
                                                            (_TurnOverData data,
                                                                    _) =>
                                                                data.payment,
                                                        width:
                                                            0.8, // Width of the columns
                                                        spacing: 0.2,
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ZoomableWidget(
                                                    child: SizedBox(
                                                      height: 300,
                                                      child: SfCircularChart(
                                                        legend: const Legend(
                                                          alignment:
                                                              ChartAlignment
                                                                  .center,
                                                          orientation:
                                                              LegendItemOrientation
                                                                  .vertical,
                                                          isVisible: true,
                                                          shouldAlwaysShowScrollbar:
                                                              true,
                                                          position:
                                                              LegendPosition
                                                                  .bottom,
                                                          overflowMode:
                                                              LegendItemOverflowMode
                                                                  .wrap,
                                                          textStyle: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        annotations: <CircularChartAnnotation>[
                                                          CircularChartAnnotation(
                                                            widget: Text(
                                                              totalAmountTurnover
                                                                  .value
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style:
                                                                  const TextStyle(
                                                                color: BLACK,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                        series: <CircularSeries<
                                                            _TurnOverData,
                                                            String>>[
                                                          DoughnutSeries<
                                                              _TurnOverData,
                                                              String>(
                                                            dataSource:
                                                                turnoverBarData,
                                                            xValueMapper:
                                                                (_TurnOverData
                                                                            data,
                                                                        _) =>
                                                                    data.date
                                                                        .toString(),
                                                            yValueMapper:
                                                                (_TurnOverData
                                                                            data,
                                                                        _) =>
                                                                    data.payment,
                                                            dataLabelSettings:
                                                                const DataLabelSettings(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              isVisible: true,
                                                              labelPosition:
                                                                  ChartDataLabelPosition
                                                                      .outside,
                                                            ),
                                                            dataLabelMapper:
                                                                (_TurnOverData
                                                                            data,
                                                                        _) =>
                                                                    "${data.payment}%",
                                                            legendIconType:
                                                                LegendIconType
                                                                    .circle,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: (isLoading.value)
                                  ? Center(
                                      child: loadingWidget(),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 20,
                                            right: 20,
                                          ),
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: titleText(
                                                datetitle.value,
                                                BLACK,
                                              )),
                                        ),
                                        Center(
                                          child: titleText(
                                            "Company Growth-FIU",
                                            PINK,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        (isLoading.value)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: loadingWidget()),
                                              )
                                            // : ZoomableWidget(
                                            // child:
                                            : SfCartesianChart(
                                                zoomPanBehavior:
                                                    ZoomPanBehavior(
                                                  enablePinching: true,
                                                  zoomMode: ZoomMode.xy,
                                                  enablePanning: true,
                                                ),
                                                enableSideBySideSeriesPlacement:
                                                    true,
                                                primaryXAxis:
                                                    const CategoryAxis(
                                                  title: AxisTitle(
                                                    text: 'Year',
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: PINK,
                                                    ),
                                                  ),
                                                  labelPlacement: LabelPlacement
                                                      .betweenTicks,
                                                  labelPosition:
                                                      ChartDataLabelPosition
                                                          .outside,
                                                  labelStyle: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                primaryYAxis: NumericAxis(
                                                  labelStyle: const TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  minimum: 1000,
                                                  numberFormat: NumberFormat
                                                      .decimalPattern(),
                                                  title: const AxisTitle(
                                                    text: 'Amount in Cr.',
                                                    textStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: PINK,
                                                    ),
                                                  ),
                                                  rangePadding:
                                                      ChartRangePadding
                                                          .additional,
                                                ),
                                                enableAxisAnimation: true,
                                                series: <CartesianSeries<
                                                    _GrowthData, dynamic>>[
                                                  ColumnSeries(
                                                      dataLabelSettings:
                                                          const DataLabelSettings(
                                                        isVisible: true,
                                                        textStyle: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      color: BLUE,
                                                      dataSource: fiuBarData,
                                                      xValueMapper: (_GrowthData
                                                                  data,
                                                              _) =>
                                                          data.year.toString(),
                                                      yValueMapper:
                                                          (_GrowthData data,
                                                                  _) =>
                                                              data.fiu,
                                                      width:
                                                          0.6, // Width of the columns
                                                      spacing: 0.1)
                                                ],
                                              ),
                                        // ),
                                        Container(
                                          height: 10,
                                          width: Get.width,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  PURPLE,
                                                  PINK,
                                                ],
                                                begin:
                                                    FractionalOffset(0.2, 0.0),
                                                end: FractionalOffset(0.5, 0.0),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: titleText(
                                            "Company Growth-Turnover",
                                            PINK,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        (isLoading.value)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: loadingWidget()),
                                              )
                                            : SfCartesianChart(
                                                zoomPanBehavior:
                                                    ZoomPanBehavior(
                                                  enablePinching: true,
                                                  zoomMode: ZoomMode.xy,
                                                  enablePanning: true,
                                                ),
                                                primaryXAxis:
                                                    const CategoryAxis(
                                                  title: AxisTitle(
                                                      text: 'Year',
                                                      textStyle: TextStyle(
                                                          fontSize: 12,
                                                          color: PINK)),
                                                  labelPlacement: LabelPlacement
                                                      .betweenTicks,
                                                  labelPosition:
                                                      ChartDataLabelPosition
                                                          .outside,
                                                  labelStyle: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                primaryYAxis: NumericAxis(
                                                  labelStyle: const TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  minimum: 1000,
                                                  numberFormat: NumberFormat
                                                      .decimalPattern(),
                                                  title: const AxisTitle(
                                                      text: 'Amount in Cr.',
                                                      textStyle: TextStyle(
                                                          fontSize: 10,
                                                          color: PINK)),
                                                  rangePadding:
                                                      ChartRangePadding
                                                          .additional,
                                                ),
                                                enableSideBySideSeriesPlacement:
                                                    true,
                                                enableAxisAnimation: true,
                                                series: <CartesianSeries<
                                                    _GrowthData, dynamic>>[
                                                  ColumnSeries(
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                      isVisible: true,
                                                      textStyle: TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    color: GREEN,
                                                    dataSource:
                                                        turnoverGrowthBarData,

                                                    xValueMapper:
                                                        (_GrowthData data, _) =>
                                                            data.year
                                                                .toString(),
                                                    yValueMapper:
                                                        (_GrowthData data, _) =>
                                                            data.fiu,
                                                    width:
                                                        0.8, // Width of the columns
                                                    spacing: 0.2,
                                                  )
                                                ],
                                              ),

                                        Container(
                                          height: 10,
                                          width: Get.width,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  PURPLE,
                                                  PINK,
                                                ],
                                                begin:
                                                    FractionalOffset(0.2, 0.0),
                                                end: FractionalOffset(0.5, 0.0),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: titleText(
                                            "Company Growth-PAT",
                                            PINK,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        (isLoading.value)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: loadingWidget()),
                                              )
                                            : SfCartesianChart(
                                                zoomPanBehavior:
                                                    ZoomPanBehavior(
                                                  enablePinching: true,
                                                  zoomMode: ZoomMode.xy,
                                                  enablePanning: true,
                                                ),
                                                primaryXAxis:
                                                    const CategoryAxis(
                                                  title: AxisTitle(
                                                      text: 'Year',
                                                      textStyle: TextStyle(
                                                          fontSize: 12,
                                                          color: PINK)),
                                                  labelPlacement: LabelPlacement
                                                      .betweenTicks,
                                                  labelPosition:
                                                      ChartDataLabelPosition
                                                          .outside,
                                                  labelStyle: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                primaryYAxis: const NumericAxis(
                                                  labelStyle: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  title: AxisTitle(
                                                      text: 'Amount in Cr.',
                                                      textStyle: TextStyle(
                                                          fontSize: 10,
                                                          color: PINK)),
                                                ),
                                                enableSideBySideSeriesPlacement:
                                                    true,
                                                enableAxisAnimation: true,
                                                series: <CartesianSeries<
                                                    _GrowthData, dynamic>>[
                                                  ColumnSeries(
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                      isVisible: true,
                                                      textStyle: TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    color: Colors.pink[300],
                                                    dataSource:
                                                        patGrowthBarData,

                                                    xValueMapper:
                                                        (_GrowthData data, _) =>
                                                            data.year
                                                                .toString(),
                                                    yValueMapper:
                                                        (_GrowthData data, _) =>
                                                            data.fiu,
                                                    width:
                                                        0.8, // Width of the columns
                                                    spacing: 0.2,
                                                  )
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
              ),
            );
          },
        ),
        drawer: WeDrawer(),
      );
    } else {
      return CupertinoPageScaffold(child: Placeholder());
    }
  }
}
