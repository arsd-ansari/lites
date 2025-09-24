import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/models/responses/reports/GetAAGReportModel.dart';

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

class AagPerformanceReport extends StatefulWidget {
  String routeName = '/AagPerformanceReport';

  AagPerformanceReport({super.key});

  @override
  State<AagPerformanceReport> createState() => _AagPerformanceReportState();
}

class _AagPerformanceReportState extends State<AagPerformanceReport> {
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
  List<DataAAG> caseList = [];

  List<String> columnTitles = ['Sr No', 'AAG Name', 'Total Cases', 'Decided', 'Favour', 'Against', 'Percentage of cases in favour'];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load first page initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdmDepList();
      //getAAGListDetails();
      getAAGListDetails(page: currentPage);
    });
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        currentPage < totalPages) {
      currentPage += 1;
      getAAGListDetails(page: currentPage, isPagination: true);
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'AAG Performance Report Filter',
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
                        // Added vertical spacing
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
                                  hodUnitDeptOptions = [];
                                  selectedFromDate = null;
                                  selectedToDate = null;
                                  rowData.clear();
                                });
                                getAAGListDetails(page: 1, isPagination: false);
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
                                getAAGListDetails(page: 1, isPagination: false);
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
                'AAG Performance Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
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


  void loadMore() async {
    if (isLoadingMore || currentPage >= totalPages) return;

    setState(() => isLoadingMore = true);

    int nextPage = currentPage + 1;

    await getAAGListDetails(page: nextPage, isPagination: true);

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

  // Widget for Government and Department Info
  Widget buildGovernmentInfo() {
    return Container(
        padding: const EdgeInsets.all(12), // Optional: add padding inside the background
    color: Colors.blue.shade100, // 🔴 Set your background color here
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
          '(${selectedAdminDept?.text.toString() ?? 'Administrative Department'} Wise AAG Performance Report )',
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

  Future getAAGListDetails({int page = 1, bool isPagination = false}) async {
    try {
      if (!isPagination) EssentialDialogs().showProgressHud(context, true);
      isLoadingMore = true;

      ReportApiClient client = await ReportApiServiceApiclient.createService(context);
      AAGReportReqModel req = AAGReportReqModel();
      req.searchParameter = SearchParameter();

      final String defaultFromDate = "01/01/1947";
      final String defaultToDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

      bool isDefaultFilter = selectedAdminDept == null &&
          selectedHodUnitDept == null &&
          selectedFromDate == null &&
          selectedToDate == null;

      if (isDefaultFilter) {
        req.searchParameter?.admdepttid = "";
        req.searchParameter?.unitid = "";
        req.searchParameter?.fromdate = defaultFromDate;
        req.searchParameter?.todate = defaultToDate;
      } else {
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
      req.pageSize = 20;
      req.pageUrl = "";
      req.ajaxUrl = "";
      req.sortingColumn = "";
      req.sortingOrder = 1;

      if (kDebugMode) {
        print('getAAGListDetails - raw request - ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getAAGReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted impcase response: $decryptedMap");
      }

      final response = GetAAGReportModel.fromJson( decryptedMap);

      if (!isPagination)
        EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;

      if ((response.status ?? false) && response.data != null) {
        List<DataAAG> newCases = response.data!;
        List<List<String>> newRows = newCases.map((caseItem) {
          final decided = caseItem.decided ?? 0;
          final favour = caseItem.favour ?? 0;
          String percentage = decided >0 ? ((favour / decided) * 100).toStringAsFixed(2) + '%' : '0%';
          return [
            caseItem.rowNum.toString(),
            caseItem.name ?? '',
            caseItem.totalCases?.toString() ?? '',
            caseItem.decided?.toString() ?? '',
            caseItem.favour?.toString() ?? '',
            caseItem.against?.toString() ?? '',
            percentage
          ];
        }).toList();

       /* List<List<String>> newRows = newCases.map((caseItem) {
          return [
            caseItem.rowNum.toString(),
            caseItem.name ?? '',
            caseItem.totalCases?.toString() ?? '',
            caseItem.decided?.toString() ?? '',
            caseItem.favour?.toString() ?? '',
            caseItem.against?.toString() ?? '',
            ""
          ];
        }).toList();*/

        setState(() {
          if (isPagination) {
            caseList.addAll(newCases);
            rowData.addAll(newRows);
          } else {
            caseList = newCases;
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
