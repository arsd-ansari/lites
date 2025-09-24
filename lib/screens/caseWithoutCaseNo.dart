import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/models/responses/GetCaseWithoutCaseNoListModel.dart';
import 'package:lites/utils/litesAppBar.dart';

import '../../utils/constants.dart';
import '../models/essentialdialog_model.dart';
import '../models/responses/CaseListDetailModel.dart';
import '../models/responses/GetDepDropDownListModel.dart';
import '../repository/caseApi/caseApiClient.dart';
import '../repository/commonRepository.dart';
import '../utils/EncryptionHelper.dart';
import '../utils/essentialdialog.dart';
import '../utils/routes.dart';
import '../utils/string_app.dart';

class CaseWithoutCaseNoScreen extends StatefulWidget {
  String routeName = '/CaseWithoutCaseNoScreen';
  CaseWithoutCaseNoScreen({super.key});

  @override
  State<CaseWithoutCaseNoScreen> createState() =>
      _CaseWithoutCaseNoScreenState();
}

class _CaseWithoutCaseNoScreenState
    extends State<CaseWithoutCaseNoScreen> {
  final CommonRepository commonRepository = CommonRepository();
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  final int pageSize = 20;
  bool isLoading = false;
  bool hasMoreData = true;
  List<int> caseIds = [];
  List<CaseWithoutCaseData> caseList = [];
  bool _isFormVisible = false;


  List<Data> officeOptions = [];
  Data? selectedOffice;
  int? officeDeptId;
  List<Data> courtTypeOptions = [];
  Data? selectedCourtType;
  int? courtTypeId;
  List<Data> abbreOptions = [];
  Data? selectedAbbre;
  int? abbreId;
  List<Data> groupOptions = [];
  Data? selectedGroup;
  int? groupId;
  List<Data> caseYearOptions = [];
  Data? selectedCaseYear;
  Data? selectedStatus;
  int? caseYearId;

  List<String> columnTitles = [
    'Sr No.',
    'Case No.',
    'Abbreviation',
    'Appellant',
    'Respondent',
    'Case Year',
    'Court Name, Court Place',
    'Action'
  ];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      loadInitialData();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 && // near bottom
          !isLoading &&
          hasMoreData) {
        getCaseWithoutCaseNoList(loadMore: true);
      }
    });
  }
  Future<void> loadInitialData() async {
    getOfficeList(0);
    getCourtTypeList(0);
    getAbbreList();
    getCaseYearList();
    getCaseWithoutCaseNoList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Case Without Case No.',
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
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Court Type',
                          options: courtTypeOptions,
                          selectedValue: selectedCourtType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCourtType = newValue;
                            });
                            courtTypeId = int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Court Type',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Abbreviation',
                          options: abbreOptions,
                          selectedValue: selectedAbbre,
                          onChanged: (newValue) {
                            setState(() {
                              selectedAbbre = newValue;
                            });
                            abbreId = int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Abbreviation',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Case Year',
                          options: caseYearOptions,
                          selectedValue: selectedCaseYear,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCaseYear = newValue;
                            });
                            caseYearId = int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Case Year',
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedOffice = null;
                                  selectedCourtType = null;
                                  selectedAbbre = null;
                                  selectedCaseYear = null;
                                });

                                currentPage = 1;
                                hasMoreData = true;
                                caseList.clear();
                                rowData.clear();
                                getCaseWithoutCaseNoList();
                                },
                              style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {

                                getCaseWithoutCaseNoList();
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
                'Case Without Case No List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Constants().buildCustomDataTableWithIcon(
                  columnTitles: columnTitles,
                  rowData: rowData,
                  iconColumns: {7: Icons.pending_actions_sharp},
                  onIconPressed: (rowIndex, colIndex) {
                    if (colIndex == 7) {
                      final selectedCase = caseList[rowIndex];
                      final caseId = selectedCase.caseId;
                      Navigator.pushNamed(
                        context,
                        Routes().caseManagementScreen,
                      //  arguments: caseId,
                        arguments: {'caseId': caseId, 'source': 'CaseWithoutCaseNo'},
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> getOfficeList(int unitDeptId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      officeOptions = await commonRepository.getOfficeList(context,
          unitDeptId!); // provide your `unitDeptId`

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

  Future<void> getCourtTypeList(int CourtTypeId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      courtTypeOptions = await commonRepository.getCourtTypeList(context,
          CourtTypeId!); // provide your `unitDeptId`

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

  Future<void> getAbbreList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      abbreOptions =
      await commonRepository.getAbbrevationList(context);

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

  Future<void> getCaseYearList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      caseYearOptions =
      await commonRepository.getYearList(context);

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

  Future<void> getCaseWithoutCaseNoList({bool loadMore = false}) async {
    if (isLoading) return;

    if (!loadMore) {
      currentPage = 1;
      hasMoreData = true;
      caseList.clear();
      rowData.clear();
    }

    if (!hasMoreData) return;

    setState(() {
      isLoading = true;
    });
    /*if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });*/
    try {
      EssentialDialogs().showProgressHud(context, true);

      CaseApiClient client = await CaseApiServiceApiclient.createService(context);

      bool isDefaultFilter = selectedOffice == null &&
          selectedCourtType == null &&
          selectedAbbre == null &&
          selectedCaseYear == null ;

      CaseReqModel req = CaseReqModel(
          admDepttId: 0,
          unitId: 0,
          officeId: int.tryParse(selectedOffice?.value ?? '0') ?? 0,
          courtTypeId: int.tryParse(selectedCourtType?.value ?? '0') ?? 0,
          abbreviationId: int.tryParse(selectedAbbre?.value ?? '0') ?? 0,
          caseYear: int.tryParse(selectedCaseYear?.value ?? '0') ?? 0,
          groupingId:  0,
          caseStatus: 0,
          primarySecondary: "",
          crnNumber:"",
          caseNo:  0,
          roleId: 0,
          oicId: 0,
          lawyerId: 0,
          districtId: 0,
          sortBy: "",
          isSortByDesc: true,
          pageNo: currentPage,
          pageSize: pageSize
      );

      if (kDebugMode) {
        print('➡️ Raw request: ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};

      final encryptedResponse = await client.getCaseWithoutCaseNoList(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("✅ Decrypted response: $decryptedMap");
      }

      final response = GetCaseWithoutCaseNoListModel.fromJson( decryptedMap);

      EssentialDialogs().showProgressHud(context, false);

      if (response.status == true && response.data != null) {
        List<List<String>> newRows = [];
        for (var caseItem in response.data!) {
          newRows.add([
            caseItem.rowID.toString(),
            caseItem.caseNo.toString() ?? '',
            caseItem.abbreviationName ?? '',
            caseItem.appellant ?? '',
            caseItem.respondent ?? '',
            caseItem.caseYear.toString() ?? '',
            caseItem.courtName ?? '',
            "View",
          ]);
        }
        setState(() {
          if (loadMore) {
            caseList.addAll(response.data!);
            rowData.addAll(newRows);
          } else {
            caseList = response.data!;
            rowData = newRows;
          }


          if (newRows.length < pageSize) {
            hasMoreData = false;
          } else {
            currentPage++;
          }
        });
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      if(kDebugMode)
{
  print("Error fetching data: $e");
}
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

}
