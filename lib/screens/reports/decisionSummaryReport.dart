import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/reports/GetDecisionSummaryReportModel.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class DecisionSummaryReport extends StatefulWidget {
  String routeName = '/DecisionSummaryReport';

  DecisionSummaryReport({super.key});

  @override
  State<DecisionSummaryReport> createState() => _DecisionSummaryReportState();
}

class _DecisionSummaryReportState extends State<DecisionSummaryReport> {
  bool _isFormVisible = false;
  String? selectedToDate;
  String? selectedFromDate;
  String? selectedDecisionFromDate;
  String? selectedDecisionToDate;
  Data? selectedLevel;
  int? levelValue;

  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  int totalPages = 1;

  bool isLoadingMore = false;
  List<DataDecisionSummary> decisionCaseList = [];
  final List<Data> levelOptions = [
    Data(text: 'Admindeptt Wise', value: 'Admindeptt Wise'),
    Data(text: 'District Wise', value: 'District Wise'),
  ];
  List<String> columnTitles = ['Sr No', 'Name of Administrative Department', 'Decided', 'In Favor', 'Against', 'Percentage in Favor'];
  List<List<String>> rowData = [];


  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load first page initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDecisionSummaryListDetails(page: currentPage);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        currentPage < totalPages) {
      currentPage += 1;
      getDecisionSummaryListDetails(page: currentPage, isPagination: true);
    }
  }

  void loadMore() async {
    if (isLoadingMore || currentPage >= totalPages) return;

    setState(() => isLoadingMore = true);

    int nextPage = currentPage + 1;

    await getDecisionSummaryListDetails(page: nextPage, isPagination: true);

    setState(() {
      currentPage = nextPage; // ✅ Update currentPage only after success
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Decision Summary Report',
        onBackPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isFormVisible = !_isFormVisible;
                      });
                    },
                    child: Text(_isFormVisible ? 'Hide Filter' : 'Show Filter'),
                  ),
                ],
              ),
              if (_isFormVisible)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Constants().buildDatePickerTile(
                          label: 'Reg. Date From',
                          selectedDate: selectedFromDate,
                          onTap: () {
                            Constants().presentDatePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedFromDate = date);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildDatePickerTile(
                          label: 'Reg. Date To',
                          selectedDate: selectedToDate,
                          onTap: () {
                            Constants().presentDatePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedToDate = date);
                              },
                            );
                          },
                        ), const SizedBox(height: 15),
                        Constants().buildDatePickerTile(
                          label: 'Decision Date From',
                          selectedDate: selectedDecisionFromDate,
                          onTap: () {
                            Constants().presentDatePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedDecisionFromDate = date);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildDatePickerTile(
                          label: 'Decision Date To',
                          selectedDate: selectedDecisionToDate,
                          onTap: () {
                            Constants().presentDatePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedDecisionToDate = date);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Level',
                          options: levelOptions,
                          selectedValue: selectedLevel,
                          onChanged: (newValue) {
                            setState(() {
                              selectedLevel = newValue;
                            });
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Level',
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedDecisionFromDate = null;
                                  selectedDecisionToDate = null;
                                  selectedFromDate = null;
                                  selectedToDate = null;
                                  selectedLevel = null;
                                  rowData.clear();
                                });

                                currentPage = 1;
                                getDecisionSummaryListDetails(page: 1, isPagination: false);
                                },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {

                                currentPage = 1;
                                rowData.clear();
                                getDecisionSummaryListDetails(page: 1, isPagination: false);
                              },
                              child: const Text("Search"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 15),
              const Text(
                'Decision Summary Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              buildGovernmentInfo(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // 👈 gives height to ListView
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (!isLoadingMore &&
                        scrollNotification.metrics.pixels >=
                            scrollNotification.metrics.maxScrollExtent - 100) {
                      if (currentPage < totalPages) {
                        loadMore(); // 👈 Load next page
                      }
                    }
                    return false;
                  },
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 16),
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Constants().buildCustomDataTableWithIcon(
                          columnTitles: columnTitles,
                          rowData: rowData,
                        ),
                      ),
                      if (isLoadingMore)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Widget for Government and Department Info
  Widget buildGovernmentInfo() {
    return Container(
        padding: const EdgeInsets.all(12),
    color: Colors.blue.shade100,
    child:
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Government of Rajasthan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.red,
          ),
        ),
        const Text(
          'Justice Department',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.red,
          ),
        ),
        const Text(
          '( Litigation Information Tracking & Evaluation System )',
          style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 12, color: Colors.red),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Administrative Department Wise Decision Summary Report',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
    ) );
  }


  Future getDecisionSummaryListDetails({int page = 1, bool isPagination = false}) async {
    try {
      if (!isPagination) EssentialDialogs().showProgressHud(context, true);
      isLoadingMore = true;

      ReportApiClient client = await ReportApiServiceApiclient.createService(context);
      DecisionSummaryReqModel req = DecisionSummaryReqModel();
      req.searchParameter = SearchParameter();

      final String defaultFromDate = "01/01/1947";
      final String defaultToDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

      bool isDefaultFilter = selectedDecisionFromDate == null &&
          selectedToDate == null &&
          selectedFromDate == null &&
          selectedToDate == null && selectedLevel == null;

      if (isDefaultFilter) {
        req.searchParameter?.dfromdate = "";
        req.searchParameter?.dtodate = "";
        req.searchParameter?.fromdate = defaultFromDate;
        req.searchParameter?.todate = defaultToDate;
        req.searchParameter?.level = 'Admindeptt Wise';
      } else {
        req.searchParameter?.dfromdate = selectedDecisionFromDate ?? "";
        req.searchParameter?.dtodate = selectedDecisionToDate ?? "";
        req.searchParameter?.level = selectedLevel?.value.toString() ?? "Admindeptt Wise";
        req.searchParameter?.fromdate = selectedFromDate ?? "";
        req.searchParameter?.todate = selectedToDate ?? "";
      }

      // Set pagination fields exactly as your working code
      req.paging = true;
      req.currentPageID = 0;
      req.totalPages = 0;
      req.startPageNumber = page;
      req.endPageNumber = 0;
      req.totalRecords = 0;
      req.startRecord = 0;
      req.endRecord = 0;
      req.pageSize = 20;
      req.pageUrl = "";
      req.ajaxUrl = "";
      req.sortingColumn = "";
      req.sortingOrder = 1;
      req.searchText = "";


      if (kDebugMode) {
        print('getAAGListDetails - raw request - ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getDecisionSummaryReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted impcase response: $decryptedMap");
      }

      final response = GetDecisionSummaryReportModel.fromJson( decryptedMap);

      if (!isPagination)
        EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;

      if ((response.status ?? false) && response.data != null) {
        List<DataDecisionSummary> newCases = response.data!;
        List<List<String>> newRows = newCases.map((caseItem) {
          return [
            caseItem.rowNum.toString(),
            caseItem.admDepttName ?? '',
            caseItem.decided?.toString() ?? '',
            caseItem.favour?.toString() ?? '',
            caseItem.against?.toString() ?? '',
            ""
          ];
        }).toList();

        setState(() {
          if (isPagination) {
            decisionCaseList.addAll(newCases);
            rowData.addAll(newRows);
          } else {
            decisionCaseList = newCases;
            rowData = newRows;
          }
          // 👇 Must update totalPages
          if (response.pagination != null && response.pagination!.isNotEmpty) {
            totalPages = (response.pagination![0].totalRecords! / req.pageSize!).ceil();
          }
        });
      } else {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage = response.message ?? "Something Went Wrong..!!";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e) {
      if (kDebugMode) {
        print('getAAGListDetails - error - $e');
      }
      EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;
      if (e is DioException) {
        ServerErrorPage.withError(error: e, context: context);
      } else {
        ServerErrorPage.withError(error: e as DioException, context: context);
      }
    }
  }
}
