import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lites/models/responses/GetDashboardDetailModel.dart';
import 'package:lites/models/responses/GetDepDropDownListModel.dart';
import 'package:lites/repository/commonRepository.dart';
import 'package:lites/repository/reportApi/reportApiClient.dart';
import 'package:lites/utils/constants.dart';
import 'package:lites/utils/servererror.dart';
import '../../models/essentialdialog_model.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/colors_app.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/litesAppBar.dart';
import '../../utils/string_app.dart';

class DashboardScreen extends StatefulWidget {
  String routeName = '/DashboardScreen';

  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final CommonRepository commonRepository = CommonRepository();

  int _priorityTouchedIndex = -1;
  int _courtTouchedIndex = -1;
  bool _isFormVisible = false;
  List<Data> adminDeptOptions = [] ;
  List<Data> hodUnitDeptOptions = [];
  List<Data> officeOptions = [];

  CaseData? listCaseData;
  CaseEntryStatusData? listCaseEntryData;
  CasePriorityWiseData? listPriorityWiseData;
  CaseCourtWiseData? listCourtWiseData;

  final List<String> mainPerformaOptions = ['Main_Party', 'Performa_Party'];
  final List<Data> statusOptions = [
    Data(text: 'All', value: '2'),
    Data(text: 'Pending', value: '0'),
    Data(text: 'Decided', value: '1'),
  ];
  Data? selectedAdminDept;
  Data? selectedHodUnitDept;
  Data? selectedOffice;
  Data? selectedStatus;
  int? statusValue;
  String? selectedMainPerforma;
  int? adminDeptId;
  int? unitDeptId;
  int? officeDeptId;
  int totalCasesRegistered = 0;
  int pendingCases = 0;
  int decidedCases = 0;

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Constants.checkConnectivity().then((value) async {
        if (value) {
          getAdmDepList();
          getDashboardDetails();
        } else {
          EssentialDialogModel appDialog = EssentialDialogModel();
          appDialog.appMessage = String_App().nointernet;
          await EssentialDialogs().showNoInternetDialog(context, appDialog);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: LitesAppBar(
        title: 'Dashboard',
        onBackPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              const SizedBox(height: 20),

              if (_isFormVisible)
              // Filter section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                          selectHint: 'Select Main/Performa',
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
                                  selectedMainPerforma = null;
                                });
                                getDashboardDetails();
                              },
                              style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Reset"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                getDashboardDetails();
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

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20)
                ,decoration: BoxDecoration(
                color: Colors_App().main_color,
                borderRadius: BorderRadius.circular(12),
              ),
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          children: [
                            const Text(
                              'Case History',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Total Cases Registered',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              totalCasesRegistered.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                Text(
                                  pendingCases.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Pending Cases',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                Text(
                                  decidedCases.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Decided Cases',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCaseEntryStatusTable(),
                  const SizedBox(height: 20),
                  _buildPriorityWiseChart(),
                  const SizedBox(height: 20),
                  _buildCourtWiseChart(),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCaseEntryStatusTable() {
    final d = listCaseEntryData;
    if (d == null) {
      return Center(child: Text('No Case Entry Status Data available'));
    }

    final rows = [
      ['This Day', d.thisDay, d.thisDayUpdate, d.thisDayDecided, d.thisDayDelete],
      ['This Week', d.thisWeek, d.thisWeekUpdate,d.thisWeekDecided, d.thisWeekDelete],
      ['This Month', d.thisMonth, d.thisMonthUpdate,d.thisMonthDecided, d.thisMonthDelete],
      ['This Year', d.thisYear, d.thisYearUpdate, d.thisYearDecided,d.thisYearDelete],
      ['Previous Year', d.preYear, d.preYearUpdate,d.preYearDecided, d.preYearDelete],
      ['Total', d.total, d.totalUpdate,d.totalDecided, d.totalDelete],
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              color: Colors.blue.shade100,
              child: const Text(
                'Case Entry Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              border: TableBorder.all(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    _buildTableCell(''),
                    _buildTableCell('Registered\n(Entered)'),
                    _buildTableCell('Update'),
                    _buildTableCell('Decided(Entered)'),
                    _buildTableCell('Deleted'),
                  ],
                ),
                ...rows.map((row) {
                  return TableRow(
                    children: [
                      _buildTableCell(row[0].toString()),
                      _buildTableCell((row[1] ?? 0).toString()),
                      _buildTableCell((row[2] ?? 0).toString()),
                      _buildTableCell((row[3] ?? 0).toString()),
                      _buildTableCell((row[4] ?? 0).toString()),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityWiseChart() {
    if (listPriorityWiseData == null) {
      return const Center(child: Text('No Priority Wise Data available'));
    }

    final Map<String, int> priorityWiseData = {
      'Red': listPriorityWiseData!.red ?? 0,
      'Orange': listPriorityWiseData!.orange ?? 0,
      'Green': listPriorityWiseData!.green ?? 0,
    };

    final List<PieChartSectionData> sections = [];
    final List<Color> colors = [
      Colors.red.shade400,
      Colors.orange.shade400,
      Colors.green.shade400,
    ];

    int i = 0;
    priorityWiseData.forEach((key, value) {
      final isTouched = i == _priorityTouchedIndex;
      final double radius = isTouched ? 70 : 60;
      final TextStyle style = TextStyle(
        fontSize: isTouched ? 18 : 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: value.toDouble(),
          title: isTouched ? value.toString() : '',
          radius: radius,
          titleStyle: style,
        ),
      );
      i++;
    });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              color: Colors.blue.shade100,
              child: const Text(
                'Priority Wise',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),

            // Legend
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: priorityWiseData.entries.map((entry) {
                  Color legendColor;
                  switch (entry.key) {
                    case 'Red':
                      legendColor = Colors.red.shade400;
                      break;
                    case 'Orange':
                      legendColor = Colors.orange.shade400;
                      break;
                    default:
                      legendColor = Colors.green.shade400;
                  }

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: legendColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('${entry.key} (${entry.value})'),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Pie chart
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    borderData: FlBorderData(show: false),
                    pieTouchData: PieTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                        setState(() {
                          if (event.isInterestedForInteractions &&
                              pieTouchResponse?.touchedSection != null) {
                            _priorityTouchedIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                          } else {
                            _priorityTouchedIndex = -1;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget _buildCourtWiseChart() {
    if (listCourtWiseData == null) {
      return const Center(child: Text('No Court Wise Data available'));
    }

    final caseCourtWiseData = listCourtWiseData!;

    final courtData = [
      {'label': 'Supreme Court', 'value': caseCourtWiseData.supremeCourt ?? 0},
      {'label': 'HC Jodhpur', 'value': caseCourtWiseData.highCourtJodhpur ?? 0},
      {'label': 'HC Jaipur', 'value': caseCourtWiseData.highCourtJaipur ?? 0},
      {'label': 'RCSAT', 'value': caseCourtWiseData.rCSAT ?? 0},
      {'label': 'District Court', 'value': caseCourtWiseData.districtCourt ?? 0},
      {'label': 'Tribunals', 'value': caseCourtWiseData.tribunalCourts ?? 0},
      {'label': 'NationalGreenTribunalCourts', 'value': caseCourtWiseData.nationalGreenTribunalCourts ?? 0},
      {'label': 'OtherStateHighCourt', 'value': caseCourtWiseData.otherStateHighCourt ?? 0},
      {'label': 'OtherThanDistrictCourt', 'value': caseCourtWiseData.otherThanDistrictCourt ?? 0},
    ];

    final filteredCourtData = courtData.where((e) => (e['value'] as int) > 0).toList();


    if (filteredCourtData.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    final colors = [
      Colors.deepPurple,
      Colors.teal,
      Colors.amber,
      Colors.redAccent,
      Colors.indigo,
      Colors.orange,
      Colors.green,
      Colors.brown,
      Colors.purple,
    ];

    final sections = List.generate(filteredCourtData.length, (i) {
      final item = filteredCourtData[i];
      final isTouched = i == _courtTouchedIndex;
      final radius = isTouched ? 70.0 : 60.0;
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: (item['value'] as int).toDouble(),
        title: isTouched ? item['value'].toString() : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 18 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            color: Colors.blue.shade100,
            child:  const Text(
              'Court Wise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: List.generate(filteredCourtData.length, (i) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: colors[i % colors.length],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${filteredCourtData[i]['label']} (${filteredCourtData[i]['value']})',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 20),

          Center(
            child: SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response?.touchedSection == null) {
                          _courtTouchedIndex = -1;
                        } else {
                          _courtTouchedIndex = response!
                              .touchedSection!.touchedSectionIndex;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
      //  ),
    );
  }

  Future<void> getAdmDepList() async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      adminDeptOptions = await commonRepository.getAdminDepartments(context); //

      setState(() {});
    }
    catch (e) {
      if (e is DioException && e.error.toString().contains("Token expired")) {
        return;
      }
      await EssentialDialogs().openOkDismissDialog(
        context,
        EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: e.toString(),
        ),
      );
    }
    finally {
      EssentialDialogs().showProgressHud(context, false);
    }
  }

  Future<void> getUnitList(int adminDeptId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      hodUnitDeptOptions = await commonRepository.getUnits(context, adminDeptId); //

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

      officeOptions = await commonRepository.getOfficeList(context, unitDeptId!);

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

  Future getDashboardDetails() async {
    try {
      EssentialDialogs().showProgressHud(context, true);
      ReportApiClient client = await ReportApiServiceApiclient.createService(context);

      DashboardReqModel req = DashboardReqModel();

      req.admDepttId = int.tryParse(selectedAdminDept?.value ?? '0') ?? 0;
      req.unitId = int.tryParse(selectedHodUnitDept?.value ?? '0') ?? 0;
      req.officeId = int.tryParse(selectedOffice?.value ?? '0') ?? 0;
      req.status = int.tryParse(selectedStatus?.value ?? '0') ?? 0;
      req.primarySecondary = selectedMainPerforma ?? 'Main_Party';
      //  }

      req.districtId = 0;
      req.oicId = 0;
      req.lawyerId = 0;
      req.roleId = 1;

      if (kDebugMode) {
        print('getDashboardDetails - raw request - ${jsonEncode(req.toJson())}');
      }
      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};

      final encryptedResponse = await client.getDashboardDetails(encryptedRequest);

      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      if (kDebugMode) {
        print("Decrypted dashboard response: $decryptedMap");
      }

      final response = GetDashboardDetailModel.fromJson( decryptedMap);

      EssentialDialogs().showProgressHud(context, false);

      if (response.status == true) {
        listCaseData = response.caseData;
        listCaseEntryData = response.caseEntryStatusData;
        listCourtWiseData = response.caseCourtWiseData;
        listPriorityWiseData = response.casePriorityWiseData;

        setState(() {
          totalCasesRegistered = listCaseData?.totalCases ?? 0;
          pendingCases = listCaseData?.totalPendingCases ?? 0;
          decidedCases = listCaseData?.totalClosedCases ?? 0;
        });
      } else {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage = response.message ?? "Something Went Wrong..!!";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('getDashboardDetails - error - $e');
      }
      EssentialDialogs().showProgressHud(context, false);
      ServerErrorPage.withError(error: e as DioException, context: context);
    }
  }

}
