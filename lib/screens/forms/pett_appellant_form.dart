import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetCaseAppellantListModel.dart';
import '../../models/responses/GetCaseDataByCaseIdModel.dart';
import '../../repository/caseApi/caseApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';


class PetitionerRespondentForm extends StatefulWidget {
  final int caseId;

  const PetitionerRespondentForm({Key? key, required this.caseId})
    : super(key: key);

  @override
  State<PetitionerRespondentForm> createState() =>
      _PetitionerRespondentFormState();
}

class _PetitionerRespondentFormState extends State<PetitionerRespondentForm> {
  bool _isFormVisible = false;
  AppellantData? selectedAppellant;
  List<AppellantData> fullAppellantList = [];

  List<String> columnTitles = [
    'Sr No',
    'Respondent Name',
    'Designation',
    'Address',
    'Email Id',
    'Mobile No.',
    'Action',
  ];
  List<List<String>> rowData = [];
  CaseData? caseData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAppellantList(widget.caseId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                            child: Text(
                              _isFormVisible ? 'Hide Form' : 'Show Form',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (_isFormVisible) buildCaseDetailsCard(),

                      const SizedBox(height: 20),

                      const Text(
                        'Case Petitioner/Appellant List',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Constants().buildCustomDataTableWithIcon(
                          columnTitles: columnTitles,
                          rowData: rowData,
                          iconColumns: {6: Icons.pending_actions_sharp},
                          onIconPressed: (rowIndex, colIndex) {
                            if (colIndex == 6) {
                              final tappedId =
                                  rowData[rowIndex][0];
                              final tappedAppellant = fullAppellantList.firstWhere(
                                (e) => e.rowID?.toString() == tappedId,
                                orElse: () {
                                  if(kDebugMode){
                                    print(
                                      " No match for rowID $tappedId in fullAppellantList",
                                    );

                                  }
                                  return AppellantData(); // empty,
                                },
                              );
                              setState(() {
                                selectedAppellant = tappedAppellant;
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

  Widget buildCaseDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Case Petitioner/Appellant Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Petitioner/Appellant Name *',
                  selectedAppellant?.name ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Contact No.',
                  selectedAppellant?.contactNo ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Mobile No.',
                  selectedAppellant?.mobileNo ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Designation',
                  selectedAppellant?.designation ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Email Id',
                  selectedAppellant?.emailId ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Sr No *',
                  selectedAppellant?.appellantSrNo?.toString() ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Address 1',
                  selectedAppellant?.address1 ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Address 2',
                  selectedAppellant?.address2 ?? '',
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getAppellantList(int CaseId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await CaseApiServiceApiclient.createService(context);
      final response = await apiClient.getAppellantsList(
        CaseId,
      ); // 👈 use await

      if (kDebugMode) {
        print(
          'getAppellantList - res - ${response.status} - ${response.message}',
        );
      }
      if (response.status == true && response.data != null) {
        setState(() {
          fullAppellantList = response.data!;
          selectedAppellant =
              fullAppellantList.isNotEmpty ? fullAppellantList[0] : null;

          rowData =
              fullAppellantList.map((AppellantData appellant) {
                return [
                  appellant.rowID?.toString() ?? '',
                  appellant.name ?? '',
                  appellant.designation ?? '',
                  appellant.address1 ?? '',
                  appellant.emailId ?? '',
                  appellant.mobileNo ?? '',
                  'View',
                ];
              }).toList();
        });
        if(kDebugMode){
          print(
            "Selected: ${selectedAppellant?.name}, ${selectedAppellant?.mobileNo}",
          );

        }
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
        print('getAppellantList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioError, context: context);
    }
  }
}
