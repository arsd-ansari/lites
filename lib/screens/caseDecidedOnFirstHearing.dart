import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/utils/litesAppBar.dart';

import '../../utils/constants.dart';
import '../models/essentialdialog_model.dart';
import '../models/responses/CaseListDetailModel.dart';
import '../models/responses/GetDepDropDownListModel.dart';
import '../models/responses/getCaseDecidedFirstHearingModel.dart';
import '../repository/caseApi/caseApiClient.dart';
import '../repository/commonRepository.dart';
import '../utils/EncryptionHelper.dart';
import '../utils/essentialdialog.dart';
import '../utils/routes.dart';
import '../utils/string_app.dart';

class CaseDecidedOnFirstHearingScreen extends StatefulWidget {
  String routeName = '/CaseDecidedOnFirstHearingScreen';
  CaseDecidedOnFirstHearingScreen({super.key});

  @override
  State<CaseDecidedOnFirstHearingScreen> createState() =>
      _CaseDecidedOnFirstHearingScreenState();
}

class _CaseDecidedOnFirstHearingScreenState
    extends State<CaseDecidedOnFirstHearingScreen> {
  bool _isFormVisible = false;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  final int pageSize = 20;
  bool isLoading = false;
  bool hasMoreData = true;
  List<int> caseIds = [];
  List<DataOfFirstHearing> caseList = [];


  final TextEditingController caseNoController = TextEditingController();
  final TextEditingController cnrNoController = TextEditingController();
  final CommonRepository commonRepository = CommonRepository();
  List<Data> officeOptions = [];
  List<Data> adminDeptOptions = [];
  List<Data> hodUnitDeptOptions = [];
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
  Data? selectedAdminDept;
  Data? selectedHodUnitDept;

  int? adminDeptId;
  int? unitDeptId;
  List<String> columnTitles = [
    'Sr No.',
    'Case No.',
    'Abbreviation',
    'Case Year',
    'Court Name, Court Place',
    'Case Reg Date',
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
          _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMoreData) {
        getCaseDecidedHearingDetails(loadMore: true);
      }
    });
  }

  Future<void> loadInitialData() async {
    getAdmDepList();
    // getOfficeList(0);
    getCourtTypeList(0);
    getAbbreList();
    getCaseYearList();
    getCaseDecidedHearingDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Case Decided On First Hearing Filter',
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
                          label: 'Admin Dept.',
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
                            adminDeptId = int.tryParse(newValue?.value ?? '0');
                            if (adminDeptId != null) {
                              await getUnitList(adminDeptId!);
                            }
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Admin Dept',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'HoD/Unit Dept.',
                          options: hodUnitDeptOptions,
                          selectedValue: selectedHodUnitDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedHodUnitDept = newValue;
                              selectedOffice = null;
                              officeOptions = [];
                            });
                            unitDeptId = int.tryParse(newValue?.value ?? '0')!;
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
                        Constants().buildTextField('Case No', caseNoController, hint: 'Enter Case Number'),
                        const SizedBox(height: 15),
                        Constants().buildTextField('CNR No', cnrNoController, hint: 'Enter CNR Number'),
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
                                  selectedCourtType = null;
                                  selectedAbbre = null;
                                  selectedCaseYear = null;

                                  caseNoController.clear();
                                  cnrNoController.clear();

                                  hodUnitDeptOptions = [];
                                  officeOptions = [];
                                });

                                currentPage = 1;
                                hasMoreData = true;
                                caseList.clear();
                                rowData.clear();

                                getCaseDecidedHearingDetails();},
                              style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                getCaseDecidedHearingDetails();},
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
                'Case Decided On First Hearing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Constants().buildCustomDataTableWithIcon(
                  columnTitles: columnTitles,
                  rowData: rowData,
                  iconColumns: {6: Icons.pending_actions_sharp},
                  onIconPressed: (rowIndex, colIndex) {
                    if (colIndex == 6) {
                      final selectedCase = caseList[rowIndex];
                      final caseId = selectedCase.caseId;

                      Navigator.pushNamed(
                        context,
                        Routes().caseManagementScreen,
                      //  arguments: caseId,
                        arguments: {'caseId': caseId, 'source': 'CaseDecidedOnFirstHearing'},
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

  Future<void> getCourtTypeList(int CourtTypeId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      courtTypeOptions = await commonRepository.getCourtTypeList(
          context,CourtTypeId!); // provide your `unitDeptId`

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
      await commonRepository.getAbbrevationList(context); // provide your `unitDeptId`

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

  Future<void> getCaseDecidedHearingDetails({bool loadMore = false}) async {
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


    try {
      EssentialDialogs().showProgressHud(context, true);

      CaseApiClient client = await CaseApiServiceApiclient.createService(context);

      bool isDefaultFilter = selectedOffice == null &&
          selectedCourtType == null &&
          selectedAbbre == null &&
          selectedCaseYear == null &&
          (caseNoController.text.isEmpty) &&
          (cnrNoController.text.isEmpty);

      // Build request model
      GetCaseDecidedFirstHearingReqModel req = GetCaseDecidedFirstHearingReqModel(
          admDepttId: int.tryParse(selectedAdminDept?.value ?? '0') ?? 0,
          unitId: int.tryParse(selectedHodUnitDept?.value ?? '0') ??0,
          officeId: int.tryParse(selectedOffice?.value ?? '0') ?? 0,
          courtTypeId: int.tryParse(selectedCourtType?.value ?? '0') ?? 0,
          abbreviationId: int.tryParse(selectedAbbre?.value ?? '0') ?? 0,
          caseYear: int.tryParse(selectedCaseYear?.value ?? '0') ?? 0,
          crnNumber: cnrNoController.text ?? '',
          caseNo: int.tryParse(caseNoController.text) ?? 0,
          sortBy: "",
          isSortByDesc: true,
          pageNo: currentPage,
          pageSize: pageSize // Provide proper size
      );

      if (kDebugMode) {
        print('➡️ Raw request: ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};


      final encryptedResponse = await client.getCaseDecidedFirstHearingList(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("✅ Decrypted response: $decryptedMap");
      }

      final response = GetCaseDecidedFirstHearingModel.fromJson( decryptedMap);

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
            caseItem.caseRegistrationDate != null
                ? DateFormat('dd/MM/yyyy').format(DateTime.parse(caseItem.caseRegistrationDate!))
                : '',
            "View",
          ]);
        }
        setState(() {
          if (loadMore) {
            caseList.addAll(response.data!);   // Add new items to caseList
            rowData.addAll(newRows);            // Add new rows for display
          } else {
            caseList = response.data!;          // Replace list when not loading more
            rowData = newRows;                  // Replace rows for display
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
