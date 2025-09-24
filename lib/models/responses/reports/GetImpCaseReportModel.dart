class GetImpCaseReportModel {
  bool? status;
  String? message;
  List<DataImpCase>? data;
  Null? pagination;

  GetImpCaseReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetImpCaseReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataImpCase>[];
      json['data'].forEach((v) {
        data!.add(new DataImpCase.fromJson(v));
      });
    }
    pagination = json['pagination'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pagination'] = this.pagination;
    return data;
  }
}

class DataImpCase {
  int? rowID;
  int? courtTypeId;
  String? courtTypeName;
  int? caseCount;

  DataImpCase({this.rowID, this.courtTypeId, this.courtTypeName, this.caseCount});

  DataImpCase.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    courtTypeId = json['CourtTypeId'];
    courtTypeName = json['CourtTypeName'];
    caseCount = json['CaseCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['CourtTypeId'] = this.courtTypeId;
    data['CourtTypeName'] = this.courtTypeName;
    data['CaseCount'] = this.caseCount;
    return data;
  }
}
