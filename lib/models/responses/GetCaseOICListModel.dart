class GetCaseOICListModel {
  bool? status;
  String? message;
  List<OICData>? data;

  GetCaseOICListModel({this.status, this.message, this.data});

  GetCaseOICListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OICData>[];
      json['data'].forEach((v) {
        data!.add(new OICData.fromJson(v));
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

class OICData {
  int? rowID;
  int? caseOICId;
  int? caseId;
  int? oICSrNo;
  int? oICId;
  String? fromDate;
  String? toDate;
  String? oICName;
  String? oICMobileNo;
  String? oICEmail;
  String? txn;
  String? signedPDFUrl;
  String? signatureAuthority;
  String? cC;
  bool? includeLawyerAppnt;
  String? otherSignatureAuthority;
  String? signAuthOffice;

  OICData(
      {this.rowID,
        this.caseOICId,
        this.caseId,
        this.oICSrNo,
        this.oICId,
        this.fromDate,
        this.toDate,
        this.oICName,
        this.oICMobileNo,
        this.oICEmail,
        this.txn,
        this.signedPDFUrl,
        this.signatureAuthority,
        this.cC,
        this.includeLawyerAppnt,
        this.otherSignatureAuthority,
        this.signAuthOffice});

  OICData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    caseOICId = json['CaseOICId'];
    caseId = json['CaseId'];
    oICSrNo = json['OIC_SrNo'];
    oICId = json['OICId'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    oICName = json['OICName'];
    oICMobileNo = json['OICMobileNo'];
    oICEmail = json['OICEmail'];
    txn = json['txn'];
    signedPDFUrl = json['SignedPDFUrl'];
    signatureAuthority = json['SignatureAuthority'];
    cC = json['CC'];
    includeLawyerAppnt = json['IncludeLawyerAppnt'];
    otherSignatureAuthority = json['OtherSignatureAuthority'];
    signAuthOffice = json['Sign_Auth_Office'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['CaseOICId'] = this.caseOICId;
    data['CaseId'] = this.caseId;
    data['OIC_SrNo'] = this.oICSrNo;
    data['OICId'] = this.oICId;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['OICName'] = this.oICName;
    data['OICMobileNo'] = this.oICMobileNo;
    data['OICEmail'] = this.oICEmail;
    data['txn'] = this.txn;
    data['SignedPDFUrl'] = this.signedPDFUrl;
    data['SignatureAuthority'] = this.signatureAuthority;
    data['CC'] = this.cC;
    data['IncludeLawyerAppnt'] = this.includeLawyerAppnt;
    data['OtherSignatureAuthority'] = this.otherSignatureAuthority;
    data['Sign_Auth_Office'] = this.signAuthOffice;
    return data;
  }
}
