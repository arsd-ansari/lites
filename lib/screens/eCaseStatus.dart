import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/utils/extension.dart';

import '../models/essentialdialog_model.dart';
import '../models/responses/CaseTypeModel.dart';
import '../models/responses/GetECourtComplex.dart';
import '../models/responses/GetECourtDistrictModel.dart';
import '../models/responses/GetECourtStateModel.dart';
import '../repository/ECourtApi/eCourtApiClient.dart';
import '../utils/constants.dart';
import '../utils/essentialdialog.dart';
import '../utils/litesAppBar.dart';
import '../utils/servererror.dart';
import '../utils/string_app.dart';

class ECaseStatus extends StatefulWidget {
  String routeName = '/eCaseStatus';

   ECaseStatus({super.key});

  @override
  State<ECaseStatus> createState() => _ECaseStatusState();
}

class _ECaseStatusState extends State<ECaseStatus> {
  Map<String, StateData>? state;
  StateData? selectedState;
  Map<String, District>? district;
  District? selectedDistrict;
  Map<String, Establishment>? establishment;
  Establishment? selectedEstablishment;
  CaseType? selectedCaseType;
  List<CaseType> caseTypeList = [];
  final TextEditingController caseNumberCon = TextEditingController();
  final TextEditingController yearCon = TextEditingController();

  List<String> columnTitlesDetails1 = [
    'CNR NO.',
    'Type Name',
    'Registration Number',
    'Registration Year',
    'Petitioner Name',
    'Respondent Name'
  ];
  List<List<String>> rowDataDetails1 = [];
  String est_name= "";

  bool isLoading = false;
  bool _isDataVisible = false;

  List<String> columnTitlesDetails = [
    'Case Type',
    'Filing Number',
    'Filing Date',
    'Registration Number',
    'Registration Date',
    'CNR Number',
  ];
  List<String> columnTitlesStatus = [
    'First Hearing Date',
    'Next Hearing Date',
    'Decision Date',
    'Stage of Case',
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
  List<List<String>> rowDataDetails = [];
  List<List<String>> rowDataStatus = [];
  List<List<String>> rowDataHistory = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStateList();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: LitesAppBar(
        title: 'e-Court Case Status',
        onBackPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: SafeArea(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Constants().buildFinalDropdownField<StateData>(
                      label: 'State',
                      options: state?.values.toList() ?? [],
                      selectedValue: selectedState,
                      onChanged: (newValue) async {
                        setState(() {
                          selectedState = newValue;
                        });
                        getDistrictList();
                        // getDetailCaseType(selectedAdminDept?.value ?? "");
                      },
                      labelExtractor: (data) => data.stateName ?? '',
                      selectHint: 'Select State',
                    ),
                    const SizedBox(height: 15),

                    Constants().buildFinalDropdownField<District>(
                      label: 'District',
                      options: district?.values.toList() ?? [],
                      selectedValue: selectedDistrict,
                      onChanged: (newValue) async {
                        setState(() {
                          selectedDistrict = newValue;
                        });
                        getComplexList();
                        // getDetailCaseType(selectedAdminDept?.value ?? "");
                      },
                      labelExtractor: (data) => data.distName ?? '',
                      selectHint: 'Select District',
                    ),
                    const SizedBox(height: 15),
                    Constants().buildFinalDropdownField<Establishment>(
                      label: 'Court Complex',
                      options: establishment?.values.toList() ?? [],
                      selectedValue: selectedEstablishment,
                      onChanged: (newValue) async {
                        setState(() {
                          selectedEstablishment = newValue;
                        });
                        getDetailCaseType(newValue?.estCode ?? "");
                      },
                      labelExtractor: (data) => data.courtEstName ?? '',
                      selectHint: 'Select Court Complex',
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
            if(rowDataDetails1.isNotEmpty)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          color: Colors.teal,
                          width: (MediaQuery.of(context).size.width* 2) + 5,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child:  Center(
                            child: Text(
                              est_name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Constants().buildCustomDataTableWithIcon(
                          columnTitles: columnTitlesDetails1,
                          rowData: rowDataDetails1,
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
                         Text(
                          est_name ,
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
                          columnTitles: columnTitlesDetails,
                          rowData: rowDataDetails,
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
                          columnTitles: columnTitlesStatus,
                          rowData: rowDataStatus,
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
      )),
    );
  }

  Future<void> getDetailByCNR(String cnrNum) async {
    setState(() {
      _isDataVisible = false;
    });
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ECourtApiServiceApiclient.createService(
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
          rowDataDetails = [
            [
              (response.data?.data?.typeName?? "--"),
              "${response.data?.data?.filNo}/${response.data?.data?.filYear?? "--"}",
              (response.data?.data?.dateOfFiling?.reverseThisDate() ?? "--"),
              "${response.data?.data?.regNo}/${response.data?.data?.regYear?? "--"}",
              (response.data?.data?.dtRegis?.reverseThisDate() ?? "--"),
              (response.data?.data?.cino?? "--"),
            ],
          ];
          rowDataStatus = [
            [
              (response.data?.data?.dateFirstList?.isNotEmpty ?? false ? "${response.data?.data?.dateFirstList?.reverseThisDate()}" : "--"),
              (response.data?.data?.dateNextList?.isNotEmpty ?? false ? "${response.data?.data?.dateNextList?.reverseThisDate()}" : "--"),
              (response.data?.data?.dateLastList?.isNotEmpty ?? false ? "${response.data?.data?.dateLastList?.reverseThisDate()}" : "--"),
              (response.data?.data?.purposeName ?? "--"),
              "${response.data?.data?.dispName ?? "--"}",
              (response.data?.data?.desgname ?? "--"),
              "${response.data?.data?.petName ?? "--"}, Advocate - ${response.data?.data?.petAdv ?? "--"}",
              "${response.data?.data?.resName ?? "--"}, Advocate - ${response.data?.data?.resAdv ?? "--"}",
            ],
          ];

          final mapped = response.data?.data?.historyofcasehearing
              ?.map((key, value) => MapEntry(
            key,
            [
              "${response.data?.data?.regNo}/${response.data?.data?.regYear ?? "--"}",
              (value.desgname?.isNotEmpty ?? false ? value.desgname! : "--"),
              (value.businessDate?.isNotEmpty ?? false ? value.businessDate!.reverseThisDate() : "--"),
              (value.hearingDate != null ? value.hearingDate!.reverseThisDate() : "--"),
              (value.purposeOfListing ?? "--"),
            ],
          ));

          rowDataHistory = mapped?.values.toList() ?? [];
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

  Future<void> getDetailByCaseNo() async {

    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ECourtApiServiceApiclient.createService(
        context,
      );
      final response = await apiClient.getDetailByCaseNumber(selectedEstablishment?.estCode ?? "",selectedCaseType?.caseType ?? "", caseNumberCon.text, yearCon.text);

      if (kDebugMode) {
        print(
          'getDetailByCNR - res - ${response}',
        );
      }

      if (response.status == true && response.data != null) {
        setState(() {
          est_name = response.data?.establishmentName ?? "";
          rowDataDetails1 = [
            [
              (response.data?.casenos?.case1?.cino?? "--"),
              "${response.data?.casenos?.case1?.typeName?? "--"}",
              (response.data?.casenos?.case1?.regNo ?? "--"),
              (response.data?.casenos?.case1?.regYear ?? "--"),
              (response.data?.casenos?.case1?.petName ?? "--"),
              (response.data?.casenos?.case1?.resName ?? "--"),
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

  Future<void> getDetailCaseType(String EstCode) async {

    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ECourtApiServiceApiclient.createService(
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



  Future<void> getStateList() async {

    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ECourtApiServiceApiclient.createService(
        context,
      );
      final response = await apiClient.getECourtStateDetail();

      if (kDebugMode) {
        print(
          'getDetailByCNR - res - ${response.status} - ${response.message}',
        );
      }

      if (response.status == true && response.data != null) {
        setState(() {
          state = response.data?.state;
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
      // ServerErrorPage.withError(error: e as DioException, context: context);
    }
  }

  Future<void> getDistrictList() async {

    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ECourtApiServiceApiclient.createService(
        context,
      );
      final response = await apiClient.getDistrictDetail(selectedState?.stateCode.toString() ?? "");

      if (kDebugMode) {
        print(
          'getDetailByCNR - res - ${response.status} - ${response.message}',
        );
      }

      if (response.status == true && response.data != null) {
        setState(() {
          district = response.data?.district ;
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
      // ServerErrorPage.withError(error: e as DioException, context: context);
    }
  }

  Future<void> getComplexList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ECourtApiServiceApiclient.createService(context);
      final response = await apiClient.getCourtComplexDetail(
        selectedState?.stateCode.toString() ?? "",
        selectedDistrict?.distCode.toString() ?? "",
      );

      if (kDebugMode) {
        print('getComplexList - res - ${response.status} - ${response.message}');
      }

      if (response.status == true && response.data != null) {
        // flatten all establishments from all complexes
        final establishments = <String, Establishment>{};

        void addEst(Establishment? est) {
          if (est != null && est.estCode != null) {
            establishments[est.estCode!] = est;
          }
        }

        final data = response.data;
        if (data != null) {
          addEst(data.complex1?.establishment1);
          addEst(data.complex1?.establishment2);
          addEst(data.complex1?.establishment3);
          addEst(data.complex1?.establishment4);

          addEst(data.complex2?.establishment1);
          addEst(data.complex2?.establishment2);

          addEst(data.complex3?.establishment1);
          addEst(data.complex3?.establishment2);
          addEst(data.complex3?.establishment3);
          addEst(data.complex3?.establishment4);

          addEst(data.complex4?.establishment1);

          addEst(data.complex5?.establishment1);
          addEst(data.complex5?.establishment2);
          addEst(data.complex5?.establishment3);
          addEst(data.complex5?.establishment4);

          addEst(data.complex6?.establishment1);
          addEst(data.complex6?.establishment2);

          addEst(data.complex7?.establishment1);
          addEst(data.complex7?.establishment2);
          addEst(data.complex7?.establishment3);
          addEst(data.complex7?.establishment4);

          addEst(data.complex8?.establishment1);
          addEst(data.complex8?.establishment2);
          addEst(data.complex8?.establishment3);
          addEst(data.complex8?.establishment4);

          addEst(data.complex9?.establishment1);
          addEst(data.complex9?.establishment2);
          addEst(data.complex9?.establishment3);
          addEst(data.complex9?.establishment4);
          addEst(data.complex9?.establishment5);
          addEst(data.complex9?.establishment6);
          addEst(data.complex9?.establishment7);
          addEst(data.complex9?.establishment8);

          addEst(data.complex10?.establishment1);
          addEst(data.complex10?.establishment2);

          addEst(data.complex11?.establishment1);
          addEst(data.complex11?.establishment2);
        }

        setState(() {
          establishment = establishments;
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
        print('getComplexList - error: $e');
      }
    }
  }
}
