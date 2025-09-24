class GetCaseDecidedFirstHearingModel {
  bool? status;
  String? message;
  List<DataOfFirstHearing>? data;
  List<Pagination>? pagination;

  GetCaseDecidedFirstHearingModel(
      {this.status, this.message, this.data, this.pagination});

  GetCaseDecidedFirstHearingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataOfFirstHearing>[];
      json['data'].forEach((v) {
        data!.add(new DataOfFirstHearing.fromJson(v));
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

class DataOfFirstHearing {
  int? rowID;
  int? caseId;
  int? caseNo;
  int? abbreviationId;
  String? abbreviationName;
  int? caseYear;
  String? courtName;
  String? courtPlace;
  String? caseRegistrationDate;
  int? decisionCount;

  DataOfFirstHearing(
      {this.rowID,
        this.caseId,
        this.caseNo,
        this.abbreviationId,
        this.abbreviationName,
        this.caseYear,
        this.courtName,
        this.courtPlace,
        this.caseRegistrationDate,
        this.decisionCount});

  DataOfFirstHearing.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    caseId = json['CaseId'];
    caseNo = json['CaseNo'];
    abbreviationId = json['AbbreviationId'];
    abbreviationName = json['AbbreviationName'];
    caseYear = json['CaseYear'];
    courtName = json['CourtName'];
    courtPlace = json['CourtPlace'];
    caseRegistrationDate = json['CaseRegistrationDate'];
    decisionCount = json['DecisionCount'];
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
    data['CourtPlace'] = this.courtPlace;
    data['CaseRegistrationDate'] = this.caseRegistrationDate;
    data['DecisionCount'] = this.decisionCount;
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

class GetCaseDecidedFirstHearingReqModel {
  int? admDepttId;
  int? unitId;
  int? officeId;
  int? courtTypeId;
  int? abbreviationId;
  int? caseYear;
  String? crnNumber;
  int? caseNo;
  String? sortBy;
  bool? isSortByDesc;
  int? pageNo;
  int? pageSize;

  GetCaseDecidedFirstHearingReqModel(
      {this.admDepttId,
        this.unitId,
        this.officeId,
        this.courtTypeId,
        this.abbreviationId,
        this.caseYear,
        this.crnNumber,
        this.caseNo,
        this.sortBy,
        this.isSortByDesc,
        this.pageNo,
        this.pageSize});

  GetCaseDecidedFirstHearingReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    officeId = json['officeId'];
    courtTypeId = json['courtTypeId'];
    abbreviationId = json['abbreviationId'];
    caseYear = json['caseYear'];
    crnNumber = json['crnNumber'];
    caseNo = json['caseNo'];
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
    data['crnNumber'] = this.crnNumber;
    data['caseNo'] = this.caseNo;
    data['sortBy'] = this.sortBy;
    data['isSortByDesc'] = this.isSortByDesc;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
