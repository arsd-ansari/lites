class GetAdvocatePerformanceReportModel {
  bool? status;
  String? message;
  List<AdvocatePerfData>? data;
  List<Pagination>? pagination;

  GetAdvocatePerformanceReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetAdvocatePerformanceReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AdvocatePerfData>[];
      json['data'].forEach((v) {
        data!.add(new AdvocatePerfData.fromJson(v));
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

class AdvocatePerfData {
  int? rowID;
  String? admDeptName;
  String? unitName;
  int? lawyerId;
  String? name;
  int? totalCases;
  int? courtTypeId;
  String? courtTypeName;
  int? decided;
  int? favour;
  int? against;

  AdvocatePerfData(
      {this.rowID,
        this.admDeptName,
        this.unitName,
        this.lawyerId,
        this.name,
        this.totalCases,
        this.courtTypeId,
        this.courtTypeName,
        this.decided,
        this.favour,
        this.against});

  AdvocatePerfData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    admDeptName = json['AdmDeptName'];
    unitName = json['UnitName'];
    lawyerId = json['LawyerId'];
    name = json['Name'];
    totalCases = json['totalCases'];
    courtTypeId = json['CourtTypeId'];
    courtTypeName = json['CourtTypeName'];
    decided = json['Decided'];
    favour = json['Favour'];
    against = json['Against'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['AdmDeptName'] = this.admDeptName;
    data['UnitName'] = this.unitName;
    data['LawyerId'] = this.lawyerId;
    data['Name'] = this.name;
    data['totalCases'] = this.totalCases;
    data['CourtTypeId'] = this.courtTypeId;
    data['CourtTypeName'] = this.courtTypeName;
    data['Decided'] = this.decided;
    data['Favour'] = this.favour;
    data['Against'] = this.against;
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

class GetAdvocatePerformanceReqModel {
  int? admDepttId;
  int? unitId;
  int? lawyerId;
  int? courtTypeId;
  String? fromDate;
  String? toDate;
  int? pageNumber;
  int? pageSize;

  GetAdvocatePerformanceReqModel(
      {this.admDepttId,
        this.unitId,
        this.lawyerId,
        this.courtTypeId,
        this.fromDate,
        this.toDate,
        this.pageNumber,
        this.pageSize});

  GetAdvocatePerformanceReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    lawyerId = json['lawyerId'];
    courtTypeId = json['courtTypeId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttId'] = this.admDepttId;
    data['unitId'] = this.unitId;
    data['lawyerId'] = this.lawyerId;
    data['courtTypeId'] = this.courtTypeId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
