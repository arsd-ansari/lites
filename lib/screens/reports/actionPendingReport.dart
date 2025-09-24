import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/models/responses/reports/GetAAGReportModel.dart';
import 'package:lites/models/responses/reports/GetActionPendingReportModel.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../repository/commonRepository.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class ActionPendingReport extends StatefulWidget {
  String routeName = '/ActionPendingReport';

  ActionPendingReport({super.key});

  @override
  State<ActionPendingReport> createState() => _ActionPendingReportState();
}

class _ActionPendingReportState extends State<ActionPendingReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  bool _isFormVisible = false;
  int? adminDeptId;
  int? unitDeptId;
  int? officeDeptId;
  String? selectedToDate;
  String? selectedFromDate;
  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  Data? selectedOffice;
  List<Data> adminDeptOptions = [];
  List<Data> hodUnitDeptOptions = [];
  List<Data> officeOptions = [];
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  int totalPages = 1;

  bool isLoadingMore = false;
  List<ActionPendingData> caseList = [];

  List<String> columnTitles = ['Sr No', 'Court Name', 'Total Cases', 'Reply Not Filed', 'Contempt Cases', 'Due Courses', 'Decision Not Implemented', 'Order Pending for Appeal'];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdmDepList();
      getActionPendingDetails(page: currentPage);
    });
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        currentPage < totalPages) {
      currentPage += 1;
      getActionPendingDetails(page: currentPage, isPagination: true);
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Action Pending Report Filter',
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
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Department',
                          options: adminDeptOptions,
                          selectedValue: selectedAdminDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedAdminDept = newValue;
                              selectedHodUnitDept = null;
                              selectedOffice = null;
                              hodUnitDeptOptions = [];
                              officeOptions = [];
                            });
                            adminDeptId =
                                int.tryParse(newValue?.value ?? '0');
                            if (adminDeptId != null) {
                              await getUnitList(adminDeptId!);
                            }
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Department',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'HoD/Unit',
                          options: hodUnitDeptOptions,
                          selectedValue: selectedHodUnitDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedHodUnitDept = newValue;
                              selectedOffice = null;
                              officeOptions = [];
                            });
                            unitDeptId =
                            int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select HoD/Unit',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Office',
                          options: officeOptions,
                          selectedValue: selectedOffice,
                          onChanged: (newValue) {
                            setState(() {
                              selectedOffice = newValue;
                            });
                            officeDeptId = int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Office',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildDatePickerTile(
                          label: 'From Date',
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
                          label: 'To Date',
                          selectedDate: selectedToDate,
                          onTap: () {
                            Constants().presentDatePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedToDate = date);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedAdminDept = null;
                                  selectedHodUnitDept = null;
                                  selectedOffice = null;
                                  hodUnitDeptOptions = [];
                                  officeOptions = [];
                                  selectedFromDate = null;
                                  selectedToDate = null;
                                  rowData.clear();
                                });
                                getActionPendingDetails(page: 1, isPagination: false);
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
                                getActionPendingDetails(page: 1, isPagination: false);
                              },
                              child: const Text("Search"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
              const Text(
                'Action Pending Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              buildGovernmentInfo(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
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


  void loadMore() async {
    if (isLoadingMore || currentPage >= totalPages) return;

    setState(() => isLoadingMore = true);

    int nextPage = currentPage + 1;

    await getActionPendingDetails(page: nextPage, isPagination: true);

    setState(() {
      currentPage = nextPage;
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                  fontWeight: FontWeight.bold,fontSize: 10, color: Colors.red),
            ),
            const SizedBox(height: 5),
            Text(
              '(${selectedAdminDept?.text.toString() ?? 'Department'} Wise Action Pending Report )',
              style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 14, color: Colors.red),
            ),

            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '(As on ${DateFormat('dd/MM/yyyy').format(DateTime.now())})',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          ],
        ));
  }



  Future<void> getAdmDepList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      adminDeptOptions = await commonRepository.getAdminDepartments(context); //

      setState(() {}); // refresh UI with updated list
    } catch (e) {
      await EssentialDialogs().openOkDismissDialog(
        context,
        EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: e.toString(),
        ),
      );
    } finally {
      EssentialDialogs().showProgressHud(context, false);
    }
  }

  Future<void> getUnitList(int adminDeptId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      hodUnitDeptOptions = await commonRepository.getUnits(context,adminDeptId); //

      setState(() {}); // refresh UI with updated list
    } catch (e) {
      await EssentialDialogs().openOkDismissDialog(
        context,
        EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: e.toString(),
        ),
      );
    } finally {
      EssentialDialogs().showProgressHud(context, false);
    }
  }

  Future getActionPendingDetails({int page = 1, bool isPagination = false}) async {
    try {
      if (!isPagination) EssentialDialogs().showProgressHud(context, true);
      isLoadingMore = true;

      ReportApiClient client = await ReportApiServiceApiclient.createService(context);
      GetActionPendingReqModel req = GetActionPendingReqModel();
      req.searchParameter = ActionSearchParameter();

      final String defaultFromDate = "01/01/1947";
      final String defaultToDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

      bool isDefaultFilter = selectedAdminDept == null &&
          selectedHodUnitDept == null && selectedOffice ==null &&
          selectedFromDate == null &&
          selectedToDate == null;

      if (isDefaultFilter) {
        req.searchParameter?.roleID = "1";
        req.searchParameter?.officeid = "";
        req.searchParameter?.admdepttid = "";
        req.searchParameter?.unitid = "";
        req.searchParameter?.fromdate = defaultFromDate;
        req.searchParameter?.todate = defaultToDate;
      } else {
        req.searchParameter?.roleID = "1";
        req.searchParameter?.officeid = selectedOffice?.value.toString() ?? "";
        req.searchParameter?.admdepttid = selectedAdminDept?.value.toString() ?? "";
        req.searchParameter?.unitid = selectedHodUnitDept?.value.toString() ?? "";
        req.searchParameter?.fromdate = selectedFromDate ?? defaultFromDate;
        req.searchParameter?.todate = selectedToDate ?? defaultToDate;
      }
      req.paging = true;
      req.currentPageID = 0;
      req.totalPages = 0;
      req.startPageNumber = page;
      req.endPageNumber = 0;
      req.totalRecords = 0;
      req.startRecord = 0;
      req.endRecord = 0;
      req.pageSize = 10;
      req.pageUrl = "";
      req.ajaxUrl = "";
      req.sortingColumn = "";
      req.sortingOrder = 1;
      req.searchText = "";

      if (kDebugMode) {
        print('getActionPendingDetails - raw request - ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getActionPendingReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted action pending response: $decryptedMap");
      }

      final response = GetActionPendingReportModel.fromJson( decryptedMap);

      if (!isPagination)
        EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;

      if ((response.status ?? false) && response.data != null) {
        List<ActionPendingData> newCases = response.data!;
        List<List<String>> newRows = newCases.asMap().entries.map((entry) {
          int index = entry.key;
          ActionPendingData caseItem = entry.value;
      //  List<List<String>> newRows = newCases.map((caseItem) {
          return [
           // caseItem.rowId.toString(),
            (isPagination ? caseList.length + index + 1 : index + 1).toString(), // Serial number
            caseItem.courtName ?? '',
            caseItem.totalCases?.toString() ?? '',
            caseItem.hcReplyNotFiled?.toString() ?? '',
            caseItem.contemptCases?.toString() ?? '',
            caseItem.dueCourse?.toString() ?? '',
            caseItem.decisionNotImplemented?.toString() ?? '',
            caseItem.dueCourse?.toString() ?? '',
          ];
        }).toList();

        setState(() {
          if (isPagination) {
            caseList.addAll(newCases);
            rowData.addAll(newRows);
          } else {
            caseList = newCases;
            rowData = newRows;
          }
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
        print('getActionPendingDetails - error - $e');
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
