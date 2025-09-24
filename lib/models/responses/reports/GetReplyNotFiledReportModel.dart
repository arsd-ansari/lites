class GetReplyNotFiledReportModel {
  bool? status;
  String? message;
  List<ReplyNotFiledData>? data;
  List<Pagination>? pagination;

  GetReplyNotFiledReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetReplyNotFiledReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReplyNotFiledData>[];
      json['data'].forEach((v) {
        data!.add(new ReplyNotFiledData.fromJson(v));
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

class ReplyNotFiledData {
  int? rowID;
  String? admDeptName;
  String? unitName;
  int? orderNo;
  String? courtName;
  String? officeName;
  String? abbrevationName;
  String? caseDetail;
  String? rEImplication;
  String? appellantName;
  String? respondantName;
  String? oICName;
  String? lawyerName;

  ReplyNotFiledData(
      {this.rowID,
        this.admDeptName,
        this.unitName,
        this.orderNo,
        this.courtName,
        this.officeName,
        this.abbrevationName,
        this.caseDetail,
        this.rEImplication,
        this.appellantName,
        this.respondantName,
        this.oICName,
        this.lawyerName});

  ReplyNotFiledData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    admDeptName = json['AdmDeptName'];
    unitName = json['UnitName'];
    orderNo = json['OrderNo'];
    courtName = json['CourtName'];
    officeName = json['OfficeName'];
    abbrevationName = json['AbbrevationName'];
    caseDetail = json['CaseDetail'];
    rEImplication = json['R_E_Implication'];
    appellantName = json['AppellantName'];
    respondantName = json['RespondantName'];
    oICName = json['OICName'];
    lawyerName = json['LawyerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['AdmDeptName'] = this.admDeptName;
    data['UnitName'] = this.unitName;
    data['OrderNo'] = this.orderNo;
    data['CourtName'] = this.courtName;
    data['OfficeName'] = this.officeName;
    data['AbbrevationName'] = this.abbrevationName;
    data['CaseDetail'] = this.caseDetail;
    data['R_E_Implication'] = this.rEImplication;
    data['AppellantName'] = this.appellantName;
    data['RespondantName'] = this.respondantName;
    data['OICName'] = this.oICName;
    data['LawyerName'] = this.lawyerName;
    return data;
  }
}

class Pagination {
  Null? sortBy;
  Null? isSortByDesc;
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
class GetReplyNotFiledReqModel {
  int? admDepttId;
  int? unitId;
  int? officeId;
  String? fromDate;
  String? toDate;
  int? pageNumber;
  int? pageSize;

  GetReplyNotFiledReqModel(
      {this.admDepttId,
        this.unitId,
        this.officeId,
        this.fromDate,
        this.toDate,
        this.pageNumber,
        this.pageSize});

  GetReplyNotFiledReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    officeId = json['officeId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttId'] = this.admDepttId;
    data['unitId'] = this.unitId;
    data['officeId'] = this.officeId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
