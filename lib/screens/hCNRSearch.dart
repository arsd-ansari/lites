import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/repository/HighCourtApi/highCourtApiClient.dart';
import 'package:lites/utils/extension.dart';

import '../models/essentialdialog_model.dart';
import '../repository/caseApi/caseApiClient.dart';
import '../utils/constants.dart';
import '../utils/essentialdialog.dart';
import '../utils/litesAppBar.dart';
import '../utils/servererror.dart';
import '../utils/string_app.dart';

class HighCourtCNRSearch extends StatefulWidget {
  String routeName = '/hCnrSearch';

  HighCourtCNRSearch({super.key});

  @override
  State<HighCourtCNRSearch> createState() => _HighCourtCNRSearchState();
}

class _HighCourtCNRSearchState extends State<HighCourtCNRSearch> {
  final TextEditingController cnrNoController = TextEditingController();
  bool isLoading = false;
  bool _isDataVisible = false;

  List<String> columnTitlesDetails = [
    'Case Type',
    'Filing Number',
    'Filing Date',
    'Registration Number',
    'Registration Date',
    'CNR Number',
  ];
  List<String> columnTitlesStatus = [
    'First Hearing Date',
    'Next Hearing Date',
    'Decision Date',
    'Stage of Case',
    'Nature of Disposal',
    'Court Number and Judge',
    'Petitioner and Advocate',
    'Respondent and Advocate',
  ];
  List<String> columnTitlesHistory = [
    'Registration No.',
    'Judge',
    'Business On Date',
    'Hearing Date',
    'Purpose of hearing',
  ];
  List<List<String>> rowDataDetails = [];
  List<List<String>> rowDataStatus = [];
  List<List<String>> rowDataHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LitesAppBar(
        title: 'Search by CNR Number',
        onBackPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Constants().buildTextField(
                        'Enter CNR Number',
                        cnrNoController,
                        hint: 'Enter CNR No.',
                        keyboardType: TextInputType.text,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            getDetailByCNR(cnrNoController.text)
                            ;
                          },
                          child: const Text("Search"),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              if (_isDataVisible)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'High Court Bench Jaipur',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Case Details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesDetails,
                            rowData: rowDataDetails,
                            iconColumns: {6: Icons.pending_actions_sharp},
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Case Status',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesStatus,
                            rowData: rowDataStatus,
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'History of Case Hearing',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Constants().buildCustomDataTableWithIcon(
                            columnTitles: columnTitlesHistory,
                            rowData: rowDataHistory,
                            onIconPressed: (rowIndex, colIndex) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getDetailByCNR(String cnrNum) async {
    setState(() {
      _isDataVisible = false;
    });
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await HighCourtApiServiceApiclient.createService(
        context,
      );
      final response = await apiClient.getDetailByCNR(cnrNum);

      if (kDebugMode) {
        print(
          'getDetailByCNR - res - ${response.status} - ${response.message}',
        );
      }

      if (response.status == true && response.data != null) {
        setState(() {
          rowDataDetails = [
            [
              (response.data?.typeNameFil?? "--"),
              "${response.data?.filNo}/${response.data?.filYear?? "--"}",
              (response.data?.dateOfFiling?.reverseThisDate() ?? "--"),
              "${response.data?.regNo}/${response.data?.regYear?? "--"}",
              (response.data?.dtRegis?.reverseThisDate() ?? "--"),
              (response.data?.cino?? "--"),
            ],
          ];
          rowDataStatus = [
            [
              (response.data?.dateFirstList?.isNotEmpty ?? false ? "${response.data?.dateFirstList?.reverseThisDate()}" : "--"),
              (response.data?.dateNextList?.isNotEmpty ?? false ? "${response.data?.dateNextList?.reverseThisDate()}" : "--"),
              (response.data?.dateLastList?.isNotEmpty ?? false ? "${response.data?.dateLastList?.reverseThisDate()}" : "--"),
              (response.data?.purposeName ?? "--"),
              "${response.data?.disposalType ?? "--"}",
              (response.data?.desgname ?? "--"),
              "${response.data?.petName ?? "--"}, Advocate - ${response.data?.petAdv ?? "--"}",
              "${response.data?.resName ?? "--"}, Advocate - ${response.data?.resAdv ?? "--"}",
            ],
          ];

          rowDataHistory = [
            [
              "${response.data?.regNo}/${response.data?.regYear?? "--"}",
              (response.data?.historyofcasehearing?.srNo1?.judgeName?.isNotEmpty ?? false ? "${response.data?.historyofcasehearing?.srNo1?.judgeName}" : "--"),
              (response.data?.historyofcasehearing?.srNo1?.businessDate?.isNotEmpty ?? false ? "${response.data?.historyofcasehearing?.srNo1?.businessDate?.reverseThisDate()}" : "--"),
              (response.data?.historyofcasehearing?.srNo1?.hearingDate?.reverseThisDate() ?? "--"),
              (response.data?.historyofcasehearing?.srNo1?.purposeOfListing ?? "--"),
            ],
          ];

          _isDataVisible = true;
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
        print('getCaseDecisionList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioException, context: context);
    }
  }
}
