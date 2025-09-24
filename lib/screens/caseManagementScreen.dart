import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lites/screens/forms/case_decision_form.dart';
import 'package:lites/screens/forms/case_hearing_form.dart';
import 'package:lites/screens/forms/case_registration_view_details.dart';
import 'package:lites/screens/forms/non_pett_resp_form.dart';
import 'package:lites/screens/forms/pett_appellant_form.dart';
import 'package:lites/utils/colors_app.dart';

import '../models/essentialdialog_model.dart';
import '../models/responses/GetCaseDataByCaseIdModel.dart';
import '../repository/caseApi/caseApiClient.dart';
import '../utils/essentialdialog.dart';
import '../utils/servererror.dart';
import '../utils/string_app.dart';
import 'forms/case_advocate_form.dart';
import 'forms/case_oic_form.dart';

class CaseManagementScreen extends StatefulWidget {
  final String routeName = '/CaseManagementScreen';
  @override
  _CaseManagementScreenState createState() => _CaseManagementScreenState();
}

class _CaseManagementScreenState extends State<CaseManagementScreen> with TickerProviderStateMixin {
  int? caseId;
  String? source;

  List<String> filteredTabs = [];
  final List<String> tabTitles = [
    "Case Registration",
    "Pett./Appellant",
    "Non-Pett./Resp.",
    "Case Advocate",
    "Case OIC",
    "Case Hearing",
    "Case Decision",
  ];

  TabController? _tabController;

  CaseData? caseData;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (caseId != null && caseData == null) {
        _fetchCaseData();
      }
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is Map) {
      caseId = args['caseId'] as int?;
      source = args['source'] as String?;
      _filterTabs();
    }
  }

  void _filterTabs() {
    List<String> newFilteredTabs;

    if (source == 'CaseWithoutCaseNo') {
      newFilteredTabs = [
        "Case Registration",
        "Pett./Appellant",
        "Non-Pett./Resp.",
        "Case Advocate",
        "Case OIC",
        "Case Hearing",
      ];
    } else if (source == 'CaseDecidedOnFirstHearing') {
      newFilteredTabs = [
        "Case Registration",
        "Pett./Appellant",
        "Non-Pett./Resp.",
        "Case Hearing",
        "Case Decision",
      ];
    } else {
      newFilteredTabs = tabTitles;
    }

    if (!listEquals(newFilteredTabs, filteredTabs)) {
      _tabController?.dispose();
      filteredTabs = newFilteredTabs;

      // Create new
      _tabController = TabController(length: filteredTabs.length, vsync: this);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _fetchCaseData() async {
    try {
      EssentialDialogs().showProgressHud(context, true);
      final apiClient = await CaseApiServiceApiclient.createService(context);
      final response = await apiClient.getCaseDataByCaseId(caseId!);

      if (response.status == true && response.data != null) {
        setState(() {
          caseData = response.data!;
        });
      } else {
        final appDialog = EssentialDialogModel(
            appTitle: String_App().appname,
            appMessage: response.message ?? "Something went wrong");
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e) {
      if (kDebugMode) {
        print('getCaseData error: $e');
      }
      ServerErrorPage.withError(error: e as DioError, context: context);
    } finally {
      EssentialDialogs().showProgressHud(context, false);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (caseId == null || _tabController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WELCOME TO THE JUSTICE DEPARTMENT",
          style: GoogleFonts.montserrat(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors_App().main_color,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TabBar(
              controller: _tabController!,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelPadding: EdgeInsets.zero,
              tabs: List.generate(filteredTabs.length, (index) {
                final bool isSelected = _tabController!.index == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors_App().main_color : Colors.transparent,
                      border: Border.all(color: Colors_App().main_color),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      filteredTabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors_App().main_color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
              onTap: (index) {
                setState(() {
                  _tabController!.index = index;
                });
              },
            ),
          ),
        ),
      ),
      body: caseData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
          children: [
          // 👇 Top Card
          CaseHeaderCard(caseData: caseData!),

      // 👇 TabBarView
      Expanded(
        child: TabBarView(
          controller: _tabController!,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(filteredTabs.length, (index) {
            final title = filteredTabs[index];
            switch (title) {
              case "Case Registration":
                return CaseRegistrationViewDetails(caseId: caseId!, caseData: caseData!);
              case "Pett./Appellant":
                return PetitionerRespondentForm(caseId: caseId!);
              case "Non-Pett./Resp.":
                return NonPetitionerRespondentForm(caseId: caseId!);
              case "Case Advocate":
                return CaseAdvocateForm(caseId: caseId!);
              case "Case OIC":
                return CaseOicForm(caseId: caseId!);
              case "Case Hearing":
                return CaseHearingForm(caseId: caseId!);
              case "Case Decision":
                return CaseDecisionForm(caseId: caseId!);
              default:
                return const SizedBox();
            }
          }),
        )
      ),
      ],
    ));
  }
}
class CaseHeaderCard extends StatelessWidget {
  final CaseData caseData;

  const CaseHeaderCard({super.key, required this.caseData});

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Card(
          color: Colors.grey.shade200,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Court Name and Place: ${caseData.courtName ?? '-'} | '
                  'Case No./Year/Abbreviation: ${caseData.caseNo ?? '-'} / ${caseData.caseYear ?? '-'} / ${caseData.abbreviationName ?? '-'} | '
                  'Petitioner/Appellant: ${caseData.appellantName ?? '-'} | '
                  'Non-Petitioner/Respondent: ${caseData.respondentName ?? '-'}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
      ),
    );
  }

}


