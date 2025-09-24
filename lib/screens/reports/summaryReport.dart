import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/reports/GetSummaryReportModel.dart';
import '../../repository/commonRepository.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class SummaryReport extends StatefulWidget {
  String routeName = '/SummaryReport';

  SummaryReport({super.key});

  @override
  State<SummaryReport> createState() => _SummaryReportState();
}

class _SummaryReportState extends State<SummaryReport> {
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

  List<String> columnTitles = ['Sr No', 'Admin Department Name', 'Total Cases'];
  List<List<String>> rowData = [];
  List<AdmindeptWiseCases>? admindeptWiseCases = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdmDepList();
      getSummaryListDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Summary Report',
        onBackPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery
                  .of(context)
                  .size
                  .height,
            ),
            child: IntrinsicHeight(
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
                        child: Text(
                            _isFormVisible ? 'Hide Filter' : 'Show Filter'),
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
                                  await getOfficeList(unitDeptId!);
                                }
                              },
                              labelExtractor: (data) => data.text ?? '',
                              selectHint: 'Select HoD/Unit',
                            ),
                            const SizedBox(height: 15),
                            // Added vertical spacing
                            Constants().buildFinalDropdownField<Data>(
                              label: 'Office',
                              options: officeOptions,
                              selectedValue: selectedOffice,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedOffice = newValue;
                                });
                                officeDeptId =
                                int.tryParse(newValue?.value ?? '0')!;
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
                                      hodUnitDeptOptions= [];
                                      officeOptions = [];
                                      selectedFromDate = null;
                                      selectedToDate = null;
                                    });

                                    admindeptWiseCases?.clear();
                                    rowData.clear();
                                    getSummaryListDetails();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Reset"),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    getSummaryListDetails();
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
                  buildGovernmentInfo(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Constants().buildCustomDataTableWithIcon(
                      columnTitles: columnTitles,
                      rowData: rowData,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGovernmentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      // Optional: add padding inside the background
      color: Colors.blue.shade100,
      // 🔴 Set your background color here
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Government of Rajasthan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          const Text(
            'Justice Department',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '( Litigation Information Tracking & Evaluation System )',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '( ${selectedAdminDept?.text.toString() ?? 'Administrative Department'} Wise Summary Report',

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'LISTED CASE DATE 01/01/1947 - 24/05/2025',
              style: TextStyle(fontSize: 12, color: Colors.black),
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

  Future<void> getOfficeList(int unitDeptId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      officeOptions = await commonRepository.getOfficeList(
          context,unitDeptId!); // provide your `unitDeptId`

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

  Future<void> getSummaryListDetails() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ReportApiServiceApiclient.createService(context);

      final response = await apiClient.getSummaryReportDetails(
        int.tryParse(selectedAdminDept?.value ?? '0') ?? 0,
        int.tryParse(selectedHodUnitDept?.value ?? '0') ?? 0,
        int.tryParse(selectedOffice?.value ?? '0') ?? 0,
        selectedFromDate ?? '01/01/1947',
        (selectedToDate?.isNotEmpty == true)
            ? selectedToDate!
            : DateFormat('dd/MM/yyyy').format(DateTime.now()),
      );

      if (response.admindeptWiseCases != null &&
          response.admindeptWiseCases!.isNotEmpty) {
        List<List<String>> newRows = [];

        for (var item in response.admindeptWiseCases!) {
          newRows.add([
            item.rowNum?.toString() ?? '',
            item.admDepttName ?? '',
            item.caseCount?.toString() ?? '',
          ]);
        }

        setState(() {
          admindeptWiseCases = response.admindeptWiseCases!;
          rowData = newRows;
        });
      } else {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage = "No data found.";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e) {
      if (kDebugMode) {
        print('getSummaryListDetails error: $e');
      }
      EssentialDialogModel appDialog = EssentialDialogModel();
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = "Failed to fetch data.";
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
    } finally {
      EssentialDialogs().showProgressHud(context, false);
    }
  }
}



/*Future getSummaryListDetails() async {
    try {
    EssentialDialogs().showProgressHud(context, true);
    final apiClient = await ReportApiServiceApiclient.createService();

    debugPrint('  API Params:');
    debugPrint(
        '    adminDept: ${int.tryParse(selectedAdminDept?.value ?? '0') ?? 0}');
    debugPrint(
        '    hodUnitDept: ${int.tryParse(selectedHodUnitDept?.value ?? '0') ??
            0}');
    debugPrint(
        '    office: ${int.tryParse(selectedOffice?.value ?? '0') ?? 0}');
    debugPrint('    fromdate: $selectedFromDate');
    debugPrint('    todate: $selectedToDate');

    final response = await apiClient.getSummaryReportDetails(
      int.tryParse(selectedAdminDept?.value ?? '0') ?? 0,
      int.tryParse(selectedHodUnitDept?.value ?? '0') ?? 0,
      int.tryParse(selectedOffice?.value ?? '0') ?? 0,
      selectedFromDate ?? '',
      selectedToDate ?? '',
    );
    if (response.status == true) {
      List<List<String>> newRows = [];
      for (var caseItem in response.data!) {
        newRows.add([
          caseItem.rowID.toString(),
          caseItem.courtTypeName ?? '',
          caseItem.caseCount.toString() ?? '',
          "Get List",
        ]);
      }
      setState(() {
        caseList = response.data!; // Replace list when not loading more
        rowData = newRows;
      });
    } else {
      EssentialDialogModel appDialog = EssentialDialogModel();
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = response.message ?? "Something Went Wrong..!!";
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
    }
  }
  catch
  (e, stackTrace) {
  if (kDebugMode) {
  print('getDashboardDetails - error - $e');
  }
  EssentialDialogs().showProgressHud(context, false);
  ServerErrorPage.withError(error: e as DioException, context: context);
  }
}*/


