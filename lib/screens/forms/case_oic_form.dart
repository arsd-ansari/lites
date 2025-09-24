import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lites/models/responses/GetCaseOICListModel.dart';

import '../../models/essentialdialog_model.dart';
import '../../repository/caseApi/caseApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class CaseOicForm extends StatefulWidget {
  final int caseId;
  const CaseOicForm({super.key, required this.caseId});

  @override
  State<CaseOicForm> createState() =>
      _CaseOicFormState();
}

class _CaseOicFormState
    extends State<CaseOicForm> {
  bool _isFormVisible = false;

  OICData? selectedOIC;
  List<OICData> fullOICList = [];
  List<String> columnTitles = [
    'Sr No',
    'OIC Name',
    'From Date',
    'To Date',
    'Action',
  ];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOICList(widget.caseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: /*selectedOIC == null
            ? const Center(child: CircularProgressIndicator())
            :*/ SingleChildScrollView(
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
                'Add Case OIC Information',
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
                        Constants().buildTextFieldReadOnly(
                          'Name *',
                          selectedOIC?.oICName ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'SSO ID *',
                          selectedOIC?.signAuthOffice ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Designation',
                          selectedOIC?.txn ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Mobile No. *',
                          selectedOIC?.oICMobileNo ?? '',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Email Id',
                          selectedOIC?.oICEmail ?? '',
                        ),
                        const SizedBox(height: 15),

                        Constants().buildTextFieldReadOnly(
                          'From Date',
                          selectedOIC?.fromDate != null && selectedOIC!.fromDate!.isNotEmpty
                              ? (() {
                            final date = DateTime.parse(selectedOIC!.fromDate!);
                            return "${date.day.toString().padLeft(2, '0')}/"
                                "${date.month.toString().padLeft(2, '0')}/"
                                "${date.year}";
                          })()
                              : '-',
                        ),

                        const SizedBox(height: 15),

                        Constants().buildTextFieldReadOnly(
                          'To Date',
                          selectedOIC?.toDate != null && selectedOIC!.toDate!.isNotEmpty
                              ? (() {
                            final date = DateTime.parse(selectedOIC!.toDate!);
                            return "${date.day.toString().padLeft(2, '0')}/"
                                "${date.month.toString().padLeft(2, '0')}/"
                                "${date.year}";
                          })()
                              : '-',
                        ),

                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isFormVisible = !_isFormVisible;
                                });},
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
                'Case OIC List',
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
                      rowData[rowIndex][0];
                      final tappedOic = fullOICList.firstWhere(
                            (e) => e.rowID?.toString() == tappedId,
                        orElse: () {
                              if(kDebugMode){
                                print(
                                  "No match for rowID $tappedId in fullAppellantList",
                                );

                              }
                          return OICData();
                        },
                      );

                      setState(() {
                        selectedOIC = tappedOic;
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

  Future<void> getOICList(int CaseId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await CaseApiServiceApiclient.createService(context);
      final response = await apiClient.getCaseOICList(CaseId);

      if (kDebugMode) {
        print('getOICList - res - ${response.status} - ${response.message}');
      }

      if (response.status == true && response.data != null) {
        setState(() {
          fullOICList = response.data!;
          selectedOIC = fullOICList.isNotEmpty ? fullOICList[0] : null;

          rowData = fullOICList.map((OICData oicdata) {
            return [
              oicdata.rowID?.toString() ?? '',
              oicdata.oICName ?? '',

              oicdata.fromDate != null
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(oicdata.fromDate!))
                  : '',
              oicdata.toDate != null
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(oicdata.toDate!))
                  : '',
              'View',
            ];

          }).toList();
        });

      } else {
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
        print('getOICList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioError, context: context);
    }
  }
}
