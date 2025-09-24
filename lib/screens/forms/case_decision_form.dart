import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/essentialdialog_model.dart';
import '../../models/responses/GetCaseDecisionListModel.dart';
import '../../repository/caseApi/caseApiClient.dart';
import '../../utils/constants.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/servererror.dart';
import '../../utils/string_app.dart';

class CaseDecisionForm extends StatefulWidget {
  final int caseId;
  const CaseDecisionForm({super.key, required this.caseId});

  @override
  State<CaseDecisionForm> createState() =>
      _CaseDecisionFormState();
}

class _CaseDecisionFormState
    extends State<CaseDecisionForm> {

  DecisionData? selectedDecision;
  List<DecisionData> fullDecisionList = [];
  bool _isFormVisible = false;
  bool? isOrderObtained;
  bool? isApplyCert;
  bool? isCopyReceived;
  bool? isDecisionGovFavor;
  bool? isMatters ;
  bool? isOpenionAdvocate;
  bool? isOpenionOic;
  bool? isOpenionToHod;
  bool? isForwordToHod;
  bool? isOpenionOfDept;
  bool? isCourtDecionSentHod;
  bool? isDecisionToGovt;
  bool? isFinalDecisonForAppeal;
  bool? isDecisionComplied;
  bool? isStayGranted;
  bool? isExParte;
  bool? isSendingCertifiedCopy;
  String? selectedCourtDecisionDateToHod;
  String? selectedCourtDecisionDateToGov;
  String? selectedFinalDecisionDateOfGov;
  String? selectedDecisionCompliedDate;
  String? selectedStayGrantedDate;
  String? selectedExParteDate;
  String? selectedSendingCertifiedCopyDate;

  List<List<String>> rowData = [];

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
                'Add Decision Details',
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
                          'Decision Date',
                          '16/09/2024',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow(
                          'Web Copy Of Order Obtained(Y/N)',
                          isOrderObtained,
                        ),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Apply For Cert. Copy(Y/N)', isApplyCert),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Copy Received',isCopyReceived),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Decision Detail',
                          'Decision Detail',
                        ),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Decision in Govt. Favor',isDecisionGovFavor),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Matters',isMatters),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Time Limit For Compliance Date',
                          selectedDecision?.pDAppealFilingDate ?? ''
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'Due Date For Filling Appeal',
                            selectedDecision?.pDDateoffilingAppeal ?? ''
                        ),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Opinion of Advocate Obtgaines(Y/N)',isOpenionAdvocate),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Opinion Of OIC',isOpenionOic),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Opinion Provide To OIC/HOD(Y/N)',isOpenionToHod),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Copy Forward To OIC/HOD(Y/N)',isForwordToHod),
                        const SizedBox(height: 15),
                        Constants().buildCheckbox(
                          'Court Decision Sent To Head Office',
                          isCourtDecionSentHod ?? false,
                              (val) {
                            setState(() {
                              isCourtDecionSentHod = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Court Decision Sent To Head Office',
                          selectedDate: selectedCourtDecisionDateToHod ?? selectedDecision?.pDDecisionSenttoHODDate,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedCourtDecisionDateToHod = date);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildCheckbox(
                          'Court Decision Sent To Govt',
                          isDecisionToGovt ?? false,
                              (val) {
                            setState(() {
                              isDecisionToGovt = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Court Decision Sent To Govt',
                          selectedDate: selectedCourtDecisionDateToGov ?? selectedDecision?.pDDecisionSenttoGovtDate,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedCourtDecisionDateToGov = date);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildRadioRow('Opinion',isOpenionOfDept),

                        const Text(
                          'PAMC Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Constants().buildTextFieldReadOnly(
                          'PAMC Date',
                          selectedDecision?.pDDateoffilingAppeal ?? ""
                        ),

                        const SizedBox(height: 15),
                        _buildFilePicker("PAMC Document"),
                        const SizedBox(height: 15),
                        _buildFilePicker("Copy Of PAMC Decision Docs"),
                        const SizedBox(height: 15),
                        _buildFilePicker("Opinion Of OIC Docs"),
                        const SizedBox(height: 15),
                        Constants().buildCheckbox(
                          'Final Decision Of Govt. For Appeal',
                          isFinalDecisonForAppeal ?? false,
                              (val) {
                            setState(() {
                              isFinalDecisonForAppeal = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Final Decision Of Govt. For Appeal',
                          selectedDate: selectedFinalDecisionDateOfGov ?? selectedDecision?.pDFinalDecisionofGovtDate,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedFinalDecisionDateOfGov = date);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildCheckbox(
                          'Decision Complied?',
                          isDecisionComplied ?? false,
                              (val) {
                            setState(() {
                              isDecisionComplied = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Decision Complied?',
                          selectedDate: selectedDecisionCompliedDate ?? selectedDecision?.pDDecisionCompliedDate,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedDecisionCompliedDate = date);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildCheckbox(
                          'Stay Granted?',
                          isStayGranted ?? false,
                              (val) {
                            setState(() {
                              isStayGranted = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Stay Granted?',
                          selectedDate: selectedStayGrantedDate ?? selectedDecision?.pDStayGrantedDate,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedStayGrantedDate = date);
                            });
                          },
                        ),

                        Constants().buildTextFieldReadOnly(
                            'Decion Non Complied Reason',
                            selectedDecision?.pDDecisionNonCompliedReason ?? ''
                        ),
                        const SizedBox(height: 15),

                        Constants().buildTextFieldReadOnly(
                          'Remarks',
                          selectedDecision?.remark ?? ''
                        ),
                        /*TextFormField(
                          maxLength: 1000,
                          decoration: InputDecoration(
                            labelText: 'Remarks/Comments',
                            border: OutlineInputBorder(),
                          ),
                        ),*/
                        const SizedBox(height: 15),
                        Constants().buildCheckbox(
                          'Is Ex-Parte',
                          isExParte ?? false,
                              (val) {
                            setState(() {
                              isExParte = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Is Ex-Parte',
                          selectedDate:selectedExParteDate ?? selectedDecision?.dateoSendingCertifiedCopy,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedExParteDate = date);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Constants().buildCheckbox(
                          'Date Of Sending Certified Copy By Advocate',
                          isSendingCertifiedCopy ?? false,
                              (val) {
                            setState(() {
                              isSendingCertifiedCopy = val ?? false;
                            });
                          },
                        ),
                        Constants().buildDatePickerTile(
                          label: 'Date Of Sending Certified Copy By Advocate',
                          selectedDate: selectedSendingCertifiedCopyDate ?? selectedDecision?.dateoSendingCertifiedCopy,
                          onTap: () {
                            Constants().presentDatePicker(context, onDatePicked: (date) {
                              setState(() => selectedSendingCertifiedCopyDate = date);
                            });
                          },
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePicker(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.upload_file),
          label: const Text("Choose File"),
        ),
        const Text("Only PDF files allowed (Max: 5MB)",
            style: TextStyle(fontSize: 12)),
      ],
    );
  }



  Future<void> getCaseDecisionList(int CaseId) async {
    try {
      EssentialDialogs().showProgressHud(context, true);

      final apiClient = await CaseApiServiceApiclient.createService(context);
      final response = await apiClient.getCaseDecisionList(CaseId);

      if (kDebugMode) {
        print('getCaseDecisionList - res - ${response.status} - ${response.message}');
      }


      if (response.status == true && response.data != null) {
        setState(() {
          fullDecisionList = response.data!;
          selectedDecision = fullDecisionList.isNotEmpty ? fullDecisionList[0] : null;

          isOrderObtained = selectedDecision?.webCopyOrderObtained ?? false;
          isApplyCert = selectedDecision?.appliedForCertifiedCopyYN ?? false;
          isCopyReceived = selectedDecision?.copyReceivedYN ?? false;
          isDecisionGovFavor = selectedDecision?.decisionFA ?? false;
          isMatters = selectedDecision?.implementationRequired ?? false;
          isOpenionAdvocate = selectedDecision?.pDLawyerOpenionYN ?? false;
          isOpenionOic = selectedDecision?.opinionOfOicYN ?? false;
          isOpenionToHod = selectedDecision?.opinionProvidedToOicHodYN ?? false;
          isForwordToHod = selectedDecision?.copyForwordedOfOicHodYN ?? false;
          isCourtDecionSentHod = selectedDecision?.pDDecisionSenttoHOOYN ?? false;
          isDecisionToGovt = selectedDecision?.pDDecisionSenttoGovtYN ?? false;
          isOpenionOfDept = selectedDecision?.pDDepttOpenionYN ?? false;
          isFinalDecisonForAppeal = selectedDecision?.pDFinalDecisionofGovtYN ?? false;
          isDecisionComplied = selectedDecision?.pDDecisionCompliedYN ?? false;
          isStayGranted = selectedDecision?.pDStayGrantedYN ?? false;
          isExParte = selectedDecision?.isExParty ?? false;
          isSendingCertifiedCopy = selectedDecision?.dateoSendingCertifiedCopyYN ?? false;

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
        print('getCaseDecisionList - error: $e');
      }
      ServerErrorPage.withError(error: e as DioError, context: context);
    }
  }

}

