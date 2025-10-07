import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/utils/AppConstants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/reports/GetTalkingPointsReportModel.dart';
import '../../repository/commonRepository.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/string_app.dart';

class ReportData {
  final String srNo;
  final String title;
  final List<SubItem> subItems;
  final dynamic value;

  ReportData({
    required this.srNo,
    required this.title,
    required this.subItems,
    this.value,
  });
}

class SubItem {
  final String label;
  final dynamic value;

  SubItem({required this.label, required this.value});
}

class TalkingPointsReport extends StatefulWidget {
  String routeName = '/TalkingPointsReport';

  TalkingPointsReport({super.key});

  @override
  State<TalkingPointsReport> createState() => _TalkingPointsReportState();
}

class _TalkingPointsReportState extends State<TalkingPointsReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  bool _isFormVisible = false;
  String? selectedToDate;
  String? selectedFromDate;

  late _TalkingPointDataSource _talkingPointDataSource;
  List<ReportData> _talkingPointReportData = [];
  GetTalkingPointsReportModel? _apiResponseData;

  bool isLoading = false;
  bool hasData = false;
  List<Data> adminDeptOptions = [];
  List<Data> hodUnitDeptOptions = [];
  List<Data> officeOptions = [];
  List<Data> districtOptions = [];
  List<String> statusOptions = ['All', 'Pending', 'Decided'];
  List<String> mainPerformaOptions = ['Main Party', 'Performa Party'];

  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  Data? selectedOffice;
  Data? selectedDist;
  String? selectedStatus;
  String? selectedMainPerforma;

  int? adminDeptId;
  int? unitDeptId;
  int? officeDeptId;
  int? distId;

  @override
  void initState() {
    super.initState();

    _talkingPointDataSource = _TalkingPointDataSource(reportData: []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialFilterOptions(); // Fetch dropdown options
      _getTalkingPointsReportDetails(); // Fetch initial report data
    });
  }

  Future<void> _fetchInitialFilterOptions() async {
    await getAdmDepList();
    await getDistrict(0, 0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Talking Points Report Filter',
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
                        // Changed to buildFinalDropdownField for consistency if you have Data model
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Department',
                          options: adminDeptOptions, // Use fetched options
                          selectedValue: selectedAdminDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedAdminDept = newValue;
                              // Reset dependent dropdowns if necessary
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
                          options: hodUnitDeptOptions, // Use fetched options
                          selectedValue: selectedHodUnitDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedHodUnitDept = newValue;
                              selectedOffice = null;
                              officeOptions = [];
                            });
                            unitDeptId = int.tryParse(newValue?.value ?? '0');
                            if (unitDeptId != null) {
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
                            officeDeptId = int.tryParse(newValue?.value ?? '0');
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Office',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'District',
                          options: districtOptions,
                          selectedValue: selectedDist,
                          onChanged: (newValue) {
                            setState(() {
                              selectedDist = newValue;
                            });
                            distId = int.tryParse(newValue?.value ?? '0');
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select District',
                        ),

                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Label outside the Outline
                              const Text(
                                'Status',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: selectedStatus,
                                hint: const Text('Status'), // Shows when no value is selected
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                ),
                                dropdownColor: Colors.white,
                                items: statusOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Label shown outside
                              const Text(
                                'Main/Performa',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: selectedMainPerforma,
                                hint: const Text('Main Party'), // Shows when no value is selected
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                ),
                                dropdownColor: Colors.white,
                                items: mainPerformaOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMainPerforma = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
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
                                  // Reset all filter values
                                  selectedAdminDept = null;
                                  selectedHodUnitDept = null;
                                  selectedOffice = null;
                                  selectedDist = null;
                                  selectedStatus = null;
                                  selectedMainPerforma = null;
                                  selectedFromDate = null;
                                  selectedToDate = null;

                                  adminDeptId = null;
                                  unitDeptId = null;
                                  officeDeptId = null;
                                  distId = null;

                                  hodUnitDeptOptions = [];
                                  officeOptions = [];

                                  _fetchInitialFilterOptions();
                                });
                                _getTalkingPointsReportDetails(); // Re-fetch data with reset filters
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
                                  _isFormVisible = false; // Hide filter form on search
                                });
                                _getTalkingPointsReportDetails(); // Fetch data based on current filters
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
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: {
                    0: FixedColumnWidth(35),
                    1: FlexColumnWidth(20),
                    2: FlexColumnWidth(10),
                    3: FlexColumnWidth(10),
                  },
                  children: [
                    // Table Header
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        _buildHeaderCell('Sr No'),
                        _buildHeaderCell('Talking Point'),
                        _buildHeaderCell('Sub Item'),
                        _buildHeaderCell('Value'),
                      ],
                    ),
                    // Table Body
                    ..._buildTableRows(_talkingPointReportData),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows(List<ReportData> data) {
    final List<TableRow> rows = [];
    for (var item in data) {
      if (item.subItems.isNotEmpty) {
        // ✅ Main Point with Sub Items
        // Main point
        rows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.srNo ?? '-'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.title),
            ),
            // First Sub Item
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.subItems.first.label ?? '-'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.subItems.first.value?.toString() ?? '-'),
            ),
          ],
        ),
        );
        // Additional Sub Items
        for (int i = 1; i < item.subItems.length; i++) {
          rows.add(TableRow(
            children: [
              const SizedBox.shrink(),
              const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item.subItems[i].label ?? '-'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item.subItems[i].value?.toString() ?? '-'),
              ),
            ],
          ));
        }
      } else {
        // ✅ No Sub Items
        rows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.srNo ?? '-'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.title),
            ),
            const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.value?.toString() ?? '-'),
            ),
          ],
        ));
      }
    }
    return rows;
  }


  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCell(String text, {bool isTopAligned = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isTopAligned ? Alignment.topLeft : Alignment.centerLeft,
        child: Text(text),
      ),
    );
  }
  Widget buildGovernmentInfo() {
    return Container(
        padding: const EdgeInsets.all(12), // Optional: add padding inside the background
        color: Colors.blue.shade100, // 🔴 Set your background color here
        child:
        Column(
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
                  fontWeight: FontWeight.bold,fontSize: 12, color: Colors.red),
            ),
            const SizedBox(height: 5),
            Text(
              // '${selectedStatus.toString() + selectedMainPerforma.toString() ?? 'Pending_Main Party'}',
              '${selectedStatus?.toString() ?? 'Pending'}_${selectedMainPerforma?.toString() ?? 'Main Party'}',

              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              '(${selectedAdminDept?.text.toString() ?? 'Administrative Department'} Wise Talking Points Report )',
              style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 5),

          ],
        ));
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

      officeOptions = await commonRepository.getOfficeList(context,unitDeptId!); // provide your `unitDeptId`

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


  Future<void> getDistrict(int DivisionId, int StateId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      districtOptions = await commonRepository.getDistricts(
        context,0,
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

  Future<void> _getTalkingPointsReportDetails() async {
    try {
      setState(() {
        isLoading = true;
        hasData = false;
      });
      EssentialDialogs().showProgressHud(context, true);
      final client = await ReportApiServiceApiclient.createService(context);

      final String defaultToDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      final req = TalkingPointsReportReqModel()
        ..paging = false
        ..currentPageID = 0
        ..totalPages = 0
        ..startPageNumber = 0
        ..endPageNumber = 0
        ..totalRecords = 0
        ..startRecord = 0
        ..endRecord = 0
        ..pageSize = 0
        ..pageUrl = ""
        ..ajaxUrl = ""
        ..sortingColumn = ""
        ..sortingOrder = 1
        ..searchText = ""
        ..searchParameter = (SearchParameter()
          ..status = selectedStatus ?? 'Pending'
          ..mainPerforma = selectedMainPerforma?? 'Main_Party'
          ..roleid = '1'
          // ..roleid = AppConstants.user!.authenticationResponse?[0].roleId.toString() ?? ''
            ..admDepttId = selectedAdminDept?.value ?? '0'
            ..unitId = selectedHodUnitDept?.value ?? '0'
            ..officeId = selectedOffice?.value ?? '0'
            ..districtId = selectedDist?.value ?? '0'
            ..fromdate = selectedFromDate ?? '01/01/1947'
            ..todate = selectedToDate ?? defaultToDate
            ..additionalProp1 =  ''
            ..additionalProp2 =  ''
            ..additionalProp3 =  ''
        );

    //  final encryptedRequest = {"data": EncryptionHelper.encryptData(req.toJson())};
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getTalkingPointsReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptDataList(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted Talking Points response: $decryptedMap");
      }

      if (decryptedMap is List) {
        final results = decryptedMap
            .map((item) => GetTalkingPointsReportModel.fromJson(item as Map<String, dynamic>))
            .toList();

        if (results.isNotEmpty) {
          final mappedData = results
              .expand((element) => _mapApiDataToTalkingPointReportData(element))
              .toList();

          setState(() {
            _talkingPointReportData = mappedData;
            _talkingPointDataSource = _TalkingPointDataSource(reportData: _talkingPointReportData);
            hasData = true;
          });
        } else {
          await _showNoDataFound();
        }
      } else {
        await _showNoDataFound();
      }
    } catch (e) {
      if (kDebugMode) {
        print('TalkingPointsReport - error - $e');
      }

      EssentialDialogModel appDialog = EssentialDialogModel();
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = "Failed to load report: ${e.toString()}";
      await EssentialDialogs().openOkDismissDialog(context, appDialog);

      setState(() {
        hasData = false;
        _talkingPointReportData = [];
        _talkingPointDataSource = _TalkingPointDataSource(reportData: []);
      });
    } finally {
      EssentialDialogs().showProgressHud(context, false);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showNoDataFound() async {
    EssentialDialogModel appDialog = EssentialDialogModel();
    appDialog.appTitle = String_App().appname;
    appDialog.appMessage = "No data found for the selected filters.";
    await EssentialDialogs().openOkDismissDialog(context, appDialog);
    setState(() {
      hasData = false;
      _talkingPointReportData = [];
      _talkingPointDataSource = _TalkingPointDataSource(reportData: []);
    });
  }

  List<ReportData> _mapApiDataToTalkingPointReportData(GetTalkingPointsReportModel apiData) {
    final List<ReportData> mappedData = [];

    final List<SubItem> subItems1 = [
      if ((apiData.totalCases ?? 0) > 0) SubItem(label: 'Total Cases Registered', value: apiData.totalCases ?? 0),
      if ((apiData.appellantCountNot ?? 0) > 0) SubItem(label: 'Entry not in Appellant', value: apiData.appellantCountNot ?? 0),
      if ((apiData.respondantCountNot ?? 0) > 0) SubItem(label: 'Entry not in Respondent', value: apiData.respondantCountNot ?? 0),
      if ((apiData.oicCountNot ?? 0) > 0) SubItem(label: 'Entry not in OIC', value: apiData.oicCountNot ?? 0),
      if ((apiData.lawyerCountNot ?? 0) > 0) SubItem(label: 'Entry not in Lawyer', value: apiData.lawyerCountNot ?? 0),
      if ((apiData.hearingCountNot ?? 0) > 0) SubItem(label: 'Entry not in Hearing', value: apiData.hearingCountNot ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '1',
      title: 'Maintenance of LITES Sheets in Court case files and progress of Data entries made in registration(F1) and not made in other details (Appellant,Respondent,Lawyer, OIC and Hearing)',
      subItems: subItems1,
      value: subItems1.isEmpty ? apiData.totalCases ?? 0 : null,
    ));

    final List<SubItem> subItems2 = [
      if ((apiData.hearingDateBlank ?? 0) > 0) SubItem(label: 'Date is Blank', value: apiData.hearingDateBlank ?? 0),
      if ((apiData.outDatedHearingDate ?? 0) > 0) SubItem(label: 'Next Hearing Date Not updated', value: apiData.outDatedHearingDate ?? 0),
      if ((apiData.dueCourses ?? 0) > 0) SubItem(label: 'Cases to be updated (in Due Course)', value: apiData.dueCourses ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '2',
      title: 'Next Hearing Status',
      subItems: subItems2,
      value: subItems2.isEmpty ? apiData.hearingDateBlank ?? 0 : null,
    ));
    mappedData.add(ReportData(
      srNo: '3',
      title: 'Review of duplicate cases',
      subItems: [],
      value: apiData.duplicateCases ?? 0,
    ));

    final List<SubItem> subItems4 = [
      if ((apiData.registraionLessDecisionDate ?? 0) > 0) SubItem(label: 'Decision Date < Registration Date', value: apiData.registraionLessDecisionDate ?? 0),
      if ((apiData.registraionLessHearingDate ?? 0) > 0) SubItem(label: 'Hearing Date < Registration Date', value: apiData.registraionLessHearingDate ?? 0),
      if ((apiData.decisionLessHearingDate ?? 0) > 0) SubItem(label: 'Decision Date < Hearing Date', value: apiData.decisionLessHearingDate ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '4',
      title: 'Overall validation report and progress of updation',
      subItems: subItems4,
      value: subItems4.isEmpty ? 0 : null,
    ));

    mappedData.add(ReportData(
      srNo: '5',
      title: 'Red Category',
      subItems: [],
      value: apiData.redCount ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '6',
      title: 'Duplicate records',
      subItems: [],
      value: apiData.duplicateCasesSameDept ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '7',
      title: 'Reply not filed',
      subItems: [],
      value: apiData.replyFileCout ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '8',
      title: 'Number of cases remaining from Approved reply submitted to Lawyer',
      subItems: [],
      value: 0,
    ));

    mappedData.add(ReportData(
      srNo: '9',
      title: 'Stay Granted',
      subItems: [],
      value: apiData.stayGranted ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '10',
      title: 'Stay in Govt. Favor',
      subItems: [],
      value: apiData.stayInGovtFavour ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '11',
      title: 'Stay in Govt. Against',
      subItems: [],
      value: apiData.stayInGovtAgainst ?? 0,
    ));

    final List<SubItem> subItems11 = [
      if ((apiData.totalCnrPending ?? 0) > 0) SubItem(label: 'Total', value: apiData.totalCnrPending ?? 0),
      if ((apiData.highCourtJpr ?? 0) > 0) SubItem(label: 'High Court Jaipur', value: apiData.highCourtJpr ?? 0),
      if ((apiData.highCourtJODH ?? 0) > 0) SubItem(label: 'High Court Jodhpur', value: apiData.highCourtJODH ?? 0),
      if ((apiData.otherSubOrdCourt ?? 0) > 0) SubItem(label: 'Other Sub Ordinate Court', value: apiData.otherSubOrdCourt ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '12',
      title: 'CNR (Case Number Record) Not Updated',
      subItems: subItems11,
      value: subItems11.isEmpty ? 0 : null,
    ));

    mappedData.add(ReportData(
      srNo: '13',
      title: 'Document Not Uploaded (Case Register After 01-08-2017)',
      subItems: [],
      value: apiData.documentUpload ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '14',
      title: 'Contempt Case',
      subItems: [],
      value: apiData.contemptCaseCount ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '15',
      title: 'Public Interest Litigation (PIL) Cases',
      subItems: [],
      value: apiData.pilCount ?? 0,
    ));

    return mappedData;
  }

}

class _TalkingPointDataSource extends DataGridSource {
  _TalkingPointDataSource({required List<ReportData> reportData}) {
    _rows = _buildRows(reportData);
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  List<DataGridRow> _buildRows(List<ReportData> dataList) {
    final List<DataGridRow> rows = [];
    for (var data in dataList) {
      if (data.subItems.isNotEmpty) {
        // 1. Main Point row
        rows.add(
          DataGridRow(cells: [
            DataGridCell(columnName: 'sr_no', value: data.srNo),
            DataGridCell(columnName: 'title_subitems', value: data),
            const DataGridCell(columnName: 'value', value: null),
          ]),
        );
        // 2. Sub Item rows
        for (var subItem in data.subItems) {
          rows.add(
            DataGridRow(cells: [
              const DataGridCell(columnName: 'sr_no', value: null),
              const DataGridCell(columnName: 'title_subitems', value: null),
              DataGridCell(columnName: 'value', value: {
                'label': subItem.label,
                'value': subItem.value,
              }),
            ]),
          );
        }
      } else {
        // Single row when no subItems
        rows.add(
          DataGridRow(cells: [
            DataGridCell(columnName: 'sr_no', value: data.srNo),
            DataGridCell(columnName: 'title_subitems', value: data),
            DataGridCell(columnName: 'value', value: data.value ?? '-'),
          ]),
        );
      }
    }
    return rows;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final srNo = row.getCells()[0]?.value;
    final titleData = row.getCells()[1]?.value;
    final valueData = row.getCells()[2]?.value;

    if (titleData != null && titleData is ReportData) {
      // This is a parent row
      return DataGridRowAdapter(cells: [
        // Sr No
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(srNo?.toString() ?? '-'),
        ),
        // Main title
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            titleData.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            softWrap: true,
            overflow: TextOverflow.clip,
          ),
        ),
        // Value
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: titleData.subItems.isEmpty
              ? Text(titleData.value?.toString() ?? '-')
              : const Text(''),
        ),
      ]);
    } else {
      final label = valueData != null && valueData is Map
          ? valueData['label'].toString()
          : '';
      final value = valueData != null && valueData is Map
          ? valueData['value'].toString()
          : '-';
      return DataGridRowAdapter(cells: [
        // Sr No
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: const Text(''),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Text(label, softWrap: true, overflow: TextOverflow.clip),
        ),
        // Value
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: Text(value),
        ),
      ]);
    }
  }
}












/*

class ReportData {
  final String srNo;
  final String title;
  final List<SubItem> subItems;
  final dynamic value;

  ReportData({
    required this.srNo,
    required this.title,
    required this.subItems,
    this.value,
  });
}

class SubItem {
  final String label;
  final dynamic value;

  SubItem({required this.label, required this.value});
}
class TalkingPointsReport extends StatefulWidget {
  String routeName = '/TalkingPointsReport';

  TalkingPointsReport({super.key});

  @override
  State<TalkingPointsReport> createState() => _TalkingPointsReportState();
}

class _TalkingPointsReportState extends State<TalkingPointsReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  bool _isFormVisible = false;
  String? selectedToDate;
  String? selectedFromDate;

  late _TalkingPointDataSource _talkingPointDataSource;
  List<ReportData> _talkingPointReportData = [];
  GetTalkingPointsReportModel? _apiResponseData;

  bool isLoading = false;
  bool hasData = false;
  List<Data> adminDeptOptions = [];
  List<Data> hodUnitDeptOptions = [];
  List<Data> officeOptions = [];
  List<Data> districtOptions = [];
  List<String> statusOptions = ['All', 'Pending', 'Decided'];
  List<String> mainPerformaOptions = ['Main Party', 'Performa Party'];

  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  Data? selectedOffice;
  Data? selectedDist;
  String? selectedStatus;
  String? selectedMainPerforma;

  int? adminDeptId;
  int? unitDeptId;
  int? officeDeptId;
  int? distId;

  @override
  void initState() {
    super.initState();

    _talkingPointDataSource = _TalkingPointDataSource(reportData: []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialFilterOptions(); // Fetch dropdown options
      _getTalkingPointsReportDetails(); // Fetch initial report data
    });
  }

  Future<void> _fetchInitialFilterOptions() async {
    await getAdmDepList();
    await getDistrict(0, 0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Talking Points Report Filter',
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
                        // Changed to buildFinalDropdownField for consistency if you have Data model
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Department',
                          options: adminDeptOptions, // Use fetched options
                          selectedValue: selectedAdminDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedAdminDept = newValue;
                              // Reset dependent dropdowns if necessary
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
                          options: hodUnitDeptOptions, // Use fetched options
                          selectedValue: selectedHodUnitDept,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedHodUnitDept = newValue;
                              selectedOffice = null;
                              officeOptions = [];
                            });
                            unitDeptId = int.tryParse(newValue?.value ?? '0');
                            if (unitDeptId != null) {
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
                            officeDeptId = int.tryParse(newValue?.value ?? '0');
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Office',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'District',
                          options: districtOptions,
                          selectedValue: selectedDist,
                          onChanged: (newValue) {
                            setState(() {
                              selectedDist = newValue;
                            });
                            distId = int.tryParse(newValue?.value ?? '0');
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select District',
                        ),

                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          dropdownColor: Colors.white,
                          items: statusOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Label outside the Outline
                              const Text(
                                'Status',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: selectedStatus,
                                hint: const Text('Status'), // Shows when no value is selected
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                ),
                                dropdownColor: Colors.white,
                                items: statusOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Label shown outside
                              const Text(
                                'Main/Performa',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: selectedMainPerforma,
                                hint: const Text('All'), // Shows when no value is selected
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                ),
                                dropdownColor: Colors.white,
                                items: mainPerformaOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMainPerforma = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        DropdownButtonFormField<String>(
                          value: selectedMainPerforma,
                          decoration: const InputDecoration(
                            labelText: 'Main/Performa',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          dropdownColor: Colors.white,
                          items: mainPerformaOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMainPerforma = newValue;
                            });
                          },
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
                                  // Reset all filter values
                                  selectedAdminDept = null;
                                  selectedHodUnitDept = null;
                                  selectedOffice = null;
                                  selectedDist = null;
                                  selectedStatus = null;
                                  selectedMainPerforma = null;
                                  selectedFromDate = null;
                                  selectedToDate = null;

                                  adminDeptId = null;
                                  unitDeptId = null;
                                  officeDeptId = null;
                                  distId = null;

                                  hodUnitDeptOptions = [];
                                  officeOptions = [];

                                  // Re-fetch initial filter options if necessary to reset dropdowns
                                  _fetchInitialFilterOptions();
                                });
                                _getTalkingPointsReportDetails(); // Re-fetch data with reset filters
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
                                  _isFormVisible = false; // Hide filter form on search
                                });
                                _getTalkingPointsReportDetails(); // Fetch data based on current filters
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
              const SizedBox(height: 10),
    SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Table(
    border: TableBorder.all(color: Colors.grey),
    columnWidths: {
    0: FixedColumnWidth(35),
    1: FlexColumnWidth(20),
    2: FlexColumnWidth(10),
    3: FlexColumnWidth(10),
    },
    children: [
    // Table Header
    TableRow(
    decoration: BoxDecoration(color: Colors.grey[300]),
    children: [
    _buildHeaderCell('Sr No'),
    _buildHeaderCell('Talking Point'),
    _buildHeaderCell('Sub Item'),
    _buildHeaderCell('Value'),
    ],
    ),
    // Table Body
    ..._buildTableRows(_talkingPointReportData),
    ],
    ),
    ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows(List<ReportData> data) {
    final List<TableRow> rows = [];
    for (var item in data) {
      if (item.subItems.isNotEmpty) {
        // ✅ Main Point with Sub Items
        // Main point
        rows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.srNo ?? '-'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.title),
            ),
            // First Sub Item
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.subItems.first.label ?? '-'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.subItems.first.value?.toString() ?? '-'),
            ),
          ],
        ),
        );
        // Additional Sub Items
        for (int i = 1; i < item.subItems.length; i++) {
          rows.add(TableRow(
            children: [
              const SizedBox.shrink(),
              const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item.subItems[i].label ?? '-'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item.subItems[i].value?.toString() ?? '-'),
              ),
            ],
          ));
        }
      } else {
        // ✅ No Sub Items
        rows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.srNo ?? '-'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.title),
            ),
            const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.value?.toString() ?? '-'),
            ),
          ],
        ));
      }
    }
    return rows;
  }


  Widget _buildHeaderCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildCell(String text, {bool isTopAligned = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: isTopAligned ? Alignment.topLeft : Alignment.centerLeft,
      child: Text(text),
    ),
  );
}
  Widget buildGovernmentInfo() {
    return Container(
        padding: const EdgeInsets.all(12), // Optional: add padding inside the background
        color: Colors.blue.shade100, // 🔴 Set your background color here
        child:
        Column(
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
                  fontWeight: FontWeight.bold,fontSize: 12, color: Colors.red),
            ),
            const SizedBox(height: 5),
             Text(
             // '${selectedStatus.toString() + selectedMainPerforma.toString() ?? 'Pending_Main Party'}',
                 '${selectedStatus?.toString() ?? 'Pending'}_${selectedMainPerforma?.toString() ?? 'Main Party'}',

                 style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(height: 5),
             Text(
              '(${selectedAdminDept?.text.toString() ?? 'Administrative Department'} Wise Talking Points Report )',
              style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 5),

          ],
        ));
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

      officeOptions = await commonRepository.getOfficeList(context,unitDeptId!); // provide your `unitDeptId`

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


  Future<void> getDistrict(int DivisionId, int StateId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      districtOptions = await commonRepository.getDistricts(
        context,0,
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

  Future<void> _getTalkingPointsReportDetails() async {
    try {
      setState(() {
        isLoading = true;
        hasData = false;
      });
      EssentialDialogs().showProgressHud(context, true);
      final client = await ReportApiServiceApiclient.createService(context);
      final req = TalkingPointsReportReqModel()
        ..paging = false
        ..currentPageID = 0
        ..totalPages = 0
        ..startPageNumber = 0
        ..endPageNumber = 0
        ..totalRecords = 0
        ..startRecord = 0
        ..endRecord = 0
        ..pageSize = 0
        ..pageUrl = ""
        ..ajaxUrl = ""
        ..sortingColumn = ""
        ..sortingOrder = 1
        ..searchText = ""
        ..searchParameter = (SearchParameter()
          ..additionalProp1 = selectedAdminDept?.value.toString() ?? ''
          ..additionalProp2 = selectedDist?.value.toString() ?? ''
          ..additionalProp3 = selectedFromDate ?? '');

final encryptedData = await EncryptionHelper.encryptData(req.toJson());
final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getTalkingPointsReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptDataList(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted Talking Points response: $decryptedMap");
      }

      if (decryptedMap is List) {
        final results = decryptedMap
            .map((item) => GetTalkingPointsReportModel.fromJson(item as Map<String, dynamic>))
            .toList();

        if (results.isNotEmpty) {
          final mappedData = results
              .expand((element) => _mapApiDataToTalkingPointReportData(element))
              .toList();

          setState(() {
            _talkingPointReportData = mappedData;
            _talkingPointDataSource = _TalkingPointDataSource(reportData: _talkingPointReportData);
            hasData = true;
          });
        } else {
          await _showNoDataFound();
        }
      } else {
        await _showNoDataFound();
      }
    } catch (e) {
      if (kDebugMode) {
        print('TalkingPointsReport - error - $e');
      }

      EssentialDialogModel appDialog = EssentialDialogModel();
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = "Failed to load report: ${e.toString()}";
      await EssentialDialogs().openOkDismissDialog(context, appDialog);

      setState(() {
        hasData = false;
        _talkingPointReportData = [];
        _talkingPointDataSource = _TalkingPointDataSource(reportData: []);
      });
    } finally {
      EssentialDialogs().showProgressHud(context, false);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showNoDataFound() async {
    EssentialDialogModel appDialog = EssentialDialogModel();
    appDialog.appTitle = String_App().appname;
    appDialog.appMessage = "No data found for the selected filters.";
    await EssentialDialogs().openOkDismissDialog(context, appDialog);
    setState(() {
      hasData = false;
      _talkingPointReportData = [];
      _talkingPointDataSource = _TalkingPointDataSource(reportData: []);
    });
  }

  List<ReportData> _mapApiDataToTalkingPointReportData(GetTalkingPointsReportModel apiData) {
    final List<ReportData> mappedData = [];

    final List<SubItem> subItems1 = [
      if ((apiData.totalCases ?? 0) > 0) SubItem(label: 'Total Cases Registered', value: apiData.totalCases ?? 0),
      if ((apiData.appellantCountNot ?? 0) > 0) SubItem(label: 'Entry not in Appellant', value: apiData.appellantCountNot ?? 0),
      if ((apiData.respondantCountNot ?? 0) > 0) SubItem(label: 'Entry not in Respondent', value: apiData.respondantCountNot ?? 0),
      if ((apiData.oicCountNot ?? 0) > 0) SubItem(label: 'Entry not in OIC', value: apiData.oicCountNot ?? 0),
      if ((apiData.lawyerCountNot ?? 0) > 0) SubItem(label: 'Entry not in Lawyer', value: apiData.lawyerCountNot ?? 0),
      if ((apiData.hearingCountNot ?? 0) > 0) SubItem(label: 'Entry not in Hearing', value: apiData.hearingCountNot ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '1',
      title: 'Maintenance of LITES Sheets in Court case files and progress of Data entries made in registration(F1) and not made in other details (Appellant,Respondent,Lawyer, OIC and Hearing)',
      subItems: subItems1,
      value: subItems1.isEmpty ? apiData.totalCases ?? 0 : null,
    ));

    final List<SubItem> subItems2 = [
      if ((apiData.hearingDateBlank ?? 0) > 0) SubItem(label: 'Date is Blank', value: apiData.hearingDateBlank ?? 0),
      if ((apiData.outDatedHearingDate ?? 0) > 0) SubItem(label: 'Next Hearing Date Not updated', value: apiData.outDatedHearingDate ?? 0),
      if ((apiData.dueCourses ?? 0) > 0) SubItem(label: 'Cases to be updated (in Due Course)', value: apiData.dueCourses ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '2',
      title: 'Next Hearing Status',
      subItems: subItems2,
      value: subItems2.isEmpty ? apiData.hearingDateBlank ?? 0 : null,
    ));
    mappedData.add(ReportData(
      srNo: '3',
      title: 'Review of duplicate cases',
      subItems: [],
      value: apiData.duplicateCases ?? 0,
    ));

    final List<SubItem> subItems4 = [
      if ((apiData.registraionLessDecisionDate ?? 0) > 0) SubItem(label: 'Decision Date < Registration Date', value: apiData.registraionLessDecisionDate ?? 0),
      if ((apiData.registraionLessHearingDate ?? 0) > 0) SubItem(label: 'Hearing Date < Registration Date', value: apiData.registraionLessHearingDate ?? 0),
      if ((apiData.decisionLessHearingDate ?? 0) > 0) SubItem(label: 'Decision Date < Hearing Date', value: apiData.decisionLessHearingDate ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '4',
      title: 'Overall validation report and progress of updation',
      subItems: subItems4,
      value: subItems4.isEmpty ? 0 : null,
    ));

    mappedData.add(ReportData(
      srNo: '5',
      title: 'Red Category',
      subItems: [],
      value: apiData.redCount ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '6',
      title: 'Duplicate records',
      subItems: [],
      value: apiData.duplicateCasesSameDept ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '7',
      title: 'Reply not filed',
      subItems: [],
      value: apiData.replyFileCout ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '8',
      title: 'Number of cases remaining from Approved reply submitted to Lawyer',
      subItems: [],
      value: 0,
    ));

    mappedData.add(ReportData(
      srNo: '9',
      title: 'Stay Granted',
      subItems: [],
      value: apiData.stayGranted ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '10',
      title: 'Stay in Govt. Favor',
      subItems: [],
      value: apiData.stayInGovtFavour ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '11',
      title: 'Stay in Govt. Against',
      subItems: [],
      value: apiData.stayInGovtAgainst ?? 0,
    ));

    final List<SubItem> subItems11 = [
      if ((apiData.totalCnrPending ?? 0) > 0) SubItem(label: 'Total', value: apiData.totalCnrPending ?? 0),
      if ((apiData.highCourtJpr ?? 0) > 0) SubItem(label: 'High Court Jaipur', value: apiData.highCourtJpr ?? 0),
      if ((apiData.highCourtJODH ?? 0) > 0) SubItem(label: 'High Court Jodhpur', value: apiData.highCourtJODH ?? 0),
      if ((apiData.otherSubOrdCourt ?? 0) > 0) SubItem(label: 'Other Sub Ordinate Court', value: apiData.otherSubOrdCourt ?? 0),
    ];
    mappedData.add(ReportData(
      srNo: '12',
      title: 'CNR (Case Number Record) Not Updated',
      subItems: subItems11,
      value: subItems11.isEmpty ? 0 : null,
    ));

    mappedData.add(ReportData(
      srNo: '13',
      title: 'Document Not Uploaded (Case Register After 01-08-2017)',
      subItems: [],
      value: apiData.documentUpload ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '14',
      title: 'Contempt Case',
      subItems: [],
      value: apiData.contemptCaseCount ?? 0,
    ));

    mappedData.add(ReportData(
      srNo: '15',
      title: 'Public Interest Litigation (PIL) Cases',
      subItems: [],
      value: apiData.pilCount ?? 0,
    ));

    return mappedData;
  }

}

class _TalkingPointDataSource extends DataGridSource {
  _TalkingPointDataSource({required List<ReportData> reportData}) {
    _rows = _buildRows(reportData);
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  List<DataGridRow> _buildRows(List<ReportData> dataList) {
    final List<DataGridRow> rows = [];
    for (var data in dataList) {
      if (data.subItems.isNotEmpty) {
        // 1. Main Point row
        rows.add(
          DataGridRow(cells: [
            DataGridCell(columnName: 'sr_no', value: data.srNo),
            DataGridCell(columnName: 'title_subitems', value: data),
            const DataGridCell(columnName: 'value', value: null),
          ]),
        );
        // 2. Sub Item rows
        for (var subItem in data.subItems) {
          rows.add(
            DataGridRow(cells: [
              const DataGridCell(columnName: 'sr_no', value: null),
              const DataGridCell(columnName: 'title_subitems', value: null),
              DataGridCell(columnName: 'value', value: {
                'label': subItem.label,
                'value': subItem.value,
              }),
            ]),
          );
        }
      } else {
        // Single row when no subItems
        rows.add(
          DataGridRow(cells: [
            DataGridCell(columnName: 'sr_no', value: data.srNo),
            DataGridCell(columnName: 'title_subitems', value: data),
            DataGridCell(columnName: 'value', value: data.value ?? '-'),
          ]),
        );
      }
    }
    return rows;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final srNo = row.getCells()[0]?.value;
    final titleData = row.getCells()[1]?.value;
    final valueData = row.getCells()[2]?.value;

    if (titleData != null && titleData is ReportData) {
      // This is a parent row
      return DataGridRowAdapter(cells: [
        // Sr No
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(srNo?.toString() ?? '-'),
        ),
        // Main title
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            titleData.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            softWrap: true,
            overflow: TextOverflow.clip,
          ),
        ),
        // Value
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: titleData.subItems.isEmpty
              ? Text(titleData.value?.toString() ?? '-')
              : const Text(''),
        ),
      ]);
    } else {
      final label = valueData != null && valueData is Map
          ? valueData['label'].toString()
          : '';
      final value = valueData != null && valueData is Map
          ? valueData['value'].toString()
          : '-';
      return DataGridRowAdapter(cells: [
        // Sr No
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: const Text(''),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Text(label, softWrap: true, overflow: TextOverflow.clip),
        ),
        // Value
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: Text(value),
        ),
      ]);
    }
  }
}
*/
