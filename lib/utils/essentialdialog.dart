import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lites/utils/routes.dart';
import 'package:lites/utils/storageService.dart';
import 'package:lites/utils/string_app.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import '../models/essentialdialog_model.dart';
import 'AppConstants.dart';
import 'colors_app.dart';
import 'constants.dart';
import 'dimen_app.dart';

class EssentialDialogs {
  openOkDismissDialog(
      BuildContext context,
      EssentialDialogModel appDialogModel,
      ) {
    FocusManager.instance.primaryFocus?.unfocus();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                contentPadding: const EdgeInsets.only(top: 10.0),
                content: SizedBox(
                  width: Dimen_App().sizedbox_width_200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: Dimen_App().sizedbox_height_10),
                      Text(
                        String_App().appname,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      SizedBox(height: Dimen_App().sizedbox_height_10),
                      Image(
                        image: appDialogModel.logo,
                        width: appDialogModel.logoWidth,
                        height: appDialogModel.logoHeight,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                          bottom: 30.0,
                          right: 20.0,
                          left: 20.0,
                        ),
                        child: Text(
                          appDialogModel.appMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                          softWrap: true,
                        ),
                      ),

                      // ✅ Buttons Section
                      Row(
                        children: [
                          if (appDialogModel.negativeText.isNotEmpty)
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(25.0),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                    if (appDialogModel.onNegative != null) {
                                      appDialogModel.onNegative!();
                                    }
                                  },
                                  child: Text(
                                    appDialogModel.negativeText,
                                    style: GoogleFonts.montserrat(
                                      color: Colors_App().whitecolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: appDialogModel.myColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: const Radius.circular(25.0),
                                  bottomLeft: appDialogModel.negativeText.isEmpty
                                      ? const Radius.circular(25.0)
                                      : Radius.zero,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  if (appDialogModel.onPositive != null) {
                                    appDialogModel.onPositive!();
                                  }
                                },
                                child: Text(
                                  appDialogModel.positiveText,
                                  style: GoogleFonts.montserrat(
                                    color: Colors_App().whitecolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  //TODO
  openLogOutDialog(BuildContext context, EssentialDialogModel appDialogModel) {
    FocusManager.instance.primaryFocus?.unfocus();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                contentPadding: const EdgeInsets.only(top: 10.0),
                content: SizedBox(
                  width: Dimen_App().sizedbox_width_400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: Dimen_App().sizedbox_height_10),
                      Text(
                        String_App().appname,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Dimen_App().sizedbox_height_10),
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: appDialogModel.myColor,
                          child: Icon(
                            Icons.logout,
                            color: Colors_App().whitecolor,
                            size: 50,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                          bottom: 30.0,
                          right: 10.0,
                          left: 10.0,
                        ),
                        child: Text(
                          'Are you sure to log out of your account?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: appDialogModel.myColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                          ),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text(
                                    String_App().btnCancel,
                                    style: GoogleFonts.montserrat(
                                      color: Colors_App().whitecolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                thickness: 1,
                                color: Colors_App().whitecolor,
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                    AppConstants.user = null;

                                    await SecureStorageService.deleteAll();

                                    // Redirect to Login
                                    if (!context.mounted) return;
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes().loginPage,
                                      (route) => false,
                                      arguments: {"type": 1},
                                    );
                                  },
                                  child: Text(
                                    String_App().logOut,
                                    style: GoogleFonts.montserrat(
                                      color: Colors_App().whitecolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
          },
        );
      },
    );
  }

  //TODO
  showNoInternetDialog(
    BuildContext context,
    EssentialDialogModel appDialogModel,
  ) {
    FocusManager.instance.primaryFocus?.unfocus();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                contentPadding: const EdgeInsets.only(top: 10.0),
                content: SizedBox(
                  width: Dimen_App().sizedbox_width_400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: Dimen_App().sizedbox_height_10),
                      Text(
                        String_App().appname,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Dimen_App().sizedbox_height_10),
                      Container(
                        child: Lottie.asset(
                          'assets/anim/noconnection.json',
                          width: 250,
                          height: 250,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: Text(
                          String_App().nointernet,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: appDialogModel.myColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            appDialogModel.isOkClicked = true;
                            Navigator.pop(context, true);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                String_App().btnOk,
                                style: GoogleFonts.montserrat(
                                  color: Colors_App().whitecolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
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
          },
        );
      },
    );
  }

  //WIDGETS
  showProgressHud(BuildContext context, bool startStop) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (startStop) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                backgroundColor: Colors_App().whitecolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 200,
                ),
                child: SizedBox(
                  width: 200, // small width
                  height: 230, // small height
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        String_App().appname,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Image(
                        image: EssentialDialogModel().logo,
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Loading...",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
