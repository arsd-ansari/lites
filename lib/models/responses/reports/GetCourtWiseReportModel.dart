class GetCourtWiseReportModel {
  bool? status;
  String? message;
  List<CourtWiseData>? data;
  List<Pagination>? pagination;

  GetCourtWiseReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetCourtWiseReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CourtWiseData>[];
      json['data'].forEach((v) {
        data!.add(new CourtWiseData.fromJson(v));
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

class CourtWiseData {
  int? no;
  int? rowID;
  String? admDeptName;
  String? unitName;
  String? officeName;
  String? courtName;
  int? admDeptId;
  int? unitId;
  int? officeId;
  int? courtId;
  String? caseDetail;
  dynamic? rEImplication;
  String? appellantName;
  String? respondantName;
  String? oICName;
  String? lawyerName;

  CourtWiseData(
      {this.no,
        this.rowID,
        this.admDeptName,
        this.unitName,
        this.officeName,
        this.courtName,
        this.admDeptId,
        this.unitId,
        this.officeId,
        this.courtId,
        this.caseDetail,
        this.rEImplication,
        this.appellantName,
        this.respondantName,
        this.oICName,
        this.lawyerName});

  CourtWiseData.fromJson(Map<String, dynamic> json) {
    no = json['No'];
    rowID = json['RowID'];
    admDeptName = json['AdmDeptName'];
    unitName = json['UnitName'];
    officeName = json['OfficeName'];
    courtName = json['CourtName'];
    admDeptId = json['AdmDeptId'];
    unitId = json['UnitId'];
    officeId = json['OfficeId'];
    courtId = json['CourtId'];
    caseDetail = json['CaseDetail'];
    rEImplication = json['R_E_Implication'];
    appellantName = json['AppellantName'];
    respondantName = json['RespondantName'];
    oICName = json['OICName'];
    lawyerName = json['LawyerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['No'] = this.no;
    data['RowID'] = this.rowID;
    data['AdmDeptName'] = this.admDeptName;
    data['UnitName'] = this.unitName;
    data['OfficeName'] = this.officeName;
    data['CourtName'] = this.courtName;
    data['AdmDeptId'] = this.admDeptId;
    data['UnitId'] = this.unitId;
    data['OfficeId'] = this.officeId;
    data['CourtId'] = this.courtId;
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
  dynamic? sortBy;
  dynamic? isSortByDesc;
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

class GetCourtWiseReqModel {
  String? fromDate;
  String? toDate;
  int? departmentId;
  int? unitId;
  int? officeId;
  int? courtId;
  int? status;
  int? pageNumber;
  int? pageSize;

  GetCourtWiseReqModel(
      {this.fromDate,
        this.toDate,
        this.departmentId,
        this.unitId,
        this.officeId,
        this.courtId,
        this.status,
        this.pageNumber,
        this.pageSize});

  GetCourtWiseReqModel.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    departmentId = json['departmentId'];
    unitId = json['unitId'];
    officeId = json['officeId'];
    courtId = json['courtId'];
    status = json['status'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['departmentId'] = this.departmentId;
    data['unitId'] = this.unitId;
    data['officeId'] = this.officeId;
    data['courtId'] = this.courtId;
    data['status'] = this.status;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
