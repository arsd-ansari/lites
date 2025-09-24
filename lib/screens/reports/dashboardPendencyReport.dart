import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/models/responses/reports/GetDashboardPendencyReportModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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


enum ReportType {
  entryPendencyStatus,
  casePendencyStatus,
  pendencyPeriodicityStatus,
  stayStatus,
  hearingStatus,
  decidedCaseStatus
}

extension ReportTypeExtension on ReportType {
  String get name {
    switch (this) {
      case ReportType.hearingStatus:
        return 'Hearing Status';
      case ReportType.stayStatus:
        return 'Stay Status';
      case ReportType.pendencyPeriodicityStatus:
        return 'Pendency Periodicity Status';
      case ReportType.casePendencyStatus:
        return 'Case Pendency Status';
      case ReportType.entryPendencyStatus:
        return 'Entry Pendency Status';
      case ReportType.decidedCaseStatus:
        return 'Decided Case Status';
    }
  }

  int get id {
    switch (this) {
      case ReportType.hearingStatus:
        return 5;
      case ReportType.stayStatus:
        return 4;
      case ReportType.pendencyPeriodicityStatus:
        return 3;
      case ReportType.casePendencyStatus:
        return 2;
      case ReportType.entryPendencyStatus:
        return 1;
      case ReportType.decidedCaseStatus:
        return 6;
    }
  }
}


class ReportData {
  ReportData({required this.rowData});
  final Map<String, dynamic> rowData;
}

class _ReportDataSource extends DataGridSource {
  _ReportDataSource({required List<ReportData> reportData}) {
    _reportData = reportData
        .map<DataGridRow>((e) => DataGridRow(
        cells: e.rowData.entries
            .map((entry) => DataGridCell<dynamic>(
            columnName: entry.key, value: entry.value))
            .toList()))
        .toList();
  }

  List<DataGridRow> _reportData = [];

  @override
  List<DataGridRow> get rows => _reportData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map((dataCell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          dataCell.value?.toString() ?? '',
          softWrap: true,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
      );
    }).toList());
  }

}

//-------------------------------------------
class DashboardPendencyReport extends StatefulWidget {
  String routeName = '/DashboardPendencyReport';
  DashboardPendencyReport({super.key});

  @override
  State<DashboardPendencyReport> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<DashboardPendencyReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();
  ScrollController _scrollController = ScrollController();
  ReportType _selectedReportType = ReportType.entryPendencyStatus;
  ReportType _tempSelectedReportType = ReportType.entryPendencyStatus;

  int currentPage = 1;
  int totalPages = 1;
  bool isLoadingMore = false;
  late _ReportDataSource _reportDataSource;
  List<ReportData> _reportData = [];
  List<Data> adminDeptOptions = [] ;
  List<Data> hodUnitDeptOptions = [];
  List<Data> officeOptions = [];
  List<Data> districtOptions = [];
  List<Data> courtTypeOptions = [];
  List<Data> courtPlaceOptions = [];
  List<Data> benchOptions = [
    Data(text: 'SB', value: 'SB'),
    Data(text: 'DB', value: 'DB'),
    Data(text: 'SB + DB', value: 'SB + DB'),
  ];
  bool _isFormVisible = false;
  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  Data? selectedOffice;
  Data? selectedStatus;
  Data? selectedCourtType;
  Data? selectedCourtPlace;
  Data? selectedBench;
  Data? selectedDist;
  int? adminDeptId;
  int? unitDeptId;
  int? officeDeptId;
  int? statusValue;
  String? selectedToDate;
  String? selectedFromDate;
  String? benchValue;
  int? distId;
  int? courtTypeId;
  int? courtPlaceId;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _reportDataSource = _ReportDataSource(reportData: _reportData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
    //  _generateReportData();
      getAdmDepList();
      getDistrict(0, 0);
      getCourtTypeList(0);
      getDashboardPendencyListDetails(page: currentPage);
    });
  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        currentPage < totalPages) {
      currentPage += 1;
      getDashboardPendencyListDetails(page: currentPage, isPagination: true);
    }
  }

  void loadMore() async {
    if (isLoadingMore || currentPage >= totalPages) return;

    setState(() => isLoadingMore = true);

    int nextPage = currentPage + 1;

    await getDashboardPendencyListDetails(page: nextPage, isPagination: true);

    setState(() {
      currentPage = nextPage; // ✅ Update currentPage only after success
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /*void _generateReportData() {
    _reportData = []; // Clear previous data
    switch (_selectedReportType) {
      case ReportType.hearingStatus:
        _reportData = [
          ReportData(rowData: {
            'Sr No.': 1,
            'Admin Deptt. Name': 'Administrative Reforms and Co-ordination Department, Jaipur',
            'Gen_This_Red': 0, 'Gen_This_Orange': 0, 'Gen_This_Green': 0, 'Gen_This_Total': 0,
            'Gen_Next_Red': 0, 'Gen_Next_Orange': 0, 'Gen_Next_Green': 0, 'Gen_Next_Total': 0,
            'Gen_Beyond_Red': 0, 'Gen_Beyond_Orange': 0, 'Gen_Beyond_Green': 0, 'Gen_Beyond_Total': 0,
            'Cont_This_Total': 0,'Cont_Next_Total': 0,'Cont_Beyond_Total': 0,
          }),
          ReportData(rowData: {
            'Sr No.': 2,
            'Admin Deptt. Name': 'Agriculture Department',
            'Gen_This_Red': 3, 'Gen_This_Orange': 0, 'Gen_This_Green': 22, 'Gen_This_Total': 25,
            'Gen_Next_Red': 0, 'Gen_Next_Orange': 0, 'Gen_Next_Green': 1, 'Gen_Next_Total': 1,
            'Gen_Beyond_Red': 0, 'Gen_Beyond_Orange': 0, 'Gen_Beyond_Green': 7, 'Gen_Beyond_Total': 7,
            'Cont_This_Total': 3,'Cont_Next_Total': 0,'Cont_Beyond_Total': 0,
          }),
          // Add more sample data as needed
        ];
        break;
      case ReportType.stayStatus:
        _reportData = [
          ReportData(rowData: {
            'Sr No.': 1,
            'Department': 'Administrative Reforms and Co-ordination Department, Jaipur',
            'AdvAppt_Below1M': 6, 'AdvAppt_1_3M': 0, 'AdvAppt_More3M': 0,
            'Reply_Below1M': 1, 'Reply_1_3M': 0, 'Reply_3_6M': 0, 'Reply_6_12M': 0, 'Reply_More1Y': 0, 'Reply_Total': 1,
          }),
          ReportData(rowData: {
            'Sr No.': 2,
            'Department': 'Agriculture Department',
            'AdvAppt_Below1M': 1, 'AdvAppt_1_3M': 18, 'AdvAppt_More3M': 10,
            'Reply_Below1M': 1, 'Reply_1_3M': 2, 'Reply_3_6M': 13, 'Reply_6_12M': 26, 'Reply_More1Y': 28, 'Reply_Total': 70,
          }),
          // Add more sample data
        ];
        break;
      case ReportType.pendencyPeriodicityStatus:
        _reportData = [
          ReportData(rowData: {
            'Sr No.': 1,
            'Department': 'Administrative Reforms and Co-ordination Department, Jaipur',
            'PP_Below1Y': 17, 'PP_1_5Y': 36, 'PP_5_10Y': 15, 'PP_More10Y': 15,
            'OIC_Below1M': 7, 'OIC_1_3M': 0, 'OIC_More3M': 0,
            'Adv_Below1M': 6, 'Adv_1_3M': 0, 'Adv_More3M': 0,
            'FR_Below1M': 0, 'FR_1_3M': 0, 'FR_More3M': 1,
            'Reply_Below1M': 0, 'Reply_1_3M': 0, 'Reply_More3M': 0,
          }),
          ReportData(rowData: {
            'Sr No.': 2,
            'Department': 'Agriculture Department',
            'PP_Below1Y': 163, 'PP_1_5Y': 951, 'PP_5_10Y': 529, 'PP_More10Y': 858,
            'OIC_Below1M': 1, 'OIC_1_3M': 16, 'OIC_More3M': 12,
            'Adv_Below1M': 1, 'Adv_1_3M': 18, 'Adv_More3M': 10,
            'FR_Below1M': 0, 'FR_1_3M': 0, 'FR_More3M': 1,
            'Reply_Below1M': 2, 'Reply_1_3M': 67, 'Reply_More3M': 0,
          }),
          // Add more sample data
        ];
        break;
      case ReportType.casePendencyStatus:
        _reportData = [
          ReportData(rowData: {
            'Sr No.': 1,
            'Department': 'Administrative Reforms and Co-ordination Department, Jaipur',
            'CC_Red': 3, 'CC_Orange': 6, 'CC_Green': 74, 'CC_Total': 83,
            'NW1_PIL': 0, 'NW1_Contempt': 0, 'NW1_Other': 80,
            'NW2_Service': 53, 'NW2_Financial': 9, 'NW2_Other': 26,
          }),
          ReportData(rowData: {
            'Sr No.': 2,
            'Department': 'Agriculture Department',
            'CC_Red': 47, 'CC_Orange': 311, 'CC_Green': 2143, 'CC_Total': 2501,
            'NW1_PIL': 2, 'NW1_Contempt': 47, 'NW1_Other': 2452,
            'NW2_Service': 607, 'NW2_Financial': 358, 'NW2_Other': 1675,
          }),
          // Add more sample data
        ];
        break;
      case ReportType.entryPendencyStatus:
        _reportData = [
          ReportData(rowData: {
            'Sr No.': 1,
            'Department': 'Administrative Reforms and Co-ordination Department, Jaipur',
            'PE_CaseNo': 0,
            'PE_Parties_Appellant': 12, 'PE_Parties_Respondent': 13,
            'PE_OIC_FR': 7, 'PE_OIC_Advocate': 1,
            'PE_DU_HearingDate': 6, 'PE_DU_NextHearing': 9, 'PE_DU_DecisionDate': 1,
            'PE_DED_HearingDate': 0, 'PE_DED_DecisionDate': 0,
            'PE_OD_HearingDate': 0, 'PE_OD_Duplicate': 0,
          }),
          ReportData(rowData: {
            'Sr No.': 2,
            'Department': 'Agriculture Department',
            'PE_CaseNo': 312,
            'PE_Parties_Appellant': 16, 'PE_Parties_Respondent': 16,
            'PE_OIC_FR': 24, 'PE_OIC_Advocate': 70,
            'PE_DU_HearingDate': 20, 'PE_DU_NextHearing': 72, 'PE_DU_DecisionDate': 12,
            'PE_DED_HearingDate': 0, 'PE_DED_DecisionDate': 0,
            'PE_OD_HearingDate': 1, 'PE_OD_Duplicate': 0,
          }),
          // Add more sample data
        ];
        break;
    }
    _reportDataSource = _ReportDataSource(reportData: _reportData);
  }*/

  Widget _buildHeaderCell(String text) {
    return Container(
      color: Colors.blue.shade100,
      padding: const EdgeInsets.all(6),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        overflow: TextOverflow.visible,
        softWrap: true,
        maxLines: null,
      ),
    );
  }

  List<GridColumn> _buildDataGridColumns() {
    switch (_selectedReportType) {
      case ReportType.hearingStatus:
// GridColumns for hearingStatus report type
        return <GridColumn>[
          GridColumn(columnName: 'Sr No.', label: _buildHeaderCell('Sr No.')),
          GridColumn(columnName: 'Admin Deptt. Name', width: 200, label: _buildHeaderCell('Admin Deptt. Name')),

          // General Cases columns
          GridColumn(columnName: 'Gen_This_Red', label: _buildHeaderCell('Red')),
          GridColumn(columnName: 'Gen_This_Orange', label: _buildHeaderCell('Orange')),
          GridColumn(columnName: 'Gen_This_Green', label: _buildHeaderCell('Green')),
          GridColumn(columnName: 'Gen_This_Total', label: _buildHeaderCell('Total')),

          GridColumn(columnName: 'Gen_Next_Red', label: _buildHeaderCell('Red')),
          GridColumn(columnName: 'Gen_Next_Orange', label: _buildHeaderCell('Orange')),
          GridColumn(columnName: 'Gen_Next_Green', label: _buildHeaderCell('Green')),
          GridColumn(columnName: 'Gen_Next_Total', label: _buildHeaderCell('Total')),

          GridColumn(columnName: 'Gen_Beyond_Red', label: _buildHeaderCell('Red')),
          GridColumn(columnName: 'Gen_Beyond_Orange', label: _buildHeaderCell('Orange')),
          GridColumn(columnName: 'Gen_Beyond_Green', label: _buildHeaderCell('Green')),
          GridColumn(columnName: 'Gen_Beyond_Total', label: _buildHeaderCell('Total')),

          // Contempt Totals only
          GridColumn(columnName: 'Cont_This_Total', label: _buildHeaderCell('This Month')),
          GridColumn(columnName: 'Cont_Next_Total', label: _buildHeaderCell('Next Month')),
          GridColumn(columnName: 'Cont_Beyond_Total', label: _buildHeaderCell('Beyond Next Month')),
        ];

      case ReportType.stayStatus:
        return <GridColumn>[
          GridColumn(columnName: 'Sr No.', label: _buildHeaderCell('Sr No.')),
          GridColumn(columnName: 'Department', width: 250, label: _buildHeaderCell('Department')),
          GridColumn(columnName: 'AdvAppt_Below1M', label: _buildHeaderCell('Below 1 M')),
          GridColumn(columnName: 'AdvAppt_1_3M', label: _buildHeaderCell('1-3 M')),
          GridColumn(columnName: 'AdvAppt_More3M', label: _buildHeaderCell('More than 3 M')),
          GridColumn(columnName: 'Reply_Below1M', label: _buildHeaderCell('Below 1 M')),
          GridColumn(columnName: 'Reply_1_3M', label: _buildHeaderCell('1-3 M')),
          GridColumn(columnName: 'Reply_3_6M', label: _buildHeaderCell('3-6 M')),
          GridColumn(columnName: 'Reply_6_12M', label: _buildHeaderCell('6-12 M')),
          GridColumn(columnName: 'Reply_More1Y', label: _buildHeaderCell('More than 1 Y')),
          GridColumn(columnName: 'Reply_Total', label: _buildHeaderCell('Total')),
        ];
      case ReportType.pendencyPeriodicityStatus:
        return <GridColumn>[
          GridColumn(columnName: 'Sr No.', label: _buildHeaderCell('Sr No.')),
          GridColumn(columnName: 'Department', width: 250, label: _buildHeaderCell('Department')),
          GridColumn(columnName: 'PP_Below1Y', label: _buildHeaderCell('Below 1 Y')),
          GridColumn(columnName: 'PP_1_5Y', label: _buildHeaderCell('1-5 Y')),
          GridColumn(columnName: 'PP_5_10Y', label: _buildHeaderCell('5-10 Y')),
          GridColumn(columnName: 'PP_More10Y', label: _buildHeaderCell('More than 10 Y')),
          GridColumn(columnName: 'OIC_Below1M', label: _buildHeaderCell('Below 1 M')),
          GridColumn(columnName: 'OIC_1_3M', label: _buildHeaderCell('1-3 M')),
          GridColumn(columnName: 'OIC_More3M', label: _buildHeaderCell('More than 3 M')),
          GridColumn(columnName: 'Adv_Below1M', label: _buildHeaderCell('Below 1 M')),
          GridColumn(columnName: 'Adv_1_3M', label: _buildHeaderCell('1-3 M')),
          GridColumn(columnName: 'Adv_More3M', label: _buildHeaderCell('More than 3 M')),
          GridColumn(columnName: 'FR_Below1M', label: _buildHeaderCell('Below 1 M')),
          GridColumn(columnName: 'FR_1_3M', label: _buildHeaderCell('1-3 M')),
          GridColumn(columnName: 'FR_More3M', label: _buildHeaderCell('More than 3 M')),
          GridColumn(columnName: 'Reply_Below1M', label: _buildHeaderCell('Below 1 M')),
          GridColumn(columnName: 'Reply_1_3M', label: _buildHeaderCell('1-3 M')),
          GridColumn(columnName: 'Reply_More3M', label: _buildHeaderCell('More than 3 M')),
        ];
      case ReportType.casePendencyStatus:
        return <GridColumn>[
          GridColumn(columnName: 'Sr No.', label: _buildHeaderCell('Sr No.')),
          GridColumn(columnName: 'Admin_Department', width: 250, label: _buildHeaderCell('Admin Deptt. Name')),
          GridColumn(columnName: 'CC_Red', label: _buildHeaderCell('Red (Policy & Above Rs 10 Cr)')),
          GridColumn(columnName: 'CC_Orange', label: _buildHeaderCell('Orange (Rs 1 - 10 Cr)')),
          GridColumn(columnName: 'CC_Green', label: _buildHeaderCell('Green (Remaining)')),
          GridColumn(columnName: 'CC_Total', label: _buildHeaderCell('Total')),
          GridColumn(columnName: 'NW1_PIL', label: _buildHeaderCell('PIL')),
          GridColumn(columnName: 'NW1_Contempt', label: _buildHeaderCell('Contempt')),
          GridColumn(columnName: 'NW1_Other', label: _buildHeaderCell('Other')),
          GridColumn(columnName: 'NW2_Service', label: _buildHeaderCell('Service')),
          GridColumn(columnName: 'NW2_Financial', label: _buildHeaderCell('Financial')),
          GridColumn(columnName: 'NW2_Other', label: _buildHeaderCell('Other')),
        ];
      case ReportType.entryPendencyStatus:
        return <GridColumn>[
          GridColumn(columnName: 'Sr No.', label: _buildHeaderCell('Sr No.')),
          GridColumn(columnName: 'Admin_Department', width: 250, label: _buildHeaderCell('Admin Deptt. Name')),
          GridColumn(columnName: 'PE_CaseNo', label: _buildHeaderCell('CNR(Case No. Record)')),
          GridColumn(columnName: 'PE_Parties_Appellant', label: _buildHeaderCell('Appellant')),
          GridColumn(columnName: 'PE_Parties_Respondent', label: _buildHeaderCell('Respondent')),
          GridColumn(columnName: 'PE_OIC_OIC', label: _buildHeaderCell('OIC')),
          GridColumn(columnName: 'PE_OIC_FR', label: _buildHeaderCell('Factual Report')),
          GridColumn(columnName: 'PE_OIC_Advocate', label: _buildHeaderCell('Advocate')),
          GridColumn(columnName: 'PE_DU_HearingDate', label: _buildHeaderCell('Hearing Date')),
          GridColumn(columnName: 'PE_DU_NextHearing', label: _buildHeaderCell('Next Hearing Date')),
          GridColumn(columnName: 'PE_DU_DecisionDate', label: _buildHeaderCell('Decision Date (Prior to Reg Date)')),
          GridColumn(columnName: 'PE_DED_HearingDate', label: _buildHeaderCell('Hearing Date (Prior to Req Date)')),
          GridColumn(columnName: 'PE_DED_DecisionDate', label: _buildHeaderCell('Decision Date (Prior to Req Date)')),
          GridColumn(columnName: 'PE_OD_HearingDate', label: _buildHeaderCell('Hearing Date')),
          GridColumn(columnName: 'PE_OD_Duplicate', label: _buildHeaderCell('Duplicate')),
        ];
      case ReportType.decidedCaseStatus:
        return <GridColumn>[
          GridColumn(columnName: 'Sr No.', label: _buildHeaderCell('Sr No.')),
          GridColumn(columnName: 'Admin_Department', width: 250, label: _buildHeaderCell('Admin Deptt. Name')),

          GridColumn(columnName: 'Red_Favor', label: _buildHeaderCell('Red Favor\n(Policy & Above Rs 10 Cr)')),
          GridColumn(columnName: 'Red_Against', label: _buildHeaderCell('Red Against\n(Policy & Above Rs 10 Cr)')),

          GridColumn(columnName: 'Orange_Favor', label: _buildHeaderCell('Orange Favor\n(Rs 1–10 Cr)')),
          GridColumn(columnName: 'Orange_Against', label: _buildHeaderCell('Orange Against\n(Rs 1–10 Cr)')),

          GridColumn(columnName: 'Green_Favor', label: _buildHeaderCell('Green Favor\n(Remaining)')),
          GridColumn(columnName: 'Green_Against', label: _buildHeaderCell('Green Against\n(Remaining)')),

          GridColumn(columnName: 'Total_Favor', label: _buildHeaderCell('Total Favor')),
          GridColumn(columnName: 'Total_Against', label: _buildHeaderCell('Total Against')),

          GridColumn(columnName: 'Appeal_Favor', label: _buildHeaderCell('Appeal Favor')),
          GridColumn(columnName: 'Appeal_Against', label: _buildHeaderCell('Appeal Against')),

          GridColumn(columnName: 'NoAppeal_Favor', label: _buildHeaderCell('No Appeal Favor')),
          GridColumn(columnName: 'NoAppeal_Against', label: _buildHeaderCell('No Appeal Against')),

          GridColumn(columnName: 'PendingAppeal_Favor', label: _buildHeaderCell('Pending Appeal Favor')),
          GridColumn(columnName: 'PendingAppeal_Against', label: _buildHeaderCell('Pending Appeal Against')),

          GridColumn(columnName: 'Compliance', label: _buildHeaderCell('Compliance')),
          GridColumn(columnName: 'Stay', label: _buildHeaderCell('Stay')),
        ];

    }
  }

  List<StackedHeaderRow> _buildStackedHeaderRows() {
    switch (_selectedReportType) {
      case ReportType.hearingStatus:
        return <StackedHeaderRow>[
          StackedHeaderRow(cells: [
            StackedHeaderCell(
              columnNames: ['Admin Deptt. Name'],
              child: _buildHeaderCell('Department'),
            ),
            StackedHeaderCell(
              columnNames: ['Sr No.'],
              child: _buildHeaderCell('Sr No.'),
            ),
            StackedHeaderCell(
              columnNames: [
                'Gen_This_Red', 'Gen_This_Orange', 'Gen_This_Green', 'Gen_This_Total',
                'Gen_Next_Red', 'Gen_Next_Orange', 'Gen_Next_Green', 'Gen_Next_Total',
                'Gen_Beyond_Red', 'Gen_Beyond_Orange', 'Gen_Beyond_Green', 'Gen_Beyond_Total'
              ],
              child: _buildHeaderCell('General Cases'),
            ),
            StackedHeaderCell(
              columnNames: [
                'Cont_This_Total',
                'Cont_Next_Total',
                'Cont_Beyond_Total',
              ],
              child: _buildHeaderCell('Contempt'),
            ),
          ]),
          StackedHeaderRow(cells: [
            StackedHeaderCell(
              columnNames: ['Gen_This_Red', 'Gen_This_Orange', 'Gen_This_Green', 'Gen_This_Total'],
              child: _buildHeaderCell('This Month'),
            ),
            StackedHeaderCell(
              columnNames: ['Gen_Next_Red', 'Gen_Next_Orange', 'Gen_Next_Green', 'Gen_Next_Total'],
              child: _buildHeaderCell('Next Month'),
            ),
            StackedHeaderCell(
              columnNames: ['Gen_Beyond_Red', 'Gen_Beyond_Orange', 'Gen_Beyond_Green', 'Gen_Beyond_Total'],
              child: _buildHeaderCell('Beyond Next Month'),
            ),

          ]),
        ];

      case ReportType.stayStatus:
        return <StackedHeaderRow>[
          StackedHeaderRow(cells: [
            StackedHeaderCell(
                columnNames: ['AdvAppt_Below1M', 'AdvAppt_1_3M', 'AdvAppt_More3M'],
                child: _buildHeaderCell('Pendency of Advocate Appointment')),
            StackedHeaderCell(
                columnNames: ['Reply_Below1M', 'Reply_1_3M', 'Reply_3_6M', 'Reply_6_12M', 'Reply_More1Y', 'Reply_Total'],
                child: _buildHeaderCell('Pending Reply (Against Government)')),
          ]),
        ];
      case ReportType.pendencyPeriodicityStatus:
        return <StackedHeaderRow>[
          StackedHeaderRow(cells: [
            StackedHeaderCell(
                columnNames: ['PP_Below1Y', 'PP_1_5Y', 'PP_5_10Y', 'PP_More10Y'],
                child: _buildHeaderCell('Pendency Period')),
            StackedHeaderCell(
                columnNames: ['OIC_Below1M', 'OIC_1_3M', 'OIC_More3M'],
                child: _buildHeaderCell('Pendency of OIC Appointment')),
            StackedHeaderCell(
                columnNames: ['Adv_Below1M', 'Adv_1_3M', 'Adv_More3M'],
                child: _buildHeaderCell('Pendency of Advocate Appointment')),
            StackedHeaderCell(
                columnNames: ['FR_Below1M', 'FR_1_3M', 'FR_More3M'],
                child: _buildHeaderCell('Pending Factual Report')),
            StackedHeaderCell(
                columnNames: ['Reply_Below1M', 'Reply_1_3M', 'Reply_More3M'],
                child: _buildHeaderCell('Pending Reply')),
          ]),
        ];
      case ReportType.casePendencyStatus:
        return <StackedHeaderRow>[
          StackedHeaderRow(cells: [

            StackedHeaderCell(
                columnNames: ['Admin_Department'],
                child: _buildHeaderCell('Department')),
            StackedHeaderCell(
                columnNames: ['Sr No.'],
                child: _buildHeaderCell('Sr No.')),
            StackedHeaderCell(
                columnNames: ['CC_Red', 'CC_Orange', 'CC_Green', 'CC_Total'],
                child: _buildHeaderCell('Color Category Wise Pending Cases')),
            StackedHeaderCell(
                columnNames: ['NW1_PIL', 'NW1_Contempt', 'NW1_Other'],
                child: _buildHeaderCell('Nature Wise Pending Cases - 1')),
            StackedHeaderCell(
                columnNames: ['NW2_Service', 'NW2_Financial', 'NW2_Other'],
                child: _buildHeaderCell('Nature Wise Pending Cases - 2')),
          ]),
        ];
      case ReportType.entryPendencyStatus:
        return <StackedHeaderRow>[
          StackedHeaderRow(cells: [
            StackedHeaderCell(
                columnNames: ['Admin_Department'],
                child: _buildHeaderCell('Department')),
            StackedHeaderCell(
                columnNames: ['Sr No.'],
                child: _buildHeaderCell('Sr No.')),
            StackedHeaderCell(
                columnNames: ['PE_DED_HearingDate', 'PE_DED_DecisionDate'],
                child: _buildHeaderCell('Data Entry Discrepancy')),
            StackedHeaderCell(
                columnNames: ['PE_CaseNo', 'PE_Parties_Appellant', 'PE_Parties_Respondent',
                  'PE_OIC_OIC', 'PE_OIC_FR', 'PE_OIC_Advocate',
                  'PE_DU_HearingDate', 'PE_DU_NextHearing', 'PE_DU_DecisionDate'],
                child: _buildHeaderCell('Pending Entries')),
            StackedHeaderCell(
                columnNames: ['PE_DED_HearingDate', 'PE_DED_DecisionDate','PE_OD_HearingDate'],
                child: _buildHeaderCell('Data Entry Discrepancy')),
          ]),
          StackedHeaderRow(cells: [
          //  StackedHeaderCell(columnNames: ['PE_CaseNo'], child: Container()), // No sub-header for Case No
            StackedHeaderCell(columnNames: ['PE_CaseNo'], child: _buildHeaderCell('Case No.')), // No sub-header for Case No
            StackedHeaderCell(
                columnNames: ['PE_Parties_Appellant', 'PE_Parties_Respondent'],
                child: _buildHeaderCell('Parties')),
            StackedHeaderCell(
                columnNames: ['PE_OIC_OIC', 'PE_OIC_FR', 'PE_OIC_Advocate'],
                child: _buildHeaderCell('OIC, FR & Advocate')),
            StackedHeaderCell(
                columnNames: ['PE_DU_HearingDate', 'PE_DU_NextHearing', 'PE_DU_DecisionDate'],
                child: _buildHeaderCell('Date Updation')),
            StackedHeaderCell(
                columnNames: ['PE_DED_HearingDate', 'PE_DED_DecisionDate','PE_OD_HearingDate'],
                child: _buildHeaderCell('Decision Date (Prior to Reg Date)')), // Renamed for clarity
            StackedHeaderCell(
                columnNames: ['PE_OD_Duplicate'],
                child: _buildHeaderCell('Other Discrepancy')), // Renamed for clarity
          ]),
        ];

      case ReportType.decidedCaseStatus:
        return <StackedHeaderRow>[
          StackedHeaderRow(cells: [
            StackedHeaderCell(columnNames: ['Admin_Department'], child: _buildHeaderCell('Department')),
            StackedHeaderCell(columnNames: ['Sr No.'], child: _buildHeaderCell('Sr No.')),
            StackedHeaderCell(
              columnNames: [
                'Red_Favor',
                'Red_Against',
                'Orange_Favor',
                'Orange_Against',
                'Green_Favor',
                'Green_Against',
                'Total_Favor',
                'Total_Against'
              ],
              child: _buildHeaderCell('Decided Cases'),
            ),
            StackedHeaderCell(
              columnNames: [
                'Appeal_Favor',
                'Appeal_Against',
                'NoAppeal_Favor',
                'NoAppeal_Against',
                'PendingAppeal_Favor',
                'PendingAppeal_Against',
              ],
              child: _buildHeaderCell('Status of Decided Cases'),
            ),
            StackedHeaderCell(columnNames: ['Compliance', 'Stay'], child: _buildHeaderCell('Contempt')),
          ]),
        ];

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title:  'Dashboard Pendency Report',
        onBackPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body:
      SafeArea(
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
                        const SizedBox(height: 15), // Added vertical spacing
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
                              if(kDebugMode){
                                print('unitiddddd-----$unitDeptId');

                              }
                              await getOfficeList(unitDeptId!);
                            }
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select HoD/Unit',
                        ),
                        const SizedBox(height: 15), // Added vertical spacing
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
                          label: 'District',
                          options: districtOptions,
                          selectedValue: selectedDist,
                          onChanged: (newValue) {
                            setState(() {
                              selectedDist = newValue;
                            });
                            distId =
                            int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select District',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Court Type',
                          options: courtTypeOptions,
                          selectedValue: selectedCourtType,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedCourtType = newValue;
                              selectedCourtPlace = null;
                              courtPlaceOptions = [];
                            });
                            courtTypeId = int.tryParse(newValue?.value ?? '0')!;
                            if (courtTypeId != null) {
                              if(kDebugMode){
                                print('courtTypeId-----$courtTypeId');

                              }
                              await getCourtPlace(courtTypeId!);
                            }
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Court Type',
                        ),

                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Court Place',
                          options: courtPlaceOptions,
                          selectedValue: selectedCourtPlace,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCourtPlace = newValue;
                            });
                            courtPlaceId = int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Court Place',
                        ),

                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Bench',
                          options: benchOptions,
                          selectedValue: selectedBench,
                          onChanged: (newValue) {
                            setState(() {
                              selectedBench = newValue;
                            });
                            benchValue = newValue?.value ?? '';
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select',
                        ),
                        const SizedBox(height: 15),

                        DropdownButtonFormField<ReportType>(
                          value: _selectedReportType,
                          decoration: const InputDecoration(
                            labelText: 'Select Report Type',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          dropdownColor: Colors.white,
                          items: ReportType.values.map((ReportType type) {
                            return DropdownMenuItem<ReportType>(
                              value: type,
                              child: Text(type.name),
                            );
                          }).toList(),
                          onChanged: (ReportType? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedReportType = newValue;
                              });

                              getDashboardPendencyListDetails(page: currentPage);
                            }
                          },
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedAdminDept = null;
                                selectedHodUnitDept = null;
                                selectedOffice = null;
                                selectedStatus = null;
                                selectedCourtType = null;
                                selectedCourtPlace = null;
                                selectedBench = null;
                                selectedDist = null;

                                adminDeptId = null;
                                unitDeptId = null;
                                officeDeptId = null;
                                statusValue = null;
                                selectedToDate = null;
                                selectedFromDate = null;
                                benchValue = null;
                                distId = null;
                                courtTypeId = null;
                                courtPlaceId = null;
                                hodUnitDeptOptions = [];
                                officeOptions = [];
                                courtPlaceOptions = [];

                                _selectedReportType = ReportType.entryPendencyStatus; // Or your desired default

                                // Reset pagination
                                currentPage = 1;

                                _isFormVisible = true;
                              });

                              // After resetting filters, re-fetch data based on the new (default) state
                              getDashboardPendencyListDetails(page: currentPage);
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
                                    _isFormVisible = false;
                                    currentPage = 1;

                                  });
                                  getDashboardPendencyListDetails(page: currentPage);

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
                'Dashboard Pendency Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              buildGovernmentInfo(),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7, // <--- Fixed height for DataGrid
                  child: isLoadingMore && _reportDataSource.rows.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      :SfDataGrid(
                    source: _reportDataSource,
                    columns: _buildDataGridColumns(),
                    stackedHeaderRows: _buildStackedHeaderRows(),
                    columnWidthMode: ColumnWidthMode.auto,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    onQueryRowHeight: (details) {
                      return details.getIntrinsicRowHeight(details.rowIndex);
                    },
                  )

              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGovernmentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue.shade100,
      child: Column(
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
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 5),
           Text(
             '(${selectedAdminDept?.text.toString() ?? 'Administrative Deptt.'} Wise Pendency Summary Report)',

             style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(As on ${DateFormat('dd/MM/yyyy').format(DateTime.now())})',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        ],
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


  Future<void> getCourtTypeList(int CourtTypeId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      courtTypeOptions = await commonRepository.getCourtTypeList(
          context,CourtTypeId!);

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

  Future<void> getCourtPlace(int CourtTypeId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      courtPlaceOptions = await commonRepository.getCourtPlaceList(
          context,CourtTypeId!);

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


  //dummy
  List<ReportData> _mapApiDataToReportData(List<DataDashboardPendency> apiData) {
    List<ReportData> mappedData = [];
    int srNo = 1; // For Sr No. column

    for (var item in apiData) {
      Map<String, dynamic> rowMap = {
        'Sr No.': srNo++,
      };

      if (_selectedReportType == ReportType.entryPendencyStatus ||
          _selectedReportType == ReportType.casePendencyStatus ||
          _selectedReportType == ReportType.hearingStatus ||
          _selectedReportType == ReportType.decidedCaseStatus) {
        rowMap['Admin_Department'] = item.admDeptName ?? '';
      } else {
        rowMap['Department'] = item.admDeptName ?? '';
      }

      switch (_selectedReportType) {
        case ReportType.hearingStatus:
          rowMap['Gen_This_Red'] = item.redCount ?? 0; // Assuming RedCount maps to 'This Month Red'
          // These 'This_Orange' and 'This_Green' values are not directly available in DataDashboardPendency.
          // You'll need to either get them from the API or calculate them if possible.
          // For now, they are set to 0.
          rowMap['Gen_This_Orange'] = 0;
          rowMap['Gen_This_Green'] = 0;
          rowMap['Gen_This_Total'] = item.totalCases ?? 0; // Assuming TotalCases is general total

          // Similarly for 'Next Month' and 'Beyond Next Month', these specific categorizations
          // are not in DataDashboardPendency. Confirm with your backend.
          rowMap['Gen_Next_Red'] = 0;
          rowMap['Gen_Next_Orange'] = 0;
          rowMap['Gen_Next_Green'] = 0;
          rowMap['Gen_Next_Total'] = 0;

          rowMap['Gen_Beyond_Red'] = 0;
          rowMap['Gen_Beyond_Orange'] = 0;
          rowMap['Gen_Beyond_Green'] = 0;
          rowMap['Gen_Beyond_Total'] = 0;

          rowMap['Cont_This_Total'] = item.contemptCaseCount ?? 0;
          // 'Next Month' and 'Beyond Next Month' for contempt are also not directly available.
          rowMap['Cont_Next_Total'] = 0;
          rowMap['Cont_Beyond_Total'] = 0;
          break;

        case ReportType.stayStatus:
          rowMap['AdvAppt_Below1M'] = item.lawyerCountNot ?? 0;
          // These duration-based counts for AdvAppt are not explicit in DataDashboardPendency.
          rowMap['AdvAppt_1_3M'] = 0;
          rowMap['AdvAppt_More3M'] = 0;

          rowMap['Reply_Below1M'] = item.replyFileCout ?? 0;
          // These duration-based counts for Reply are not explicit in DataDashboardPendency.
          rowMap['Reply_1_3M'] = 0;
          rowMap['Reply_3_6M'] = 0;
          rowMap['Reply_6_12M'] = 0;
          rowMap['Reply_More1Y'] = 0;
          rowMap['Reply_Total'] = item.replyFileCout ?? 0; // Assuming ReplyFileCout is the total pending reply
          break;

        case ReportType.pendencyPeriodicityStatus:
        // 'PP_Below1Y', 'PP_1_5Y', etc. are typically derived from case registration dates
        // and current date. DataDashboardPendency doesn't provide these counts directly.
          rowMap['PP_Below1Y'] = 0;
          rowMap['PP_1_5Y'] = 0;
          rowMap['PP_5_10Y'] = 0;
          rowMap['PP_More10Y'] = 0;

          rowMap['OIC_Below1M'] = item.oICCountNot ?? 0;
          rowMap['OIC_1_3M'] = 0;
          rowMap['OIC_More3M'] = 0;

          rowMap['Adv_Below1M'] = item.lawyerCountNot ?? 0;
          rowMap['Adv_1_3M'] = 0;
          rowMap['Adv_More3M'] = 0;

          rowMap['FR_Below1M'] = item.factualReport ?? 0;
          rowMap['FR_1_3M'] = 0;
          rowMap['FR_More3M'] = 0;

          rowMap['Reply_Below1M'] = item.replyFileCout ?? 0;
          rowMap['Reply_1_3M'] = 0;
          rowMap['Reply_More3M'] = 0;
          break;

        case ReportType.casePendencyStatus:
          rowMap['CC_Red'] = item.redCount ?? 0;
          // 'Orange' and 'Green' categories for cases are not explicit in DataDashboardPendency.
          rowMap['CC_Orange'] = 0;
          rowMap['CC_Green'] = 0;
          rowMap['CC_Total'] = item.totalCases ?? 0;

          rowMap['NW1_PIL'] = item.pILCount ?? 0;
          rowMap['NW1_Contempt'] = item.contemptCaseCount ?? 0;
          // 'NW1_Other' would be total minus PIL and Contempt, if available.
          rowMap['NW1_Other'] = 0;

          // 'Service', 'Financial', 'Other' for Nature Wise 2 are not explicit.
          rowMap['NW2_Service'] = 0;
          rowMap['NW2_Financial'] = 0;
          rowMap['NW2_Other'] = 0;
          break;

        case ReportType.entryPendencyStatus:
          rowMap['PE_CaseNo'] = 0; // 'CaseNo' pending entry not explicit.
          rowMap['PE_Parties_Appellant'] = item.appellantCountNot ?? 0;
          rowMap['PE_Parties_Respondent'] = item.respondantCountNot ?? 0;

          rowMap['PE_OIC_OIC'] = item.oICCountNot ?? 0;
          rowMap['PE_OIC_FR'] = item.factualReport ?? 0;
          rowMap['PE_OIC_Advocate'] = item.lawyerCountNot ?? 0;

          rowMap['PE_DU_HearingDate'] = item.outDatedHearingDate ?? 0; // Assuming this means blank
          rowMap['PE_DU_NextHearing'] = item.hearingDateBlank ?? 0; // Assuming this maps to Next Hearing Date
          rowMap['PE_DU_DecisionDate'] = item.registraionLessDecisionDate ?? 0; // Assuming prior to Reg Date

          rowMap['PE_DED_HearingDate'] = item.registraionLessHearingDate ?? 0; // Assuming prior to Req Date
          rowMap['PE_DED_DecisionDate'] = item.decisionLessHearingDate ?? 0; // Assuming prior to Req Date

          rowMap['PE_OD_HearingDate'] = item.outDatedHearingDate ?? 0;
          rowMap['PE_OD_Duplicate'] = item.duplicateCases ?? 0;
          break;

        case ReportType.decidedCaseStatus:
          rowMap['Red_Favor'] = item.redCount ?? 0;
          rowMap['Red_Against'] = 0;

          rowMap['Orange_Favor'] = 0;
          rowMap['Orange_Against'] = 0;

          rowMap['Green_Favor'] = 0;
          rowMap['Green_Against'] = 0;

          rowMap['Total_Favor'] = item.totalCases ?? 0;
          rowMap['Total_Against'] = 0;

          // Status of Decided Cases
          rowMap['Appeal_Favor'] = 0;
          rowMap['Appeal_Against'] = 0;

          rowMap['NoAppeal_Favor'] = 0;
          rowMap['NoAppeal_Against'] = 0;

          rowMap['PendingAppeal_Favor'] = 0;
          rowMap['PendingAppeal_Against'] = 0;

          // Contempt
          rowMap['Compliance'] = item.contemptCaseCount ?? 0;
          rowMap['Stay'] = 0;
          break;

      }
      if (rowMap.length != _buildDataGridColumns().length) {
        if(kDebugMode){
          debugPrint(
            '⚠️ Column mismatch: Expected ${_buildDataGridColumns().length}, got ${rowMap.length}',
          );

        }
      }

      mappedData.add(ReportData(rowData: rowMap));
    }
    return mappedData;
  }

  Future getDashboardPendencyListDetails({int page = 1, bool isPagination = false}) async {
    try {
      if (!isPagination) EssentialDialogs().showProgressHud(context, true);
      isLoadingMore = true;

      ReportApiClient client = await ReportApiServiceApiclient.createService(context);
      GetDashboardPendencyReqModel req = GetDashboardPendencyReqModel();

      bool isDefaultFilter = selectedAdminDept == null &&
          selectedHodUnitDept == null &&
          selectedOffice == null &&
          selectedDist == null && selectedCourtType == null && selectedCourtPlace == null && selectedBench == null;

      if (isDefaultFilter) {
        req.admDepttId = 0;
        req.unitId = 0;
        req.officeId = 0;
        req.districtId = 0;
        req.courtTypeId = 0;
        req.placeId = 0;
        req.bench = "";
      //  req.level = 1;
      } else {
        req.admDepttId = adminDeptId ?? 0;
        req.unitId = unitDeptId ?? 0;
        req.officeId = officeDeptId ?? 0;
        req.districtId = distId ?? 0;
        req.courtTypeId = courtTypeId ?? 0;
        req.placeId = courtPlaceId ?? 0;
        req.bench = benchValue.toString() ?? "";
      }
      req.level = _selectedReportType.id;
      req.oicId = 0;
      req.lawyerId = 0;
      req.status = 0;
      req.roleId = 1;
      req.pageNo = 1;
      req.pageSize = 20;

      if (kDebugMode) {
        print('getDashboardPendencyListDetails - raw request - ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.getDashboardPendingReportDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted getDashboardPendencyListDetails response: $decryptedMap");
      }

      final response = GetDashboardPendencyReportModel.fromJson( decryptedMap);

      if (!isPagination)
        EssentialDialogs().showProgressHud(context, false);
      isLoadingMore = false;

      if ((response.status ?? false) && response.data != null) {
        List<DataDashboardPendency> newCases = response.data!;
        setState(() {
          if (isPagination) {
            _reportData.addAll(_mapApiDataToReportData(newCases));
          } else {
            _reportData = _mapApiDataToReportData(newCases);
          }
          if (response.pagination != null && response.pagination!.isNotEmpty) {
            totalPages = (response.pagination![0].totalRecords! / req.pageSize!).ceil();
          }
          // CRITICAL: Re-initialize the data source after _reportData changes
          _reportDataSource = _ReportDataSource(reportData: _reportData);
        });
      }else {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage = response.message ?? "Something Went Wrong..!!";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e) {
      if (kDebugMode) {
        print('getDashboardPendencyListDetails - error - $e');
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
