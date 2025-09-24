class GetCaseHearingListModel {
  bool? status;
  String? message;
  List<HearingData>? data;

  GetCaseHearingListModel({this.status, this.message, this.data});

  GetCaseHearingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HearingData>[];
      json['data'].forEach((v) {
        data!.add(new HearingData.fromJson(v));
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

class HearingData {
  int? rowID;
  int? caseHearingId;
  int? caseId;
  String? hearingDate;
  String? nextHearingDate;
  String? dueCourse;
  String? remark;
  String? decidedStr;
  int? lawyerId;
  String? lawyerName;
  int? oICId;
  String? oICName;
  String? judgmentPR;
  bool? argumentOverYN;
  int? hCAdmittedYNA;
  bool? hCStayGrantedYN;
  bool? hCAnyMiscAppfiledYN;
  String? hCSupInwordNo;
  String? hCSupInwordRegion;
  String? hCSupInwordDate;
  int? hCReplyfiledYN;
  bool? stayOrderFA;
  String? stayFinishDate;
  bool? interimOrderYN;
  String? interimOrderDate;
  String? interimOrderNo;
  bool? supplementaryFactulYN;
  String? supplementaryInwordNo;
  String? supplementaryInwordDate;
  bool? applVactingStayYN;
  String? applVactingInwordNo;
  String? applVactingInwordDate;
  String? replayFildInwordNo;
  String? replayFildInwordDate;
  bool? adjournedYN;
  String? replyFileDate;
  bool? adjournmentByCourtYN;
  bool? adjournmentByPertitnorYN;
  bool? adjournmentByResponentYN;
  String? adjournmentDate;
  String? adjournmentRegion;
  String? specialAppearance;
  String? factualReportDate;
  bool? nextHearingYN;
  bool? isExPartyStay;
  String? exPartyStayDate;
  bool? decided;
  String? dateCaseFillingDeptToAGAAG;

  HearingData(
      {this.rowID,
        this.caseHearingId,
        this.caseId,
        this.hearingDate,
        this.nextHearingDate,
        this.dueCourse,
        this.remark,
        this.decidedStr,
        this.lawyerId,
        this.lawyerName,
        this.oICId,
        this.oICName,
        this.judgmentPR,
        this.argumentOverYN,
        this.hCAdmittedYNA,
        this.hCStayGrantedYN,
        this.hCAnyMiscAppfiledYN,
        this.hCSupInwordNo,
        this.hCSupInwordRegion,
        this.hCSupInwordDate,
        this.hCReplyfiledYN,
        this.stayOrderFA,
        this.stayFinishDate,
        this.interimOrderYN,
        this.interimOrderDate,
        this.interimOrderNo,
        this.supplementaryFactulYN,
        this.supplementaryInwordNo,
        this.supplementaryInwordDate,
        this.applVactingStayYN,
        this.applVactingInwordNo,
        this.applVactingInwordDate,
        this.replayFildInwordNo,
        this.replayFildInwordDate,
        this.adjournedYN,
        this.replyFileDate,
        this.adjournmentByCourtYN,
        this.adjournmentByPertitnorYN,
        this.adjournmentByResponentYN,
        this.adjournmentDate,
        this.adjournmentRegion,
        this.specialAppearance,
        this.factualReportDate,
        this.nextHearingYN,
        this.isExPartyStay,
        this.exPartyStayDate,
        this.decided,
        this.dateCaseFillingDeptToAGAAG});

  HearingData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    caseHearingId = json['CaseHearingId'];
    caseId = json['CaseId'];
    hearingDate = json['HearingDate'];
    nextHearingDate = json['NextHearing_Date'];
    dueCourse = json['DueCourse'];
    remark = json['Remark'];
    decidedStr = json['Decided_Str'];
    lawyerId = json['LawyerId'];
    lawyerName = json['LawyerName'];
    oICId = json['OICId'];
    oICName = json['OICName'];
    judgmentPR = json['Judgment_PR'];
    argumentOverYN = json['ArgumentOver_YN'];
    hCAdmittedYNA = json['HC_Admitted_YNA'];
    hCStayGrantedYN = json['HC_StayGranted_YN'];
    hCAnyMiscAppfiledYN = json['HC_AnyMiscAppfiled_YN'];
    hCSupInwordNo = json['HC_Sup_InwordNo'];
    hCSupInwordRegion = json['HC_Sup_InwordRegion'];
    hCSupInwordDate = json['HC_Sup_InwordDate'];
    hCReplyfiledYN = json['HC_Replyfiled_YN'];
    stayOrderFA = json['StayOrder_FA'];
    stayFinishDate = json['StayFinishDate'];
    interimOrderYN = json['InterimOrder_YN'];
    interimOrderDate = json['Interim_Order_Date'];
    interimOrderNo = json['Interim_Order_No'];
    supplementaryFactulYN = json['SupplementaryFactul_YN'];
    supplementaryInwordNo = json['SupplementaryInwordNo'];
    supplementaryInwordDate = json['SupplementaryInwordDate'];
    applVactingStayYN = json['ApplVactingStay_YN'];
    applVactingInwordNo = json['ApplVactingInwordNo'];
    applVactingInwordDate = json['ApplVactingInwordDate'];
    replayFildInwordNo = json['ReplayFildInwordNo'];
    replayFildInwordDate = json['ReplayFildInwordDate'];
    adjournedYN = json['Adjourned_YN'];
    replyFileDate = json['ReplyFileDate'];
    adjournmentByCourtYN = json['AdjournmentByCourt_YN'];
    adjournmentByPertitnorYN = json['AdjournmentByPertitnor_YN'];
    adjournmentByResponentYN = json['AdjournmentByResponent_YN'];
    adjournmentDate = json['AdjournmentDate'];
    adjournmentRegion = json['AdjournmentRegion'];
    specialAppearance = json['SpecialAppearance'];
    factualReportDate = json['FactualReportDate'];
    nextHearingYN = json['Next_HearingYN'];
    isExPartyStay = json['IsExPartyStay'];
    exPartyStayDate = json['ExPartyStayDate'];
    decided = json['Decided'];
    dateCaseFillingDeptToAGAAG = json['DateCaseFillingDeptToAG_AAG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['CaseHearingId'] = this.caseHearingId;
    data['CaseId'] = this.caseId;
    data['HearingDate'] = this.hearingDate;
    data['NextHearing_Date'] = this.nextHearingDate;
    data['DueCourse'] = this.dueCourse;
    data['Remark'] = this.remark;
    data['Decided_Str'] = this.decidedStr;
    data['LawyerId'] = this.lawyerId;
    data['LawyerName'] = this.lawyerName;
    data['OICId'] = this.oICId;
    data['OICName'] = this.oICName;
    data['Judgment_PR'] = this.judgmentPR;
    data['ArgumentOver_YN'] = this.argumentOverYN;
    data['HC_Admitted_YNA'] = this.hCAdmittedYNA;
    data['HC_StayGranted_YN'] = this.hCStayGrantedYN;
    data['HC_AnyMiscAppfiled_YN'] = this.hCAnyMiscAppfiledYN;
    data['HC_Sup_InwordNo'] = this.hCSupInwordNo;
    data['HC_Sup_InwordRegion'] = this.hCSupInwordRegion;
    data['HC_Sup_InwordDate'] = this.hCSupInwordDate;
    data['HC_Replyfiled_YN'] = this.hCReplyfiledYN;
    data['StayOrder_FA'] = this.stayOrderFA;
    data['StayFinishDate'] = this.stayFinishDate;
    data['InterimOrder_YN'] = this.interimOrderYN;
    data['Interim_Order_Date'] = this.interimOrderDate;
    data['Interim_Order_No'] = this.interimOrderNo;
    data['SupplementaryFactul_YN'] = this.supplementaryFactulYN;
    data['SupplementaryInwordNo'] = this.supplementaryInwordNo;
    data['SupplementaryInwordDate'] = this.supplementaryInwordDate;
    data['ApplVactingStay_YN'] = this.applVactingStayYN;
    data['ApplVactingInwordNo'] = this.applVactingInwordNo;
    data['ApplVactingInwordDate'] = this.applVactingInwordDate;
    data['ReplayFildInwordNo'] = this.replayFildInwordNo;
    data['ReplayFildInwordDate'] = this.replayFildInwordDate;
    data['Adjourned_YN'] = this.adjournedYN;
    data['ReplyFileDate'] = this.replyFileDate;
    data['AdjournmentByCourt_YN'] = this.adjournmentByCourtYN;
    data['AdjournmentByPertitnor_YN'] = this.adjournmentByPertitnorYN;
    data['AdjournmentByResponent_YN'] = this.adjournmentByResponentYN;
    data['AdjournmentDate'] = this.adjournmentDate;
    data['AdjournmentRegion'] = this.adjournmentRegion;
    data['SpecialAppearance'] = this.specialAppearance;
    data['FactualReportDate'] = this.factualReportDate;
    data['Next_HearingYN'] = this.nextHearingYN;
    data['IsExPartyStay'] = this.isExPartyStay;
    data['ExPartyStayDate'] = this.exPartyStayDate;
    data['Decided'] = this.decided;
    data['DateCaseFillingDeptToAG_AAG'] = this.dateCaseFillingDeptToAGAAG;
    return data;
  }

  
}
