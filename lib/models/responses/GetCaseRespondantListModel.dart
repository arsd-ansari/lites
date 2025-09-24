class GetCaseRespondantListModel {
  bool? status;
  String? message;
  List<RespondantData>? data;

  GetCaseRespondantListModel({this.status, this.message, this.data});

  GetCaseRespondantListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RespondantData>[];
      json['data'].forEach((v) {
        data!.add(new RespondantData.fromJson(v));
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

class RespondantData {
  int? rowID;
  int? respondentId;
  int? caseId;
  String? name;
  String? designation;
  String? address1;
  String? address2;
  String? contactNo;
  String? mobileNo;
  String? emailId;
  int? respondantSrNo;

  RespondantData(
      {this.rowID,
        this.respondentId,
        this.caseId,
        this.name,
        this.designation,
        this.address1,
        this.address2,
        this.contactNo,
        this.mobileNo,
        this.emailId,
        this.respondantSrNo});

  RespondantData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    respondentId = json['RespondentId'];
    caseId = json['CaseId'];
    name = json['Name'];
    designation = json['Designation'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    contactNo = json['ContactNo'];
    mobileNo = json['MobileNo'];
    emailId = json['EmailId'];
    respondantSrNo = json['Respondant_SrNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['RespondentId'] = this.respondentId;
    data['CaseId'] = this.caseId;
    data['Name'] = this.name;
    data['Designation'] = this.designation;
    data['Address1'] = this.address1;
    data['Address2'] = this.address2;
    data['ContactNo'] = this.contactNo;
    data['MobileNo'] = this.mobileNo;
    data['EmailId'] = this.emailId;
    data['Respondant_SrNo'] = this.respondantSrNo;
    return data;
  }
}
