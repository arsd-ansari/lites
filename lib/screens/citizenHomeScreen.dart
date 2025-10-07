import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lites/models/essentialdialog_model.dart';
import 'package:lites/utils/essentialdialog.dart';

import '../utils/colors_app.dart';
import '../utils/dimen_app.dart';
import '../utils/routes.dart';
import 'common/subMenuScreen.dart';

class MenuItem {
  final String title;
  final Map<String, String> subItems;
  final IconData icon;

  MenuItem({required this.title, required this.subItems, required this.icon});
}
final routes = Routes();


final List<MenuItem> mainMenuItems = [
  MenuItem(title: "Dashboard", subItems: {}, icon: Icons.dashboard),
  MenuItem(
    title: "Case Management",
    icon: Icons.folder_copy,
    subItems: {
      "Case Registration": routes.caseRegistrationForm,
      "Case Without Case": routes.caseWithoutCaseNoScreen,
      "Case Decided on 1st Hearing": routes.caseDecidedOnFirstHearingScreen,
    },
  ),
  MenuItem(
    title: "Important Reports",
    icon: Icons.star,
    subItems: {
      "Talking Points": routes.talkingPointsReport,
      "Summary Reports": routes.summaryReport,
      "Attention Warrented": routes.attentionWarrantReport,
      "AAG Performance": routes.aagPerformanceReport,
      "Important Report": routes.importantCaseReport,
      "Dashboard Pendency Report": routes.dashboardPendencyReport,
      "Decision Report": routes.decisionSummaryReport,
    },
  ),
  MenuItem(
    title: "MIS Reports",
    icon: Icons.bar_chart,
    subItems: {
      "Entry Status": routes.entryStatusReport,
      "Action Pending Reports": routes.actionPendingReport,
    },
  ),
  MenuItem(
    title: "Summary Reports",
    icon: Icons.summarize,
    subItems: {
      "Deficiency Report": routes.deficiencyReport,
      "Evaluation Report": routes.evaluationSummaryReport,
    },
  ),
  MenuItem(
    title: "Details Reports",
    icon: Icons.info_outline,
    subItems: {
      "Court Wise": routes.courtWiseReport,
      "Priority Wise": routes.priorityWiseReport,
    },
  ),
  MenuItem(
    title: "Analysis Reports",
    icon: Icons.analytics,
    subItems: {
      "OIC Performance": routes.oicPerformanceReport,
      "Advocate Performance": routes.advocatePerformanceReport,
    },
  ),
  MenuItem(
    title: "Pending Reports",
    icon: Icons.pending_actions,
    subItems: {
      "Order Pending for Appeal": routes.orderPendingReport,
      "Reply not Filed": routes.replyNotFiledReport,
    },
  ),
  MenuItem(
    title: "Integrate High Court Search",
    icon: Icons.manage_search_outlined,
    subItems: {
      "CNR Search": routes.orderPendingReport,
      "Case Status": routes.replyNotFiledReport,
    },
  ),
  MenuItem(
    title: "Integrate E-Court Search",
    icon: Icons.format_align_justify,
    subItems: {
      "CNR Search": routes.orderPendingReport,
      "Case Status": routes.replyNotFiledReport,
    },
  ),
  MenuItem(
    title: "High Court Cause List",
    icon: Icons.list_alt,
    subItems: {
      "Cause List Data": routes.causeList,
    },
  ),
  MenuItem(
    title: "Generic Search",
    icon: Icons.search,
    subItems: {
      "Advance Search": routes.advanceSearch,
    },
  ),
];



class CitizenHomeScreen extends StatefulWidget {
  String routeName = '/CitizenHomeScreen';

  CitizenHomeScreen({Key? key}) : super(key: key);

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors_App().main_color,
        elevation: 5.0,
        shadowColor: Colors.black,
        toolbarHeight: 55,
        title: Text(
          'Dashboard',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Dimen_App().borderRadius_circular_25),
            bottomRight: Radius.circular(Dimen_App().borderRadius_circular_25),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              EssentialDialogs().openLogOutDialog(
                context,
                EssentialDialogModel(),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 2,
        ),
        itemCount: mainMenuItems.length,itemBuilder: (context, index) {
        final item = mainMenuItems[index];
        return GestureDetector(
          onTap: () {
            if (item.title == "Dashboard") {
              Navigator.pushNamed(context, Routes().dashboardScreen);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubMenuScreen(menuItem: item),
                ),
              );
            }
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(item.icon, size: 40, color: Colors_App().main_color),

                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      ),
    );
  }
}

