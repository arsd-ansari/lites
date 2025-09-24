class GetCaseAppellantListModel {
  bool? status;
  String? message;
  List<AppellantData>? data;

  GetCaseAppellantListModel({this.status, this.message, this.data});

  GetCaseAppellantListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AppellantData>[];
      json['data'].forEach((v) {
        data!.add(new AppellantData.fromJson(v));
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
    return data;
  }
}

class AppellantData {
  int? rowID;
  int? caseAppellantId;
  int? caseId;
  String? name;
  String? designation;
  String? address1;
  String? address2;
  String? contactNo;
  String? mobileNo;
  String? emailId;
  int? appellantSrNo;

  AppellantData(
      {this.rowID,
        this.caseAppellantId,
        this.caseId,
        this.name,
        this.designation,
        this.address1,
        this.address2,
        this.contactNo,
        this.mobileNo,
        this.emailId,
        this.appellantSrNo});

  AppellantData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    caseAppellantId = json['CaseAppellantId'];
    caseId = json['CaseId'];
    name = json['Name'];
    designation = json['Designation'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    contactNo = json['ContactNo'];
    mobileNo = json['MobileNo'];
    emailId = json['EmailId'];
    appellantSrNo = json['Appellant_SrNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['CaseAppellantId'] = this.caseAppellantId;
    data['CaseId'] = this.caseId;
    data['Name'] = this.name;
    data['Designation'] = this.designation;
    data['Address1'] = this.address1;
    data['Address2'] = this.address2;
    data['ContactNo'] = this.contactNo;
    data['MobileNo'] = this.mobileNo;
    data['EmailId'] = this.emailId;
    data['Appellant_SrNo'] = this.appellantSrNo;
    return data;
  }
}
