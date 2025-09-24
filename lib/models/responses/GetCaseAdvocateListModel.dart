class GetCaseAdvocateListModel {
  bool? status;
  String? message;
  List<AdvocateData>? data;

  GetCaseAdvocateListModel({this.status, this.message, this.data});

  GetCaseAdvocateListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AdvocateData>[];
      json['data'].forEach((v) {
        data!.add(new AdvocateData.fromJson(v));
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

class AdvocateData {
  int? rowID;
  int? caseLawyerId;
  int? caseId;
  int? lawyerId;
  String? lawyerName;
  String? fromDate;
  String? toDate;
  dynamic? aORId;
  dynamic? srAdv;
  dynamic? actuallyPaidFee;
  dynamic? approvedFee;
  String? enrollNo;
  dynamic? orderNo;
  int? reqSendto;
  int? districtId;
  String? appointmentAuthority;
  bool? isAGAAG;
  dynamic? appointDisposedPanding;
  String? createdDate;
  int? gLASrNo;
  bool? reqSent;

  AdvocateData(
      {this.rowID,
        this.caseLawyerId,
        this.caseId,
        this.lawyerId,
        this.lawyerName,
        this.fromDate,
        this.toDate,
        this.aORId,
        this.srAdv,
        this.actuallyPaidFee,
        this.approvedFee,
        this.enrollNo,
        this.orderNo,
        this.reqSendto,
        this.districtId,
        this.appointmentAuthority,
        this.isAGAAG,
        this.appointDisposedPanding,
        this.createdDate,
        this.gLASrNo,
        this.reqSent});

  AdvocateData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    caseLawyerId = json['CaseLawyerId'];
    caseId = json['CaseId'];
    lawyerId = json['LawyerId'];
    lawyerName = json['LawyerName'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    aORId = json['AORId'];
    srAdv = json['SrAdv'];
    actuallyPaidFee = json['ActuallyPaidFee'];
    approvedFee = json['ApprovedFee'];
    enrollNo = json['EnrollNo'];
    orderNo = json['OrderNo'];
    reqSendto = json['ReqSendto'];
    districtId = json['DistrictId'];
    appointmentAuthority = json['AppointmentAuthority'];
    isAGAAG = json['IsAG_AAG'];
    appointDisposedPanding = json['AppointDisposedPanding'];
    createdDate = json['CreatedDate'];
    gLASrNo = json['GLA_SrNo'];
    reqSent = json['ReqSent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['CaseLawyerId'] = this.caseLawyerId;
    data['CaseId'] = this.caseId;
    data['LawyerId'] = this.lawyerId;
    data['LawyerName'] = this.lawyerName;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['AORId'] = this.aORId;
    data['SrAdv'] = this.srAdv;
    data['ActuallyPaidFee'] = this.actuallyPaidFee;
    data['ApprovedFee'] = this.approvedFee;
    data['EnrollNo'] = this.enrollNo;
    data['OrderNo'] = this.orderNo;
    data['ReqSendto'] = this.reqSendto;
    data['DistrictId'] = this.districtId;
    data['AppointmentAuthority'] = this.appointmentAuthority;
    data['IsAG_AAG'] = this.isAGAAG;
    data['AppointDisposedPanding'] = this.appointDisposedPanding;
    data['CreatedDate'] = this.createdDate;
    data['GLA_SrNo'] = this.gLASrNo;
    data['ReqSent'] = this.reqSent;
    return data;
  }
}
