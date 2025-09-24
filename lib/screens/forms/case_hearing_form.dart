import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetCaseHearingListModel.dart';
import '../../repository/caseApi/caseApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class CaseHearingForm extends StatefulWidget {
  final int caseId;
    const CaseHearingForm({super.key, required this.caseId});

  @override
  State<CaseHearingForm> createState() =>
      _CaseHearingFormState();
}

class _CaseHearingFormState
    extends State<CaseHearingForm> {

  HearingData? selectedHearing;
  List<HearingData> fullHearingList = [];
  bool _isFormVisible = false;
  bool? isAdmitted = true;
  bool? isStayGranted;
  bool? isIntrimOrder;
  bool? isMiscApp;
  bool? isReplyFiled;
  bool? isVacatingAdmitted;
  bool? isSupplimentaryFiled;
  bool? isAdjournment;
  bool? isArgument;
  bool? isReserved;
  bool? isDecided;
  bool? _isNextHearing;
  String? selectedNextHearingDate;
  String getAdmittedStatus(int? value) {
    switch (value) {
      case 1:
        return "Yes";
      case 0:
        return "No";
      case 2:
        return "Awaited";
      default:
        return "-";
    }
  }
  String getRepliedFiledStatus(int? value) {
    switch (value) {
      case 1:
        return "Yes";
      case 0:
        return "No";
      default:
        return "-";
    }
  }
  String getJudgeProReservedStatus(int? value) {
    switch (value) {
      case 1:
        return "Yes";
      case 0:
        return "No";
      default:
        return "-";
    }
  }

  List<String> columnTitles = [
    'Sr No',
    'Hearing Date',
    'Next Hearing Date',
    'Due Course',
    'Remarks',
    'Decided',
    'Action',
  ];
  List<List<String>> rowData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHearingList(widget.caseId);
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
                    child: Text(_isFormVisible ? 'Hide Form' : 'Show Form'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Add Case Hearing',
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
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Advocate Name',
                          selectedHearing?.lawyerName ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Hearing Date',
                          selectedHearing?.hearingDate ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'OIC',
                          selectedHearing?.oICName ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Admitted (Y/N/A)',
                          getAdmittedStatus(selectedHearing?.hCAdmittedYNA),
                        ),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Stay Granted', isStayGranted),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Intrim Order',isIntrimOrder),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Date of submission of Factual Report by Deptt to Advocate',
                          selectedHearing?.dateCaseFillingDeptToAGAAG ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('HC ANy Misc App Filed',isMiscApp),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Stay Finish Date',
                          selectedHearing?.stayFinishDate ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Approved Reply Submitted to Advocate Date',
                          selectedHearing?.replyFileDate ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Reply Filed',isReplyFiled),
                        Constants().buildTextFieldReadOnly(
                          'Reply Filed',
                          getRepliedFiledStatus(selectedHearing?.hCReplyfiledYN),
                        ),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('App. Vacating/Stay',isVacatingAdmitted),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Supplimantary Reply Filed',isSupplimentaryFiled),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Adjourned without any actionhearing/Adjournment',isAdjournment),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Personal Appearance',
                          selectedHearing?.specialAppearance ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildCheckbox(
                          'Next Hearing Date',
                          _isNextHearing ?? false,
                              (val) {
                            setState(() {
                              _isNextHearing = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Next Hearing Date',
                          selectedDate: selectedHearing?.nextHearingDate,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedNextHearingDate = date);
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        Constants().buildTextFieldReadOnly(
                          'Due Course/Decided',
                          selectedHearing?.dueCourse ?? '',
                        ),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Argument Over',isArgument),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Judge Pro/Reserved?',isReserved),
                        const SizedBox(height: 5),
                        Constants().buildRadioRow('Decided',isDecided),
                        const SizedBox(height: 5),
                        // TextFormField(
                        //   maxLength: 1000,
                        //   decoration: InputDecoration(
                        //     labelText: 'Enter Remarks',
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                        _buildRichTextEditor(),
                        const SizedBox(height: 5),
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
                'Case Hearing List',
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
                      rowData[rowIndex][0]; // 👈 this is rowID
                      final tappedHearing = fullHearingList.firstWhere(
                            (e) => e.rowID?.toString() == tappedId,
                        orElse: () {
                              if(kDebugMode){
                                print(
                                  "⚠️ No match for rowID $tappedId in fullAppellantList",
                                );

                              }
                          return HearingData();
                        },
                      );
                      setState(() {
                        selectedHearing = tappedHearing;
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
  Widget _buildRichTextEditor() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        maxLines: 6,
        decoration: InputDecoration(
          labelText: 'Enter Remarks',
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> getHearingList(int CaseId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await CaseApiServiceApiclient.createService(context);
      final response = await apiClient.getCaseHearingsList(CaseId);

      if (kDebugMode) {
        print('getHearingList - res - ${response.status} - ${response.message}');
      }


      if (response.status == true && response.data != null) {
        setState(() {
          fullHearingList = response.data!;
          selectedHearing = fullHearingList.isNotEmpty ? fullHearingList[0] : null;

          isStayGranted = selectedHearing?.hCStayGrantedYN ?? false;
          isIntrimOrder = selectedHearing?.interimOrderYN ?? false;
          isMiscApp = selectedHearing?.hCAnyMiscAppfiledYN ?? false;
          isVacatingAdmitted = selectedHearing?.applVactingStayYN ?? false;
          isSupplimentaryFiled = selectedHearing?.supplementaryFactulYN ?? false;
          _isNextHearing = selectedHearing?.nextHearingYN ?? false;
          isAdjournment = selectedHearing?.adjournedYN ?? false;
          final status = selectedHearing?.judgmentPR?.trim().toUpperCase();
          isReserved = (status == 'R');

          rowData = fullHearingList.map((HearingData hearingData) {
            return [
              hearingData.rowID?.toString() ?? '',
              hearingData.hearingDate ?? '',
              hearingData.nextHearingDate ?? '',
              hearingData.dueCourse ?? '',
              hearingData.remark ?? '',
              hearingData.decidedStr ?? '',
              'View',
            ];

          }).toList();
        });

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
        print('getHearingList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioError, context: context);
    }
  }

}
