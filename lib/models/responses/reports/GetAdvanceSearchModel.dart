class GetAdvanceSearchResponseModel {
  bool? status;
  String? message;
  List<AdvanceData>? data;
  List<Pagination>? pagination;

  GetAdvanceSearchResponseModel(
      {this.status, this.message, this.data, this.pagination});

  GetAdvanceSearchResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AdvanceData>[];
      json['data'].forEach((v) {
        data!.add(new AdvanceData.fromJson(v));
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

class AdvanceData {
  String? abbrCaseNoCaseYear;
  String? admDepttName;
  String? cNR;
  int? caseId;
  String? courtNameCourtPlace;
  String? officeName;
  String? performaMain;
  int? rowID;
  String? unitName;

  AdvanceData(
      {this.abbrCaseNoCaseYear,
        this.admDepttName,
        this.cNR,
        this.caseId,
        this.courtNameCourtPlace,
        this.officeName,
        this.performaMain,
        this.rowID,
        this.unitName});

  AdvanceData.fromJson(Map<String, dynamic> json) {
    abbrCaseNoCaseYear = json['Abbr/CaseNo/CaseYear'];
    admDepttName = json['AdmDepttName'];
    cNR = json['CNR'];
    caseId = json['CaseId'];
    courtNameCourtPlace = json['Court Name, Court Place'];
    officeName = json['OfficeName'];
    performaMain = json['Performa/Main'];
    rowID = json['RowID'];
    unitName = json['UnitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Abbr/CaseNo/CaseYear'] = this.abbrCaseNoCaseYear;
    data['AdmDepttName'] = this.admDepttName;
    data['CNR'] = this.cNR;
    data['CaseId'] = this.caseId;
    data['Court Name, Court Place'] = this.courtNameCourtPlace;
    data['OfficeName'] = this.officeName;
    data['Performa/Main'] = this.performaMain;
    data['RowID'] = this.rowID;
    data['UnitName'] = this.unitName;
    return data;
  }
}

class Pagination {
  String? sortBy;
  bool? isSortByDesc;
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
    isSortByDesc = json['IsSortByDesc'];
    pageNo = json['PageNo'];
    pageSize = json['PageSize'];
    totalRecords = json['TotalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortBy'] = this.sortBy;
    data['IsSortByDesc'] = this.isSortByDesc;
    data['PageNo'] = this.pageNo;
    data['PageSize'] = this.pageSize;
    data['TotalRecords'] = this.totalRecords;
    return data;
  }
}


class GetAdvanceSearchReqModel {
  int? admDepttId;
  int? unitId;
  int? officeId;
  int? caseNo;
  int? caseYear;
  int? status;
  String? primarySecondary;
  String? appellantOrResponded;
  String? entryDateFrom;
  String? entryDateTo;
  String? regDateFrom;
  String? regDateTo;
  String? courtTypeIds;
  int? abbreviationId;
  int? priorityId;
  int? subPriorityId;
  int? caseType;
  String? lawyerIds;
  String? oicIds;
  int? subjectCategoryId;
  int? subjectSubCategoryId;
  int? subjectMatterId;
  int? subjectSubMatterId;
  String? appellantName;
  String? respondedName;
  String? hearingDateFrom;
  String? hearingDateTo;
  String? nextHearingDateFrom;
  String? nextHearingDateTo;
  String? decisionDateFrom;
  String? decisionDateTo;
  String? decisionEntryDateFrom;
  String? decisionEntryDateTo;
  String? districtIds;
  int? decisionFA;
  int? specialAppearance;
  String? oicMobileNo;
  String? rEImplication;
  int? doesPOA;
  int? doesPAPD;
  String? crnNumber;
  int? stayFA;
  int? lawOICNotAppointed;
  int? replyFiled;
  int? groupingId;
  String? bench;
  String? replyFileDateFrom;
  String? replyFileDateTo;
  int? pDFinalDecisionofGovtYN;
  String? pDFinalDecisionofGovtDateFrom;
  String? pDFinalDecisionofGovtDateTo;
  String? selectedColumns;
  String? sortBy;
  bool? isSortByDesc;
  int? pageNo;
  int? pageSize;

  GetAdvanceSearchReqModel(
      {this.admDepttId,
        this.unitId,
        this.officeId,
        this.caseNo,
        this.caseYear,
        this.status,
        this.primarySecondary,
        this.appellantOrResponded,
        this.entryDateFrom,
        this.entryDateTo,
        this.regDateFrom,
        this.regDateTo,
        this.courtTypeIds,
        this.abbreviationId,
        this.priorityId,
        this.subPriorityId,
        this.caseType,
        this.lawyerIds,
        this.oicIds,
        this.subjectCategoryId,
        this.subjectSubCategoryId,
        this.subjectMatterId,
        this.subjectSubMatterId,
        this.appellantName,
        this.respondedName,
        this.hearingDateFrom,
        this.hearingDateTo,
        this.nextHearingDateFrom,
        this.nextHearingDateTo,
        this.decisionDateFrom,
        this.decisionDateTo,
        this.decisionEntryDateFrom,
        this.decisionEntryDateTo,
        this.districtIds,
        this.decisionFA,
        this.specialAppearance,
        this.oicMobileNo,
        this.rEImplication,
        this.doesPOA,
        this.doesPAPD,
        this.crnNumber,
        this.stayFA,
        this.lawOICNotAppointed,
        this.replyFiled,
        this.groupingId,
        this.bench,
        this.replyFileDateFrom,
        this.replyFileDateTo,
        this.pDFinalDecisionofGovtYN,
        this.pDFinalDecisionofGovtDateFrom,
        this.pDFinalDecisionofGovtDateTo,
        this.selectedColumns,
        this.sortBy,
        this.isSortByDesc,
        this.pageNo,
        this.pageSize});

  GetAdvanceSearchReqModel.fromJson(Map<String, dynamic> json) {
    admDepttId = json['admDepttId'];
    unitId = json['unitId'];
    officeId = json['officeId'];
    caseNo = json['caseNo'];
    caseYear = json['caseYear'];
    status = json['status'];
    primarySecondary = json['primarySecondary'];
    appellantOrResponded = json['appellantOrResponded'];
    entryDateFrom = json['entryDateFrom'];
    entryDateTo = json['entryDateTo'];
    regDateFrom = json['regDateFrom'];
    regDateTo = json['regDateTo'];
    courtTypeIds = json['courtTypeIds'];
    abbreviationId = json['abbreviationId'];
    priorityId = json['priorityId'];
    subPriorityId = json['subPriorityId'];
    caseType = json['caseType'];
    lawyerIds = json['lawyerIds'];
    oicIds = json['oicIds'];
    subjectCategoryId = json['subjectCategoryId'];
    subjectSubCategoryId = json['subjectSubCategoryId'];
    subjectMatterId = json['subjectMatterId'];
    subjectSubMatterId = json['subjectSubMatterId'];
    appellantName = json['appellantName'];
    respondedName = json['respondedName'];
    hearingDateFrom = json['hearingDateFrom'];
    hearingDateTo = json['hearingDateTo'];
    nextHearingDateFrom = json['nextHearingDateFrom'];
    nextHearingDateTo = json['nextHearingDateTo'];
    decisionDateFrom = json['decisionDateFrom'];
    decisionDateTo = json['decisionDateTo'];
    decisionEntryDateFrom = json['decisionEntryDateFrom'];
    decisionEntryDateTo = json['decisionEntryDateTo'];
    districtIds = json['districtIds'];
    decisionFA = json['decisionFA'];
    specialAppearance = json['specialAppearance'];
    oicMobileNo = json['oicMobileNo'];
    rEImplication = json['r_E_Implication'];
    doesPOA = json['does_P_O_A'];
    doesPAPD = json['does_P_A_PD'];
    crnNumber = json['crnNumber'];
    stayFA = json['stayFA'];
    lawOICNotAppointed = json['lawOICNotAppointed'];
    replyFiled = json['replyFiled'];
    groupingId = json['groupingId'];
    bench = json['bench'];
    replyFileDateFrom = json['replyFileDateFrom'];
    replyFileDateTo = json['replyFileDateTo'];
    pDFinalDecisionofGovtYN = json['pD_FinalDecisionofGovtYN'];
    pDFinalDecisionofGovtDateFrom = json['pD_FinalDecisionofGovtDateFrom'];
    pDFinalDecisionofGovtDateTo = json['pD_FinalDecisionofGovtDateTo'];
    selectedColumns = json['selectedColumns'];
    sortBy = json['sortBy'];
    isSortByDesc = json['isSortByDesc'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttId'] = this.admDepttId;
    data['unitId'] = this.unitId;
    data['officeId'] = this.officeId;
    data['caseNo'] = this.caseNo;
    data['caseYear'] = this.caseYear;
    data['status'] = this.status;
    data['primarySecondary'] = this.primarySecondary;
    data['appellantOrResponded'] = this.appellantOrResponded;
    data['entryDateFrom'] = this.entryDateFrom;
    data['entryDateTo'] = this.entryDateTo;
    data['regDateFrom'] = this.regDateFrom;
    data['regDateTo'] = this.regDateTo;
    data['courtTypeIds'] = this.courtTypeIds;
    data['abbreviationId'] = this.abbreviationId;
    data['priorityId'] = this.priorityId;
    data['subPriorityId'] = this.subPriorityId;
    data['caseType'] = this.caseType;
    data['lawyerIds'] = this.lawyerIds;
    data['oicIds'] = this.oicIds;
    data['subjectCategoryId'] = this.subjectCategoryId;
    data['subjectSubCategoryId'] = this.subjectSubCategoryId;
    data['subjectMatterId'] = this.subjectMatterId;
    data['subjectSubMatterId'] = this.subjectSubMatterId;
    data['appellantName'] = this.appellantName;
    data['respondedName'] = this.respondedName;
    data['hearingDateFrom'] = this.hearingDateFrom;
    data['hearingDateTo'] = this.hearingDateTo;
    data['nextHearingDateFrom'] = this.nextHearingDateFrom;
    data['nextHearingDateTo'] = this.nextHearingDateTo;
    data['decisionDateFrom'] = this.decisionDateFrom;
    data['decisionDateTo'] = this.decisionDateTo;
    data['decisionEntryDateFrom'] = this.decisionEntryDateFrom;
    data['decisionEntryDateTo'] = this.decisionEntryDateTo;
    data['districtIds'] = this.districtIds;
    data['decisionFA'] = this.decisionFA;
    data['specialAppearance'] = this.specialAppearance;
    data['oicMobileNo'] = this.oicMobileNo;
    data['r_E_Implication'] = this.rEImplication;
    data['does_P_O_A'] = this.doesPOA;
    data['does_P_A_PD'] = this.doesPAPD;
    data['crnNumber'] = this.crnNumber;
    data['stayFA'] = this.stayFA;
    data['lawOICNotAppointed'] = this.lawOICNotAppointed;
    data['replyFiled'] = this.replyFiled;
    data['groupingId'] = this.groupingId;
    data['bench'] = this.bench;
    data['replyFileDateFrom'] = this.replyFileDateFrom;
    data['replyFileDateTo'] = this.replyFileDateTo;
    data['pD_FinalDecisionofGovtYN'] = this.pDFinalDecisionofGovtYN;
    data['pD_FinalDecisionofGovtDateFrom'] = this.pDFinalDecisionofGovtDateFrom;
    data['pD_FinalDecisionofGovtDateTo'] = this.pDFinalDecisionofGovtDateTo;
    data['selectedColumns'] = this.selectedColumns;
    data['sortBy'] = this.sortBy;
    data['isSortByDesc'] = this.isSortByDesc;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
