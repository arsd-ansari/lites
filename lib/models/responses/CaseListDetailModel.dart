class CaseListDetailModel {
  bool? status;
  String? message;
  List<DataCaseList>? data;
  List<Pagination>? pagination;

  CaseListDetailModel({this.status, this.message, this.data, this.pagination});

  CaseListDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataCaseList>[];
      json['data'].forEach((v) {
        data!.add(new DataCaseList.fromJson(v));
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

class DataCaseList {
  int? rowID;
  int? caseId;
  int? caseNo;
  int? abbreviationId;
  String? abbreviationName;
  int? caseYear;
  String? courtName;
  String? primarySecondary;
  String? cRNNumber;
  int? decisionId;
  int? appellantCount;
  int? respondantCount;
  int? lawyerCount;
  int? oICCount;
  int? decisionCount;
  int? hearingCount;
  int? contemptCount;

  DataCaseList(
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
        this.contemptCount});

  DataCaseList.fromJson(Map<String, dynamic> json) {
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



class CaseReqModel {
  int? admDepttId;
  int? unitId;
  int? officeId;
  int? courtTypeId;
  int? abbreviationId;
  int? caseYear;
  int? groupingId;
  int? caseStatus;
  String? primarySecondary;
  String? crnNumber;
  int? caseNo;
  int? roleId;
  int? oicId;
  int? lawyerId;
  int? districtId;
  String? sortBy;
  bool? isSortByDesc;
  int? pageNo;
  int? pageSize;

  CaseReqModel(
      {this.admDepttId,
        this.unitId,
        this.officeId,
        this.courtTypeId,
        this.abbreviationId,
        this.caseYear,
        this.groupingId,
        this.caseStatus,
        this.primarySecondary,
        this.crnNumber,
        this.caseNo,
        this.roleId,
        this.oicId,
        this.lawyerId,
        this.districtId,
        this.sortBy,
        this.isSortByDesc,
        this.pageNo,
        this.pageSize});

  CaseReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    officeId = json['officeId'];
    courtTypeId = json['courtTypeId'];
    abbreviationId = json['abbreviationId'];
    caseYear = json['caseYear'];
    groupingId = json['groupingId'];
    caseStatus = json['caseStatus'];
    primarySecondary = json['primarySecondary'];
    crnNumber = json['crnNumber'];
    caseNo = json['caseNo'];
    roleId = json['roleId'];
    oicId = json['oicId'];
    lawyerId = json['lawyerId'];
    districtId = json['districtId'];
    sortBy = json['sortBy'];
    isSortByDesc = json['isSortByDesc'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttId'] = this.admDepttId;
    data['unitId'] = this.unitId;
    data['officeId'] = this.officeId;
    data['courtTypeId'] = this.courtTypeId;
    data['abbreviationId'] = this.abbreviationId;
    data['caseYear'] = this.caseYear;
    data['groupingId'] = this.groupingId;
    data['caseStatus'] = this.caseStatus;
    data['primarySecondary'] = this.primarySecondary;
    data['crnNumber'] = this.crnNumber;
    data['caseNo'] = this.caseNo;
    data['roleId'] = this.roleId;
    data['oicId'] = this.oicId;
    data['lawyerId'] = this.lawyerId;
    data['districtId'] = this.districtId;
    data['sortBy'] = this.sortBy;
    data['isSortByDesc'] = this.isSortByDesc;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    return data;
  }
}