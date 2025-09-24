import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/models/responses/GetCaseAdvocateListModel.dart';

import '../../models/essentialdialog_model.dart';
import '../../repository/caseApi/caseApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class CaseAdvocateForm extends StatefulWidget {
  final int caseId;
  const CaseAdvocateForm({super.key, required this.caseId});

  @override
  State<CaseAdvocateForm> createState() =>
      _CaseAdvocateFormState();
}

class _CaseAdvocateFormState
    extends State<CaseAdvocateForm> {
  bool _isFormVisible = false;

  AdvocateData? selectedAdvocate;
  List<AdvocateData> fullAdvocateList = [];
  bool isAag = false;
  List<String> columnTitles = [
    'Sr No',
    'Advocate Name',
    'From Date',
    'To Date',
    'Action',
  ];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdvocateList(widget.caseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isFormVisible = !_isFormVisible;
                      });
                    },
                    child: Text(_isFormVisible ? 'Hide Form' : 'Show Form'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Add Case Advocate Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              if (_isFormVisible)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        SwitchListTile(
                          title: Text("If AG/AAG (Y/N)"),
                          value: isAag,
                          onChanged: (val) => setState(() => selectedAdvocate?.isAGAAG = val),
                        ),
                        Constants().buildTextFieldReadOnly(
                          'Name *',
                          selectedAdvocate?.lawyerName ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Sr Adv/Others',
                          selectedAdvocate?.srAdv ?? '',
                        ),
                        const SizedBox(height: 15),

                        Constants().buildTextFieldReadOnly(
                          'From Date',
                          selectedAdvocate?.fromDate != null && selectedAdvocate!.fromDate!.isNotEmpty
                              ? (() {
                            final date = DateTime.parse(selectedAdvocate!.fromDate!);
                            return "${date.day.toString().padLeft(2, '0')}/"
                                "${date.month.toString().padLeft(2, '0')}/"
                                "${date.year}";
                          })()
                              : '-',
                        ),
                        const SizedBox(height: 15),

                        Constants().buildTextFieldReadOnly(
                          'To Date',
                          selectedAdvocate?.toDate != null && selectedAdvocate!.toDate!.isNotEmpty
                              ? (() {
                            final date = DateTime.parse(selectedAdvocate!.toDate!);
                            return "${date.day.toString().padLeft(2, '0')}/"
                                "${date.month.toString().padLeft(2, '0')}/"
                                "${date.year}";
                          })()
                              : '-',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Actual Fee Paid',
                          selectedAdvocate?.actuallyPaidFee ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Approved Fee',
                          selectedAdvocate?.approvedFee ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Enrollment No. *',
                          selectedAdvocate?.enrollNo ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Order No.',
                          selectedAdvocate?.orderNo ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Request Send To *',
                          selectedAdvocate?.reqSendto.toString() ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Appointment Authority.',
                          selectedAdvocate?.appointmentAuthority ?? '',
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isFormVisible = !_isFormVisible;
                                });
                              },
                              style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Cancel"),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              const Text(
                'Case Advocate List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Constants().buildCustomDataTableWithIcon(
                  columnTitles: columnTitles,
                  rowData: rowData,
                  iconColumns: {4: Icons.pending_actions_sharp},
                  onIconPressed: (rowIndex, colIndex) {
                    if (colIndex == 4) {
                      final tappedId =
                      rowData[rowIndex][0]; // 👈 this is rowID
                      final tappedAppellant = fullAdvocateList.firstWhere(
                            (e) => e.rowID?.toString() == tappedId,
                        orElse: () {
                              if(kDebugMode){
                                print(
                                  "⚠️ No match for rowID $tappedId in fullAppellantList",
                                );
                              }
                          return AdvocateData();
                        },
                      );

                      setState(() {
                        selectedAdvocate = tappedAppellant;
                        _isFormVisible = true;
                      });
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

  Future<void> getAdvocateList(int CaseId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await CaseApiServiceApiclient.createService(context);
      final response = await apiClient.getCaseLawyersList(CaseId); // 👈 use await

      if (kDebugMode) {
        print('getAdvocateList - res - ${response.status} - ${response.message}');
      }

      if (response.status == true && response.data != null) {
        setState(() {
          fullAdvocateList = response.data!;
          selectedAdvocate = fullAdvocateList.isNotEmpty ? fullAdvocateList[0] : null;

          rowData = fullAdvocateList.map((AdvocateData advocate) {
            return [
              advocate.rowID?.toString() ?? '',
              advocate.lawyerName ?? '',
              advocate.fromDate != null
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(advocate.fromDate!))
                  : '',
              advocate.toDate != null
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(advocate.toDate!))
                  : '',
              'View',
            ];

          }).toList();
        });

      }else {
        EssentialDialogs().showProgressHud(context, false);
        final appDialog = EssentialDialogModel(
          appTitle: String_App().appname,
          appMessage: response.message ?? "Something went wrong",
        );
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }

      EssentialDialogs().showProgressHud(context, false);
    } catch (e) {
      EssentialDialogs().showProgressHud(context, false);
      if (kDebugMode) {
        print('getAdvocateList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioError, context: context);
    }
  }
}
