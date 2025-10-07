import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/repository/masterApi/masterApiClient.dart';

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
import '../models/responses/reports/GetCauseDropDownListModel.dart';
import '../models/responses/reports/GetCauseListResponseModel.dart';

class CauseListData extends StatefulWidget {
  String routeName = '/CauseListData';

  CauseListData({super.key});

  @override
  State<CauseListData> createState() => _CauseListDataState();
}

class _CauseListDataState extends State<CauseListData> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  bool _isFormVisible = false;
  bool isLoading = true;
  int? lawyerId;
  int? oicId;
  int? officeDeptId;
  String? selectedToDate;
  String? selectedFromDate;
  CauseDDData? selectedLawyer;
  CauseDDData? selectedOicDept;
  Data? selectedOffice;
  Data? selectedCourtType;
  Data? selectedCauseType;
  CauseDDData? selectedCourtRoomType;
  CauseDDData? selectedJudgeType;
  CauseDDData? selectedDeptDDType;
  Data? selectedRecordType;
  String? courtTypeId;

  String? causeTypeId;
  int? courtRoomTypeId;
  String? judgeTypeId;
  String? deptDDTypeId;
  String? recordTypeId;
  List<CauseDDData> lawyerOptions = [];
  List<CauseDDData> oicOptions = [];
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  int totalPages = 1;
  List<Data> courtTypeOptions = [
    Data(text: 'High Court Jaipur', value: 'JP'),
    Data(text: 'High Court Jodhpur', value: 'JU'),
  ];
  List<Data> causeListTypeOptions = [
    Data(text: 'All', value: ''),
    Data(text: 'Daily', value: 'D'),
    Data(text: 'Supplymentary', value: 'S'),
    Data(text: 'Weekly', value: 'W'),
    Data(text: 'Regular', value: 'R'),
  ];
  List<Data> recordTypeOptions = [
    Data(text: 'Cause List Record', value: '1'),
    Data(text: 'Match By CNR', value: '2'),
    Data(text: 'Match By Case No. & Year', value: '3'),
    Data(text: 'Un-Match Records', value: '4'),
  ];
  List<CauseDDData> courtRoomOptions = [];
  List<CauseDDData> judgeNameOptions = [];
  List<CauseDDData> deptDDOptions = [];
  bool isLoadingMore = false;
  List<CauseData> caseList = [];

  List<String> columnTitles = [
    'Sr No',
    'Date',
    'Case Type/No/CNR',
    'Title of The Case',
    'Name of Advocate',
    'Name of Deptt.(HighCourt/Lites)',
    'Name of Advocate',
    'Name of OIC',
    'Action',
  ];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    selectedCourtType = courtTypeOptions.firstWhere(
      (data) => data.text == 'High Court Jodhpur',
      orElse: () => Data(text: '', value: ''),
    );
    courtTypeId = selectedCourtType?.value ?? 'JU';

    selectedCauseType = causeListTypeOptions.firstWhere(
      (data) => data.text == 'All',
      orElse: () => Data(text: '', value: ''),
    );
    causeTypeId = selectedCauseType?.value ?? '0';

    selectedRecordType = recordTypeOptions.firstWhere(
      (data) => data.text == 'Cause List Record',
      orElse: () => Data(text: '', value: ''),
    );
    recordTypeId = selectedRecordType?.value ?? '1';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initializeData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {
    List<Future<void>> futures = [
      getCourtRoomList(context, selectedFromDate, selectedToDate, courtTypeId),
      getJudgeList(context, selectedFromDate, selectedToDate, courtTypeId),
      getCauseDDList(context),
      //   getLawyerList(context),
      //   getOicList(context),
      getCauseListDetails(page: currentPage),
    ];

    await Future.wait(futures);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        currentPage < totalPages) {
      currentPage += 1;
      getCauseListDetails(page: currentPage, isPagination: true);
    }
  }

  void loadMore() async {
    if (isLoadingMore || currentPage >= totalPages) return;

    setState(() => isLoadingMore = true);

    int nextPage = currentPage + 1;

    await getCauseListDetails(page: nextPage, isPagination: true);

    setState(() {
      currentPage = nextPage;
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Cause List Filter',
        onBackPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                      child: Text(
                        _isFormVisible ? 'Hide Filter' : 'Show Filter',
                      ),
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
                          const SizedBox(height: 15),
                          Constants().buildDateFormatPickerTile(
                            label: 'Case List From',
                            selectedDate: selectedFromDate,
                            onTap: () {
                              Constants().futureDateFormatPicker(
                                context,
                                onDatePicked: (date) {
                                  setState(() => selectedFromDate = date);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          Constants().buildDateFormatPickerTile(
                            label: 'Case List To',
                            selectedDate: selectedToDate,
                            onTap: () async {
                              Constants().futureDateFormatPicker(
                                context,
                                onDatePicked: (date) {
                                  setState(() => selectedToDate = date);
                                },
                              );
                            },
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
                              courtTypeId = newValue?.value ?? '0';
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Select Court Type',
                          ),
                          const SizedBox(height: 15),

                          Constants().buildFinalDropdownField<Data>(
                            label: 'Cause List Type',
                            options: causeListTypeOptions,
                            selectedValue: selectedCauseType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCauseType = newValue;
                              });
                              causeTypeId = newValue?.value ?? '0';
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Select Cause List Type',
                          ),
                          const SizedBox(height: 15),

                          Constants().buildFinalDropdownField<CauseDDData>(
                            label: 'Court Room',
                            options: courtRoomOptions,
                            selectedValue: selectedCourtRoomType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCourtRoomType = newValue;
                              });
                              courtRoomTypeId = int.parse(
                                newValue?.value ?? '0',
                              );
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Select Court Room',
                          ),
                          const SizedBox(height: 15),

                          Constants().buildFinalDropdownField<CauseDDData>(
                            label: 'Honourable Judge',
                            options: judgeNameOptions,
                            selectedValue: selectedJudgeType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedJudgeType = newValue;
                              });
                              judgeTypeId = newValue?.value ?? '0';
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Select Honourable Judge',
                          ),
                          const SizedBox(height: 15),
                          Constants().buildFinalDropdownField<CauseDDData>(
                            label: 'Department Name',
                            options: deptDDOptions,
                            selectedValue: selectedDeptDDType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedDeptDDType = newValue;
                              });
                              deptDDTypeId = newValue?.value ?? '0';
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Select Department Name',
                          ),
                          const SizedBox(height: 15),

                          Constants().buildFinalDropdownField<CauseDDData>(
                            label: 'Lawyer',
                            options: lawyerOptions,
                            selectedValue: selectedLawyer,
                            onChanged: (newValue) async {
                              setState(() {
                                selectedLawyer = newValue;
                              });
                              lawyerId =
                                  int.tryParse(newValue?.value ?? '0') ?? 0;
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Select Lawyer',
                          ),
                          const SizedBox(height: 15),
                          // Added vertical spacing
                          Constants().buildFinalDropdownField<CauseDDData>(
                            label: 'OIC',
                            options: oicOptions,
                            selectedValue: selectedOicDept,
                            onChanged: (newValue) async {
                              setState(() {
                                selectedOicDept = newValue;
                              });
                              oicId = int.tryParse(newValue?.value ?? '0') ?? 0;
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Select OIC',
                          ),

                          const SizedBox(height: 15),
                          Constants().buildFinalDropdownField<Data>(
                            label: 'Record Type',
                            options: recordTypeOptions,
                            selectedValue: selectedRecordType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedRecordType = newValue;
                              });
                              recordTypeId = newValue?.value ?? '0';
                            },
                            labelExtractor: (data) => data.text ?? '',
                            selectHint: 'Record Type',
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedFromDate = null;
                                    selectedToDate = null;
                                    selectedCourtType = null;
                                    selectedCauseType = null;
                                    selectedCourtRoomType = null;
                                    selectedJudgeType = null;
                                    selectedDeptDDType = null;
                                    selectedLawyer = null;
                                    selectedOicDept = null;
                                    selectedRecordType = null;
                                    rowData.clear();
                                  });
                                  getCauseListDetails(
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
                                  if (selectedFromDate == null ||
                                      selectedToDate == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select both "Case List From" and "Case List To" dates.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    currentPage = 1;
                                    rowData.clear();
                                  });
                                  getCauseListDetails(page: 1);
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
                  'Cause List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (!isLoadingMore &&
                          scrollNotification.metrics.pixels >=
                              scrollNotification.metrics.maxScrollExtent -
                                  100) {
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
      ),
    );
  }

  Future<void> getCourtRoomList(
    BuildContext context,
    String? selectedFromDate,
    String? selectedToDate,
    String? courtTypeId,
  ) async {
    if (!mounted) return;

    EssentialDialogs().showProgressHud(context, true);

    try {
      final client = await ReportApiServiceApiclient.createService(context);

      final fromDate = selectedFromDate ?? '1947-01-01';
      final toDate =
          (selectedToDate?.isNotEmpty == true)
              ? selectedToDate!
              : DateFormat('yyyy-MM-dd').format(DateTime.now());
      final courtType = courtTypeId ?? 'JU';

      final response = await client.getCourtRoomDetails(
        fromDate,
        toDate,
        courtType,
      );

      if (mounted) {
        setState(() {
          courtRoomOptions =
              (response != null &&
                      response.status == true &&
                      response.data != null)
                  ? response.data!
                  : [];
        });
      }
    } catch (e) {
      if (mounted) {
        await EssentialDialogs().openOkDismissDialog(
          context,
          EssentialDialogModel(
            appTitle: String_App().appname,
            appMessage: e.toString(),
          ),
        );
      }
    } finally {
      if (mounted) {
        EssentialDialogs().showProgressHud(context, false);
      }
    }
  }

  Future<void> getJudgeList(
    BuildContext context,
    String? selectedFromDate,
    String? selectedToDate,
    String? selectedCourtType,
  ) async {
    if (!mounted) return;
    EssentialDialogs().showProgressHud(context, true);
    try {
      final client = await ReportApiServiceApiclient.createService(context);

      final fromDate = selectedFromDate ?? '1947-01-01';
      final toDate =
          (selectedToDate?.isNotEmpty == true)
              ? selectedToDate!
              : DateFormat('yyyy-MM-dd').format(DateTime.now());

      final courtType =
          (courtTypeId?.isNotEmpty ?? false) ? courtTypeId! : 'JU';

      final response = await client.getJudgeNameDetails(
        fromDate,
        toDate,
        courtType,
      );

      if (mounted) {
        setState(() {
          judgeNameOptions =
              (response.status == true && response.data != null)
                  ? response.data!
                  : [];
        });
      }
    } catch (e) {
      if (mounted) {
        await EssentialDialogs().openOkDismissDialog(
          context,
          EssentialDialogModel(
            appTitle: String_App().appname,
            appMessage: e.toString(),
          ),
        );
      }
    } finally {
      if (mounted) {
        EssentialDialogs().showProgressHud(context, false);
      }
    }
  }

  Future<void> getCauseDDList(BuildContext context) async {
    if (!mounted) return;

    EssentialDialogs().showProgressHud(context, true);

    try {
      final client = await ReportApiServiceApiclient.createService(context);
      final response = await client.getCauseDeptDDDetails();

      if (mounted) {
        setState(() {
          deptDDOptions =
              response.status == true && response.data != null
                  ? response.data!
                  : [];
        });
      }
    } catch (e) {
      if (mounted) {
        await EssentialDialogs().openOkDismissDialog(
          context,
          EssentialDialogModel(
            appTitle: String_App().appname,
            appMessage: e.toString(),
          ),
        );
      }
    } finally {
      if (mounted) {
        EssentialDialogs().showProgressHud(context, false);
      }
    }
  }

  Future<void> getLawyerList(BuildContext context) async {
    if (!mounted) return;

    EssentialDialogs().showProgressHud(context, true);

    try {
      final client = await MasterApiServiceApiclient.createService(context);
      final response = await client.getCauseLawyerList();

      if (mounted) {
        setState(() {
          lawyerOptions =
              response.status == true && response.data != null
                  ? response.data!
                  : [];
        });
      }
    } catch (e) {
      if (mounted) {
        await EssentialDialogs().openOkDismissDialog(
          context,
          EssentialDialogModel(
            appTitle: String_App().appname,
            appMessage: e.toString(),
          ),
        );
      }
    } finally {
      if (mounted) {
        EssentialDialogs().showProgressHud(context, false);
      }
    }
  }

  Future<void> getOicList(BuildContext context) async {
    if (!mounted) return;

    EssentialDialogs().showProgressHud(context, true);

    try {
      final client = await MasterApiServiceApiclient.createService(context);
      final response = await client.getCauseOicList(0);

      if (mounted) {
        setState(() {
          oicOptions =
              response.status == true && response.data != null
                  ? response.data!
                  : [];
        });
      }
    } catch (e) {
      if (mounted) {
        await EssentialDialogs().openOkDismissDialog(
          context,
          EssentialDialogModel(
            appTitle: String_App().appname,
            appMessage: e.toString(),
          ),
        );
      }
    } finally {
      if (mounted) {
        EssentialDialogs().showProgressHud(context, false);
      }
    }
  }

  Future<void> getCauseListDetails({
    int page = 1,
    bool isPagination = false,
  }) async {
    try {
      if (!isPagination) EssentialDialogs().showProgressHud(context, true);
      isLoadingMore = true;

      ReportApiClient client = await ReportApiServiceApiclient.createService(
        context,
      );
      CauseListReqModel req = CauseListReqModel();

      final String defaultFromDate = "1947-01-01";
      final String defaultToDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());

      req.causeListDateFrom = selectedFromDate ?? defaultFromDate;
      req.causeListDateTo = selectedToDate ?? defaultToDate;
      req.estt = selectedCourtType?.value.toString() ?? 'JU';
      req.causeListType = selectedCauseType?.value.toString() ?? '';
      req.courtRoom =
          int.tryParse(selectedCourtRoomType?.value.toString() ?? '') ?? 0;
      req.judgeName = selectedJudgeType?.value.toString() ?? '';
      req.departmentName = selectedDeptDDType?.value.toString() ?? '';
      req.lawyerId = int.tryParse(selectedLawyer?.value.toString() ?? '') ?? 0;
      req.oicId = int.tryParse(selectedOicDept?.value.toString() ?? '') ?? 0;
      req.recordsType = selectedRecordType?.value.toString() ?? '1';
      req.pageNo = page;
      req.pageSize = 20;

      if (kDebugMode) {
        print(
          'getCauseListDetails - raw request - ${jsonEncode(req.toJson())}',
        );
      }

      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getCauseListDetails(
        encryptedRequest,
      );

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap = await EncryptionHelper.decryptData(
        responseJson["Data"],
      );

      if (kDebugMode) {
        print("Decrypted getCauseListDetails response: $decryptedMap");
      }

      final response = GetCauseListResponseModel.fromJson(decryptedMap);

      if ((response.status ?? false) && response.data != null) {
        List<CauseData> newCases = response.data!;
        List<List<String>> newRows =
            newCases.map((caseItem) {
              return [
                caseItem.rowID?.toString() ?? '',
                caseItem.causelistDate ?? '',
                caseItem.cno?.toString() ?? '',
                caseItem.caseTitle?.toString() ?? '',
                caseItem.advocateName?.toString() ?? '',
                caseItem.deparmentName?.toString() ?? '',
                caseItem.lawyerName?.toString() ?? '',
                caseItem.oICName?.toString() ?? '',
                "View",
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
        EssentialDialogModel appDialog =
            EssentialDialogModel()
              ..appTitle = String_App().appname
              ..appMessage = response.message ?? "Something Went Wrong..!!";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e) {
      if (kDebugMode) print('getCauseListDetails - error - $e');
      if (e is DioException) {
        ServerErrorPage.withError(error: e, context: context);
      } else {
        ServerErrorPage.withError(error: e as DioException, context: context);
      }
    } finally {
      if (!isPagination) EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;
    }
  }
}
