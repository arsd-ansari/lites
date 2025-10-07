import 'package:flutter/material.dart';

class EssentialDialogModel {

  IconData iconData;
  ImageProvider logo;
  bool isOkClicked;

  double logoWidth,logoHeight;

  String appTitle, appMessage;
  Color myColor;



  EssentialDialogModel({
    this.appTitle = 'LITES',
    this.appMessage = 'pass msg here',
    this.isOkClicked = false,
    this.iconData =  Icons.flutter_dash,
    this.logo = const AssetImage('assets/images/lites.png'),
    this.logoHeight = 100,
    this.logoWidth = 100,
    this.myColor = const Color(0xFF124e7e),
  });
}
