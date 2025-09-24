class GetDashboardDetailModel {
  bool? status;
  String? message;
  CaseData? caseData;
  CaseEntryStatusData? caseEntryStatusData;
  CasePriorityWiseData? casePriorityWiseData;
  CaseCourtWiseData? caseCourtWiseData;

  GetDashboardDetailModel(
      {this.status,
        this.message,
        this.caseData,
        this.caseEntryStatusData,
        this.casePriorityWiseData,
        this.caseCourtWiseData});

  GetDashboardDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    caseData = json['caseData'] != null
        ? new CaseData.fromJson(json['caseData'])
        : null;
    caseEntryStatusData = json['caseEntryStatusData'] != null
        ? new CaseEntryStatusData.fromJson(json['caseEntryStatusData'])
        : null;
    casePriorityWiseData = json['casePriorityWiseData'] != null
        ? new CasePriorityWiseData.fromJson(json['casePriorityWiseData'])
        : null;
    caseCourtWiseData = json['caseCourtWiseData'] != null
        ? new CaseCourtWiseData.fromJson(json['caseCourtWiseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.caseData != null) {
      data['caseData'] = this.caseData!.toJson();
    }
    if (this.caseEntryStatusData != null) {
      data['caseEntryStatusData'] = this.caseEntryStatusData!.toJson();
    }
    if (this.casePriorityWiseData != null) {
      data['casePriorityWiseData'] = this.casePriorityWiseData!.toJson();
    }
    if (this.caseCourtWiseData != null) {
      data['caseCourtWiseData'] = this.caseCourtWiseData!.toJson();
    }
    return data;
  }
}

class CaseData {
  int? totalCases;
  int? totalPendingCases;
  int? totalClosedCases;
  double? totalCasesGroth;
  double? pendingCasesGroth;
  double? closedCasesGroth;

  CaseData(
      {this.totalCases,
        this.totalPendingCases,
        this.totalClosedCases,
        this.totalCasesGroth,
        this.pendingCasesGroth,
        this.closedCasesGroth});

  CaseData.fromJson(Map<String, dynamic> json) {
    totalCases = json['TotalCases'];
    totalPendingCases = json['TotalPendingCases'];
    totalClosedCases = json['TotalClosedCases'];
    /*totalCasesGroth = json['TotalCasesGroth'];
    pendingCasesGroth = json['PendingCasesGroth'];
    closedCasesGroth = json['ClosedCasesGroth'];*/
    totalCasesGroth = (json['TotalCasesGroth'] as num?)?.toDouble() ?? 0.0;
    pendingCasesGroth = (json['PendingCasesGroth'] as num?)?.toDouble() ?? 0.0;
    closedCasesGroth = (json['ClosedCasesGroth'] as num?)?.toDouble() ?? 0.0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCases'] = this.totalCases;
    data['TotalPendingCases'] = this.totalPendingCases;
    data['TotalClosedCases'] = this.totalClosedCases;
    data['TotalCasesGroth'] = this.totalCasesGroth;
    data['PendingCasesGroth'] = this.pendingCasesGroth;
    data['ClosedCasesGroth'] = this.closedCasesGroth;
    return data;
  }
}

class CaseEntryStatusData {
  int? total;
  int? totalUpdate;
  int? totalDecided;
  int? totalDelete;
  int? thisDay;
  int? thisDayUpdate;
  int? thisDayDecided;
  int? thisDayDelete;
  int? thisWeek;
  int? thisWeekUpdate;
  int? thisWeekDecided;
  int? thisWeekDelete;
  int? thisMonth;
  int? thisMonthUpdate;
  int? thisMonthDecided;
  int? thisMonthDelete;
  int? thisYear;
  int? thisYearUpdate;
  int? thisYearDecided;
  int? thisYearDelete;
  int? preYear;
  int? preYearUpdate;
  int? preYearDecided;
  int? preYearDelete;

  CaseEntryStatusData(
      {this.total,
        this.totalUpdate,
        this.totalDecided,
        this.totalDelete,
        this.thisDay,
        this.thisDayUpdate,
        this.thisDayDecided,
        this.thisDayDelete,
        this.thisWeek,
        this.thisWeekUpdate,
        this.thisWeekDecided,
        this.thisWeekDelete,
        this.thisMonth,
        this.thisMonthUpdate,
        this.thisMonthDecided,
        this.thisMonthDelete,
        this.thisYear,
        this.thisYearUpdate,
        this.thisYearDecided,
        this.thisYearDelete,
        this.preYear,
        this.preYearUpdate,
        this.preYearDecided,
        this.preYearDelete});

  CaseEntryStatusData.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    totalUpdate = json['TotalUpdate'];
    totalDecided = json['TotalDecided'];
    totalDelete = json['TotalDelete'];
    thisDay = json['ThisDay'];
    thisDayUpdate = json['ThisDayUpdate'];
    thisDayDecided = json['ThisDayDecided'];
    thisDayDelete = json['ThisDayDelete'];
    thisWeek = json['ThisWeek'];
    thisWeekUpdate = json['ThisWeekUpdate'];
    thisWeekDecided = json['ThisWeekDecided'];
    thisWeekDelete = json['ThisWeekDelete'];
    thisMonth = json['ThisMonth'];
    thisMonthUpdate = json['ThisMonthUpdate'];
    thisMonthDecided = json['ThisMonthDecided'];
    thisMonthDelete = json['ThisMonthDelete'];
    thisYear = json['ThisYear'];
    thisYearUpdate = json['ThisYearUpdate'];
    thisYearDecided = json['ThisYearDecided'];
    thisYearDelete = json['ThisYearDelete'];
    preYear = json['PreYear'];
    preYearUpdate = json['PreYearUpdate'];
    preYearDecided = json['PreYearDecided'];
    preYearDelete = json['PreYearDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total'] = this.total;
    data['TotalUpdate'] = this.totalUpdate;
    data['TotalDecided'] = this.totalDecided;
    data['TotalDelete'] = this.totalDelete;
    data['ThisDay'] = this.thisDay;
    data['ThisDayUpdate'] = this.thisDayUpdate;
    data['ThisDayDecided'] = this.thisDayDecided;
    data['ThisDayDelete'] = this.thisDayDelete;
    data['ThisWeek'] = this.thisWeek;
    data['ThisWeekUpdate'] = this.thisWeekUpdate;
    data['ThisWeekDecided'] = this.thisWeekDecided;
    data['ThisWeekDelete'] = this.thisWeekDelete;
    data['ThisMonth'] = this.thisMonth;
    data['ThisMonthUpdate'] = this.thisMonthUpdate;
    data['ThisMonthDecided'] = this.thisMonthDecided;
    data['ThisMonthDelete'] = this.thisMonthDelete;
    data['ThisYear'] = this.thisYear;
    data['ThisYearUpdate'] = this.thisYearUpdate;
    data['ThisYearDecided'] = this.thisYearDecided;
    data['ThisYearDelete'] = this.thisYearDelete;
    data['PreYear'] = this.preYear;
    data['PreYearUpdate'] = this.preYearUpdate;
    data['PreYearDecided'] = this.preYearDecided;
    data['PreYearDelete'] = this.preYearDelete;
    return data;
  }
}

class CasePriorityWiseData {
  int? total;
  int? red;
  int? orange;
  int? green;

  CasePriorityWiseData({this.total, this.red, this.orange, this.green});

  CasePriorityWiseData.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    red = json['Red'];
    orange = json['Orange'];
    green = json['Green'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total'] = this.total;
    data['Red'] = this.red;
    data['Orange'] = this.orange;
    data['Green'] = this.green;
    return data;
  }
}

class CaseCourtWiseData {
  int? total;
  int? supremeCourt;
  int? highCourtJodhpur;
  int? highCourtJaipur;
  int? rCSAT;
  int? districtCourt;
  int? tribunalCourts;
  int? nationalGreenTribunalCourts;
  int? otherStateHighCourt;
  int? otherThanDistrictCourt;

  CaseCourtWiseData(
      {this.total,
        this.supremeCourt,
        this.highCourtJodhpur,
        this.highCourtJaipur,
        this.rCSAT,
        this.districtCourt,
        this.tribunalCourts,
        this.nationalGreenTribunalCourts,
        this.otherStateHighCourt,
        this.otherThanDistrictCourt});

  CaseCourtWiseData.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    supremeCourt = json['SupremeCourt'];
    highCourtJodhpur = json['HighCourtJodhpur'];
    highCourtJaipur = json['HighCourtJaipur'];
    rCSAT = json['RCSAT'];
    districtCourt = json['DistrictCourt'];
    tribunalCourts = json['TribunalCourts'];
    nationalGreenTribunalCourts = json['NationalGreenTribunalCourts'];
    otherStateHighCourt = json['OtherStateHighCourt'];
    otherThanDistrictCourt = json['OtherThanDistrictCourt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total'] = this.total;
    data['SupremeCourt'] = this.supremeCourt;
    data['HighCourtJodhpur'] = this.highCourtJodhpur;
    data['HighCourtJaipur'] = this.highCourtJaipur;
    data['RCSAT'] = this.rCSAT;
    data['DistrictCourt'] = this.districtCourt;
    data['TribunalCourts'] = this.tribunalCourts;
    data['NationalGreenTribunalCourts'] = this.nationalGreenTribunalCourts;
    data['OtherStateHighCourt'] = this.otherStateHighCourt;
    data['OtherThanDistrictCourt'] = this.otherThanDistrictCourt;
    return data;
  }
}

class DashboardReqModel {
  int? admDepttId;
  int? unitId;
  int? officeId;
  int? districtId;
  int? oicId;
  int? lawyerId;
  int? status;
  String? primarySecondary;
  int? roleId;

  DashboardReqModel(
      {this.admDepttId,
        this.unitId,
        this.officeId,
        this.districtId,
        this.oicId,
        this.lawyerId,
        this.status,
        this.primarySecondary,
        this.roleId});

  DashboardReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    officeId = json['officeId'];
    districtId = json['districtId'];
    oicId = json['oicId'];
    lawyerId = json['lawyerId'];
    status = json['status'];
    primarySecondary = json['primarySecondary'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttId'] = this.admDepttId;
    data['unitId'] = this.unitId;
    data['officeId'] = this.officeId;
    data['districtId'] = this.districtId;
    data['oicId'] = this.oicId;
    data['lawyerId'] = this.lawyerId;
    data['status'] = this.status;
    data['primarySecondary'] = this.primarySecondary;
    data['roleId'] = this.roleId;
    return data;
  }
}
