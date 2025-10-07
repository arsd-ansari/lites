import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import '../models/responses/reports/GetAdvanceSearchModel.dart';

class AdvanceSearch extends StatefulWidget {
  String routeName = '/AdvanceSearch';

  AdvanceSearch({super.key});

  @override
  State<AdvanceSearch> createState() => _AdvanceSearchState();
}

class _AdvanceSearchState extends State<AdvanceSearch> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  bool _isFormVisible = false;
  int? adminDeptId;
  int? unitDeptId;
  int? officeDeptId;
  String? selectedToDate;
  String? selectedFromDate;
  String? selectedEntryToDate;
  String? selectedEntryFromDate;
  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  Data? selectedOffice;
  List<Data> adminDeptOptions = [];
  List<Data> hodUnitDeptOptions = [];
  List<Data> officeOptions = [];
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  int totalPages = 1;

  final TextEditingController caseNoController = TextEditingController();
  bool isLoadingMore = false;
  List<AdvanceData> caseList = [];

  List<Data> statusOptions = [
    Data(text: 'All', value: '-1'),
    Data(text: 'Pending', value: '0'),
    Data(text: 'Decided', value: '1'),
  ];
  final List<Data> appResOptions = [
    Data(text: 'All', value: ''),
    Data(text: 'Responded', value: 'R'),
    Data(text: 'Appelant', value: 'A'),
  ];
  List<String> columnTitles = [
    'Sr No',
    'AdmDepttName',
    'UnitName',
    'OfficeName',
    'Abbr/CaseNo/CaseYear',
    'Court Name/Court Place',
    'Performa/Main',
    'CNR',
    'View',
  ];

  final List<String> mainPerformaOptions = ['Main_Party', 'Performa_Party'];
  List<Data> caseYearOptions = [];
  List<List<String>> rowData = [];
  Data? selectedCaseYear;
  Data? selectedStatus;
  int? caseYearId;
  int? statusValue;
  String? selectedMainPerforma;
  Data? selectedAppRes;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialData();
    });
  }

  initialData() async {
    await getAdmDepList();
    await getCaseYearList();
    await getAdvanceSearchDetails(page: currentPage);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoadingMore && currentPage < totalPages) {
      currentPage += 1;
      getAdvanceSearchDetails(page: currentPage, isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Advance Search Report Filter',
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
                          label: 'Adm Deptt.',
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
                            unitDeptId = int.tryParse(newValue?.value ?? '0')!;
                            if (unitDeptId != null) {
                              if (kDebugMode) {
                                print('unitiddddd-----$unitDeptId');
                              }
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
                            officeDeptId =
                                int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Office',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextField(
                          'Case No',
                          caseNoController,
                          hint: 'Enter Case Number',
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
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Status',
                          options: statusOptions,
                          selectedValue: selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                            statusValue = int.tryParse(newValue?.value ?? '-1') ?? -1;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select status',
                        ),

                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<String>(
                          label: 'Main/Performa',
                          options: mainPerformaOptions,
                          selectedValue: selectedMainPerforma,
                          onChanged: (newValue) {
                            setState(() {
                              selectedMainPerforma = newValue;
                            });
                          },
                          labelExtractor: (value) => value,
                          selectHint: 'All',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildDateFormatPickerTile(
                          label: 'Entry Date From',
                          selectedDate: selectedEntryFromDate,
                          onTap: () {
                            Constants().datePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedEntryFromDate = date);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildDateFormatPickerTile(
                          label: 'Entry Date To',
                          selectedDate: selectedEntryToDate,
                          onTap: () {
                            Constants().datePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedEntryToDate = date);
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 15),
                        Constants().buildDateFormatPickerTile(
                          label: 'Reg. Date From',
                          selectedDate: selectedFromDate,
                          onTap: () {
                            Constants().datePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedFromDate = date);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildDateFormatPickerTile(
                          label: 'Reg. Date To',
                          selectedDate: selectedToDate,
                          onTap: () {
                            Constants().datePicker(
                              context,
                              onDatePicked: (date) {
                                setState(() => selectedToDate = date);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Govt. Appl. or Res.',
                          options: appResOptions,
                          selectedValue: selectedAppRes,
                          onChanged: (newValue) {
                            setState(() {
                              selectedAppRes = newValue;
                            });
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'All',
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
                                  caseNoController.clear();
                                  selectedCaseYear = null;
                                  selectedStatus = null;
                                  statusValue = null;
                                  selectedMainPerforma = null;
                                  selectedEntryFromDate = null;
                                  selectedEntryToDate = null;
                                  selectedAppRes = null;
                                });
                                getAdvanceSearchDetails(
                                  page: 1,
                                  isPagination: false,
                                );
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
                                getAdvanceSearchDetails(
                                  page: currentPage,
                                  isPagination: false,
                                );
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
                'Advance Search Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (!isLoadingMore &&
                        scrollNotification.metrics.pixels >=
                            scrollNotification.metrics.maxScrollExtent - 100) {
                      if (currentPage < totalPages) {
                        loadMore();
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
    await getAdvanceSearchDetails(page: nextPage, isPagination: true);
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

  Future<void> getAdmDepList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      adminDeptOptions = await commonRepository.getAdminDepartments(context);

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

  Future<void> getUnitList(int adminDeptId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      hodUnitDeptOptions = await commonRepository.getUnits(
        context,
        adminDeptId,
      ); //

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

  Future<void> getOfficeList(int unitDeptId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      officeOptions = await commonRepository.getOfficeList(
        context,
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

  Future<void> getCaseYearList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      caseYearOptions = await commonRepository.getYearList(context);

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

  Future getAdvanceSearchDetails({
    int page = 1,
    bool isPagination = false,
  }) async {
    try {
      if (!isPagination) EssentialDialogs().showProgressHud(context, true);
      isLoadingMore = true;

      ReportApiClient client = await ReportApiServiceApiclient.createService(
        context,
      );
      GetAdvanceSearchReqModel req = GetAdvanceSearchReqModel();
      req.admDepttId = adminDeptId ?? -1;
      req.unitId = unitDeptId ?? -1;
      req.officeId = officeDeptId ?? -1;
      req.caseNo = int.parse(caseNoController.text.trim()) ?? 0;
      req.caseYear = caseYearId ?? -1;
      req.status = int.tryParse(selectedStatus?.value ?? '-1') ?? -1;
      req.primarySecondary = selectedMainPerforma ?? '';
      req.appellantOrResponded = selectedAppRes?.value ?? '';
      req.entryDateFrom = selectedEntryFromDate ?? '';
      req.entryDateTo = selectedEntryToDate ?? '';
      req.regDateFrom = selectedFromDate ?? '';
      req.regDateTo = selectedToDate ?? '';
      req.courtTypeIds = '';
      req.abbreviationId = -1;
      req.priorityId = -1;
      req.subPriorityId = -1;
      req.caseType = -1;
      req.lawyerIds = '';
      req.oicIds = '';
      req.subjectCategoryId = -1;
      req.subjectSubCategoryId = -1;
      req.subjectMatterId = -1;
      req.subjectSubMatterId = -1;
      req.appellantName = '';
      req.respondedName = '';
      req.hearingDateFrom = '';
      req.hearingDateTo = '';
      req.nextHearingDateFrom = '';
      req.nextHearingDateTo = '';
      req.decisionDateFrom = '';
      req.decisionDateTo = '';
      req.decisionEntryDateFrom = '';
      req.decisionEntryDateTo = '';
      req.districtIds = '';
      req.decisionFA = -1;
      req.specialAppearance = -1;
      req.oicMobileNo = '';
      req.rEImplication = '';
      req.doesPOA = -1;
      req.doesPAPD = -1;
      req.crnNumber = '';
      req.stayFA = -1;
      req.lawOICNotAppointed = -1;
      req.replyFiled = -1;
      req.groupingId = -1;
      req.bench = '';
      req.replyFileDateFrom = '';
      req.replyFileDateTo = '';
      req.pDFinalDecisionofGovtYN = -1;
      req.pDFinalDecisionofGovtDateFrom = '';
      req.pDFinalDecisionofGovtDateTo = '';
      req.selectedColumns =
          '';
      req.sortBy = '';
      req.isSortByDesc = false;
      req.pageNo = page;
      req.pageSize = 10;

      if (kDebugMode) {
        print(
          'getAdvanceSearchDetails - raw request - ${jsonEncode(req.toJson())}',
        );
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getAdvanceSearchDetails(
        encryptedRequest,
      );

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap = await EncryptionHelper.decryptData(
        responseJson["Data"],
      );

      if (kDebugMode) {
        print("Decrypted getAdvanceSearchDetails response: $decryptedMap");
      }

      final response = GetAdvanceSearchResponseModel.fromJson(decryptedMap);

      if (!isPagination) EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;

      if ((response.status ?? false) && response.data != null) {
        List<AdvanceData> newCases = response.data!;
        List<List<String>> newRows =
            newCases.map((caseItem) {
              return [
                caseItem.rowID.toString(),
                caseItem.admDepttName ?? '',
                caseItem.unitName?.toString() ?? '',
                caseItem.officeName?.toString() ?? '',
                caseItem.abbrCaseNoCaseYear?.toString() ?? '',
                caseItem.courtNameCourtPlace?.toString() ?? '',
                caseItem.performaMain?.toString() ?? '',
                caseItem.cNR?.toString() ?? '',
                '',
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
            totalPages =
                (response.pagination![0].totalRecords! / req.pageSize!).ceil();
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
        print('getAdvanceSearchDetails - error - $e');
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
