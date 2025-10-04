import 'package:intl/intl.dart';

extension DateFormatting on String {
  String reverseThisDate() {
    if (isEmpty) return "";
    try {
      var parts = split("-");
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    } catch (e) {
      return this;
    }
  }
}