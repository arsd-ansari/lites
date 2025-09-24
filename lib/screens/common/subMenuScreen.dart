import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors_app.dart';
import '../../utils/dimen_app.dart';
import '../citizenHomeScreen.dart';

class SubMenuScreen extends StatelessWidget {
  final MenuItem menuItem;

  const SubMenuScreen({Key? key, required this.menuItem}) : super(key: key);

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
          menuItem.title,
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
      ),
      body: ListView(
        children: menuItem.subItems.entries.map((entry) {
          return ListTile(
            leading: Icon(Icons.arrow_circle_right_sharp, color: Colors_App().main_color,), // ⬅️ arrow icon at start
            title: Text(
              entry.key,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, entry.value);
            },
          );
        }).toList(),
      ),

    );
  }
}


