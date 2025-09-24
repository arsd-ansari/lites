import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/models/responses/reports/GetImpCaseReportModel.dart';
import 'package:lites/utils/litesAppBar.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDashboardDetailModel.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../repository/commonRepository.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class ImportantCaseReport extends StatefulWidget {
  String routeName = '/ImportantCaseReport';
   ImportantCaseReport({super.key});

  @override
  State<ImportantCaseReport> createState() =>
      _ImportantCaseReportState();
}

class _ImportantCaseReportState
    extends State<ImportantCaseReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  bool _isFormVisible = false;

  List<DataImpCase> caseList = [];
  List<Data> adminDeptOptions = [];
  List<Data> hodUnitDeptOptions = [];
  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  int? adminDeptId;
  int? unitDeptId;
  List<String> columnTitles = [
    'Sr No',
    'Court Name',
    'Case Count',
    'Action'
  ];
  List<List<String>> rowData = [];

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdmDepList();
      getImpCaseReportDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Important Case Report Filter',
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
                          label: 'Administrative Department',
                          options: adminDeptOptions,
                          selectedValue: selectedAdminDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedAdminDept = newValue;
                              selectedHodUnitDept = null;
                              hodUnitDeptOptions = [];
                            });
                            adminDeptId = int.tryParse(newValue?.value ?? '0');
                            if (adminDeptId != null) {
                              await getUnitList(adminDeptId!);
                            }
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Admin Dept',
                        ),
                        const SizedBox(height: 15), // Added vertical spacing
                        Constants().buildFinalDropdownField<Data>(
                          label: 'HoD/Unit',
                          options: hodUnitDeptOptions,
                          selectedValue: selectedHodUnitDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedHodUnitDept = newValue;
                            });
                            unitDeptId = int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select HoD/Unit',
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
                                  hodUnitDeptOptions =[];
                                });

                                caseList.clear();
                                rowData.clear();
                                getImpCaseReportDetails();
                              },
                              style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                getImpCaseReportDetails();
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
                'Important Case Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
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

  Future getImpCaseReportDetails() async {
    try {
      EssentialDialogs().showProgressHud(context, true);
      ReportApiClient client = await ReportApiServiceApiclient.createService(context);

      // Set filters
      bool isDefaultFilter = selectedAdminDept == null &&
          selectedHodUnitDept == null ;

      DashboardReqModel req = DashboardReqModel();

      if (isDefaultFilter) {
        req.admDepttId = 0;
        req.unitId = 0;
      } else {
        req.admDepttId = int.tryParse(selectedAdminDept?.value ?? '0') ?? 0;
        req.unitId = int.tryParse(selectedHodUnitDept?.value ?? '0') ?? 0;
      }

      if (kDebugMode) {
        print('getImpCaseReportDetails - raw request - ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getImpCaseReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted impcase response: $decryptedMap");
      }
      final response = GetImpCaseReportModel.fromJson(decryptedMap);

      EssentialDialogs().showProgressHud(context, false);

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
          caseList = response.data!;
          rowData = newRows;
        });
      } else {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage = response.message ?? "Something Went Wrong..!!";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('getImpCaseReportDetails - error - $e');
      }
      EssentialDialogs().showProgressHud(context, false);
      ServerErrorPage.withError(error: e as DioException, context: context);
    }
  }

}
