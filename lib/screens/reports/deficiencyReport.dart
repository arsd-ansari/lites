import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/reports/GetDeficiencyReportModel.dart';
import '../../repository/commonRepository.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/string_app.dart';

class DeficiencyReport extends StatefulWidget {
  String routeName = '/DeficiencyReport';

  DeficiencyReport({super.key});

  @override
  State<DeficiencyReport> createState() => _DeficiencyReportState();
}

class _DeficiencyReportState extends State<DeficiencyReport> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();

  List<DataDeficiency> deficiencyData = [];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
   int _pageSize = 20;
  bool _isLoading = false;
  bool _hasMoreData = true; // NEW


  DataDeficiency? _totalRowData;
  bool _totalRowAdded = false;
  int totalPages = 1;

// Data list and DataSource
  List<DeficiencyData> deficiencyList = [];
  late DeficiencyDataSource dataSource;
  bool isLoadingMore = false;
  bool _isFormVisible = false;
  String? selectedToDate;
  String? selectedFromDate;
  final List<String> mainPerformaOptions = ['Main_Party', 'Performa_Party'];
  final List<Data> statusOptions = [
    Data(text: 'All', value: 'All'),
    Data(text: 'Pending', value: 'Pending'),
    Data(text: 'Decided', value: 'Decided'),
  ];

  List<Data> adminDeptOptions = [];
  List<Data> hodUnitDeptOptions = [];
  List<Data> officeOptions = [];
  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  Data? selectedOffice;
  Data? selectedStatus;
  String? selectedMainPerforma;

  Data? selectedDist;
  Data? selectedLevel;
  int? adminDeptId;
  int? unitDeptId;
  int? officeDeptId;
  int? distId;
  String? statusValue;
  String? levelValue;
  List<Data> districtOptions = [];
  final List<Data> levelOptions = [
    Data(text: 'Admindeptt Wise', value: 'Admindeptt Wise'),
    Data(text: 'HoD/Unit Wise', value: 'HoD/Unit Wise'),
    Data(text: 'Office Wise', value: 'Office Wise'),
    Data(text: 'District Wise', value: 'District Wise'),
    Data(text: 'Court Wise', value: 'Court Wise'),
  ];

  @override
  void initState()  {
    super.initState();
    dataSource = DeficiencyDataSource([]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdmDepList();
      getDistrict(0, 0);
      getDeficiencyReportDetails();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        _currentPage++;
        getDeficiencyReportDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Deficiency Report',
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
                            officeDeptId =
                            int.tryParse(newValue?.value ?? '0')!;
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Office',
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
                            //  statusValue = int.tryParse(newValue?.value ?? 'All');
                            statusValue = newValue?.value ?? 'All';
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select status',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildFinalDropdownField<Data>(
                          label: 'Level',
                          options: levelOptions,
                          selectedValue: selectedLevel,
                          onChanged: (newValue) {
                            setState(() {
                              selectedLevel = newValue;
                            });
                            levelValue = newValue?.value ?? '2';
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Level',
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
                                  selectedAdminDept = null;
                                  selectedHodUnitDept = null;
                                  selectedOffice = null;
                                  selectedStatus = null;
                                  selectedLevel = null;
                                  selectedMainPerforma = null;
                                  selectedDist = null;
                                  selectedFromDate = null;
                                  selectedToDate = null;

                                  adminDeptId = null;
                                  unitDeptId = null;
                                  officeDeptId = null;
                                  statusValue = null;
                                  levelValue = null;
                                  distId = null;

                                  hodUnitDeptOptions = [];
                                  officeOptions = [];
                                  _currentPage = 1;
                                  deficiencyList.clear();
                                 // isLastPage = false;
                                  dataSource = DeficiencyDataSource([]);
                                });
                                getDeficiencyReportDetails();
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
                                  _currentPage = 1;
                                  deficiencyList.clear();
                                  dataSource = DeficiencyDataSource([]);
                                  deficiencyData =[];
                                  deficiencyList = [];
                                });
                                getDeficiencyReportDetails();
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
                'Deficiency Summary Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              buildGovernmentInfo(),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7, // <--- Fixed height for DataGrid
                  child: _isLoading && dataSource.rows.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      :SfDataGrid(
                    source: dataSource,
                    columnWidthMode: ColumnWidthMode.auto,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    verticalScrollController: _scrollController,
                    rowHeight: 70, // minimum height
                    allowSorting: false,
                    stackedHeaderRows: [
                      StackedHeaderRow(cells: [
                        StackedHeaderCell(
                          columnNames: ['srNo'],
                          child: Center(child: Text('Sr No')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['deptName'],
                          child: Center(child: Text('Administrative Dept. Name')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['totalEntries'],
                          child: Center(child: Text('Total Entries\n(As Per LITES)')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['pendingCases'],
                          child: Center(child: Text('Pending Cases')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['nonPet', 'pet', 'advocate', 'oic', 'hearing'],
                          child: Center(child: Text('Not Entered Details')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['nextHearingDateNotUpdated'],
                          child: Center(child: Text('Next Hearing Date\nNot Updated')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['redCategoryCase'],
                          child: Center(child: Text('Red Category Case')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['replyNotFiled'],
                          child: Center(child: Text('Reply Not Filed')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['approvedToAdvocate'],
                          child: Center(child: Text('Approved Reply\nTo Advocate')),
                        ),
                        StackedHeaderCell(
                          columnNames: ['stayInGovtFavour', 'stayInGovtAgainst'],
                          child: Center(child: Text('Stay Granted')),
                        ),
                      ])
                    ],
                    columns:  [
                      GridColumn(
                          columnName: '    ',
                          label: Center(child: Text('Sr No'))),
                      GridColumn(
                          columnName: '                           ',
                          label: Center(child: Text('Department'))),
                      GridColumn(
                          columnName: '    ',
                          label: Center(child: Text('Total Entries'))),
                      GridColumn(
                          columnName: '       ',
                          label: Center(child: Text('Pending Cases'))),
                      GridColumn(
                          columnName: 'nonPet',
                          label: Center(child: Text('Non-Pet.'))),
                      GridColumn(
                          columnName: 'pet',
                          label: Center(child: Text('Pet.'))),
                      GridColumn(
                          columnName: 'advocate',
                          label: Center(child: Text('Advocate'))),
                      GridColumn(
                          columnName: 'oic',
                          label: Center(child: Text('OIC'))),
                      GridColumn(
                          columnName: 'hearing',
                          label: Center(child: Text('Hearing'))),
                      GridColumn(
                          columnName: '       ',
                          label: Center(child: Text('Next Hearing Date\nNot Updated'))),
                      GridColumn(
                          columnName: '        ',
                          label: Center(child: Text('Red Category Case'))),
                      GridColumn(
                          columnName: '     ',
                          label: Center(child: Text('Reply Not Filed'))),
                      GridColumn(
                          columnName: '            ',
                          label: Center(child: Text('Approved Reply submitted To Advocate'))),
                      GridColumn(
                          columnName: 'stayInGovtFavour',
                          label: Center(child: Text('Stay in\nGovt. Favour'))),
                      GridColumn(
                          columnName: 'stayInGovtAgainst',
                          label: Center(child: Text('Stay in\nGovt. Against'))),
                    ],
                  )
              )

            ],
          ),
        ),
      ),
    );
  }


  Widget buildGovernmentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      // Optional: add padding inside the background
      color: Colors.blue.shade100,
      // 🔴 Set your background color here
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
            '( ${selectedAdminDept?.text.toString() ?? 'Administrative Deptt.'} Wise Deficiency Summary Report(${selectedStatus?.text.toString() ?? 'All'}), Main/Performa:${selectedMainPerforma ?? 'Main_Performa'} )',
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

  Future<void> getDeficiencyReportDetails() async {
    try {
      _isLoading = true;

      if (_currentPage == 1) {
        EssentialDialogs().showProgressHud(context, true);
        deficiencyList.clear();
        _totalRowData = null;
        _totalRowAdded = false;
      }

      final apiClient = await ReportApiServiceApiclient.createService(context);
      final response = await apiClient.getDeficiencyReportDetails(
        adminDeptId ?? 0,
        unitDeptId ?? 0,
        officeDeptId ?? 0,
        statusValue ?? 'All',
        levelValue ?? 'Admindeptt Wise',
        selectedMainPerforma ?? 'Main_Party',
        distId ?? 0,
        1,
        _pageSize,
        _currentPage,
        selectedFromDate ?? '01/01/1947',
        (selectedToDate?.isNotEmpty == true)
            ? selectedToDate!
            : DateFormat('dd/MM/yyyy').format(DateTime.now()),
      );

      if (response.status == true) {
        List<DataDeficiency> newData = response.data ?? [];

        // Check and remove total row
        if (newData.isNotEmpty &&
            newData.last.admDepttName?.toLowerCase() == 'total') {
          _totalRowData = newData.removeLast();
          _totalRowAdded = false;
        }

        // Convert to DeficiencyData
        final newItems = mapDeficiencyToGridRows(newData, _currentPage, _pageSize);
        deficiencyList.addAll(newItems);

        // Pagination handling
        final totalRecords = response.pagination?.first.totalRecords ?? 0;
        totalPages = (totalRecords / _pageSize).ceil();

        // Add total row only once after all data
        if (_currentPage >= totalPages && !_totalRowAdded && _totalRowData != null) {
          final totalRow = DeficiencyData(
            (deficiencyList.length + 1).toString(), // Sr No for total
            _totalRowData?.admDepttName ?? 'Total',
            _totalRowData?.totalEntryMonthly?.toString() ?? '0',
            _totalRowData?.totalPending?.toString() ?? '0',
            _totalRowData?.totalNAPPell?.toString() ?? '0',
            _totalRowData?.totalNRespo?.toString() ?? '0',
            _totalRowData?.totalNLawyers?.toString() ?? '0',
            _totalRowData?.totalNOIC?.toString() ?? '0',
            _totalRowData?.totalNHearing?.toString() ?? '0',
            _totalRowData?.nHoutDated?.toString() ?? '0',
            _totalRowData?.totalRedPending?.toString() ?? '0',
            _totalRowData?.rplyNotFile?.toString() ?? '0',
            _totalRowData?.factualReport?.toString() ?? '0',
            _totalRowData?.stayInGovtFavour?.toString() ?? '0',
            _totalRowData?.stayInGovtAgainst?.toString() ?? '0',
          );
          deficiencyList.add(totalRow);
          _totalRowAdded = true;
        }

        dataSource = DeficiencyDataSource(deficiencyList);
        setState(() {});
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      _hasMoreData = false;
      iuf(kDebugMode){
        print('Error: $e');

      }
    } finally {
      if (_currentPage == 1) {
        EssentialDialogs().showProgressHud(context, false);
      }
      _isLoading = false;
    }
  }


  List<DeficiencyData> mapDeficiencyToGridRows(List<DataDeficiency> dataList, int currentPage, int pageSize) {
    int startIndex = ((currentPage - 1) * pageSize) + 1;

    return dataList.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return DeficiencyData(
        (startIndex + index).toString(), // 👈 Sr No continues across pages
        item.admDepttName ?? '',
        item.totalEntryMonthly?.toString() ?? '0',
        item.totalPending?.toString() ?? '0',
        item.totalNAPPell?.toString() ?? '0',
        item.totalNRespo?.toString() ?? '0',
        item.totalNLawyers?.toString() ?? '0',
        item.totalNOIC?.toString() ?? '0',
        item.totalNHearing?.toString() ?? '0',
        item.nHoutDated?.toString() ?? '0',
        item.totalRedPending?.toString() ?? '0',
        item.rplyNotFile?.toString() ?? '0',
        item.factualReport?.toString() ?? '0',
        item.stayInGovtFavour?.toString() ?? '0',
        item.stayInGovtAgainst?.toString() ?? '0',
      );
    }).toList();
  }


}



//----------------------------
class DeficiencyData {
  final String srNo;
  final String deptName;
  final String totalEntries;
  final String pendingCases;
  final String pet;
  final String nonPet;
  final String advocate;
  final String oic;
  final String hearing;
  final String dateNotUpdated;
  final String redCategory;
  final String replyNotFiled;
  final String approvedToAdvocate;
  final String stayFavour;
  final String stayAgainst;

  DeficiencyData(
      this.srNo,
      this.deptName,
      this.totalEntries,
      this.pendingCases,
      this.pet,
      this.nonPet,
      this.advocate,
      this.oic,
      this.hearing,
      this.dateNotUpdated,
      this.redCategory,
      this.replyNotFiled,
      this.approvedToAdvocate,
      this.stayFavour,
      this.stayAgainst,
      );
}


class DeficiencyDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  DeficiencyDataSource(List<DeficiencyData> dataList) {
    _rows = dataList.map<DataGridRow>((data) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'srNo', value: data.srNo),
        DataGridCell(columnName: 'deptName', value: data.deptName),
        DataGridCell(columnName: 'totalEntries', value: data.totalEntries),
        DataGridCell(columnName: 'pendingCases', value: data.pendingCases),
        DataGridCell(columnName: 'pet', value: data.pet),
        DataGridCell(columnName: 'nonPet', value: data.nonPet),
        DataGridCell(columnName: 'advocate', value: data.advocate),
        DataGridCell(columnName: 'oic', value: data.oic),
        DataGridCell(columnName: 'hearing', value: data.hearing),
        DataGridCell(columnName: 'dateNotUpdated', value: data.dateNotUpdated),
        DataGridCell(columnName: 'redCategory', value: data.redCategory),
        DataGridCell(columnName: 'replyNotFiled', value: data.replyNotFiled),
        DataGridCell(columnName: 'approvedToAdvocate', value: data.approvedToAdvocate),
        DataGridCell(columnName: 'stayFavour', value: data.stayFavour),
        DataGridCell(columnName: 'stayAgainst', value: data.stayAgainst),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            softWrap: true,         // 👈 allows wrapping
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

}
