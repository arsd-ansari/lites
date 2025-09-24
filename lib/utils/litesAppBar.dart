import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors_app.dart';
import '../utils/dimen_app.dart';

class LitesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final String? packingSize;
  final VoidCallback onBackPressed;
  final PreferredSizeWidget? bottom;

  const LitesAppBar({
    Key? key,
    required this.title,
    this.subTitle,
    this.packingSize,
    required this.onBackPressed,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors_App().main_color,
      elevation: 5.0,
      shadowColor: Colors.black,
      toolbarHeight: 74,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          subTitle != null
              ? Text(
            subTitle ?? "",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
            maxLines: 2,// Avoid truncating
          )
              : const SizedBox.shrink(),
        ],
      ),
      centerTitle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Dimen_App().borderRadius_circular_25),
          bottomRight: Radius.circular(Dimen_App().borderRadius_circular_25),
        ),
      ),
      leading: BackButton(
        onPressed: () {
          onBackPressed();
        },
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
