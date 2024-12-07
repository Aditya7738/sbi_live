import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sbi/widget/drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constant.dart';
import '../services/service.dart';
import '../widget/appbar.dart';
import 'package:intl/intl.dart';

class TreasuryPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TreasuryPage({Key? key}) : super(key: key);

  @override
  _TreasuryPageState createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  RxString date = "".obs;
  RxString apidate = "".obs;
  RxBool isLoading = false.obs;
  late TabController tabController;
  RxList tableRFR = [].obs;
  RxList tableCredit = [].obs;
  RxList tablePRR = [].obs;
  RxList tableCOB = [].obs;
  RxList tableAssetsAndLiabilites = [].obs;
  RxString headerdate = "".obs;
  @override
  void initState() {
    setState(() {
      tabController = TabController(length: 4, vsync: this);
      getCompanyTreasury();
      getRFR();
      getCreditRating();
      getPRR();
      getCOB();
      getCOB();
      getassetsandliabilities();
    });

    super.initState();
  }

  List<_ChartData> debtData = [];
  _selectDate(BuildContext context) async {
    isLoading.value = true;
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
        DateTime hdate = DateFormat("yyyy-MM-dd").parse(apidate.value);
        headerdate.value = DateFormat("MM/dd/yyyy").format(hdate);
        debtData.clear();

        getCompanyTreasury();
        getassetsandliabilities();

        isLoading.value = false;
      });
      isLoading.value = false;
    }
  }

  getCompanyTreasury() async {
    isLoading.value = true;

    var data = await Service.getCompanytreasury(apidate.value);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        for (var i in data["data"]) {
          debtData.add(
            _ChartData(
                "TIER_II_BOND",
                double.parse(i["TIER_II_BOND"] == null
                    ? "0.0"
                    : i["TIER_II_BOND"].toString()),
                BLUE),
          );
          debtData.add(
            _ChartData(
                "Commercial_Paper",
                double.parse(i["Commercial_Paper"] == null
                    ? "0.0"
                    : i["Commercial_Paper"].toString()),
                Colors.deepOrange),
          );
          debtData.add(
            _ChartData(
                "Bank_Line_WCL",
                double.parse(i["Bank_Line_WCL"] == null
                    ? "0.0"
                    : i["Bank_Line_WCL"].toString()),
                RED),
          );
          debtData.add(
            _ChartData(
                "FOREX",
                double.parse(i["FOREX"] == null
                    ? "0.0"
                    : double.parse(i["FOREX"]).toStringAsFixed(2)),
                GREEN),
          );

          isLoading.value = false;
        }
      }
    });
    isLoading.value = false;
  }

  getRFR() async {
    var data = await Service.getRFR();
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tableRFR.value = data["data"];
        DateTime datea =
            DateFormat("yyyy-MM-dd").parse(data["data"][0]["FileDate"]);
        headerdate.value = DateFormat("MM/dd/yyyy").format(datea);
      }
    });
  }

  getCreditRating() async {
    isLoading.value = true;
    var data = await Service.getCreditRating();
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tableCredit.value = data["data"];
      }
    });
    isLoading.value = false;
  }

  getPRR() async {
    isLoading.value = true;
    var data = await Service.getCreditPRR();
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablePRR.value = data["data"];
      }
    });
    isLoading.value = false;
  }

  getCOB() async {
    isLoading.value = true;
    var data = await Service.getCreditCOB();
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tableCOB.value = data["data"];
      }
    });
    isLoading.value = false;
  }

  getassetsandliabilities() async {
    isLoading.value = true;
    var data = await Service.getassetsandliabilities(apidate.value);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tableAssetsAndLiabilites.value = data["data"];
      }
    });
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: Obx(
        () {
          return SafeArea(
              child: Column(
            children: [
              AppBarWidget(
                "Treasury Dashboard",
                true,
                true,
              ),
              TabBar(
                labelColor: PURPLE,
                indicatorColor: PINK,
                indicatorSize: TabBarIndicatorSize.label,
                controller: tabController,
                isScrollable: true,
                physics: const NeverScrollableScrollPhysics(),
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const <Widget>[
                  Tab(
                    text: 'Borrowing',
                  ),
                  Tab(
                    text: 'RFR and Credit Rating',
                  ),
                  Tab(
                    text: 'PRR and COB',
                  ),
                  Tab(
                    text: 'Assets And Liabilities',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
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
                          headerdate.value,
                          style: const TextStyle(
                            color: GREY_DARK,
                          ),
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
              const SizedBox(
                height: 10,
              ),
              (isLoading.value)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: loadingWidget()),
                    )
                  : Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          //Borrowing

                          // : (debtData.isEmpty == true)
                          //     ? Center(
                          //         child: titleText(
                          //           "Error:No data found!",
                          //           RED,
                          //         ),
                          //       )
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              // height: Get.height - 300,
                              child: SfCartesianChart(
                                primaryXAxis: const CategoryAxis(
                                  labelPlacement: LabelPlacement.betweenTicks,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  labelStyle: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                primaryYAxis: NumericAxis(
                                  // numberFormat: NumberFormat.decimalPattern(),
                                  // decimalPlaces: 3,
                                  labelStyle: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                enableAxisAnimation: true,
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  zoomMode: ZoomMode.xy,
                                  enablePanning: true,
                                ),
                                series: <CartesianSeries<_ChartData, String>>[
                                  ColumnSeries(
                                    color: RED,
                                    pointColorMapper: (_ChartData data, _) =>
                                        data.color,
                                    dataSource: debtData,

                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        textStyle: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    xValueMapper: (_ChartData data, _) =>
                                        data.treasury.toString(),
                                    yValueMapper: (_ChartData data, _) =>
                                        data.count,
                                    width: 0.8, // Width of the columns
                                    spacing: 0.2,
                                  )
                                ],
                              ),
                            ),
                          ),

                          ///RFR & Crdit rating
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: titleText(
                                      "Risk Free Rate (RFR)",
                                      PINK,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      // dataRowMinHeight: 20.0,
                                      columnSpacing: 10.0,
                                      // horizontalMargin: 10,
                                      dataRowColor:
                                          WidgetStateProperty.all(Colors.white),
                                      headingRowColor:
                                          WidgetStateProperty.all(PURPLE),

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
                                      // dataTextStyle: const TextStyle(wordSpacing: 1),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: SizedBox(
                                                width: 55,
                                                child: Text(
                                                  'SR NO',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: WHITE,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: SizedBox(
                                                width: 55,
                                                child: Text(
                                                  'CURRENCY',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: WHITE,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: SizedBox(
                                                width: 55,
                                                child: Text(
                                                  'RFR',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: WHITE,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: SizedBox(
                                                width: 55,
                                                child: Text(
                                                  'PERIOD',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: WHITE,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                                child: SizedBox(
                                              width: 55,
                                              child: Text(
                                                'RATE (%)',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        // Set the values to the columns
                                        for (var i in tableRFR)
                                          DataRow(
                                            cells: [
                                              DataCell(Center(
                                                child: normaltext(
                                                  (tableRFR.indexOf(i) + 1)
                                                      .toString(),
                                                  BLACK,
                                                  FontWeight.bold,
                                                ),
                                              )),
                                              DataCell(
                                                Center(
                                                  child: normaltext(
                                                    i["Currency"].toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  i["rfr"].toString(),
                                                  BLACK,
                                                  FontWeight.bold,
                                                  TextAlign.center,
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  (i["EffectiveDate"]
                                                      .toString()
                                                      .substring(0, 10)),
                                                  BLACK,
                                                  FontWeight.bold,
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  (i["Rate"].toString()),
                                                  BLACK,
                                                  FontWeight.bold,
                                                )),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: titleText(
                                      "Credit Rating",
                                      PINK,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      // dataRowMinHeight: 20.0,
                                      columnSpacing: 10.0,
                                      // horizontalMargin: 10,
                                      dataRowColor: MaterialStateProperty.all(
                                          Colors.white),
                                      headingRowColor:
                                          MaterialStateProperty.all(PURPLE),
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
                                      columns: const [
                                        DataColumn(
                                            label: Expanded(
                                          child: Center(
                                            child: SizedBox(
                                              width: 55,
                                              child: Text(
                                                'SR NO',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                        DataColumn(
                                            label: Expanded(
                                                child: Center(
                                          child: SizedBox(
                                            width: 55,
                                            child: Text(
                                              'RATIONALE DATED',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: WHITE,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ))),
                                        DataColumn(
                                          label: Expanded(
                                              child: Center(
                                            child: SizedBox(
                                              width: 55,
                                              child: Text(
                                                'COMPANY NAME',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          )),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                              child: Center(
                                            child: SizedBox(
                                              width: 55,
                                              child: Text(
                                                'LONG TERM RATING',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          )),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                                child: SizedBox(
                                              width: 55,
                                              child: Text(
                                                'SHORT TERM RATING',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        // Set the values to the columns
                                        for (var i in tableCredit)
                                          DataRow(
                                            cells: [
                                              DataCell(
                                                Center(
                                                  child: normaltext(
                                                    (tableCredit.indexOf(i) + 1)
                                                        .toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: normaltext(
                                                    i["cr_createddate"]
                                                        .toString()
                                                        .substring(0, 10),
                                                    BLACK,
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  i["cr_companyname"]
                                                      .toString(),
                                                  BLACK,
                                                  FontWeight.bold,
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  (i["cr_ltr"].toString()),
                                                  BLACK,
                                                  FontWeight.bold,
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  (i["cr_str"].toString()),
                                                  BLACK,
                                                  FontWeight.bold,
                                                )),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //PRR and cob
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: titleText(
                                    "Prime Reference Rate (PRR)",
                                    PINK,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: DataTable(
                                    // dataRowMinHeight: 20.0,
                                    columnSpacing: 70.0,
                                    // horizontalMargin: 10,
                                    dataRowColor:
                                        MaterialStateProperty.all(Colors.white),
                                    headingRowColor:
                                        MaterialStateProperty.all(PURPLE),
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
                                    // dataTextStyle: const TextStyle(wordSpacing: 1),
                                    columns: const [
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: SizedBox(
                                              width: 55,
                                              child: Text(
                                                'SR NO',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                            child: Center(
                                                child: SizedBox(
                                          width: 55,
                                          child: Text(
                                            'DATE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: WHITE,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ))),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                            child: Center(
                                                child: SizedBox(
                                          width: 55,
                                          child: Text(
                                            'RATE(%)',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: WHITE,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ))),
                                      ),
                                    ],
                                    rows: [
                                      // Set the values to the columns
                                      for (var i in tablePRR)
                                        DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: normaltext(
                                              (tablePRR.indexOf(i) + 1)
                                                  .toString(),
                                              BLACK,
                                              FontWeight.bold,
                                            ))),
                                            DataCell(
                                              Center(
                                                child: normaltext(
                                                  i["pr_date"]
                                                      .toString()
                                                      .substring(0, 10),
                                                  BLACK,
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                  child: normaltext(
                                                "${i["pr_rate"]}%",
                                                BLACK,
                                                FontWeight.bold,
                                              )),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: titleText(
                                    "Cost of Borrowing (COB)",
                                    PINK,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    child: DataTable(
                                      // dataRowMinHeight: 20.0,
                                      columnSpacing: 10.0,
                                      // horizontalMargin: 10,
                                      dataRowColor: MaterialStateProperty.all(
                                          Colors.white),
                                      headingRowColor:
                                          MaterialStateProperty.all(PURPLE),
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
                                      // dataTextStyle: const TextStyle(wordSpacing: 1),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: SizedBox(
                                                width: 55,
                                                child: Text(
                                                  'SR NO',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: WHITE,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                              child: Center(
                                                  child: SizedBox(
                                            width: 55,
                                            child: Text(
                                              'PERIOD',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: WHITE,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ))),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                                child: SizedBox(
                                              width: 55,
                                              child: Text(
                                                'FINANCIAL YEAR',
                                                textAlign: TextAlign.center,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            )),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                                child: SizedBox(
                                              width: 95,
                                              child: Text(
                                                'AVERAGE COB (INCLUDING NCDS) (%)',
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: WHITE,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            )),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                                child: SizedBox(
                                                    width: 95,
                                                    child: Text(
                                                      'MARGINAL COB (EXCLUDING NCDS) (%)',
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: WHITE,
                                                        fontSize: 10,
                                                      ),
                                                    ))),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        // Set the values to the columns
                                        for (var i in tableCOB)
                                          DataRow(
                                            cells: [
                                              DataCell(
                                                Center(
                                                  child: normaltext(
                                                    (tableCOB.indexOf(i) + 1)
                                                        .toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: normaltext(
                                                    i["cob_period"].toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  i["cob_finantialyear"]
                                                      .toString(),
                                                  BLACK,
                                                  FontWeight.bold,
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  ("${i["cob_includingncd"]}%"),
                                                  BLACK,
                                                  FontWeight.bold,
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: normaltext(
                                                  ("${i["cob_excludingncd"]}%"),
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
                          //assets and liabilities
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: DataTable(
                                  dataRowMinHeight: 20.0,
                                  columnSpacing: 0.0,
                                  horizontalMargin: 0,

                                  headingRowHeight: 0,
                                  // dataRowMinHeight: 20,
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
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
                                  columns: const [
                                    DataColumn(label: Text('')),
                                    DataColumn(label: Text('')),
                                    DataColumn(label: Text('')),
                                    DataColumn(label: Text('')),
                                    DataColumn(label: Text('')),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: [
                                    // Set the values to the columns
                                    for (var i in tableAssetsAndLiabilites)
                                      DataRow(
                                        cells: [
                                          DataCell(
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              color: (i["al_particulars"]) ==
                                                      "PARTICULARS"
                                                  ? PURPLE
                                                  : GREY,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: normaltext(
                                                  i["al_particulars"] == null
                                                      ? ""
                                                      : i["al_particulars"]
                                                          .toString(),
                                                  (i["al_particulars"]) ==
                                                          "PARTICULARS"
                                                      ? WHITE
                                                      : BLACK,
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.center,
                                              color: (i["al_particulars"]) ==
                                                      "PARTICULARS"
                                                  ? PURPLE
                                                  : GREY,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: normaltext(
                                                  (i["al_col1"] == null)
                                                      ? ""
                                                      : i["al_col1"]
                                                          .toString()
                                                          .toUpperCase()
                                                          .replaceFirst(
                                                              ",", ""),
                                                  (i["al_particulars"]) ==
                                                          "PARTICULARS"
                                                      ? WHITE
                                                      : BLACK,
                                                  FontWeight.bold,
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                                color: (i["al_particulars"]) ==
                                                        "PARTICULARS"
                                                    ? PURPLE
                                                    : GREY,
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: normaltext(
                                                    (i["al_col2"] == null)
                                                        ? ""
                                                        : i["al_col2"]
                                                            .toString()
                                                            .toUpperCase()
                                                            .replaceFirst(
                                                                ",", ""),
                                                    (i["al_particulars"]) ==
                                                            "PARTICULARS"
                                                        ? WHITE
                                                        : BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.center,
                                                  ),
                                                )),
                                          ),
                                          DataCell(
                                            Container(
                                                color: (i["al_particulars"]) ==
                                                        "PARTICULARS"
                                                    ? PURPLE
                                                    : GREY,
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: normaltext(
                                                    (i["al_col3"] == null)
                                                        ? ""
                                                        : i["al_col3"]
                                                            .toString()
                                                            .toUpperCase()
                                                            .replaceFirst(
                                                                ",", ""),
                                                    (i["al_particulars"]) ==
                                                            "PARTICULARS"
                                                        ? WHITE
                                                        : BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.center,
                                                  ),
                                                )),
                                          ),
                                          DataCell(
                                            Container(
                                                color:
                                                    //  (i["al_col1"]
                                                    //         .toString()
                                                    //         .contains("AS 0N"))
                                                    (i["al_particulars"]) ==
                                                            "PARTICULARS"
                                                        ? PURPLE
                                                        : GREY,
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: normaltext(
                                                    (i["al_col4"] == null)
                                                        ? ""
                                                        : i["al_col4"]
                                                            .toString()
                                                            .toUpperCase()
                                                            .replaceFirst(
                                                                ",", ""),
                                                    (i["al_particulars"]) ==
                                                            "PARTICULARS"
                                                        ? WHITE
                                                        : BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.center,
                                                  ),
                                                )),
                                          ),
                                          DataCell(
                                            Container(
                                                alignment: Alignment.center,
                                                color: (i["al_particulars"]) ==
                                                        "PARTICULARS"
                                                    ? PURPLE
                                                    : GREY,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: normaltext(
                                                    (i["al_col5"] == null)
                                                        ? ""
                                                        : i["al_col5"]
                                                            .toString()
                                                            .toUpperCase()
                                                            .replaceFirst(
                                                                ",", ""),
                                                    (i["al_particulars"]) ==
                                                            "PARTICULARS"
                                                        ? WHITE
                                                        : BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.center,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ));
        },
      ),
      drawer: WeDrawer(),
    );
  }
}

class _ChartData {
  _ChartData(
    this.treasury,
    this.count,
    this.color,
  );
  final double count;
  final String treasury;
  final Color? color;
}
