import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/reports/GetEnytryStatusReportModel.dart';
import '../../repository/commonRepository.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/string_app.dart';
import 'package:lites/screens/reports/entryStatusReport.dart' as entry;


class EntryStatusReport extends StatefulWidget {
  String routeName = '/EntryStatusReport';
  EntryStatusReport({super.key});

  @override
  State<EntryStatusReport> createState() => _EntryStatusReportState();
}

class _EntryStatusReportState extends State<EntryStatusReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
   CommonRepository commonRepository = CommonRepository();
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
  List<Data> statusOptions = [
    Data(text: 'Pending', value: '0'),
    Data(text: 'Decided', value: '1'),
    Data(text: 'All', value: '2'),
  ];
  Data? selectedStatus;
  int? statusValue;
  late EntryStatusDataSource _overallStatusDataSource;
  late EntryStatusDataSource _todayStatusDataSource;


  @override
  void initState() {
    super.initState();
    _overallStatusDataSource = EntryStatusDataSource([]);
    _todayStatusDataSource = EntryStatusDataSource([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdmDepList();
      getEntryStatusDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Entry Status Report Filter',
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
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Status',
                          options: statusOptions,
                          selectedValue: selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                            statusValue = int.tryParse(newValue?.value ?? '0') ?? 0;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select status',
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
                                  selectedStatus = null;
                                  selectedFromDate = null;
                                  selectedToDate = null;
                                  hodUnitDeptOptions = [];
                                  officeOptions = [];
                                });
                                _overallStatusDataSource = EntryStatusDataSource([]);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {

                                _overallStatusDataSource = EntryStatusDataSource([]);
                              },
                              child: const Text("Search"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              // --- Main Content Section ---
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Entry Status Report',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            //  const _ReportHeaderSection(),
              buildGovernmentInfo(),
                SfDataGrid(
                  source: _overallStatusDataSource,
                  gridLinesVisibility: GridLinesVisibility.both ,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.auto,
                  stackedHeaderRows: _buildStackedHeaderRows(),
                  columns: _buildGridColumns(),
                ),
              // --- Today's Status Table ---
             // const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            //  const SizedBox(height: 6),
              /* SizedBox(
               height: 150, // Fixed height for the smaller table
                child:*/ SfDataGrid(
                  source: _todayStatusDataSource,
                gridLinesVisibility: GridLinesVisibility.both ,
                headerGridLinesVisibility: GridLinesVisibility.both,
                stackedHeaderRows: _buildStackedHeaderRows(),
                  columnWidthMode: ColumnWidthMode.auto,
                  columns: _buildGridColumns(), // Reusing same columns
                ),
             // ),
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
      EssentialDialogs().showProgressHud(context, false);
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
      EssentialDialogs().showProgressHud(context, false);
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
      EssentialDialogs().showProgressHud(context, false);
    } finally {
      EssentialDialogs().showProgressHud(context, false);
    }
  }

  Future<void> getEntryStatusDetails() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await ReportApiServiceApiclient.createService(context);

      final response = await apiClient.getEntryStatusReportDetails(
        0,0,
        int.tryParse(selectedAdminDept?.value ?? '0') ?? 0,
        int.tryParse(selectedHodUnitDept?.value ?? '0') ?? 0,
        int.tryParse(selectedOffice?.value ?? '0') ?? 0,
        int.tryParse(selectedStatus?.value ?? '0') ?? 0,
        selectedFromDate ?? '01/01/1947',
        (selectedToDate?.isNotEmpty == true)
            ? selectedToDate!
            : DateFormat('dd/MM/yyyy').format(DateTime.now()),
      );

      if (response != null) {
        final overallRows = buildEntryStatusTableRows(
          entry: response.getMISEntryStatus!,
          update: response.getMISEntryStatusUpdate!,
        );

        final todayRows = buildTodayStatusTableRows(
          today: response.getMISEntryStatusToday!,
          todayUpdate: response.getMISEntryStatusUpdate!,
        );

        setState(() {
          _overallStatusDataSource?.updateData(overallRows);
          _todayStatusDataSource?.updateData(todayRows);
        });

        setState(() {
        });
      } else {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage = "No data found.";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e) {
      if (kDebugMode) {
        print('getEntryStatusDetails error: $e');
      }
      EssentialDialogModel appDialog = EssentialDialogModel();
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = "Failed to fetch getEntryStatusDetails data.";
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      EssentialDialogs().showProgressHud(context, false);
    } finally {
      EssentialDialogs().showProgressHud(context, false);
    }
  }

  List<EntryRowModel> buildEntryStatusTableRows({
    required GetMISEntryStatus entry,
    required GetMISEntryStatusUpdate update,
  }) {
    return [
      EntryRowModel(
        type: "Entry",
        regist: entry.format1 ?? 0,
        pett: entry.format2 ?? 0,
        nonPett: entry.format3 ?? 0,
        advocate: entry.format4 ?? 0,
        oic: entry.format5 ?? 0,
        hearing: entry.format6 ?? 0,
        decision: entry.format7 ?? 0,
        contempt: entry.format8 ?? 0,
        demandJustice: entry.format9 ?? 0,
        notice80: entry.format10 ?? 0,
        arbitration: entry.format11 ?? 0,
        total: entry.format12 ?? 0,
      ),
      EntryRowModel(
        type: "Update",
        regist: update.format1 ?? 0,
        pett: update.format2 ?? 0,
        nonPett: update.format3 ?? 0,
        advocate: update.format4 ?? 0,
        oic: update.format5 ?? 0,
        hearing: update.format6 ?? 0,
        decision: update.format7 ?? 0,
        contempt: update.format8 ?? 0,
        demandJustice: update.format9 ?? 0,
        notice80: update.format10 ?? 0,
        arbitration: update.format11 ?? 0,
        total: update.format12 ?? 0,
      ),
      EntryRowModel(
        type: "Delete",
        regist: update.format1 ?? 0,
        pett: update.format2 ?? 0,
        nonPett: update.format3 ?? 0,
        advocate: update.format4 ?? 0,
        oic: update.format5 ?? 0,
        hearing: update.format6 ?? 0,
        decision: update.format7 ?? 0,
        contempt: update.format8 ?? 0,
        demandJustice: update.format9 ?? 0,
        notice80: update.format10 ?? 0,
        arbitration: update.format11 ?? 0,
        total: update.format12 ?? 0,
      ),
    ];
  }

  List<EntryRowModel> buildTodayStatusTableRows({
    required GetMISEntryStatus today,
    required GetMISEntryStatusUpdate todayUpdate,
  }) {
    return [
      EntryRowModel(
        type: "Entry",
        regist: today.format1 ?? 0,
        pett: today.format2 ?? 0,
        nonPett: today.format3 ?? 0,
        advocate: today.format4 ?? 0,
        oic: today.format5 ?? 0,
        hearing: today.format6 ?? 0,
        decision: today.format7 ?? 0,
        contempt: today.format8 ?? 0,
        demandJustice: today.format9 ?? 0,
        notice80: today.format10 ?? 0,
        arbitration: today.format11 ?? 0,
        total: today.format12 ?? 0,
      ),
      EntryRowModel(
        type: "Update",
        regist: todayUpdate.format1 ?? 0,
        pett: todayUpdate.format2 ?? 0,
        nonPett: todayUpdate.format3 ?? 0,
        advocate: todayUpdate.format4 ?? 0,
        oic: todayUpdate.format5 ?? 0,
        hearing: todayUpdate.format6 ?? 0,
        decision: todayUpdate.format7 ?? 0,
        contempt: todayUpdate.format8 ?? 0,
        demandJustice: todayUpdate.format9 ?? 0,
        notice80: todayUpdate.format10 ?? 0,
        arbitration: todayUpdate.format11 ?? 0,
        total: todayUpdate.format12 ?? 0,
      ),
      EntryRowModel(
        type: "Delete",
        regist: todayUpdate.format1 ?? 0,
        pett: todayUpdate.format2 ?? 0,
        nonPett: todayUpdate.format3 ?? 0,
        advocate: todayUpdate.format4 ?? 0,
        oic: todayUpdate.format5 ?? 0,
        hearing: todayUpdate.format6 ?? 0,
        decision: todayUpdate.format7 ?? 0,
        contempt: todayUpdate.format8 ?? 0,
        demandJustice: todayUpdate.format9 ?? 0,
        notice80: todayUpdate.format10 ?? 0,
        arbitration: todayUpdate.format11 ?? 0,
        total: todayUpdate.format12 ?? 0,
      ),
    ];
  }


  Widget buildGovernmentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      // Background color as seen in the image
      color: Colors.blue.shade100, // Light blue background for the header
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
        children: [
          const Text(
            'Government of Rajasthan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'Justice Department\n(Litigation Information Tracking & Evaluation System)',
            textAlign: TextAlign.center,
          ),
          Text(
            '${selectedAdminDept?.text.toString() ?? 'Administrative Department'} Wise Entry Status Summary (Pending)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('(From: 01/01/1947 To: ${DateFormat('dd/MM/yyyy').format(DateTime.now())})'),
          // Dates can be dynamic from filter
          const SizedBox(height: 8),
           Align(
            alignment: Alignment.centerLeft, // Align this line to the left
            child: Text(
              'Department Name: ${selectedAdminDept?.text.toString() ?? 'All'}    Unit Name: ${selectedHodUnitDept?.text.toString() ?? 'All'}    Office Name: ${selectedOffice?.text.toString() ?? 'All'}',
              style: TextStyle(color: Colors.red),
            ),
          ),
          // "As on ${DateFormat('dd/MM/yyyy').format(DateTime.now())}" for 'Overall Status' table (moved from previous version, not strictly in this header)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(As on ${DateFormat('dd/MM/yyyy').format(DateTime.now())})',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}


//----------------------------
List<GridColumn> _buildGridColumns() {
  return [
    GridColumn(columnName: 'type', label: _gridHeaderText('')),
    GridColumn(columnName: 'regist', label: _gridHeaderText('Regist.')),
    GridColumn(columnName: 'pett', label: _gridHeaderText('Pett./App.')),
    GridColumn(columnName: 'nonPett', label: _gridHeaderText('Non-Pett./Res.')),
    GridColumn(columnName: 'advocate', label: _gridHeaderText('Advocate')),
    GridColumn(columnName: 'oic', label: _gridHeaderText('OIC')),
    GridColumn(columnName: 'hearing', label: _gridHeaderText('Hearing')),
    GridColumn(columnName: 'decision', label: _gridHeaderText('Decision')),
    GridColumn(columnName: 'contempt', label: _gridHeaderText('Contempt')),
    GridColumn(
      columnName: 'demandJustice',
      label: _gridHeaderText('Demand of Justice'),
    ),
    GridColumn(columnName: 'notice80', label: _gridHeaderText('Notice 80 CPC')),
    GridColumn(
      columnName: 'arbitration',
      label: _gridHeaderText('Arbitration'),
    ),
    GridColumn(columnName: 'total', label: _gridHeaderText('Total')),
  ];
}

Widget _gridHeaderText(String text) {
  return Container(
    padding: const EdgeInsets.all(8),
    alignment: Alignment.center,
    child: Text(text, textAlign: TextAlign.center),
  );
}

List<StackedHeaderRow> _buildStackedHeaderRows() {
  return [
    StackedHeaderRow(
      cells: [
        StackedHeaderCell(
          columnNames: ['regist', 'pett', 'nonPett'],
          child: const Center(child: Text('Format 1')),
        ),
        StackedHeaderCell(
          columnNames: ['advocate', 'oic'],
          child: const Center(child: Text('Format 2')),
        ),
        StackedHeaderCell(
          columnNames: ['hearing'],
          child: const Center(child: Text('Format 3')),
        ),
        StackedHeaderCell(
          columnNames: ['decision'],
          child: const Center(child: Text('Format 4')),
        ),
        StackedHeaderCell(
          columnNames: ['contempt', 'demandJustice'],
          child: const Center(child: Text('Format 5')),
        ),
        StackedHeaderCell(
          columnNames: ['notice80', 'arbitration'],
          child: const Center(child: Text('Pre Litigation')),
        ),
        StackedHeaderCell(
          columnNames: ['total'],
          child: const Center(child: Text('Transaction')),
        ),
      ],
    ),
  ];
}

class EntryRowModel {
  final String type;
  final int regist, pett, nonPett, advocate, oic, hearing, decision;
  final int contempt, demandJustice, notice80, arbitration, total;

  EntryRowModel({
    required this.type,
    required this.regist,
    required this.pett,
    required this.nonPett,
    required this.advocate,
    required this.oic,
    required this.hearing,
    required this.decision,
    required this.contempt,
    required this.demandJustice,
    required this.notice80,
    required this.arbitration,
    required this.total,
  });
}


class EntryStatusDataSource extends DataGridSource {
  List<EntryRowModel>
  _entryData; // Make this non-final if you want to update it

  EntryStatusDataSource(this._entryData) {
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];
  void updateData(List<EntryRowModel> newData) {
    _entryData = newData;
    _buildDataGridRows();
    notifyListeners();
  }

  void _buildDataGridRows() {
    _dataGridRows =
        _entryData.map<DataGridRow>((entry) {
          return DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'type', value: entry.type),
              DataGridCell<int>(columnName: 'regist', value: entry.regist),
              DataGridCell<int>(columnName: 'pett', value: entry.pett),
              DataGridCell<int>(columnName: 'nonPett', value: entry.nonPett),
              DataGridCell<int>(columnName: 'advocate', value: entry.advocate),
              DataGridCell<int>(columnName: 'oic', value: entry.oic),
              DataGridCell<int>(columnName: 'hearing', value: entry.hearing),
              DataGridCell<int>(columnName: 'decision', value: entry.decision),
              DataGridCell<int>(columnName: 'contempt', value: entry.contempt),
              DataGridCell<int>(
                columnName: 'demandJustice',
                value: entry.demandJustice,
              ),
              DataGridCell<int>(columnName: 'notice80', value: entry.notice80),
              DataGridCell<int>(
                columnName: 'arbitration',
                value: entry.arbitration,
              ),
              DataGridCell<int>(columnName: 'total', value: entry.total),
            ],
          );
        }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map((e) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: Text('${e.value}'),
            );
          }).toList(),
    );
  }
}
