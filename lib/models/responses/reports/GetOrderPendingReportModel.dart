class GetOrderPendingReportModel {
  bool? status;
  String? message;
  List<OrderPendingData>? data;
  List<Pagination>? pagination;

  GetOrderPendingReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetOrderPendingReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderPendingData>[];
      json['data'].forEach((v) {
        data!.add(new OrderPendingData.fromJson(v));
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

class OrderPendingData {
  int? rowID;
  String? admDeptName;
  String? unitName;
  int? orderNo;
  String? abbrevationName;
  String? courtName;
  String? caseDetail;
  String? officeName;
  String? rEImplication;
  String? decision;
  String? decisionDate;
  String? appellantName;
  String? respondantName;
  String? oICName;
  String? lawyerName;

  OrderPendingData(
      {this.rowID,
        this.admDeptName,
        this.unitName,
        this.orderNo,
        this.abbrevationName,
        this.courtName,
        this.caseDetail,
        this.officeName,
        this.rEImplication,
        this.decision,
        this.decisionDate,
        this.appellantName,
        this.respondantName,
        this.oICName,
        this.lawyerName});

  OrderPendingData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    admDeptName = json['AdmDeptName'];
    unitName = json['UnitName'];
    orderNo = json['OrderNo'];
    abbrevationName = json['AbbrevationName'];
    courtName = json['CourtName'];
    caseDetail = json['CaseDetail'];
    officeName = json['OfficeName'];
    rEImplication = json['R_E_Implication'];
    decision = json['Decision'];
    decisionDate = json['DecisionDate'];
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
    data['AbbrevationName'] = this.abbrevationName;
    data['CourtName'] = this.courtName;
    data['CaseDetail'] = this.caseDetail;
    data['OfficeName'] = this.officeName;
    data['R_E_Implication'] = this.rEImplication;
    data['Decision'] = this.decision;
    data['DecisionDate'] = this.decisionDate;
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

class GetOrderPendingReqModel {
  int? admDepttId;
  int? unitId;
  int? officeId;
  String? fromDate;
  String? toDate;
  int? pageNumber;
  int? pageSize;

  GetOrderPendingReqModel(
      {this.admDepttId,
        this.unitId,
        this.officeId,
        this.fromDate,
        this.toDate,
        this.pageNumber,
        this.pageSize});

  GetOrderPendingReqModel.fromJson(Map<String, dynamic> json) {
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
