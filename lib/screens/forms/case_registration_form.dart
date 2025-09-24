import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/repository/caseApi/caseApiClient.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/CaseListDetailModel.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../repository/commonRepository.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/routes.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class CaseRegistrationForm extends StatefulWidget {
  String routeName = '/CaseRegistrationForm';

  CaseRegistrationForm({super.key});

  @override
  State<CaseRegistrationForm> createState() => _CaseRegistrationFormState();
}

class _CaseRegistrationFormState extends State<CaseRegistrationForm> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  final int pageSize = 20;
  bool isLoading = false;
  bool hasMoreData = true;
  List<int> caseIds = [];
  List<DataCaseList> caseList = [];

  bool _isFormVisible = false;
  final TextEditingController caseNoController = TextEditingController();
  final TextEditingController cnrNoController = TextEditingController();
  final CommonRepository commonRepository = CommonRepository();
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
  String? selectedMainPerforma;

  final List<String> mainPerformaOptions = ['Main_Party', 'Performa_Party'];
  final List<Data> statusOptions = [
    Data(text: 'All', value: '2'),
    Data(text: 'Pending', value: '0'),
    Data(text: 'Decided', value: '1'),
  ];

  int? statusValue;
  List<String> columnTitles = [
    'Sr No',
    'Case No',
    'Abbreviation',
    'Case Year',
    'Court Name, Court Place',
    'Performa/Main',
    'CNR No',
    'Action',
  ];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });


  }
  Future<void> loadInitialData() async {
    await getOfficeList(0);
    await getCourtTypeList(0);
    await getAbbreList();
    await getCaseYearList();
    await getGroupList(0, 0);
    getCaseListDetails(loadMore: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMoreData) {
      getCaseListDetails(loadMore: true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Case Filter',
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
              const SizedBox(height: 15),

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
                            officeDeptId =
                                int.tryParse(newValue?.value ?? '0')!;
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
                        Constants().buildTextField('Case No', caseNoController, hint: 'Enter Case Number'),

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
                        Constants().buildTextField('CNR No', cnrNoController,hint: 'Enter CNR Number'),

                        const SizedBox(height: 15),

                        Constants().buildFinalDropdownField<Data>(
                          label: 'Status',
                          options: statusOptions,
                          selectedValue: selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                            statusValue = int.tryParse(newValue?.value ?? '2');
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Pending',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Group Type',
                          options: groupOptions,
                          selectedValue: selectedGroup,
                          onChanged: (newValue) {
                            setState(() {
                              selectedGroup = newValue;
                            });
                            groupId = int.tryParse(newValue?.value ?? '0');
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Group Type',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<String>(
                          label: 'Main/Performa',
                          options: mainPerformaOptions,
                          // 👈 List<String>
                          selectedValue: selectedMainPerforma,
                          onChanged: (newValue) {
                            setState(() {
                              selectedMainPerforma = newValue;
                            });
                          },
                          labelExtractor: (value) => value,
                          // 👈 Use value directly
                          selectHint: 'Main Party',
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
                                  selectedStatus = null;
                                  selectedGroup = null;
                                  selectedMainPerforma = null;
                                  caseNoController.clear();
                                  cnrNoController.clear();
                                });

                                currentPage = 1;
                                hasMoreData = true;
                                caseList.clear();
                                rowData.clear();
                                getCaseListDetails();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                getCaseListDetails();
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
                'Case List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Constants().buildCustomDataTable(
                      screenTitle: "Case List",
                      rowData: rowData,
                      clickableColumns: {7},
                      onIconPressed: (rowIndex, colIndex) {
                        if (colIndex == 7) {
                          final selectedCase = caseList[rowIndex];
                          final caseId = selectedCase.caseId;

                          Navigator.pushNamed(
                            context,
                            Routes().caseManagementScreen,
                           // arguments: caseId,
                            arguments: {'caseId': caseId, 'source': 'CaseRegistrationForm'},
                          );
                        }
                      },
                    ),
                    if (hasMoreData)
                      ElevatedButton(
                        onPressed: () {
                          getCaseListDetails(loadMore: true);
                        },
                        child:
                            isLoading
                                ? CircularProgressIndicator()
                                : Text("Load More"),
                      ),
                  ],
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
        unitDeptId!,
      );

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

  Future<void> getCourtTypeList(int CourtTypeId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      courtTypeOptions = await commonRepository.getCourtTypeList(context,
        CourtTypeId!,
      );

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

  Future<void> getAbbreList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      abbreOptions =
          await commonRepository
              .getAbbrevationList(context); // provide your `unitDeptId`

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

  Future<void> getGroupList(int AdmDeptId, int UnitId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      groupOptions = await commonRepository.getGroupTypeList(context,
        0,
        0,
      ); // provide your `unitDeptId`

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

  Future<void> getCaseListDetails({bool loadMore = false}) async {
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

      bool isDefaultFilter =
          selectedOffice == null &&
          selectedCourtType == null &&
          selectedAbbre == null &&
          selectedCaseYear == null &&
          selectedStatus == null &&
          selectedGroup == null &&
          (caseNoController.text.isEmpty) &&
          (cnrNoController.text.isEmpty);

      CaseReqModel req = CaseReqModel(
        admDepttId: 0,
        unitId: 0,
        officeId: int.tryParse(selectedOffice?.value ?? '0') ?? 0,
        courtTypeId: int.tryParse(selectedCourtType?.value ?? '0') ?? 0,
        abbreviationId: int.tryParse(selectedAbbre?.value ?? '0') ?? 0,
        caseYear: int.tryParse(selectedCaseYear?.value ?? '0') ?? 0,
        groupingId: int.tryParse(selectedGroup?.value ?? '0') ?? 0,
        caseStatus: int.tryParse(selectedStatus?.value ?? '0') ?? 0,
        primarySecondary: selectedMainPerforma ?? "Main_Party",
        crnNumber: cnrNoController.text,
        caseNo: int.tryParse(caseNoController.text) ?? 0,
        roleId: 0,
        oicId: 0,
        lawyerId: 0,
        districtId: 0,
        sortBy: "",
        isSortByDesc: true,
        pageNo: currentPage,
        pageSize: pageSize,
      );

      if (kDebugMode) {
        print('➡️ Raw request: ${jsonEncode(req.toJson())}');
      }
     // final encryptedRequest = {"data": EncryptionHelper.encryptData(req.toJson()),};

      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};

      final encryptedResponse = await client.getCaseList(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("✅ Decrypted response: $decryptedMap");
      }

      final response = CaseListDetailModel.fromJson( decryptedMap);

      EssentialDialogs().showProgressHud(context, false);

      if (response.status == true && response.data != null) {
        List<List<String>> newRows = [];
        for (var caseItem in response.data!) {
          newRows.add([
            caseItem.rowID.toString(),
            caseItem.caseNo.toString(),
            caseItem.abbreviationName ?? '',
            caseItem.caseYear.toString(),
            caseItem.courtName ?? '',
            caseItem.primarySecondary ?? '',
            caseItem.cRNNumber ?? '',
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
      if(kDebugMode){
        print("Error fetching data: $e");

      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

}
