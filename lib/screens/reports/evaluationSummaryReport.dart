import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/utils/litesAppBar.dart';
import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/reports/GetEvaluationSummaryModel.dart';
import '../../repository/reportApi/reportApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/string_app.dart';


class EvaluationSummaryReport extends StatefulWidget {
  String routeName = '/EvaluationSummaryReport';
  EvaluationSummaryReport({super.key});

  @override
  State<EvaluationSummaryReport> createState() => _EvaluationSummaryReportState();
}

class _EvaluationSummaryReportState extends State<EvaluationSummaryReport> {
  bool _isFormVisible = false;
  String? selectedToDate;
  String? selectedFromDate;
  Data? selectedLevel;
  List<DataEvaluationSummary> evaluationData = [];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMoreData = true; // NEW

  int totalPages = 1;
  bool isLoadingMore = false;
  final List<Data> levelOptions = [
    Data(text: 'All', value: '-1'),
    Data(text: 'Major', value: '1'),
    Data(text: 'Minor', value: '2'),
  ];
  List<String> columnTitles = [
    'Rank',
    'Administrative Deptt. Name',
    'Pending Cases',
    'Case Registered After 01/08/2017',
    'Case in document uploading pending',
    'Pendency in document uploading (in %)',
    'Reply Not Filed',
    'Reply Not Filed (in %)',
    'Case decided (against)',
    'Order Pending for Appeal',
    'Pendency of pending Appeal (in %)',
    'Order Pending for Compliance',
    'Pendency of pending Compliance (in %)',
    'Contempt Case',
    'Pendency of Contempt against pending cases (in %)',
  ];

  List<String> columnLabels = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'
  ];

  List<String> columnFormulas = [
    '', '', '', '', '', '(f) = (e/d)%',
    '', '(h) = (g/d)%',
    '', '', '(k) = (j/i)%',
    '', '(m) = (l/i)%',
    '', '(o) = (n/c)%'
  ];
  // Raw data format: [rank, dept, c, d, e, g, i, j, l, n]
  List<List<String>> rawData = [
    ['1', 'Agriculture Department', '2501', '2855', '70', '70', '1657', '0', '56', '47'],
    ['2', 'Co-operative Department, Jaipur', '2796', '2950', '34', '72', '496', '0', '4', '64'],
  ];

  List<List<String>> get rowData => evaluationData.asMap().entries.map((entry) {
    int index = entry.key + 1;
    final item = entry.value;

    String c = item.totalCases?.toString() ?? '0';
    String d = item.caseregAfter?.toString() ?? '0';
    String e = item.docsAdded?.toString() ?? '0';
    String g = item.replyFileCout?.toString() ?? '0';
    String i = item.totalDecidedAgainst?.toString() ?? '0';
    String j = item.orderPendingforAppeal?.toString() ?? '0';
    String l = item.decisionNotImplemented?.toString() ?? '0';
    String n = item.contemptCaseCount?.toString() ?? '0';

    return [
      index.toString(), // a - Rank
      item.admDepttName ?? '', // b - Department Name
      c,
      d,
      e,
      _percentage(e, d),
      g,
      _percentage(g, d),
      i,
      j,
      _percentage(j, i),
      l,
      _percentage(l, i),
      n,
      _percentage(n, c),
    ];
  }).toList();

  String _percentage(String num, String denom) {
    double numerator = double.tryParse(num) ?? 0;
    double denominator = double.tryParse(denom) ?? 1;
    return denominator == 0 ? '0%' : '${((numerator / denominator) * 100).toStringAsFixed(2)}%';
  }

  List<String> get totalRow {
    List<double> totals = List.filled(15, 0.0);

    for (var row in rowData) {
      for (int i = 2; i <= 13; i++) {
        if (!row[i].contains('%')) {
          totals[i] += double.tryParse(row[i]) ?? 0.0;
        }
      }
    }

    return List.generate(15, (i) {
      if (i == 0) return 'Total';
      if (i == 1) return '';
      if (i == 5) return _percentage(totals[4].toString(), totals[3].toString());
      if (i == 7) return _percentage(totals[6].toString(), totals[3].toString());
      if (i == 10) return _percentage(totals[9].toString(), totals[8].toString());
      if (i == 12) return _percentage(totals[11].toString(), totals[8].toString());
      if (i == 14) return _percentage(totals[13].toString(), totals[2].toString());
      return totals[i].toStringAsFixed(0);
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_isLoading && _hasMoreData) {
          _currentPage++;
          getEvaluationDetails();
        }
      }
    });


    WidgetsBinding.instance.addPostFrameCallback((_) {
      getEvaluationDetails();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Evaluation Summary',
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
                          label: 'Major/Minor',
                          options: levelOptions,
                          selectedValue: selectedLevel,
                          onChanged: (newValue) {
                            setState(() {
                              selectedLevel = newValue;
                            });
                          },
                          labelExtractor: (data) => data.text ?? '',
                          selectHint: 'Select Level',
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
                                  selectedFromDate = null;
                                  selectedToDate = null;
                                  selectedLevel = null;
                                  evaluationData.clear();
                                });

                                _currentPage = 1;
                                getEvaluationDetails();
                                },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentPage = 1;
                                  evaluationData.clear(); // 👈 correct
                                });
                                getEvaluationDetails();
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
                'Evaluation Summary Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              buildGovernmentInfo(),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // 👈 gives height to ListView
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (!isLoadingMore &&
                        scrollNotification.metrics.pixels >=
                            scrollNotification.metrics.maxScrollExtent - 200) {
                      if (_currentPage < totalPages) {
                        loadMore(); // 👈 Load next page
                      }
                    }
                    return false;
                  },
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 16),
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: buildCustomMultiRowTable(
                          columnTitles: columnTitles,
                          columnLabels: columnLabels,
                          columnFormulas: columnFormulas,
                          rowData: rowData,
                          totalRow: totalRow,
                        ),
                      ),
                      if (_isLoading && _currentPage > 1)
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
    if (_currentPage >= totalPages) return;

    setState(() {
      isLoadingMore = true;
      _currentPage++;
    });

    await getEvaluationDetails(); // 👈 loads next page

    setState(() {
      isLoadingMore = false;
    });
  }

  Widget buildGovernmentInfo() {
    return Container(
        padding: const EdgeInsets.all(12), // Optional: add padding inside the background
        color: Colors.blue.shade100, // 🔴 Set your background color here
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            Text(
              'Government of Rajasthan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
            ),
            Text(
              'Justice Department',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
            ),
            Text(
              '( Litigation Information Tracking & Evaluation System )',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
            ),
            SizedBox(height: 5),
            Text(
              '( Administrative Department Wise Evaluation Summary Report )',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '(As on ${DateFormat('dd/MM/yyyy').format(DateTime.now())})',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ],
        ) );
  }

  Widget buildCustomMultiRowTable({
    required List<String> columnTitles,
    required List<String> columnLabels,
    required List<String> columnFormulas,
    required List<List<String>> rowData,
    required List<String> totalRow,
  }) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      defaultColumnWidth: IntrinsicColumnWidth(),
      children: [
        // Row 1: Column Titles
        TableRow(
          decoration: BoxDecoration(color: Colors.blue.shade100),
          children: columnTitles
              .map((title) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ))
              .toList(),
        ),
        // Row 2: Alphabet Labels
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: columnLabels
              .map((label) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ))
              .toList(),
        ),
        // Row 3: Formula Descriptions
        TableRow(
          // decoration: BoxDecoration(color: Colors.orange.shade100),
          children: columnFormulas
              .map((formula) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              formula,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ))
              .toList(),
        ),
        // Data Rows
        ...rowData.map((row) {
          return TableRow(
            children: row
                .map((cell) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cell, textAlign: TextAlign.center),
            ))
                .toList(),
          );
        }),
        // Total Row
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: totalRow
              .map((cell) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cell,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ))
              .toList(),
        ),
      ],
    );
  }

  Future<void> getEvaluationDetails() async {
    try {
      _isLoading = true;
      if (_currentPage == 1) {
        EssentialDialogs().showProgressHud(context, true);
      }

      final apiClient = await ReportApiServiceApiclient.createService(context);
      final response = await apiClient.getEvaluationSummaryReportDetails(
        int.tryParse(selectedLevel?.value ?? '-1') ?? -1,
        selectedFromDate ?? '01/01/1947',
        (selectedToDate?.isNotEmpty == true)
            ? selectedToDate!
            : DateFormat('dd/MM/yyyy').format(DateTime.now()),
        _pageSize,
        _currentPage,
      );

      if (response.status == true && response.data != null) {
        final newRecords = response.data!;
        final paginationInfo = response.pagination?.first;

        setState(() {
          evaluationData.addAll(newRecords);

          // Calculate total pages based on totalRecords and pageSize
          final totalRecords = paginationInfo?.totalRecords ?? 0;
          totalPages = (totalRecords / _pageSize).ceil(); // 👈 calculate total pages
        });
      }
 else {
        if (_currentPage == 1) {
          EssentialDialogModel appDialog = EssentialDialogModel();
          appDialog.appTitle = String_App().appname;
          appDialog.appMessage = "No data found.";
          await EssentialDialogs().openOkDismissDialog(context, appDialog);
        }

        _hasMoreData = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('getSummaryListDetails error: $e');
      }

      if (_currentPage == 1) {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage = "Failed to fetch evaluation data.";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }

      _hasMoreData = false;
    } finally {
      if (_currentPage == 1) {
        EssentialDialogs().showProgressHud(context, false);
      }
      _isLoading = false;
    }
  }

}

