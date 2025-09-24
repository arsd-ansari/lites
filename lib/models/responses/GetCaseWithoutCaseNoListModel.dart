class GetCaseWithoutCaseNoListModel {
  bool? status;
  String? message;
  List<CaseWithoutCaseData>? data;
  List<Pagination>? pagination;

  GetCaseWithoutCaseNoListModel(
      {this.status, this.message, this.data, this.pagination});

  GetCaseWithoutCaseNoListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CaseWithoutCaseData>[];
      json['data'].forEach((v) {
        data!.add(new CaseWithoutCaseData.fromJson(v));
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

class CaseWithoutCaseData {
  int? rowID;
  int? caseId;
  int? caseNo;
  int? abbreviationId;
  String? abbreviationName;
  int? caseYear;
  String? courtName;
  String? primarySecondary;
  String? cRNNumber;
  dynamic? decisionId;
  int? appellantCount;
  int? respondantCount;
  int? lawyerCount;
  int? oICCount;
  int? decisionCount;
  int? hearingCount;
  int? contemptCount;
  String? appellant;
  String? respondent;
  int? linkCaseId;

  CaseWithoutCaseData(
      {this.rowID,
        this.caseId,
        this.caseNo,
        this.abbreviationId,
        this.abbreviationName,
        this.caseYear,
        this.courtName,
        this.primarySecondary,
        this.cRNNumber,
        this.decisionId,
        this.appellantCount,
        this.respondantCount,
        this.lawyerCount,
        this.oICCount,
        this.decisionCount,
        this.hearingCount,
        this.contemptCount,
        this.appellant,
        this.respondent,
        this.linkCaseId});

  CaseWithoutCaseData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    caseId = json['CaseId'];
    caseNo = json['CaseNo'];
    abbreviationId = json['AbbreviationId'];
    abbreviationName = json['AbbreviationName'];
    caseYear = json['CaseYear'];
    courtName = json['CourtName'];
    primarySecondary = json['PrimarySecondary'];
    cRNNumber = json['CRNNumber'];
    decisionId = json['DecisionId'];
    appellantCount = json['AppellantCount'];
    respondantCount = json['RespondantCount'];
    lawyerCount = json['LawyerCount'];
    oICCount = json['OICCount'];
    decisionCount = json['DecisionCount'];
    hearingCount = json['HearingCount'];
    contemptCount = json['ContemptCount'];
    appellant = json['Appellant'];
    respondent = json['Respondent'];
    linkCaseId = json['LinkCaseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['CaseId'] = this.caseId;
    data['CaseNo'] = this.caseNo;
    data['AbbreviationId'] = this.abbreviationId;
    data['AbbreviationName'] = this.abbreviationName;
    data['CaseYear'] = this.caseYear;
    data['CourtName'] = this.courtName;
    data['PrimarySecondary'] = this.primarySecondary;
    data['CRNNumber'] = this.cRNNumber;
    data['DecisionId'] = this.decisionId;
    data['AppellantCount'] = this.appellantCount;
    data['RespondantCount'] = this.respondantCount;
    data['LawyerCount'] = this.lawyerCount;
    data['OICCount'] = this.oICCount;
    data['DecisionCount'] = this.decisionCount;
    data['HearingCount'] = this.hearingCount;
    data['ContemptCount'] = this.contemptCount;
    data['Appellant'] = this.appellant;
    data['Respondent'] = this.respondent;
    data['LinkCaseId'] = this.linkCaseId;
    return data;
  }
}

class Pagination {
  String? sortBy;
  bool? isSortByDesc;
  int? pageNo;
  int? pageSize;
  int? totalRecords;

  Pagination(
      {this.sortBy,
        this.isSortByDesc,
        this.pageNo,
        this.pageSize,
        this.totalRecords});

  Pagination.fromJson(Map<String, dynamic> json) {
    sortBy = json['sortBy'];
    isSortByDesc = json['isSortByDesc'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortBy'] = this.sortBy;
    data['isSortByDesc'] = this.isSortByDesc;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    return data;
  }
}
