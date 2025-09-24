import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lites/screens/caseDecidedOnFirstHearing.dart';
import 'package:lites/screens/caseManagementScreen.dart';
import 'package:lites/screens/caseWithoutCaseNo.dart';
import 'package:lites/screens/citizenHomeScreen.dart';
import 'package:lites/screens/common/dashboardScreen.dart';
import 'package:lites/screens/common/loginPageScreen.dart';
import 'package:lites/screens/common/splashPage.dart';
import 'package:lites/screens/common/updateProfileScreen.dart';
import 'package:lites/screens/forms/case_registration_form.dart';
import 'package:lites/screens/forms/case_registration_view_details.dart';
import 'package:lites/screens/reports/aagPerformanceReport.dart';
import 'package:lites/screens/reports/actionPendingReport.dart';
import 'package:lites/screens/reports/advocatePerformanceReport.dart';
import 'package:lites/screens/reports/attentionWarrantReport.dart';
import 'package:lites/screens/reports/courtWiseReport.dart';
import 'package:lites/screens/reports/dashboardPendencyReport.dart';
import 'package:lites/screens/reports/decisionSummaryReport.dart';
import 'package:lites/screens/reports/deficiencyReport.dart';
import 'package:lites/screens/reports/entryStatusReport.dart';
import 'package:lites/screens/reports/evaluationSummaryReport.dart';
import 'package:lites/screens/reports/importantCaseReport.dart';
import 'package:lites/screens/reports/oicPerformanceReport.dart';
import 'package:lites/screens/reports/orderPendingReport.dart';
import 'package:lites/screens/reports/periorityWiseReport.dart';
import 'package:lites/screens/reports/replyNotFiledReport.dart';
import 'package:lites/screens/reports/summaryReport.dart';
import 'package:lites/screens/reports/talkingPointsReport.dart';
import 'package:lites/utils/colors_app.dart';
import 'package:lites/utils/constants.dart';
import 'package:lites/utils/lighttheme.dart';
import 'package:lites/utils/routes.dart';
import 'package:lites/utils/string_app.dart';

import 'models/responses/GetCaseDataByCaseIdModel.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  runApp(const LITES());
}

const fetchBackground = "fetchBackground";

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+



class LITES extends StatelessWidget {
  const LITES({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lighttheme = LightTheme();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: MaterialApp(
              title: String_App().appname,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.light,
              navigatorKey: Constants.navigatorKey,
              theme: ThemeData(
                useMaterial3: false,
                primarySwatch: lighttheme.createMaterialColor(Colors_App().main_color),
                canvasColor: Colors.transparent,
                scaffoldBackgroundColor: Colors_App().whitecolor,
              ),
              initialRoute: Routes().splashPage,
              routes: {
                /// Common Screens
                Routes().splashPage: (context) => SplashPage(),
                Routes().loginPage: (context) => LoginPage(),
                Routes().updateProfile: (context) => UpdateProfile(),
                Routes().citizenHomeScreen: (context) => CitizenHomeScreen(),
                Routes().caseManagementScreen: (context) => CaseManagementScreen(),
              //  Routes().caseRegistrationViewDetails: (context) => CaseRegistrationViewDetails(),
                /*Routes().caseRegistrationViewDetails: (context) {
                  final caseId = ModalRoute.of(context)!.settings.arguments as int;
                  return CaseRegistrationViewDetails(caseId: caseId);
                },*/
    Routes().caseRegistrationViewDetails: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return CaseRegistrationViewDetails(
    caseId: args['caseId'] as int,
    caseData: args['caseData'] as CaseData,
    );},
                Routes().caseRegistrationForm: (context) => CaseRegistrationForm(),
                Routes().caseWithoutCaseNoScreen: (context) => CaseWithoutCaseNoScreen(),
                Routes().caseDecidedOnFirstHearingScreen: (context) => CaseDecidedOnFirstHearingScreen(),
                Routes().importantCaseReport: (context) => ImportantCaseReport(),
                Routes().attentionWarrantReport: (context) => AttentionWarrantReport(),
                Routes().aagPerformanceReport: (context) => AagPerformanceReport(),
                Routes().summaryReport: (context) => SummaryReport(),
                Routes().talkingPointsReport: (context) => TalkingPointsReport(),
                Routes().decisionSummaryReport: (context) => DecisionSummaryReport(),
                Routes().dashboardPendencyReport: (context) => DashboardPendencyReport(),
                Routes().evaluationSummaryReport: (context) => EvaluationSummaryReport(),
                Routes().entryStatusReport: (context) => EntryStatusReport(),
                Routes().deficiencyReport: (context) => DeficiencyReport(),

                // new
                Routes().dashboardScreen: (context) => DashboardScreen(),
                Routes().actionPendingReport: (context) => ActionPendingReport(),
                Routes().courtWiseReport: (context) => CourtWiseReport(),
                Routes().priorityWiseReport: (context) => PriorityWiseReport(),
                Routes().oicPerformanceReport: (context) => OicPerformanceReport(),
                Routes().advocatePerformanceReport: (context) => AdvocatePerformanceReport(),
                Routes().orderPendingReport: (context) => OrderPendingReport(),
                Routes().replyNotFiledReport: (context) => ReplyNotFiledReport(),
              }
            // onGenerateRoute: Routes.generateRoutes,
          ),
        );

  }
}
