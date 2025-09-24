
class ReportItem {
  final String srNo;
  final String adminDeptName;
  final String from1To10Years;
  final String moreThan10To20Years;
  final String moreThan20Years;
  final String contemptCases;
  final String reply3MonthsTo1Year;
  final String replyMoreThan1Year;
  final String approvedReplySubmittedToLawyer;
  final String caseWithoutCaseNo;
  final String orderPending3MonthsTo1Year;
  final String orderPendingMoreThan1Year;
  final String appeal3MonthsTo1Year;
  final String appealMoreThan1Year;

  ReportItem({
    required this.srNo,
    required this.adminDeptName,
    required this.from1To10Years,
    required this.moreThan10To20Years,
    required this.moreThan20Years,
    required this.contemptCases,
    required this.reply3MonthsTo1Year,
    required this.replyMoreThan1Year,
    required this.approvedReplySubmittedToLawyer,
    required this.caseWithoutCaseNo,
    required this.orderPending3MonthsTo1Year,
    required this.orderPendingMoreThan1Year,
    required this.appeal3MonthsTo1Year,
    required this.appealMoreThan1Year,
  });

  factory ReportItem.fromList(List<String> data) {
    return ReportItem(
      srNo: data[0],
      adminDeptName: data[1],
      from1To10Years: data[2],
      moreThan10To20Years: data[3],
      moreThan20Years: data[4],
      contemptCases: data[5],
      reply3MonthsTo1Year: data[6],
      replyMoreThan1Year: data[7],
      approvedReplySubmittedToLawyer: data[8],
      caseWithoutCaseNo: data[9],
      orderPending3MonthsTo1Year: data[10],
      orderPendingMoreThan1Year: data[11],
      appeal3MonthsTo1Year: data[12],
      appealMoreThan1Year: data[13],
    );
  }

  int _numericValue(String? value) {
    if (value == null || value.isEmpty) return 0;
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }

  List<int> get numericFields {
    return [
      _numericValue(from1To10Years),
      _numericValue(moreThan10To20Years),
      _numericValue(moreThan20Years),
      _numericValue(contemptCases),
      _numericValue(reply3MonthsTo1Year),
      _numericValue(replyMoreThan1Year),
      _numericValue(approvedReplySubmittedToLawyer),
      _numericValue(caseWithoutCaseNo),
      _numericValue(orderPending3MonthsTo1Year),
      _numericValue(orderPendingMoreThan1Year),
      _numericValue(appeal3MonthsTo1Year),
      _numericValue(appealMoreThan1Year),
    ];
  }

  List<String> toList() {
    return [
      srNo,
      adminDeptName,
      from1To10Years,
      moreThan10To20Years,
      moreThan20Years,
      contemptCases,
      reply3MonthsTo1Year,
      replyMoreThan1Year,
      approvedReplySubmittedToLawyer,
      caseWithoutCaseNo,
      orderPending3MonthsTo1Year,
      orderPendingMoreThan1Year,
      appeal3MonthsTo1Year,
      appealMoreThan1Year,
    ];
  }
}