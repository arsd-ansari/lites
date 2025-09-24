import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/models/responses/reports/GetAAGReportModel.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/reports/GetOrderPendingReportModel.dart';
import '../../repository/commonRepository.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class OrderPendingReport extends StatefulWidget {
  String routeName = '/OrderPendingReport';

  OrderPendingReport({super.key});

  @override
  State<OrderPendingReport> createState() => _OrderPendingReportState();
}

class _OrderPendingReportState extends State<OrderPendingReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  bool _isFormVisible = false;
  bool hasSearched = false;
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
  List<OrderPendingData> caseList = [];
  List<String> columnTitles = ['Sr. No', 'Office Name', 'Case Detail', 'Pett./Appellant Name', 'Respondant name', 'Advocate Name', 'OIC name', 'Abbreviation', 'R E Implication'];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdmDepList();
      getOrderPendingDetails(page: currentPage);
    });
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        currentPage < totalPages) {
      currentPage += 1;
      getOrderPendingDetails(page: currentPage, isPagination: true);
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Order Pending Report Filter',
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
                            if (unitDeptId != null) {
                              print('unitiddddd-----$unitDeptId');
                              await getOfficeList(unitDeptId!);
                            }
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
                            Constants().presentDatePickerDiffFormat(
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
                            Constants().presentDatePickerDiffFormat(
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
                                  officeOptions = [];
                                  hodUnitDeptOptions =[];
                                  selectedFromDate = null;
                                  selectedToDate = null;
                                  rowData.clear();
                                });
                                getOrderPendingDetails(page: 1, isPagination: false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {

                                setState(() {
                                  hasSearched = true;
                                });
                                currentPage = 1;
                                rowData.clear();
                                getOrderPendingDetails(page: 1, isPagination: false);
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
                'Order Pending Report',
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

    await getOrderPendingDetails(page: nextPage, isPagination: true);

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

  Widget buildGovernmentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue.shade100,
      child: Column(
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
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '(Order Pending For Appeal)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(As on ${DateFormat('dd/MM/yyyy').format(DateTime.now())})',
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Colors.grey),

          const SizedBox(height: 8),
          if (hasSearched &&
              (selectedAdminDept?.text != null ||
                  selectedOffice?.text != null ||
                  selectedHodUnitDept?.text != null))

            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 20,
                runSpacing: 6,
                children: [
                  if (selectedAdminDept?.text != null)
                    Text(
                      'Department: ${selectedAdminDept!.text}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (selectedOffice?.text != null)
                    Text(
                      'Office: ${selectedOffice!.text}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (selectedHodUnitDept?.text != null)
                    Text(
                      'HOD/Unit: ${selectedHodUnitDept!.text}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
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

  Future getOrderPendingDetails({int page = 1, bool isPagination = false}) async {
    try {
      if (!isPagination) EssentialDialogs().showProgressHud(context, true);
      isLoadingMore = true;

      ReportApiClient client = await ReportApiServiceApiclient.createService(context);
      GetOrderPendingReqModel req = GetOrderPendingReqModel();
      final String defaultFromDate = "1947-01-01T11:59:34.874Z";
      final String defaultToDate = Constants().isoUtcWithMillis(DateTime.now());

      bool isDefaultFilter = selectedAdminDept == null &&
          selectedHodUnitDept == null && selectedOffice == null &&
          selectedFromDate == null &&
          selectedToDate == null;

      if (isDefaultFilter) {
        req.fromDate = defaultFromDate;
        req.toDate = defaultToDate;
        req.admDepttId = 0;
        req.unitId = 0;
        req.officeId = 0;
      }
      else {
        req.admDepttId = selectedAdminDept?.value != null
            ? int.parse(selectedAdminDept!.value.toString())
            : 0;

        req.unitId = selectedHodUnitDept?.value != null
            ? int.parse(selectedHodUnitDept!.value.toString())
            : 0;

        req.officeId = selectedOffice?.value != null
            ? int.parse(selectedOffice!.value.toString())
            : 0;

        req.fromDate = selectedFromDate ?? defaultFromDate;
        req.toDate = selectedToDate ?? defaultToDate;

      }
      req.pageNumber = page;
      req.pageSize = 10;

      if (kDebugMode) {
        print('getOrderPendingDetails - raw request - ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getOrderPendingReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted getOrderPendingDetails response: $decryptedMap");
      }

      final response = GetOrderPendingReportModel.fromJson( decryptedMap);

      if (!isPagination)
        EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;

      if ((response.status ?? false) && response.data != null) {
        List<OrderPendingData> newCases = response.data!;
        List<List<String>> newRows = newCases.map((caseItem) {
          return [
            caseItem.rowID.toString(),
            caseItem.officeName ?? '',
            caseItem.caseDetail?.toString() ?? '',
            caseItem.appellantName?.toString() ?? '',
            caseItem.respondantName?.toString() ?? '',
            caseItem.lawyerName?.toString() ?? '',
            caseItem.oICName?.toString() ?? '',
            caseItem.abbrevationName?.toString() ?? '',
            caseItem.rEImplication?.toString() ?? '',
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
        print('getOrderPendingDetails - error - $e');
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

  Future<void> getOfficeList(int unitDeptId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      officeOptions = await commonRepository.getOfficeList(
          context,unitDeptId!);

      setState(() {});
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


}
