import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/utils/extension.dart';

import '../models/essentialdialog_model.dart';
import '../models/responses/CaseDetailResponse.dart';
import '../models/responses/CaseTypeModel.dart';
import '../models/responses/GetDepDropDownListModel.dart';
import '../repository/HighCourtApi/highCourtApiClient.dart';
import '../utils/constants.dart';
import '../utils/essentialdialog.dart';
import '../utils/litesAppBar.dart';
import '../utils/servererror.dart';
import '../utils/string_app.dart';

class HighCourtCaseStatus extends StatefulWidget {
  String routeName = '/hCaseStatus';

  HighCourtCaseStatus({super.key});

  @override
  State<HighCourtCaseStatus> createState() => _HighCourtCaseStatusState();
}

class _HighCourtCaseStatusState extends State<HighCourtCaseStatus> {
  bool _isFormVisible = true;

  Data? selectedAdminDept;
  CaseType? selectedCaseType;
  List<CaseType> caseTypeList = [];
  CaseDetailData? data;


  List<Data> courtList = [
    Data(text: 'Jaipur',value: 'RJHC02'),
    Data(text: 'Jodhpur',value: 'RJHC01')
  ];

  final TextEditingController caseNumberCon = TextEditingController();
  final TextEditingController yearCon = TextEditingController();

  List<String> columnTitlesDetail = [
    'CNR NO.',
    'Type Name',
    'Registration Number',
    'Registration Year',
    'Petitioner Name',
  ];
  List<List<String>> rowDataDetail = [];


  bool isLoading = false;
  bool _isDataVisible = false;

  List<String> columnTitlesDetails1 = [
    'Case Type',
    'Filing Number',
    'Filing Date',
  ];
  List<String> columnTitlesDetails2 = [
    'Registration Number',
    'Registration Date',
    'CNR Number',
  ];
  List<String> columnTitlesStatus1 = [
    'First Hearing Date',
    'Next Hearing Date',
    'Decision Date',
    'Stage of Case',
  ];
  List<String> columnTitlesStatus2 = [
    'Nature of Disposal',
    'Court Number and Judge',
    'Petitioner and Advocate',
    'Respondent and Advocate',
  ];
  List<String> columnTitlesHistory = [
    'Registration No.',
    'Judge',
    'Business On Date',
    'Hearing Date',
    'Purpose of hearing',
  ];
  List<List<String>> rowDataDetails1 = [];
  List<List<String>> rowDataDetails2 = [];
  List<List<String>> rowDataStatus1 = [];
  List<List<String>> rowDataStatus2 = [];
  List<List<String>> rowDataHistory = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Search by CNR Number',
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
                          label: 'Court',
                          options: courtList,
                          selectedValue: selectedAdminDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedAdminDept = newValue;
                            });
                            getDetailCaseType(selectedAdminDept?.value ?? "");
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Court',
                        ),
                        const SizedBox(height: 15),

                        Constants().buildFinalDropdownField<CaseType>(
                          label: 'Case Type',
                          options: caseTypeList,
                          selectedValue: selectedCaseType,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedCaseType = newValue;
                            });
                          },
                          labelExtractor: (data) => data.typeName ?? '',
                          selectHint: 'Select Case Type',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextField(
                          'Case Number',
                          caseNumberCon,
                          hint: 'Enter Case No.',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextField(
                          'Year',
                          yearCon,
                          hint: 'Enter Year',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            ElevatedButton(
                              onPressed: () async {
                                getDetailByCaseNo();
                              },
                              child: const Text("Search"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if(rowDataDetail.isNotEmpty)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "कृपया अधिक जानकारी के लिए CNR NO. पर क्लिक करे",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            color: Colors.teal,
                            width: (MediaQuery.of(context).size.width* 2) + 5,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Center(
                              child: Text(
                                "High Court Bench at Jaipur",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesDetail,
                            rowData: rowDataDetail,
                            iconColumns: {6: Icons.pending_actions_sharp},
                            onIconPressed: (rowIndex, colIndex) {},
                            onCnrPressed: (rowIndex, cnr) {

                              getDetailByCNR(cnr)
                              ;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (_isDataVisible)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'High Court Bench Jaipur',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Case Details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesDetails1,
                            rowData: rowDataDetails1,
                            iconColumns: {6: Icons.pending_actions_sharp},
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesDetails2,
                            rowData: rowDataDetails2,
                            iconColumns: {6: Icons.pending_actions_sharp},
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Case Status',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesStatus1,
                            rowData: rowDataStatus1,
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesStatus2,
                            rowData: rowDataStatus2,
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'History of Case Hearing',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesHistory,
                            rowData: rowDataHistory,
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> getDetailCaseType(String EstCode) async {

    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await HighCourtApiServiceApiclient.createService(
        context,
      );
      final response = await apiClient.getDetailCaseType(EstCode);

      if (kDebugMode) {
        print(
          'getDetailByCNR - res - ${response.status} - ${response.message}',
        );
      }

      if (response.status == true && response.caseTypes != null) {
        setState(() {
          caseTypeList = response.caseTypes ?? [];
        });
      } else {
        EssentialDialogs().showProgressHud(context, false);
        final appDialog = EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: response.error ?? "Something went wrong",
        );
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }

      EssentialDialogs().showProgressHud(context, false);
    } catch (e) {
      EssentialDialogs().showProgressHud(context, false);
      if (kDebugMode) {
        print('getCaseDecisionList - error: ${e.toString()}');
      }
      if (e is DioException) {
        ServerErrorPage.withError(error: e, context: context);
      } else {
        final appDialog = EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: "Unexpected error: ${e.toString()}",
        );
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    }
  }

  Future<void> getDetailByCaseNo() async {

    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await HighCourtApiServiceApiclient.createService(
        context,
      );
      final response = await apiClient.getDetailByCaseNumber(selectedAdminDept?.value ?? "",selectedCaseType?.caseType ?? "", caseNumberCon.text, yearCon.text);

      if (kDebugMode) {
        print(
          'getDetailByCNR - res - ${response}',
        );
      }

      if (response.status == true && response.data != null) {
        // {"status":true,"message":"Success","data":{"establishment_name":"High Court Bench at Jaipur","casenos":{"case1":{"cino":"RJHC020882222023","type_name":"CW","reg_no":"17274","reg_year":"2023","pet_name":"MANOJ BAIRWA S/O LAL CHAND BAIRWA","res_name":"STATE OF GOVENRMENT","police_st_code":""}}}}
        setState(() {
          rowDataDetail = [
            [
              (response.data?.casenos?.case1?.cino?? "--"),
              "${response.data?.casenos?.case1?.typeName?? "--"}",
              (response.data?.casenos?.case1?.regNo ?? "--"),
              (response.data?.casenos?.case1?.regYear ?? "--"),
              (response.data?.casenos?.case1?.petName ?? "--"),
            ],
          ];
        });
      } else {
        EssentialDialogs().showProgressHud(context, false);
        final appDialog = EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: response.message ?? "Something went wrong",
        );
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }

      EssentialDialogs().showProgressHud(context, false);
    } catch (e) {
      EssentialDialogs().showProgressHud(context, false);
      if (kDebugMode) {
        print('getCaseDecisionList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioException, context: context);
    }
  }

  Future<void> getDetailByCNR(String cnrNum) async {
    setState(() {
      _isDataVisible = false;
    });
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await HighCourtApiServiceApiclient.createService(
        context,
      );
      final response = await apiClient.getDetailByCNR(cnrNum);

      if (kDebugMode) {
        print(
          'getDetailByCNR - res - ${response.status} - ${response.message}',
        );
      }

      if (response.status == true && response.data != null) {
        setState(() {
          rowDataDetails1 = [
            [
              (response.data?.typeNameFil?? "--"),
              "${response.data?.filNo}/${response.data?.filYear?? "--"}",
              (response.data?.dateOfFiling?.reverseThisDate() ?? "--"),
            ],
          ];
          rowDataDetails2 = [
            [
              "${response.data?.regNo}/${response.data?.regYear?? "--"}",
              (response.data?.dtRegis?.reverseThisDate() ?? "--"),
              (response.data?.cino?? "--"),
            ],
          ];
          rowDataStatus1 = [
            [
              (response.data?.dateFirstList?.isNotEmpty ?? false ? "${response.data?.dateFirstList?.reverseThisDate()}" : "--"),
              (response.data?.dateNextList?.isNotEmpty ?? false ? "${response.data?.dateNextList?.reverseThisDate()}" : "--"),
              (response.data?.dateLastList?.isNotEmpty ?? false ? "${response.data?.dateLastList?.reverseThisDate()}" : "--"),
              (response.data?.purposeName ?? "--"),
            ],
          ];
          rowDataStatus2 = [
            [
              "${response.data?.disposalType ?? "--"}",
              (response.data?.desgname ?? "--"),
              "${response.data?.petName ?? "--"}, Advocate - ${response.data?.petAdv ?? "--"}",
              "${response.data?.resName ?? "--"}, Advocate - ${response.data?.resAdv ?? "--"}",
            ],
          ];

          rowDataHistory = [
            [
              "${response.data?.regNo}/${response.data?.regYear?? "--"}",
              (response.data?.historyofcasehearing?.srNo1?.judgeName?.isNotEmpty ?? false ? "${response.data?.historyofcasehearing?.srNo1?.judgeName}" : "--"),
              (response.data?.historyofcasehearing?.srNo1?.businessDate?.isNotEmpty ?? false ? "${response.data?.historyofcasehearing?.srNo1?.businessDate?.reverseThisDate()}" : "--"),
              (response.data?.historyofcasehearing?.srNo1?.hearingDate?.reverseThisDate() ?? "--"),
              (response.data?.historyofcasehearing?.srNo1?.purposeOfListing ?? "--"),
            ],
          ];

          _isDataVisible = true;
        });
      } else {
        EssentialDialogs().showProgressHud(context, false);
        final appDialog = EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: response.message ?? "Something went wrong",
        );
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }

      EssentialDialogs().showProgressHud(context, false);
    } catch (e) {
      EssentialDialogs().showProgressHud(context, false);
      if (kDebugMode) {
        print('getCaseDecisionList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioException, context: context);
    }
  }
}
