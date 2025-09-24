class GetEnytryStatusReportModel {
  GetMISEntryStatus? getMISEntryStatus;
  GetMISEntryStatusUpdate? getMISEntryStatusUpdate;
  GetMISEntryStatusUpdate? getMISEntryStatusDelete;
  GetMISEntryStatus? getMISEntryStatusToday;
  GetMISEntryStatusUpdate? getMISEntryStatusUpdateToday;
  GetMISEntryStatusUpdate? getMISEntryStatusDeleteToday;

  GetEnytryStatusReportModel(
      {this.getMISEntryStatus,
        this.getMISEntryStatusUpdate,
        this.getMISEntryStatusDelete,
        this.getMISEntryStatusToday,
        this.getMISEntryStatusUpdateToday,
        this.getMISEntryStatusDeleteToday});

  GetEnytryStatusReportModel.fromJson(Map<String, dynamic> json) {
    getMISEntryStatus = json['getMISEntryStatus'] != null
        ? new GetMISEntryStatus.fromJson(json['getMISEntryStatus'])
        : null;
    getMISEntryStatusUpdate = json['getMISEntryStatusUpdate'] != null
        ? new GetMISEntryStatusUpdate.fromJson(json['getMISEntryStatusUpdate'])
        : null;
    getMISEntryStatusDelete = json['getMISEntryStatusDelete'] != null
        ? new GetMISEntryStatusUpdate.fromJson(json['getMISEntryStatusDelete'])
        : null;
    getMISEntryStatusToday = json['getMISEntryStatusToday'] != null
        ? new GetMISEntryStatus.fromJson(json['getMISEntryStatusToday'])
        : null;
    getMISEntryStatusUpdateToday = json['getMISEntryStatusUpdateToday'] != null
        ? new GetMISEntryStatusUpdate.fromJson(
        json['getMISEntryStatusUpdateToday'])
        : null;
    getMISEntryStatusDeleteToday = json['getMISEntryStatusDeleteToday'] != null
        ? new GetMISEntryStatusUpdate.fromJson(
        json['getMISEntryStatusDeleteToday'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getMISEntryStatus != null) {
      data['getMISEntryStatus'] = this.getMISEntryStatus!.toJson();
    }
    if (this.getMISEntryStatusUpdate != null) {
      data['getMISEntryStatusUpdate'] = this.getMISEntryStatusUpdate!.toJson();
    }
    if (this.getMISEntryStatusDelete != null) {
      data['getMISEntryStatusDelete'] = this.getMISEntryStatusDelete!.toJson();
    }
    if (this.getMISEntryStatusToday != null) {
      data['getMISEntryStatusToday'] = this.getMISEntryStatusToday!.toJson();
    }
    if (this.getMISEntryStatusUpdateToday != null) {
      data['getMISEntryStatusUpdateToday'] =
          this.getMISEntryStatusUpdateToday!.toJson();
    }
    if (this.getMISEntryStatusDeleteToday != null) {
      data['getMISEntryStatusDeleteToday'] =
          this.getMISEntryStatusDeleteToday!.toJson();
    }
    return data;
  }
}

class GetMISEntryStatus {
  String? deptName;
  String? deptText;
  String? unitText;
  String? unitName;
  String? officeText;
  String? officeName;
  int? format2;
  int? format3;
  int? format4;
  int? format5;
  int? format6;
  int? format7;
  int? format8;
  int? format9;
  int? format1;
  int? format10;
  int? format11;
  int? format12;

  GetMISEntryStatus(
      {this.deptName,
        this.deptText,
        this.unitText,
        this.unitName,
        this.officeText,
        this.officeName,
        this.format2,
        this.format3,
        this.format4,
        this.format5,
        this.format6,
        this.format7,
        this.format8,
        this.format9,
        this.format1,
        this.format10,
        this.format11,
        this.format12});

  GetMISEntryStatus.fromJson(Map<String, dynamic> json) {
    deptName = json['deptName'];
    deptText = json['deptText'];
    unitText = json['unitText'];
    unitName = json['unitName'];
    officeText = json['officeText'];
    officeName = json['officeName'];
    format2 = json['format2'];
    format3 = json['format3'];
    format4 = json['format4'];
    format5 = json['format5'];
    format6 = json['format6'];
    format7 = json['format7'];
    format8 = json['format8'];
    format9 = json['format9'];
    format1 = json['format1'];
    format10 = json['format10'];
    format11 = json['format11'];
    format12 = json['format12'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deptName'] = this.deptName;
    data['deptText'] = this.deptText;
    data['unitText'] = this.unitText;
    data['unitName'] = this.unitName;
    data['officeText'] = this.officeText;
    data['officeName'] = this.officeName;
    data['format2'] = this.format2;
    data['format3'] = this.format3;
    data['format4'] = this.format4;
    data['format5'] = this.format5;
    data['format6'] = this.format6;
    data['format7'] = this.format7;
    data['format8'] = this.format8;
    data['format9'] = this.format9;
    data['format1'] = this.format1;
    data['format10'] = this.format10;
    data['format11'] = this.format11;
    data['format12'] = this.format12;
    return data;
  }
}

class GetMISEntryStatusUpdate {
  int? format2;
  int? format3;
  int? format4;
  int? format5;
  int? format6;
  int? format7;
  int? format8;
  int? format9;
  int? format1;
  int? format10;
  int? format11;
  int? format12;

  GetMISEntryStatusUpdate(
      {this.format2,
        this.format3,
        this.format4,
        this.format5,
        this.format6,
        this.format7,
        this.format8,
        this.format9,
        this.format1,
        this.format10,
        this.format11,
        this.format12});

  GetMISEntryStatusUpdate.fromJson(Map<String, dynamic> json) {
    format2 = json['format2'];
    format3 = json['format3'];
    format4 = json['format4'];
    format5 = json['format5'];
    format6 = json['format6'];
    format7 = json['format7'];
    format8 = json['format8'];
    format9 = json['format9'];
    format1 = json['format1'];
    format10 = json['format10'];
    format11 = json['format11'];
    format12 = json['format12'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['format2'] = this.format2;
    data['format3'] = this.format3;
    data['format4'] = this.format4;
    data['format5'] = this.format5;
    data['format6'] = this.format6;
    data['format7'] = this.format7;
    data['format8'] = this.format8;
    data['format9'] = this.format9;
    data['format1'] = this.format1;
    data['format10'] = this.format10;
    data['format11'] = this.format11;
    data['format12'] = this.format12;
    return data;
  }
}
