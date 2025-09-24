import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/responses/GetCaseDataByCaseIdModel.dart';
import '../../utils/constants.dart';

class CaseRegistrationViewDetails extends StatelessWidget {
  final int caseId;
  final CaseData caseData;

  const CaseRegistrationViewDetails({Key? key, required this.caseId, required this.caseData})
      : super(key: key);

  Widget buildReadOnlyCheckbox(String label, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: null,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14), softWrap: true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isRamification = caseData.doesPOA ?? false;
    bool isAdminDept = caseData.doesPAPD ?? false;
    bool groupValue = caseData.applicationUnderSec5FiledYN ?? false;
    bool isGovEmployee = caseData.isEmployee ?? false;
    bool isImpCase = caseData.importantCase ?? true;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('CNR Number', caseData.cRNNumber ?? ''),
              const Text(
                'The CNR means Case No. Recorded. CNR is unique 16 digits number. For Example(RJHC000000000001)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red),
              ),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Admin Department', caseData.admDeptName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('HoD/Unit', caseData.unitName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Office', caseData.officeName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Court Type', caseData.courtName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Court Place', caseData.placeName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Court', caseData.courtName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Abbreviation', caseData.abbreviationName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Case Year', caseData.caseYear?.toString() ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Case No.', caseData.caseNo?.toString() ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('File No.', caseData.fileNo ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Category', caseData.subjectCategoryName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Sub Category', caseData.subjectSubCategoryName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Subject Matter', caseData.subjectMatterName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Subject Sub Matter', caseData.subjectSubMatterName ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Govt. Appellant/Respondent', caseData.appellantOrResponded ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Finance on Stake(Rs.)', ''),
              const SizedBox(height: 15),
              buildReadOnlyCheckbox(
                'Does the Litigation involve any policy of Govt./ important policies/orders of administrative dept. with wider ramification?',
                isRamification,
              ),
              const SizedBox(height: 15),
              buildReadOnlyCheckbox(
                'Does the Litigation involve any policy of Govt./ any amendment in act/ any policy decision of administrative department?',
                isAdminDept,
              ),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Priority Code', caseData.priorityCode?.toString() ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Sub Priority', caseData.subPriorityId?.toString() ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Reg. date', caseData.dateCaseFillingDeptToAGAAG ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Main/Performa', caseData.primarySecondary ?? ''),
              const SizedBox(height: 15),
              buildReadOnlyCheckbox('Group', groupValue),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Remark', caseData.remark ?? ''),
              const SizedBox(height: 15),
              Constants().buildTextFieldReadOnly('Link With Other Case', caseData.linkCaseId?.toString() ?? ''),
              const SizedBox(height: 15),
              buildReadOnlyCheckbox('Is Govt. Employee', isGovEmployee),
              const SizedBox(height: 15),
              Constants().buildRadioRow('Important Case', isImpCase),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}