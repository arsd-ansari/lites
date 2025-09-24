class GetOICPerformanceReportModel {
  bool? status;
  String? message;
  List<OICPerfData>? data;
  List<Pagination>? pagination;

  GetOICPerformanceReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetOICPerformanceReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OICPerfData>[];
      json['data'].forEach((v) {
        data!.add(new OICPerfData.fromJson(v));
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

class OICPerfData {
  int? rowID;
  String? unitName;
  String? admDeptName;
  int? oICId;
  String? name;
  int? totalCases;
  int? decided;
  int? favour;
  int? against;

  OICPerfData(
      {this.rowID,
        this.unitName,
        this.admDeptName,
        this.oICId,
        this.name,
        this.totalCases,
        this.decided,
        this.favour,
        this.against});

  OICPerfData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    unitName = json['UnitName'];
    admDeptName = json['AdmDeptName'];
    oICId = json['OICId'];
    name = json['Name'];
    totalCases = json['totalCases'];
    decided = json['Decided'];
    favour = json['Favour'];
    against = json['Against'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['UnitName'] = this.unitName;
    data['AdmDeptName'] = this.admDeptName;
    data['OICId'] = this.oICId;
    data['Name'] = this.name;
    data['totalCases'] = this.totalCases;
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

class GetOICPerformanceReqModel {
  int? admDepttId;
  int? unitId;
  int? oicId;
  String? fromDate;
  String? toDate;
  int? pageNumber;
  int? pageSize;

  GetOICPerformanceReqModel(
      {this.admDepttId,
        this.unitId,
        this.oicId,
        this.fromDate,
        this.toDate,
        this.pageNumber,
        this.pageSize});

  GetOICPerformanceReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    oicId = json['oicId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttId'] = this.admDepttId;
    data['unitId'] = this.unitId;
    data['oicId'] = this.oicId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
