import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sbi/widget/drawer.dart';
import '../constant.dart';
import '../services/service.dart';
import '../widget/appbar.dart';
import 'package:intl/intl.dart';

class ClientServicePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ClientServicePage({Key? key}) : super(key: key);

  @override
  _ClientServicePageState createState() => _ClientServicePageState();
}

class _ClientServicePageState extends State<ClientServicePage>
    with SingleTickerProviderStateMixin {
  RxBool isLoading = false.obs;
  RxBool iserror = false.obs;
  RxString date = "".obs;
  RxString table1date = "".obs;
  RxString table2date = "".obs;
  RxString lastmonth = "".obs;
  RxString headerdate = "".obs;
  RxString errormsg = "".obs;
  RxString apidate = "".obs;
  RxString year = "".obs;
  DateTime selectedDate = DateTime.now();
  RxDouble totalamount = 0.0.obs;
  late TabController tabController;
  RxList tablefiuturnover = [].obs;
  RxList tablefiuoutstanding = [].obs;
  RxList tablefiubranchwise = [].obs;
  @override
  void initState() {
    setState(() {
      year.value = DateFormat("yy").format(DateTime.now());
      tabController = TabController(length: 3, vsync: this);
      getFIUTurnoverClientService();
      getFIUOutstandingClientService();
      getFIUBranchWiseClientService();
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

        getFIUTurnoverClientService();
        getFIUOutstandingClientService();
        getFIUBranchWiseClientService();
        isLoading.value = false;
      });
    }
  }

  getFIUTurnoverClientService() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getFIUTurnoverClientService(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablefiuturnover.value = data["data"];
        print(tablefiuturnover);
      }
    });
    isLoading.value = false;
  }

  double ocol1 = 0.0;
  double ocol2 = 0.0;
  double ocol3 = 0.0;
  double ocol4 = 0.0;
  double ocollastmarch = 0.0;
  getFIUOutstandingClientService() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getFIUOutstandingClientService(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablefiuoutstanding.value = data["data"];
        for (var j in data["data"]) {
          // table1date.value = j["filedate"].toString();
          DateTime date = DateFormat("yyyy-MM-dd").parse(j["filedate"]);
          table1date.value = DateFormat("dd-MMM-yy").format(date);
          print(table1date.value);
          // date.value = DateFormat("MM/dd/yyyy").format(j["filedate"]);
          DateTime date2 = DateFormat("yyyy-MM-dd").parse(j["FileDate2"]);
          table2date.value = DateFormat("dd-MMM-yy").format(date2);
          print(table2date.value);
          // DateTime pastMonth = date2.subtract(Duration(days: 30));
          var s = DateTime(date2.day, date2.month, 1).add(Duration(days: -1));
          lastmonth.value = DateFormat("dd-MMM").format(s);
          print(lastmonth.value);
          // table2date.value = j["FileDate2"];
          DateTime dateh = DateFormat("yyyy-MM-dd").parse(j["filedate"]);
          headerdate.value = DateFormat("MM/dd/yyyy").format(dateh);
          print(headerdate.value);
          ocol1 += j["col_1"].round();
          ocol2 += j["col_2"].round();
          ocol3 += j["col_3"].round();
          ocol4 += (j["col_4"].round());
          ocollastmarch += (j["LastYearMarch"].round());
        }

        print(tablefiuoutstanding);
      }
    });
    isLoading.value = false;
  }

  double col5 = 0.0;
  double col4 = 0.0;
  double col3 = 0.0;
  double col6 = 0.0;
  getFIUBranchWiseClientService() async {
    isLoading.value = true;
    iserror.value = false;
    var data = await Service.getFIUBranchwiseClientService(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablefiubranchwise.value = data["data"];

        for (var t in tablefiubranchwise) {
          col5 += t["col_5"].round();
          col4 += t["col_1"].round();
          col3 += t["col_2"].round();
          col6 += t["col_4"].round();
          print(col5);
        }
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBarWidget(
                  "Client Service",
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
                    fontSize: 11  ,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const <Widget>[
                    Tab(
                      text: 'Snapshot of FIU and Turnover',
                    ),
                    Tab(
                      text: 'Branchwise FIU (DF,EF and RF)',
                    ),
                    Tab(
                      text: 'LC - Region wise FIU Outstanding',
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
                (isLoading.value)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: loadingWidget()),
                      )
                    : Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            //turnover table
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              // child: Padding(
                              //   padding: const EdgeInsets.only(right: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: DataTable(
                                  dataRowMinHeight: 20.0,
                                  columnSpacing: 0,
                                  horizontalMargin: 10,
                                  // horizontalMargin: 0,
                                  // columnSpacing: 0.0,
                                  // headingRowHeight: 0,
                                  // dataRowMinHeight: 20.0,
                                  // columnSpacing: 100.0,
                                  // horizontalMargin: 10,
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => PINK),
                                  border: const TableBorder(
                                    verticalInside: BorderSide(
                                        color: GREY_DARK, width: 0.5),
                                    right: BorderSide(
                                        color: GREY_DARK, width: 0.5),
                                    left: BorderSide(
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
                                        width: 90,
                                        child: Text('Particulars'.toUpperCase(),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: WHITE,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            )),
                                        // child: normaltext(
                                        //     'Particulars'.toUpperCase(),
                                        //     WHITE,
                                        //     FontWeight.bold,
                                        //     TextAlign.center),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: normaltext(
                                            'Mar-23'.toUpperCase(),
                                            WHITE,
                                            FontWeight.bold,
                                            TextAlign.center),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: normaltext(
                                            'Mar-24'.toUpperCase(),
                                            WHITE,
                                            FontWeight.bold,
                                            TextAlign.center),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: normaltext(
                                            "${lastmonth.value}-${year.value}"
                                                .toUpperCase(),
                                            WHITE,
                                            FontWeight.bold,
                                            TextAlign.center),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: normaltext(
                                            table2date.value.toUpperCase(),
                                            WHITE,
                                            FontWeight.bold,
                                            TextAlign.center),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: normaltext(
                                            table1date.value.toUpperCase(),
                                            WHITE,
                                            FontWeight.bold,
                                            TextAlign.center),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    // Set the values to the columns
                                    for (var i in tablefiuturnover)
                                      DataRow(
                                        cells: [
                                          // DataCell(normaltext(
                                          //     (i["Particulars"]), BLACK)),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  i["Particulars"]
                                                      .toUpperCase(),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: BLACK,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                              // child: normaltext(
                                              //   i["Particulars"].toString(),
                                              //   BLACK,
                                              //   FontWeight.bold,
                                              //   TextAlign.left,
                                              // ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(i["col_5"].toString(),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: BLACK,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  (i["col_1"].round())
                                                      .toString(),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: BLACK,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                              //  normaltext(
                                              //   (i["col_1"].round())
                                              //       .toString(),
                                              //   BLACK,
                                              //    FontWeight.bold,
                                              //   TextAlign.right,
                                              // )
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  (i["col_2"].round())
                                                      .toString(),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: BLACK,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                              //  normaltext(
                                              //   (i["col_2"].round())
                                              //       .toString(),
                                              //   BLACK,
                                              //    FontWeight.bold,
                                              //   TextAlign.right,
                                              // )
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  (i["col_3"].round())
                                                      .toString(),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: BLACK,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                              // normaltext(
                                              //   (i["col_3"].round())
                                              //       .toString(),
                                              //   BLACK,
                                              //    FontWeight.bold,
                                              //   TextAlign.right,
                                              // )
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  (i["col_4"].round())
                                                      .toString(),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: BLACK,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                              // normaltext(
                                              //   (i["col_4"].round())
                                              //       .toString(),
                                              //   BLACK,
                                              //    FontWeight.bold,
                                              //   TextAlign.right,
                                              // )
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            // ),
                            //BranchWise table
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: DataTable(
                                    dataRowMinHeight: 20.0,
                                    columnSpacing: 4.0,
                                    horizontalMargin: 10,
                                    // dataRowMinHeight: 20.0,
                                    // columnSpacing: 5.0,
                                    // horizontalMargin: 10,
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
                                      left: BorderSide(
                                          color: GREY_DARK, width: 0.5),
                                      right: BorderSide(
                                          color: GREY_DARK, width: 0.5),
                                    ),
                                    showBottomBorder: true,
                                    dataTextStyle:
                                        const TextStyle(wordSpacing: 1),
                                    columns: [
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: normaltext(
                                            'branch'.toString().toUpperCase(),
                                            WHITE,
                                            FontWeight.bold,
                                            TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              'Mar-23'.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              'Mar-24'.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              table1date.value.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              'YOD %'.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              'SEP 24'.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      // Set the values to the columns
                                      for (var i in tablefiubranchwise)
                                        DataRow(
                                          cells: [
                                            DataCell(normaltext(
                                              (i["Particulars"]),
                                              BLACK,
                                              FontWeight.bold,
                                            )),
                                            DataCell(
                                              Container(
                                                alignment: Alignment.center,
                                                child: normaltext(
                                                  (i["col_5"].round())
                                                      .toString(),
                                                  BLACK,
                                                  FontWeight.bold,
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    (i["col_1"].round())
                                                        .toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.right,
                                                  )),
                                            ),
                                            DataCell(
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    ((i["col_2"].round())
                                                        .toString()),
                                                    BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.right,
                                                  )),
                                            ),
                                            DataCell(
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: i["Particulars"] ==
                                                            "Grand Total"
                                                        ? Colors.transparent
                                                        : (i["col_3"] <= 0.00)
                                                            ? RED
                                                            : (i["col_3"] >=
                                                                    35.00)
                                                                ? GREEN
                                                                : Colors.yellow,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    i["Particulars"] ==
                                                            "Grand Total"
                                                        ? ""
                                                        : ((i["col_3"].round())
                                                                .toString() +
                                                            "%"),
                                                    BLACK,
                                                    i["Particulars"] ==
                                                            "Grand Total"
                                                        ? FontWeight.w900
                                                        : FontWeight.bold,
                                                    TextAlign.right,
                                                  )),
                                            ),
                                            DataCell(
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    ((i["col_4"].round())
                                                        .toString()),
                                                    BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.right,
                                                  )),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //outstanding
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: DataTable(
                                    dataRowMinHeight: 20.0,
                                    columnSpacing: 4.0,
                                    horizontalMargin: 10,
                                    // dataRowMinHeight: 20.0,
                                    // columnSpacing: 5.0,
                                    // horizontalMargin: 10,
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
                                      left: BorderSide(
                                          color: GREY_DARK, width: 0.5),
                                      right: BorderSide(
                                          color: GREY_DARK, width: 0.5),
                                    ),
                                    showBottomBorder: true,
                                    dataTextStyle:
                                        const TextStyle(wordSpacing: 1),
                                    columns: [
                                      DataColumn(
                                        label:
                                            // SizedBox(
                                            //   width: 60,
                                            //   child: normaltext(
                                            //       'branch'.toUpperCase(),
                                            //       WHITE,
                                            //       FontWeight.,
                                            //       TextAlign.center),
                                            // ),
                                            Container(
                                          alignment: Alignment.center,
                                          child: normaltext(
                                            'branch'.toString().toUpperCase(),
                                            WHITE,
                                            FontWeight.bold,
                                            TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              'Mar-23'.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              'Mar-24'.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              "${lastmonth.value}-${year.value}"
                                                  .toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              table2date.value.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 80,
                                          child: normaltext(
                                              table1date.value.toUpperCase(),
                                              WHITE,
                                              FontWeight.bold,
                                              TextAlign.center),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      // Set the values to the columns
                                      for (var i in tablefiuoutstanding)
                                        DataRow(
                                          cells: [
                                            DataCell(normaltext(
                                              (i["Particulars"]),
                                              BLACK,
                                              FontWeight.bold,
                                            )),
                                            DataCell(
                                              Container(
                                                alignment: Alignment.center,
                                                child: normaltext(
                                                  (i["LastYearMarch"].round())
                                                      .toString(),
                                                  BLACK,
                                                  FontWeight.bold,
                                                  TextAlign.right,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    (i["col_1"].round())
                                                        .toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.right,
                                                  )),
                                            ),
                                            DataCell(
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    (i["col_2"].round())
                                                        .toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.right,
                                                  )),
                                            ),
                                            DataCell(
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    (i["col_3"].round())
                                                        .toString(),
                                                    BLACK,
                                                    FontWeight.bold,
                                                    TextAlign.right,
                                                  )),
                                            ),
                                            DataCell(
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: normaltext(
                                                    (i["col_4"].round())
                                                        .toString(),
                                                    BLACK,
                                                    i["Particulars"] ==
                                                            "Grand Total"
                                                        ? FontWeight.w900
                                                        : FontWeight.bold,
                                                    TextAlign.right,
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
            ),
          );
        },
      ),
      drawer: WeDrawer(),
    );
  }
}
