
import 'package:lites/screens/advanceSearch.dart';
import 'package:lites/screens/caseDecidedOnFirstHearing.dart';
import 'package:lites/screens/caseManagementScreen.dart';
import 'package:lites/screens/caseWithoutCaseNo.dart';
import 'package:lites/screens/causeListData.dart';
import 'package:lites/screens/common/dashboardScreen.dart';
import 'package:lites/screens/forms/case_registration_form.dart';
import 'package:lites/screens/reports/aagPerformanceReport.dart';
import 'package:lites/screens/reports/actionPendingReport.dart';
import 'package:lites/screens/reports/advocatePerformanceReport.dart';
import 'package:lites/screens/reports/attentionWarrantReport.dart';
import 'package:lites/screens/reports/courtWiseReport.dart';
import 'package:lites/screens/reports/decisionSummaryReport.dart';
import 'package:lites/screens/reports/evaluationSummaryReport.dart';
import 'package:lites/screens/reports/oicPerformanceReport.dart';
import 'package:lites/screens/reports/periorityWiseReport.dart';
import 'package:lites/screens/reports/replyNotFiledReport.dart';
import 'package:lites/screens/reports/summaryReport.dart';
import 'package:lites/screens/reports/talkingPointsReport.dart';

import '../screens/citizenHomeScreen.dart';
import '../screens/common/loginPageScreen.dart';
import '../screens/common/splashPage.dart';
import '../screens/common/updateProfileScreen.dart';
import '../screens/reports/dashboardPendencyReport.dart';
import '../screens/reports/deficiencyReport.dart';
import '../screens/reports/entryStatusReport.dart';
import '../screens/reports/importantCaseReport.dart';
import '../screens/reports/orderPendingReport.dart';


class Routes {
  String splashPage = SplashPage().routeName;
  String loginPage = LoginPage().routeName;
  String updateProfile = UpdateProfile().routeName;
  String citizenHomeScreen = CitizenHomeScreen().routeName;
  String subMenuScreen = CitizenHomeScreen().routeName;
  String caseManagementScreen = CaseManagementScreen().routeName;
  String caseRegistrationForm = CaseRegistrationForm().routeName;
 // String caseRegistrationViewDetails = CaseRegistrationViewDetails().routeName;

   String caseRegistrationViewDetails = '/CaseRegistrationViewDetails';
  String caseWithoutCaseNoScreen = CaseWithoutCaseNoScreen().routeName;
  String caseDecidedOnFirstHearingScreen = CaseDecidedOnFirstHearingScreen().routeName;
  String importantCaseReport = ImportantCaseReport().routeName;
  String attentionWarrantReport = AttentionWarrantReport().routeName;
  String aagPerformanceReport = AagPerformanceReport().routeName;
  String summaryReport = SummaryReport().routeName;
  String talkingPointsReport = TalkingPointsReport().routeName;
  String decisionSummaryReport = DecisionSummaryReport().routeName;
  String dashboardPendencyReport = DashboardPendencyReport().routeName;
  String evaluationSummaryReport = EvaluationSummaryReport().routeName;
  String entryStatusReport = EntryStatusReport().routeName;
  String deficiencyReport = DeficiencyReport().routeName;

  // new report
  String dashboardScreen = DashboardScreen().routeName;
  String actionPendingReport = ActionPendingReport().routeName;
  String courtWiseReport = CourtWiseReport().routeName;
  String priorityWiseReport = PriorityWiseReport().routeName;
  String oicPerformanceReport = OicPerformanceReport().routeName;
  String advocatePerformanceReport = AdvocatePerformanceReport().routeName;
  String orderPendingReport = OrderPendingReport().routeName;
  String replyNotFiledReport = ReplyNotFiledReport().routeName;

  //new development
  String hCnrSearch = DashboardScreen().routeName;
  String hCaseStatus = DashboardScreen().routeName;
  String eCnrSearch = DashboardScreen().routeName;
  String eCaseStatus = DashboardScreen().routeName;
  String causeList = CauseListData().routeName;
  String advanceSearch = AdvanceSearch().routeName;

}
