class GetAttentionWarrantReportModel {
  bool? status;
  String? message;
  List<DataAttentionWarrant>? data;
  List<Pagination>? pagination;

  GetAttentionWarrantReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetAttentionWarrantReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataAttentionWarrant>[];
      json['data'].forEach((v) {
        data!.add(new DataAttentionWarrant.fromJson(v));
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

class DataAttentionWarrant {
  String? admDepttName;
  int? admDepttId;
  int? unitId;
  String? unitName;
  int? officeId;
  String? officeName;
  int? districtId;
  String? districtName;
  int? replyNotFiledUpto3;
  int? replyNotFiledMoreThan3M;
  int? replyNotFiledMoreThan1Year;
  int? factualReportMoreThen1Year;
  int? moreThan1YrTo10Yr;
  int? moreThan10Yr;
  int? moreThan20Yr;
  int? orderPendingComplianceUpto3M;
  int? orderPendingComplianceMoreThan3M;
  int? orderPendingComplianceMoreThan1Yr;
  int? orderPendingAppealUpto3M;
  int? orderPendingAppealMoreThan3M;
  int? orderPendingAppealMoreThan1Yr;
  int? redCategory;
  int? contemptCases;
  int? casewithoutcaseno;
  Null? rowNum;

  DataAttentionWarrant(
      {this.admDepttName,
        this.admDepttId,
        this.unitId,
        this.unitName,
        this.officeId,
        this.officeName,
        this.districtId,
        this.districtName,
        this.replyNotFiledUpto3,
        this.replyNotFiledMoreThan3M,
        this.replyNotFiledMoreThan1Year,
        this.factualReportMoreThen1Year,
        this.moreThan1YrTo10Yr,
        this.moreThan10Yr,
        this.moreThan20Yr,
        this.orderPendingComplianceUpto3M,
        this.orderPendingComplianceMoreThan3M,
        this.orderPendingComplianceMoreThan1Yr,
        this.orderPendingAppealUpto3M,
        this.orderPendingAppealMoreThan3M,
        this.orderPendingAppealMoreThan1Yr,
        this.redCategory,
        this.contemptCases,
        this.casewithoutcaseno,
        this.rowNum});

  DataAttentionWarrant.fromJson(Map<String, dynamic> json) {
    admDepttName = json['admDepttName'];
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    officeId = json['officeId'];
    officeName = json['officeName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    replyNotFiledUpto3 = json['replyNotFiledUpto3'];
    replyNotFiledMoreThan3M = json['replyNotFiledMoreThan3M'];
    replyNotFiledMoreThan1Year = json['replyNotFiledMoreThan1Year'];
    factualReportMoreThen1Year = json['factualReportMoreThen1Year'];
    moreThan1YrTo10Yr = json['moreThan1YrTo10Yr'];
    moreThan10Yr = json['moreThan10Yr'];
    moreThan20Yr = json['moreThan20Yr'];
    orderPendingComplianceUpto3M = json['orderPendingComplianceUpto3M'];
    orderPendingComplianceMoreThan3M = json['orderPendingComplianceMoreThan3M'];
    orderPendingComplianceMoreThan1Yr =
    json['orderPendingComplianceMoreThan1Yr'];
    orderPendingAppealUpto3M = json['orderPendingAppealUpto3M'];
    orderPendingAppealMoreThan3M = json['orderPendingAppealMoreThan3M'];
    orderPendingAppealMoreThan1Yr = json['orderPendingAppealMoreThan1Yr'];
    redCategory = json['redCategory'];
    contemptCases = json['contemptCases'];
    casewithoutcaseno = json['casewithoutcaseno'];
    rowNum = json['rowNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttName'] = this.admDepttName;
    data['admDepttId'] = this.admDepttId;
    data['unitId'] = this.unitId;
    data['unitName'] = this.unitName;
    data['officeId'] = this.officeId;
    data['officeName'] = this.officeName;
    data['districtId'] = this.districtId;
    data['districtName'] = this.districtName;
    data['replyNotFiledUpto3'] = this.replyNotFiledUpto3;
    data['replyNotFiledMoreThan3M'] = this.replyNotFiledMoreThan3M;
    data['replyNotFiledMoreThan1Year'] = this.replyNotFiledMoreThan1Year;
    data['factualReportMoreThen1Year'] = this.factualReportMoreThen1Year;
    data['moreThan1YrTo10Yr'] = this.moreThan1YrTo10Yr;
    data['moreThan10Yr'] = this.moreThan10Yr;
    data['moreThan20Yr'] = this.moreThan20Yr;
    data['orderPendingComplianceUpto3M'] = this.orderPendingComplianceUpto3M;
    data['orderPendingComplianceMoreThan3M'] =
        this.orderPendingComplianceMoreThan3M;
    data['orderPendingComplianceMoreThan1Yr'] =
        this.orderPendingComplianceMoreThan1Yr;
    data['orderPendingAppealUpto3M'] = this.orderPendingAppealUpto3M;
    data['orderPendingAppealMoreThan3M'] = this.orderPendingAppealMoreThan3M;
    data['orderPendingAppealMoreThan1Yr'] = this.orderPendingAppealMoreThan1Yr;
    data['redCategory'] = this.redCategory;
    data['contemptCases'] = this.contemptCases;
    data['casewithoutcaseno'] = this.casewithoutcaseno;
    data['rowNum'] = this.rowNum;
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
