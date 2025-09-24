class GetDashboardPendencyReportModel {
  bool? status;
  String? message;
  List<DataDashboardPendency>? data;
  List<Pagination>? pagination;

  GetDashboardPendencyReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetDashboardPendencyReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataDashboardPendency>[];
      json['data'].forEach((v) {
        data!.add(new DataDashboardPendency.fromJson(v));
      });
    }
    if (json['pagination'] != null) {
      pagination = <Pagination>[];
      json['pagination'].forEach((v) {
        pagination!.add(new Pagination.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataDashboardPendency {
  int? admDeptId;
  String? admDeptName;
  int? totalCases;
  int? appellantCountNot;
  int? respondantCountNot;
  int? oICCountNot;
  int? lawyerCountNot;
  int? hearingCountNot;
  int? redCount;
  int? pILCount;
  int? replyFileCout;
  int? factualReport;
  int? stayGranted;
  int? stayInGovtFavour;
  int? stayInGovtAgainst;
  int? totalCnrPending;
  int? supremeCourt;
  int? highCourtJpr;
  int? otherSubOrdCourt;
  int? rCSAT;
  int? highCourtJODH;
  int? tribunalCourts;
  int? nationalGreenTribunal;
  int? otherStateHighCourt;
  int? documentUpload;
  int? outDatedHearingDate;
  int? hearingDateBlank;
  int? dueCourses;
  int? contemptCaseCount;
  int? registraionLessDecisionDate;
  int? registraionLessHearingDate;
  int? decisionLessHearingDate;
  int? duplicateCases;
  int? duplicateCasesSameDept;

  DataDashboardPendency(
      {this.admDeptId,
        this.admDeptName,
        this.totalCases,
        this.appellantCountNot,
        this.respondantCountNot,
        this.oICCountNot,
        this.lawyerCountNot,
        this.hearingCountNot,
        this.redCount,
        this.pILCount,
        this.replyFileCout,
        this.factualReport,
        this.stayGranted,
        this.stayInGovtFavour,
        this.stayInGovtAgainst,
        this.totalCnrPending,
        this.supremeCourt,
        this.highCourtJpr,
        this.otherSubOrdCourt,
        this.rCSAT,
        this.highCourtJODH,
        this.tribunalCourts,
        this.nationalGreenTribunal,
        this.otherStateHighCourt,
        this.documentUpload,
        this.outDatedHearingDate,
        this.hearingDateBlank,
        this.dueCourses,
        this.contemptCaseCount,
        this.registraionLessDecisionDate,
        this.registraionLessHearingDate,
        this.decisionLessHearingDate,
        this.duplicateCases,
        this.duplicateCasesSameDept});

  DataDashboardPendency.fromJson(Map<String, dynamic> json) {
    admDeptId = json['AdmDeptId'];
    admDeptName = json['AdmDeptName'];
    totalCases = json['TotalCases'];
    appellantCountNot = json['AppellantCountNot'];
    respondantCountNot = json['RespondantCountNot'];
    oICCountNot = json['OICCountNot'];
    lawyerCountNot = json['LawyerCountNot'];
    hearingCountNot = json['HearingCountNot'];
    redCount = json['RedCount'];
    pILCount = json['PILCount'];
    replyFileCout = json['ReplyFileCout'];
    factualReport = json['FactualReport'];
    stayGranted = json['StayGranted'];
    stayInGovtFavour = json['StayInGovtFavour'];
    stayInGovtAgainst = json['StayInGovtAgainst'];
    totalCnrPending = json['TotalCnrPending'];
    supremeCourt = json['SupremeCourt'];
    highCourtJpr = json['HighCourtJpr'];
    otherSubOrdCourt = json['OtherSubOrdCourt'];
    rCSAT = json['RCSAT'];
    highCourtJODH = json['HighCourtJODH'];
    tribunalCourts = json['TribunalCourts'];
    nationalGreenTribunal = json['NationalGreenTribunal'];
    otherStateHighCourt = json['OtherStateHighCourt'];
    documentUpload = json['DocumentUpload'];
    outDatedHearingDate = json['OutDatedHearingDate'];
    hearingDateBlank = json['HearingDateBlank'];
    dueCourses = json['DueCourses'];
    contemptCaseCount = json['ContemptCaseCount'];
    registraionLessDecisionDate = json['RegistraionLessDecisionDate'];
    registraionLessHearingDate = json['RegistraionLessHearingDate'];
    decisionLessHearingDate = json['DecisionLessHearingDate'];
    duplicateCases = json['DuplicateCases'];
    duplicateCasesSameDept = json['DuplicateCasesSameDept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AdmDeptId'] = this.admDeptId;
    data['AdmDeptName'] = this.admDeptName;
    data['TotalCases'] = this.totalCases;
    data['AppellantCountNot'] = this.appellantCountNot;
    data['RespondantCountNot'] = this.respondantCountNot;
    data['OICCountNot'] = this.oICCountNot;
    data['LawyerCountNot'] = this.lawyerCountNot;
    data['HearingCountNot'] = this.hearingCountNot;
    data['RedCount'] = this.redCount;
    data['PILCount'] = this.pILCount;
    data['ReplyFileCout'] = this.replyFileCout;
    data['FactualReport'] = this.factualReport;
    data['StayGranted'] = this.stayGranted;
    data['StayInGovtFavour'] = this.stayInGovtFavour;
    data['StayInGovtAgainst'] = this.stayInGovtAgainst;
    data['TotalCnrPending'] = this.totalCnrPending;
    data['SupremeCourt'] = this.supremeCourt;
    data['HighCourtJpr'] = this.highCourtJpr;
    data['OtherSubOrdCourt'] = this.otherSubOrdCourt;
    data['RCSAT'] = this.rCSAT;
    data['HighCourtJODH'] = this.highCourtJODH;
    data['TribunalCourts'] = this.tribunalCourts;
    data['NationalGreenTribunal'] = this.nationalGreenTribunal;
    data['OtherStateHighCourt'] = this.otherStateHighCourt;
    data['DocumentUpload'] = this.documentUpload;
    data['OutDatedHearingDate'] = this.outDatedHearingDate;
    data['HearingDateBlank'] = this.hearingDateBlank;
    data['DueCourses'] = this.dueCourses;
    data['ContemptCaseCount'] = this.contemptCaseCount;
    data['RegistraionLessDecisionDate'] = this.registraionLessDecisionDate;
    data['RegistraionLessHearingDate'] = this.registraionLessHearingDate;
    data['DecisionLessHearingDate'] = this.decisionLessHearingDate;
    data['DuplicateCases'] = this.duplicateCases;
    data['DuplicateCasesSameDept'] = this.duplicateCasesSameDept;
    return data;
  }
}

class Pagination {
  int? pageNo;
  int? pageSize;
  int? totalRecords;

  Pagination({this.pageNo, this.pageSize, this.totalRecords});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNo = json['PageNo'];
    pageSize = json['PageSize'];
    totalRecords = json['TotalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageNo'] = this.pageNo;
    data['PageSize'] = this.pageSize;
    data['TotalRecords'] = this.totalRecords;
    return data;
  }
}


class GetDashboardPendencyReqModel {
  int? admDepttId;
  int? unitId;
  int? officeId;
  int? districtId;
  int? oicId;
  int? lawyerId;
  int? status;
  int? roleId;
  int? level;
  int? courtTypeId;
  int? placeId;
  String? bench;
  int? pageNo;
  int? pageSize;

  GetDashboardPendencyReqModel(
      {this.admDepttId,
        this.unitId,
        this.officeId,
        this.districtId,
        this.oicId,
        this.lawyerId,
        this.status,
        this.roleId,
        this.level,
        this.courtTypeId,
        this.placeId,
        this.bench,
        this.pageNo,
        this.pageSize});

  GetDashboardPendencyReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    officeId = json['officeId'];
    districtId = json['districtId'];
    oicId = json['oicId'];
    lawyerId = json['lawyerId'];
    status = json['status'];
    roleId = json['roleId'];
    level = json['level'];
    courtTypeId = json['courtTypeId'];
    placeId = json['placeId'];
    bench = json['bench'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
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
    data['roleId'] = this.roleId;
    data['level'] = this.level;
    data['courtTypeId'] = this.courtTypeId;
    data['placeId'] = this.placeId;
    data['bench'] = this.bench;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
