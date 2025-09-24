class GetCaseDecisionListModel {
  bool? status;
  String? message;
  List<DecisionData>? data;

  GetCaseDecisionListModel({this.status, this.message, this.data});

  GetCaseDecisionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DecisionData>[];
      json['data'].forEach((v) {
        data!.add(new DecisionData.fromJson(v));
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

class DecisionData {
  int? rowID;
  int? decisionId;
  int? caseId;
  String? decisionDate;
  String? decisionCompDate;
  String? decisionDetail;
  bool? decisionFA;
  bool? webCopyOrderObtained;
  String? webObtainedDate;
  String? documentName;
  bool? implementationRequired;
  int? implementationRequiredOrNo;
  String? implementationRequiredDate;
  bool? appliedForCertifiedCopyYN;
  int? appliedForCertifiedCopyInwordNo;
  String? appliedForCertifiedCopyDate;
  bool? copyReceivedYN;
  bool? copyForwordedOfOicHodYN;
  bool? opinionProvidedToOicHodYN;
  bool? pDDecisionCopyRecYN;
  String? pDDecisionCopyRecDate;
  bool? pDDecisionSenttoHOOYN;
  String? pDDecisionSenttoHOODate;
  bool? pDDecisionSenttoGovtYN;
  String? pDDecisionSenttoGovtDate;
  bool? pDStayGrantedYN;
  String? pDStayGrantedDate;
  bool? pDLawyerOpenionYN;
  String? pDDateoffilingAppeal;
  String? remark;
  bool? dateoSendingCertifiedCopyYN;
  String? dateoSendingCertifiedCopy;
  String? pDAppealFilingDate;
  bool? pDDecisionSenttoHODYN;
  String? pDDecisionSenttoHODDate;
  bool? pDFinalDecisionofGovtYN;
  String? pDFinalDecisionofGovtDate;
  bool? pDDecisionCompliedYN;
  String? pDDecisionCompliedDate;
  bool? pDDepttOpenionYN;
  String? pDAppealNo;
  bool? isExParty;
  String? exPartyDate;
  bool? dataSendCommYN;
  String? dateSendingComment;
  String? dateoSendingCertifiedCopyFileType;
  String? pLCDate;
  dynamic? pLCDocument;
  dynamic? copyOfDecisionReceivedDocs;
  bool? opinionOfOicYN;
  dynamic? opinionOfOicDocs;
  String? pDDecisionNonCompliedReason;
  String? dateoSendingCertifiedCopyFileTypePath;
  String? pLCDocumentPath;
  String? copyOfDecisionReceivedDocsPath;
  String? opinionOfOicDocsPath;

  DecisionData(
      {this.rowID,
        this.decisionId,
        this.caseId,
        this.decisionDate,
        this.decisionCompDate,
        this.decisionDetail,
        this.decisionFA,
        this.webCopyOrderObtained,
        this.webObtainedDate,
        this.documentName,
        this.implementationRequired,
        this.implementationRequiredOrNo,
        this.implementationRequiredDate,
        this.appliedForCertifiedCopyYN,
        this.appliedForCertifiedCopyInwordNo,
        this.appliedForCertifiedCopyDate,
        this.copyReceivedYN,
        this.copyForwordedOfOicHodYN,
        this.opinionProvidedToOicHodYN,
        this.pDDecisionCopyRecYN,
        this.pDDecisionCopyRecDate,
        this.pDDecisionSenttoHOOYN,
        this.pDDecisionSenttoHOODate,
        this.pDDecisionSenttoGovtYN,
        this.pDDecisionSenttoGovtDate,
        this.pDStayGrantedYN,
        this.pDStayGrantedDate,
        this.pDLawyerOpenionYN,
        this.pDDateoffilingAppeal,
        this.remark,
        this.dateoSendingCertifiedCopyYN,
        this.dateoSendingCertifiedCopy,
        this.pDAppealFilingDate,
        this.pDDecisionSenttoHODYN,
        this.pDDecisionSenttoHODDate,
        this.pDFinalDecisionofGovtYN,
        this.pDFinalDecisionofGovtDate,
        this.pDDecisionCompliedYN,
        this.pDDecisionCompliedDate,
        this.pDDepttOpenionYN,
        this.pDAppealNo,
        this.isExParty,
        this.exPartyDate,
        this.dataSendCommYN,
        this.dateSendingComment,
        this.dateoSendingCertifiedCopyFileType,
        this.pLCDate,
        this.pLCDocument,
        this.copyOfDecisionReceivedDocs,
        this.opinionOfOicYN,
        this.opinionOfOicDocs,
        this.pDDecisionNonCompliedReason,
        this.dateoSendingCertifiedCopyFileTypePath,
        this.pLCDocumentPath,
        this.copyOfDecisionReceivedDocsPath,
        this.opinionOfOicDocsPath});

  DecisionData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    decisionId = json['DecisionId'];
    caseId = json['CaseId'];
    decisionDate = json['DecisionDate'];
    decisionCompDate = json['Decision_Comp_Date'];
    decisionDetail = json['Decision_Detail'];
    decisionFA = json['Decision_FA'];
    webCopyOrderObtained = json['Web_copy_order_obtained'];
    webObtainedDate = json['Web_obtained_date'];
    documentName = json['DocumentName'];
    implementationRequired = json['Implementation_required'];
    implementationRequiredOrNo = json['Implementation_required_OrNo'];
    implementationRequiredDate = json['Implementation_required_date'];
    appliedForCertifiedCopyYN = json['AppliedForCertifiedCopy_YN'];
    appliedForCertifiedCopyInwordNo = json['AppliedForCertifiedCopyInwordNo'];
    appliedForCertifiedCopyDate = json['AppliedForCertifiedCopyDate'];
    copyReceivedYN = json['CopyReceived_YN'];
    copyForwordedOfOicHodYN = json['CopyForwordedOfOic_Hod_YN'];
    opinionProvidedToOicHodYN = json['OpinionProvidedToOic_Hod_YN'];
    pDDecisionCopyRecYN = json['PD_DecisionCopyRecYN'];
    pDDecisionCopyRecDate = json['PD_DecisionCopyRecDate'];
    pDDecisionSenttoHOOYN = json['PD_DecisionSenttoHOOYN'];
    pDDecisionSenttoHOODate = json['PD_DecisionSenttoHOODate'];
    pDDecisionSenttoGovtYN = json['PD_DecisionSenttoGovtYN'];
    pDDecisionSenttoGovtDate = json['PD_DecisionSenttoGovtDate'];
    pDStayGrantedYN = json['PD_StayGrantedYN'];
    pDStayGrantedDate = json['PD_StayGrantedDate'];
    pDLawyerOpenionYN = json['PD_LawyerOpenionYN'];
    pDDateoffilingAppeal = json['PD_DateoffilingAppeal'];
    remark = json['Remark'];
    dateoSendingCertifiedCopyYN = json['DateoSendingCertifiedCopyYN'];
    dateoSendingCertifiedCopy = json['DateoSendingCertifiedCopy'];
    pDAppealFilingDate = json['PD_AppealFilingDate'];
    pDDecisionSenttoHODYN = json['PD_DecisionSenttoHODYN'];
    pDDecisionSenttoHODDate = json['PD_DecisionSenttoHODDate'];
    pDFinalDecisionofGovtYN = json['PD_FinalDecisionofGovtYN'];
    pDFinalDecisionofGovtDate = json['PD_FinalDecisionofGovtDate'];
    pDDecisionCompliedYN = json['PD_DecisionCompliedYN'];
    pDDecisionCompliedDate = json['PD_DecisionCompliedDate'];
    pDDepttOpenionYN = json['PD_DepttOpenionYN'];
    pDAppealNo = json['PD_AppealNo'];
    isExParty = json['IsExParty'];
    exPartyDate = json['ExPartyDate'];
    dataSendCommYN = json['DataSendCommYN'];
    dateSendingComment = json['Date_Sending_Comment'];
    dateoSendingCertifiedCopyFileType =
    json['DateoSendingCertifiedCopyFileType'];
    pLCDate = json['PLC_Date'];
    pLCDocument = json['PLC_Document'];
    copyOfDecisionReceivedDocs = json['CopyOfDecisionReceivedDocs'];
    opinionOfOicYN = json['OpinionOfOic_YN'];
    opinionOfOicDocs = json['OpinionOfOicDocs'];
    pDDecisionNonCompliedReason = json['PD_DecisionNonCompliedReason'];
    dateoSendingCertifiedCopyFileTypePath =
    json['DateoSendingCertifiedCopyFileType_Path'];
    pLCDocumentPath = json['PLC_Document_Path'];
    copyOfDecisionReceivedDocsPath = json['CopyOfDecisionReceivedDocs_Path'];
    opinionOfOicDocsPath = json['OpinionOfOicDocs_Path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['DecisionId'] = this.decisionId;
    data['CaseId'] = this.caseId;
    data['DecisionDate'] = this.decisionDate;
    data['Decision_Comp_Date'] = this.decisionCompDate;
    data['Decision_Detail'] = this.decisionDetail;
    data['Decision_FA'] = this.decisionFA;
    data['Web_copy_order_obtained'] = this.webCopyOrderObtained;
    data['Web_obtained_date'] = this.webObtainedDate;
    data['DocumentName'] = this.documentName;
    data['Implementation_required'] = this.implementationRequired;
    data['Implementation_required_OrNo'] = this.implementationRequiredOrNo;
    data['Implementation_required_date'] = this.implementationRequiredDate;
    data['AppliedForCertifiedCopy_YN'] = this.appliedForCertifiedCopyYN;
    data['AppliedForCertifiedCopyInwordNo'] =
        this.appliedForCertifiedCopyInwordNo;
    data['AppliedForCertifiedCopyDate'] = this.appliedForCertifiedCopyDate;
    data['CopyReceived_YN'] = this.copyReceivedYN;
    data['CopyForwordedOfOic_Hod_YN'] = this.copyForwordedOfOicHodYN;
    data['OpinionProvidedToOic_Hod_YN'] = this.opinionProvidedToOicHodYN;
    data['PD_DecisionCopyRecYN'] = this.pDDecisionCopyRecYN;
    data['PD_DecisionCopyRecDate'] = this.pDDecisionCopyRecDate;
    data['PD_DecisionSenttoHOOYN'] = this.pDDecisionSenttoHOOYN;
    data['PD_DecisionSenttoHOODate'] = this.pDDecisionSenttoHOODate;
    data['PD_DecisionSenttoGovtYN'] = this.pDDecisionSenttoGovtYN;
    data['PD_DecisionSenttoGovtDate'] = this.pDDecisionSenttoGovtDate;
    data['PD_StayGrantedYN'] = this.pDStayGrantedYN;
    data['PD_StayGrantedDate'] = this.pDStayGrantedDate;
    data['PD_LawyerOpenionYN'] = this.pDLawyerOpenionYN;
    data['PD_DateoffilingAppeal'] = this.pDDateoffilingAppeal;
    data['Remark'] = this.remark;
    data['DateoSendingCertifiedCopyYN'] = this.dateoSendingCertifiedCopyYN;
    data['DateoSendingCertifiedCopy'] = this.dateoSendingCertifiedCopy;
    data['PD_AppealFilingDate'] = this.pDAppealFilingDate;
    data['PD_DecisionSenttoHODYN'] = this.pDDecisionSenttoHODYN;
    data['PD_DecisionSenttoHODDate'] = this.pDDecisionSenttoHODDate;
    data['PD_FinalDecisionofGovtYN'] = this.pDFinalDecisionofGovtYN;
    data['PD_FinalDecisionofGovtDate'] = this.pDFinalDecisionofGovtDate;
    data['PD_DecisionCompliedYN'] = this.pDDecisionCompliedYN;
    data['PD_DecisionCompliedDate'] = this.pDDecisionCompliedDate;
    data['PD_DepttOpenionYN'] = this.pDDepttOpenionYN;
    data['PD_AppealNo'] = this.pDAppealNo;
    data['IsExParty'] = this.isExParty;
    data['ExPartyDate'] = this.exPartyDate;
    data['DataSendCommYN'] = this.dataSendCommYN;
    data['Date_Sending_Comment'] = this.dateSendingComment;
    data['DateoSendingCertifiedCopyFileType'] =
        this.dateoSendingCertifiedCopyFileType;
    data['PLC_Date'] = this.pLCDate;
    data['PLC_Document'] = this.pLCDocument;
    data['CopyOfDecisionReceivedDocs'] = this.copyOfDecisionReceivedDocs;
    data['OpinionOfOic_YN'] = this.opinionOfOicYN;
    data['OpinionOfOicDocs'] = this.opinionOfOicDocs;
    data['PD_DecisionNonCompliedReason'] = this.pDDecisionNonCompliedReason;
    data['DateoSendingCertifiedCopyFileType_Path'] =
        this.dateoSendingCertifiedCopyFileTypePath;
    data['PLC_Document_Path'] = this.pLCDocumentPath;
    data['CopyOfDecisionReceivedDocs_Path'] =
        this.copyOfDecisionReceivedDocsPath;
    data['OpinionOfOicDocs_Path'] = this.opinionOfOicDocsPath;
    return data;
  }
}
