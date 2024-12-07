import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sbi/widget/drawer.dart';
import '../constant.dart';
import '../services/service.dart';
import '../widget/appbar.dart';
import 'package:intl/intl.dart';

class FinancialPerformancePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  FinancialPerformancePage({Key? key}) : super(key: key);

  @override
  _FinancialPerformancePageState createState() =>
      _FinancialPerformancePageState();
}

class _FinancialPerformancePageState extends State<FinancialPerformancePage>
    with SingleTickerProviderStateMixin {
  // RxBool isLoadingHighlight = false.obs;
  RxBool isLoading = false.obs;
  RxBool iserror = false.obs;
  RxString date = "".obs;
  RxString table1date = "".obs;
  RxString table2date = "".obs;
  RxString headerdate = "".obs;
  RxString errormsg = "".obs;
  RxString apidate = "".obs;
  RxString year = "".obs;
  DateTime selectedDate = DateTime.now();
  RxDouble totalamount = 0.0.obs;
  late TabController tabController;
  RxList tablehighlights = [].obs;
  RxList tablefinancialhighlights = [].obs;
  RxList tablefinancialyield = [].obs;
  RxList tablefinancialefficiency = [].obs;
  RxList tablefinancialactualanadbudget = [].obs;
  @override
  void initState() {
    setState(() {
      year.value = DateFormat("yy").format(DateTime.now());
      tabController = TabController(length: 5, vsync: this);
      getHighlights();
      getFinancialHighlights();
      getFinancialActualandBudget();
      getFinancialYield();
      getFinancialEfficiency();
      // getFIUBranchWiseClientService();
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
        DateTime hdate = DateFormat("yyyy-MM-dd").parse(apidate.value);
        headerdate.value = DateFormat("MM/dd/yyyy").format(hdate);
        tablehighlights.clear();
        tablefinancialhighlights.clear();
        tablefinancialactualanadbudget.clear();
        tablefinancialyield.clear();
        tablefinancialefficiency.clear();
        isLoading.value = false;
        getHighlights();
        getFinancialHighlights();
        getFinancialActualandBudget();
        getFinancialYield();
        getFinancialEfficiency();
      });
    }
  }

  getHighlights() async {
    setState(() async {
      iserror.value = false;
      isLoading.value = true;
      var data = await Service.getHighlights(apidate.value);
      print(data);

      if (data["outcome"]["outcomeId"] == 1) {
        tablehighlights.value = data["data"];
        print(tablehighlights);
        // headerdate.value = data["data"][0]["h_date"];
        // print(headerdate);
        DateTime date =
            DateFormat("yyyy-MM-dd").parse(data["data"][0]["h_date"]);
        headerdate.value = DateFormat("MM/dd/yyyy").format(date);

        print(headerdate.value);
      }
      isLoading.value = false;
    });
    // isLoadingHighlight.value = false;
  }

  getFinancialHighlights() async {
    iserror.value = false;
    isLoading.value = true;
    var data = await Service.getFinancialHighlights(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablefinancialhighlights.value = data["data"];
        print(tablefinancialhighlights);
      }
    });
    isLoading.value = false;
  }

  getFinancialActualandBudget() async {
    iserror.value = false;
    isLoading.value = true;
    var data = await Service.getFinancialBudgetAndActual(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablefinancialactualanadbudget.value = data["data"];
        print(tablefinancialactualanadbudget);
      }
    });
    isLoading.value = false;
  }

  getFinancialYield() async {
    iserror.value = false;
    isLoading.value = true;
    var data = await Service.getFinancialYield(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablefinancialyield.value = data["data"];
        print(tablefinancialyield);
      }
    });
    isLoading.value = false;
  }

  getFinancialEfficiency() async {
    iserror.value = false;
    isLoading.value = true;
    var data = await Service.getFinancialEfficiency(apidate.value);
    print(data);
    setState(() {
      if (data["outcome"]["outcomeId"] == 1) {
        tablefinancialefficiency.value = data["data"];
        print(tablefinancialefficiency);
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
                  "Financial Performance",
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
                      text: 'Highlights',
                    ),
                    Tab(
                      text: 'Financial Highlights',
                    ),
                    Tab(
                      text: 'Budget vs Actual',
                    ),
                    Tab(
                      text: 'Yield',
                    ),
                    Tab(
                      text: 'Efficiency Ratio',
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
                // (tablehighlights.isEmpty == true ||
                //         tablefinancialyield.isEmpty == true ||
                //         tablefinancialefficiency.isEmpty == true ||
                //         tablefinancialactualanadbudget.isEmpty == true ||
                //         tablefinancialhighlights.isEmpty == true)
                //     ? normaltext("There is no data", RED)
                //     :
                Expanded(
                  child: Column(
                    children: [
                      (isLoading.value)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: loadingWidget()),
                            )
                          : Expanded(
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  //highlight table
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: DataTable(
                                          horizontalMargin: 0,
                                          columnSpacing: 0.0,
                                          headingRowHeight: 0,
                                          border: const TableBorder(
                                            verticalInside: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            horizontalInside: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            top: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            left: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            right: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            bottom: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                          ),
                                          showBottomBorder: true,
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
                                            for (var i in tablehighlights)
                                              DataRow(
                                                cells: [
                                                  DataCell(Container(
                                                    // width: 60,
                                                    color: i["h_particulars"] ==
                                                            "Particulars"
                                                        ? PURPLE
                                                        : GREY,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          i["h_particulars"]
                                                              .toUpperCase(),
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          )),
                                                      // child: normaltext(
                                                      //     (i["h_particulars"]),
                                                      //     i["h_particulars"] ==
                                                      //             "Particulars"
                                                      //         ? WHITE
                                                      //         : BLACK,
                                                      //     i["h_particulars"] ==
                                                      //             "Particulars"
                                                      //         ? FontWeight.bold
                                                      //         : FontWeight
                                                      //             .normal),
                                                    ),
                                                  )),
                                                  DataCell(
                                                    Container(
                                                      // width: 60,
                                                      color:
                                                          i["h_particulars"] ==
                                                                  "Particulars"
                                                              ? PURPLE
                                                              : GREY,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: normaltext(
                                                          i["col1"]
                                                              .toString()
                                                              .toUpperCase()
                                                              .replaceFirst(
                                                                  "       ",
                                                                  ""),
                                                          i["h_particulars"] ==
                                                                  "Particulars"
                                                              ? WHITE
                                                              : BLACK,
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        // width: 60,
                                                        color:
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: normaltext(
                                                            (i["col2"])
                                                                .toString()
                                                                .toUpperCase()
                                                                .replaceFirst(
                                                                    "       ",
                                                                    ""),
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
                                                          ),
                                                        )),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        // width: 60,
                                                        color:
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: normaltext(
                                                            (i["col3"])
                                                                .toString()
                                                                .toUpperCase()
                                                                .replaceFirst(
                                                                    "       ",
                                                                    ""),
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
                                                          ),
                                                        )),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        // width: 60,
                                                        color:
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: normaltext(
                                                            (i["col4"])
                                                                .toString()
                                                                .toUpperCase(),
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
                                                          ),
                                                        )),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        // width: 60,
                                                        color:
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: normaltext(
                                                            (i["col5"])
                                                                .toString()
                                                                .toUpperCase(),
                                                            i["h_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
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
                                  //financial highlight table
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: DataTable(
                                          horizontalMargin: 0,
                                          columnSpacing: 0.0,
                                          headingRowHeight: 0,
                                          border: const TableBorder(
                                            verticalInside: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            horizontalInside: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            top: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            left: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            right: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                            bottom: BorderSide(
                                                color: GREY_DARK, width: 0.5),
                                          ),
                                          showBottomBorder: true,
                                          columns: const [
                                            DataColumn(label: Text('')),
                                            DataColumn(label: Text('')),
                                            DataColumn(label: Text('')),
                                            DataColumn(label: Text('')),
                                            DataColumn(label: Text('')),
                                          ],
                                          rows: [
                                            // Set the values to the columns
                                            for (var i
                                                in tablefinancialhighlights)
                                              DataRow(
                                                cells: [
                                                  DataCell(
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: 200,
                                                      color:
                                                          i["f_particulars"] ==
                                                                  "Particulars"
                                                              ? PURPLE
                                                              : GREY,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                            (i["f_particulars"]
                                                                .toString()
                                                                .toUpperCase()
                                                                .toUpperCase()),
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color: i["f_particulars"] ==
                                                                      "Particulars"
                                                                  ? WHITE
                                                                  : BLACK,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            )),
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   // width: 60,
                                                    //   color:
                                                    //       i["f_particulars"] ==
                                                    //               "Particulars"
                                                    //           ? PURPLE
                                                    //           : GREY,
                                                    //   alignment:
                                                    //       Alignment.centerLeft,
                                                    //   child: Padding(
                                                    //     padding:
                                                    //         const EdgeInsets
                                                    //             .only(
                                                    //             left: 8.0),
                                                    //     child: normaltext(
                                                    //         (i["f_particulars"]
                                                    //             .toString()
                                                    //             .toUpperCase()),
                                                    //         i["f_particulars"] ==
                                                    //                 "Particulars"
                                                    //             ? WHITE
                                                    //             : BLACK,
                                                    //         i["f_particulars"] ==
                                                    //                 "Particulars"
                                                    //             ? FontWeight
                                                    //                 .bold
                                                    //             : FontWeight
                                                    //                 .normal),
                                                    //   ),
                                                    // ),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                      color:
                                                          i["f_particulars"] ==
                                                                  "Particulars"
                                                              ? PURPLE
                                                              : GREY,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: normaltext(
                                                          i["col1"]
                                                              .toString()
                                                              .toUpperCase()
                                                              .replaceFirst(
                                                                  "       ",
                                                                  ""),
                                                          i["f_particulars"] ==
                                                                  "Particulars"
                                                              ? WHITE
                                                              : BLACK,
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        color:
                                                            i["f_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: normaltext(
                                                            (i["col2"])
                                                                .toString()
                                                                .toUpperCase()
                                                                .replaceFirst(
                                                                    "       ",
                                                                    ""),
                                                            i["f_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
                                                          ),
                                                        )),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        color:
                                                            i["f_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0,
                                                                  right: 0),
                                                          child: normaltext(
                                                            (i["col3"])
                                                                .toString()
                                                                .toUpperCase(),
                                                            i["f_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
                                                          ),
                                                        )),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        color:
                                                            i["f_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: normaltext(
                                                            (i["col4"])
                                                                .toString()
                                                                .toUpperCase(),
                                                            i["f_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
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
                                  //budget and actual
                                  SingleChildScrollView(
                                    // scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: DataTable(
                                        horizontalMargin: 0,
                                        columnSpacing: 0.0,
                                        headingRowHeight: 0,
                                        border: const TableBorder(
                                          verticalInside: BorderSide(
                                              color: GREY_DARK, width: 0.5),
                                          horizontalInside: BorderSide(
                                              color: GREY_DARK, width: 0.5),
                                          top: BorderSide(
                                              color: GREY_DARK, width: 0.5),
                                          left: BorderSide(
                                              color: GREY_DARK, width: 0.5),
                                          right: BorderSide(
                                              color: GREY_DARK, width: 0.5),
                                          bottom: BorderSide(
                                              color: GREY_DARK, width: 0.5),
                                        ),
                                        showBottomBorder: true,
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
                                          for (var i
                                              in tablefinancialactualanadbudget)
                                            DataRow(
                                              cells: [
                                                DataCell(
                                                  Container(
                                                    color: i["m_particulars"] ==
                                                            "Particulars"
                                                        ? PURPLE
                                                        : GREY,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: normaltext(
                                                          (i["m_particulars"]
                                                              .toString()
                                                              .toUpperCase()),
                                                          i["m_particulars"] ==
                                                                  "Particulars"
                                                              ? WHITE
                                                              : BLACK,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    color: i["m_particulars"] ==
                                                            "Particulars"
                                                        ? PURPLE
                                                        : GREY,
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: normaltext(
                                                        i["col1"]
                                                            .toString()
                                                            .toUpperCase()
                                                            .replaceFirst(
                                                                "       ", ""),
                                                        i["m_particulars"] ==
                                                                "Particulars"
                                                            ? WHITE
                                                            : BLACK,
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                      color:
                                                          i["m_particulars"] ==
                                                                  "Particulars"
                                                              ? PURPLE
                                                              : GREY,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: normaltext(
                                                          (i["col2"])
                                                              .toString()
                                                              .toUpperCase(),
                                                          i["m_particulars"] ==
                                                                  "Particulars"
                                                              ? WHITE
                                                              : BLACK,
                                                          FontWeight.bold,
                                                        ),
                                                      )),
                                                ),
                                                DataCell(
                                                  Container(
                                                    color: i["m_particulars"] ==
                                                            "Particulars"
                                                        ? PURPLE
                                                        : GREY,
                                                    alignment: Alignment.center,
                                                    // child: Padding(
                                                    //   padding:
                                                    //       const EdgeInsets.only(
                                                    //           left: 8.0,
                                                    //           right: 8.0),
                                                    //   child: normaltext(
                                                    //     (i["m_achievement"])
                                                    //         .toString(),
                                                    //     i["m_particulars"] ==
                                                    //             "Particulars"
                                                    //         ? WHITE
                                                    //         : BLACK,
                                                    //     i["m_particulars"] ==
                                                    //             "Particulars"
                                                    //         ? FontWeight.bold
                                                    //         : FontWeight.normal,
                                                    //   ),
                                                    // ),
                                                    // width: 100,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                        5.0,
                                                      ),
                                                      child: Text(
                                                          (i["col3"])
                                                              .toString()
                                                              .toUpperCase(),
                                                          maxLines: 5,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: i["m_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                                ((i["col4"]).toString() == "")
                                                    ? DataCell(SizedBox())
                                                    : DataCell(
                                                        Container(
                                                            color: i["m_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0),
                                                              child: normaltext(
                                                                (i["col4"])
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                i["m_particulars"] ==
                                                                        "Particulars"
                                                                    ? WHITE
                                                                    : BLACK,
                                                                FontWeight.bold,
                                                              ),
                                                            )),
                                                      ),
                                                ((i["col5"]).toString() == "")
                                                    ? DataCell(SizedBox())
                                                    : DataCell(
                                                        Container(
                                                            color: i["m_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0),
                                                              child: normaltext(
                                                                (i["col5"])
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                i["m_particulars"] ==
                                                                        "Particulars"
                                                                    ? WHITE
                                                                    : BLACK,
                                                                FontWeight.bold,
                                                              ),
                                                            )),
                                                      ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //yield table
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: DataTable(
                                        horizontalMargin: 0,
                                        columnSpacing: 0.0,
                                        headingRowHeight: 0,
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
                                        columns: const [
                                          DataColumn(
                                              label: Text(
                                            '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ],
                                        rows: [
                                          // Set the values to the columns
                                          for (var i in tablefinancialyield)
                                            DataRow(
                                              cells: [
                                                DataCell(Container(
                                                  color: i["y_particulars"] ==
                                                          "Yield on Standard Assets"
                                                      ? PURPLE
                                                      : GREY,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: normaltext(
                                                        (i["y_particulars"]
                                                            .toString()
                                                            .toUpperCase()),
                                                        i["y_particulars"] ==
                                                                "Yield on Standard Assets"
                                                            ? WHITE
                                                            : BLACK,
                                                        FontWeight.bold),
                                                  ),
                                                )),
                                                DataCell(
                                                  Container(
                                                    color: i["y_particulars"] ==
                                                            "Yield on Standard Assets"
                                                        ? PURPLE
                                                        : GREY,
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: normaltext(
                                                        i["col1"]
                                                            .toString()
                                                            .toUpperCase()
                                                            .replaceFirst(
                                                                "       ", ""),
                                                        i["y_particulars"] ==
                                                                "Yield on Standard Assets"
                                                            ? WHITE
                                                            : BLACK,
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                      color: i["y_particulars"] ==
                                                              "Yield on Standard Assets"
                                                          ? PURPLE
                                                          : GREY,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: normaltext(
                                                          (i["col2"])
                                                              .toString()
                                                              .toUpperCase()
                                                              .replaceFirst(
                                                                  "       ",
                                                                  ""),
                                                          i["y_particulars"] ==
                                                                  "Yield on Standard Assets"
                                                              ? WHITE
                                                              : BLACK,
                                                          FontWeight.bold,
                                                        ),
                                                      )),
                                                ),
                                                DataCell(
                                                  Container(
                                                      color: i["y_particulars"] ==
                                                              "Yield on Standard Assets"
                                                          ? PURPLE
                                                          : GREY,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: normaltext(
                                                          (i["col3"])
                                                              .toString()
                                                              .toUpperCase()
                                                              .replaceFirst(
                                                                  "       ",
                                                                  ""),
                                                          i["y_particulars"] ==
                                                                  "Yield on Standard Assets"
                                                              ? WHITE
                                                              : BLACK,
                                                          // i["y_particulars"] ==
                                                          //         "Yield on Standard Assets"
                                                          //     ? FontWeight
                                                          //         .normal
                                                          //     :
                                                          FontWeight.bold,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //Efficiency Ratio table
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: DataTable(
                                          horizontalMargin: 0,
                                          columnSpacing: 0.0,
                                          headingRowHeight: 0,
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
                                          columns: const [
                                            DataColumn(label: Text('')),
                                            DataColumn(label: Text('')),
                                            DataColumn(label: Text('')),
                                            DataColumn(label: Text('')),
                                          ],
                                          rows: [
                                            // Set the values to the columns
                                            for (var i
                                                in tablefinancialefficiency)
                                              DataRow(
                                                cells: [
                                                  DataCell(Container(
                                                    color: i["e_particulars"] ==
                                                            "Particulars"
                                                        ? PURPLE
                                                        : GREY,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: normaltext(
                                                          (i["e_particulars"]
                                                              .toString()
                                                              .toUpperCase()),
                                                          i["e_particulars"] ==
                                                                  "Particulars"
                                                              ? WHITE
                                                              : BLACK,
                                                          FontWeight.bold),
                                                    ),
                                                  )),
                                                  DataCell(
                                                    Container(
                                                      color:
                                                          i["e_particulars"] ==
                                                                  "Particulars"
                                                              ? PURPLE
                                                              : GREY,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: normaltext(
                                                          i["col1"]
                                                              .toString()
                                                              .toUpperCase()
                                                              .replaceFirst(
                                                                  "       ",
                                                                  ""),
                                                          i["e_particulars"] ==
                                                                  "Particulars"
                                                              ? WHITE
                                                              : BLACK,
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        color:
                                                            i["e_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: normaltext(
                                                            (i["col2"])
                                                                .toString()
                                                                .toUpperCase(),
                                                            i["e_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
                                                          ),
                                                        )),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                        color:
                                                            i["e_particulars"] ==
                                                                    "Particulars"
                                                                ? PURPLE
                                                                : GREY,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: normaltext(
                                                            (i["col3"])
                                                                .toString()
                                                                .toUpperCase()
                                                                .replaceFirst(
                                                                    "       ",
                                                                    ""),
                                                            i["e_particulars"] ==
                                                                    "Particulars"
                                                                ? WHITE
                                                                : BLACK,
                                                            FontWeight.bold,
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
                  ),
                )
              ],
            ),
          );
        },
      ),
      drawer: WeDrawer(),
    );
  }
}
