class GetCaseDataByCaseIdModel {
  bool? status;
  String? message;
  int? returnID;
  CaseData? data;

  GetCaseDataByCaseIdModel(
      {this.status, this.message, this.returnID, this.data});

  GetCaseDataByCaseIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    returnID = json['returnID'];
    data = json['data'] != null ? new CaseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['returnID'] = this.returnID;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CaseData {
  int? caseId;
  int? caseNo;
  int? abbreviationId;
  String? abbreviationName;
  int? caseYear;
  dynamic? preCaseNo;
  String? courtName;
  String? primarySecondary;
  String? cRNNumber;
  int? admDepttId;
  String? admDeptName;
  int? unitId;
  String? unitName;
  int? officeId;
  String? officeName;
  int? placeId;
  String? placeName;
  int? courtId;
  int? courtTypeId;
  String? fileNo;
  int? subjectSubCategoryId;
  int? subjectSubMatterId;
  String? appellantOrResponded;
  String? rEImplication;
  bool? doesPOA;
  bool? doesPAPD;
  String? priorityCode;
  int? priorityId;
  int? subPriorityId;
  String? caseRegistrationDate;
  String? bench;
  String? wACPNo;
  int? groupingId;
  dynamic? dateCaseFillingDeptToAGAAG;
  dynamic? dateFillingCaseCourtByAGAAG;
  bool? applicationUnderSec5FiledYN;
  String? remark;
  int? linkCaseId;
  bool? isEmployee;
  String? caseStatus;
  int? subjectCategoryId;
  String? subjectCategoryName;
  String? subjectSubCategoryName;
  int? subjectMatterId;
  String? subjectMatterName;
  String? subjectSubMatterName;
  String? employeeCode;
  bool? importantCase;
  dynamic? lastUpdatedDate;
  String? appellantName;
  String? respondentName;
  dynamic? decisionId;
  dynamic? hearingDate;
  int? appellantCount;
  int? respondantCount;
  int? lawyerCount;
  int? oICCount;
  int? hearingCount;
  int? decisionCount;
  dynamic? lawyerId;
  int? oICId;
  int? caseType;
  String? employeeId;
  String? employeeName;
  String? employeeDesignation;
  String? employeeSSOID;
  dynamic? decisionDecidedDate;

  CaseData(
      {this.caseId,
        this.caseNo,
        this.abbreviationId,
        this.abbreviationName,
        this.caseYear,
        this.preCaseNo,
        this.courtName,
        this.primarySecondary,
        this.cRNNumber,
        this.admDepttId,
        this.admDeptName,
        this.unitId,
        this.unitName,
        this.officeId,
        this.officeName,
        this.placeId,
        this.placeName,
        this.courtId,
        this.courtTypeId,
        this.fileNo,
        this.subjectSubCategoryId,
        this.subjectSubMatterId,
        this.appellantOrResponded,
        this.rEImplication,
        this.doesPOA,
        this.doesPAPD,
        this.priorityCode,
        this.priorityId,
        this.subPriorityId,
        this.caseRegistrationDate,
        this.bench,
        this.wACPNo,
        this.groupingId,
        this.dateCaseFillingDeptToAGAAG,
        this.dateFillingCaseCourtByAGAAG,
        this.applicationUnderSec5FiledYN,
        this.remark,
        this.linkCaseId,
        this.isEmployee,
        this.caseStatus,
        this.subjectCategoryId,
        this.subjectCategoryName,
        this.subjectSubCategoryName,
        this.subjectMatterId,
        this.subjectMatterName,
        this.subjectSubMatterName,
        this.employeeCode,
        this.importantCase,
        this.lastUpdatedDate,
        this.appellantName,
        this.respondentName,
        this.decisionId,
        this.hearingDate,
        this.appellantCount,
        this.respondantCount,
        this.lawyerCount,
        this.oICCount,
        this.hearingCount,
        this.decisionCount,
        this.lawyerId,
        this.oICId,
        this.caseType,
        this.employeeId,
        this.employeeName,
        this.employeeDesignation,
        this.employeeSSOID,
        this.decisionDecidedDate});

  CaseData.fromJson(Map<String, dynamic> json) {
    caseId = json['CaseId'];
    caseNo = json['CaseNo'];
    abbreviationId = json['AbbreviationId'];
    abbreviationName = json['AbbreviationName'];
    caseYear = json['CaseYear'];
    preCaseNo = json['PreCaseNo'];
    courtName = json['CourtName'];
    primarySecondary = json['PrimarySecondary'];
    cRNNumber = json['CRNNumber'];
    admDepttId = json['AdmDepttId'];
    admDeptName = json['AdmDeptName'];
    unitId = json['UnitId'];
    unitName = json['UnitName'];
    officeId = json['OfficeId'];
    officeName = json['OfficeName'];
    placeId = json['PlaceId'];
    placeName = json['PlaceName'];
    courtId = json['CourtId'];
    courtTypeId = json['CourtTypeId'];
    fileNo = json['FileNo'];
    subjectSubCategoryId = json['SubjectSubCategoryId'];
    subjectSubMatterId = json['SubjectSubMatterId'];
    appellantOrResponded = json['AppellantOrResponded'];
    rEImplication = json['R_E_Implication'];
    doesPOA = json['Does_P_O_A'];
    doesPAPD = json['Does_P_A_PD'];
    priorityCode = json['PriorityCode'];
    priorityId = json['PriorityId'];
    subPriorityId = json['SubPriorityId'];
    caseRegistrationDate = json['CaseRegistrationDate'];
    bench = json['Bench'];
    wACPNo = json['WACPNo'];
    groupingId = json['GroupingId'];
    dateCaseFillingDeptToAGAAG = json['DateCaseFillingDeptToAG_AAG'];
    dateFillingCaseCourtByAGAAG = json['DateFillingCaseCourtByAG_AAG'];
    applicationUnderSec5FiledYN = json['ApplicationUnderSec5FiledYN'];
    remark = json['Remark'];
    linkCaseId = json['LinkCaseId'];
    isEmployee = json['IsEmployee'];
    caseStatus = json['CaseStatus'];
    subjectCategoryId = json['SubjectCategoryId'];
    subjectCategoryName = json['SubjectCategoryName'];
    subjectSubCategoryName = json['SubjectSubCategoryName'];
    subjectMatterId = json['SubjectMatterId'];
    subjectMatterName = json['SubjectMatterName'];
    subjectSubMatterName = json['SubjectSubMatterName'];
    employeeCode = json['EmployeeCode'];
    importantCase = json['ImportantCase'];
    lastUpdatedDate = json['LastUpdatedDate'];
    appellantName = json['AppellantName'];
    respondentName = json['RespondentName'];
    decisionId = json['DecisionId'];
    hearingDate = json['HearingDate'];
    appellantCount = json['AppellantCount'];
    respondantCount = json['RespondantCount'];
    lawyerCount = json['LawyerCount'];
    oICCount = json['OICCount'];
    hearingCount = json['HearingCount'];
    decisionCount = json['DecisionCount'];
    lawyerId = json['LawyerId'];
    oICId = json['OICId'];
    caseType = json['CaseType'];
    employeeId = json['EmployeeId'];
    employeeName = json['EmployeeName'];
    employeeDesignation = json['EmployeeDesignation'];
    employeeSSOID = json['EmployeeSSOID'];
    decisionDecidedDate = json['DecisionDecidedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CaseId'] = this.caseId;
    data['CaseNo'] = this.caseNo;
    data['AbbreviationId'] = this.abbreviationId;
    data['AbbreviationName'] = this.abbreviationName;
    data['CaseYear'] = this.caseYear;
    data['PreCaseNo'] = this.preCaseNo;
    data['CourtName'] = this.courtName;
    data['PrimarySecondary'] = this.primarySecondary;
    data['CRNNumber'] = this.cRNNumber;
    data['AdmDepttId'] = this.admDepttId;
    data['AdmDeptName'] = this.admDeptName;
    data['UnitId'] = this.unitId;
    data['UnitName'] = this.unitName;
    data['OfficeId'] = this.officeId;
    data['OfficeName'] = this.officeName;
    data['PlaceId'] = this.placeId;
    data['PlaceName'] = this.placeName;
    data['CourtId'] = this.courtId;
    data['CourtTypeId'] = this.courtTypeId;
    data['FileNo'] = this.fileNo;
    data['SubjectSubCategoryId'] = this.subjectSubCategoryId;
    data['SubjectSubMatterId'] = this.subjectSubMatterId;
    data['AppellantOrResponded'] = this.appellantOrResponded;
    data['R_E_Implication'] = this.rEImplication;
    data['Does_P_O_A'] = this.doesPOA;
    data['Does_P_A_PD'] = this.doesPAPD;
    data['PriorityCode'] = this.priorityCode;
    data['PriorityId'] = this.priorityId;
    data['SubPriorityId'] = this.subPriorityId;
    data['CaseRegistrationDate'] = this.caseRegistrationDate;
    data['Bench'] = this.bench;
    data['WACPNo'] = this.wACPNo;
    data['GroupingId'] = this.groupingId;
    data['DateCaseFillingDeptToAG_AAG'] = this.dateCaseFillingDeptToAGAAG;
    data['DateFillingCaseCourtByAG_AAG'] = this.dateFillingCaseCourtByAGAAG;
    data['ApplicationUnderSec5FiledYN'] = this.applicationUnderSec5FiledYN;
    data['Remark'] = this.remark;
    data['LinkCaseId'] = this.linkCaseId;
    data['IsEmployee'] = this.isEmployee;
    data['CaseStatus'] = this.caseStatus;
    data['SubjectCategoryId'] = this.subjectCategoryId;
    data['SubjectCategoryName'] = this.subjectCategoryName;
    data['SubjectSubCategoryName'] = this.subjectSubCategoryName;
    data['SubjectMatterId'] = this.subjectMatterId;
    data['SubjectMatterName'] = this.subjectMatterName;
    data['SubjectSubMatterName'] = this.subjectSubMatterName;
    data['EmployeeCode'] = this.employeeCode;
    data['ImportantCase'] = this.importantCase;
    data['LastUpdatedDate'] = this.lastUpdatedDate;
    data['AppellantName'] = this.appellantName;
    data['RespondentName'] = this.respondentName;
    data['DecisionId'] = this.decisionId;
    data['HearingDate'] = this.hearingDate;
    data['AppellantCount'] = this.appellantCount;
    data['RespondantCount'] = this.respondantCount;
    data['LawyerCount'] = this.lawyerCount;
    data['OICCount'] = this.oICCount;
    data['HearingCount'] = this.hearingCount;
    data['DecisionCount'] = this.decisionCount;
    data['LawyerId'] = this.lawyerId;
    data['OICId'] = this.oICId;
    data['CaseType'] = this.caseType;
    data['EmployeeId'] = this.employeeId;
    data['EmployeeName'] = this.employeeName;
    data['EmployeeDesignation'] = this.employeeDesignation;
    data['EmployeeSSOID'] = this.employeeSSOID;
    data['DecisionDecidedDate'] = this.decisionDecidedDate;
    return data;
  }
}
