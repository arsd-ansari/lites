import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/models/responses/GetCaseRespondantListModel.dart';

import '../../models/essentialdialog_model.dart';
import '../../repository/caseApi/caseApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class NonPetitionerRespondentForm extends StatefulWidget {
  final int caseId;
  const NonPetitionerRespondentForm({super.key, required this.caseId});

  @override
  State<NonPetitionerRespondentForm> createState() =>
      _NonPetitionerRespondentFormState();
}

class _NonPetitionerRespondentFormState
    extends State<NonPetitionerRespondentForm> {
  bool _isFormVisible = false;

  RespondantData? selectedRespondant;
  List<RespondantData> fullRespondantList = [];
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


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getRespondantList(widget.caseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: /*selectedRespondant == null
            ? const Center(child: CircularProgressIndicator())
            : */SingleChildScrollView(
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

              if (_isFormVisible)
                buildCaseDetailsCard(),

              const SizedBox(height: 20),

              const Text(
                'Case Non-Petitioner/Respondent List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      final tappedAppellant = fullRespondantList.firstWhere(
                            (e) => e.rowID?.toString() == tappedId,
                        orElse: () {

                              if(kDebugMode){
                                print(
                                  " No match for rowID $tappedId in fullAppellantList",
                                );

                              }
                          return RespondantData();
                        },
                      );
                      setState(() {
                        selectedRespondant = tappedAppellant;
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
          'Add Case Non-Petitioner/Respondent Details',
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
                  'Non-Petitioner/Respondent Name *',
                  selectedRespondant?.name ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Contact No.',
                  selectedRespondant?.contactNo ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Mobile No.',
                  selectedRespondant?.mobileNo ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Designation',
                  selectedRespondant?.designation ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Email Id',
                  selectedRespondant?.emailId ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Sr No *',
                  selectedRespondant?.respondantSrNo?.toString() ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Address 1',
                  selectedRespondant?.address1 ?? '',
                ),
                const SizedBox(height: 15),
                Constants().buildTextFieldReadOnly(
                  'Address 2',
                  selectedRespondant?.address2 ?? '',
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

  Future<void> getRespondantList(int CaseId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await CaseApiServiceApiclient.createService(context);
      final response = await apiClient.getRespondentsList(CaseId);

      if (kDebugMode) {
        print('getRespondentsList - res - ${response.status} - ${response.message}');
      }
      if (response.status == true && response.data != null) {
        setState(() {
          fullRespondantList = response.data!;
          selectedRespondant = fullRespondantList.isNotEmpty ? fullRespondantList[0] : null;

          rowData = fullRespondantList.map((RespondantData appellant) {
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
          print("Selected: ${selectedRespondant?.name}, ${selectedRespondant?.mobileNo}");

        }

      }
      else {
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
        print('getRespondentsList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioError, context: context);
    }
  }
}
