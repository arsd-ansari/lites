class GetCauseListResponseModel {
  bool? status;
  String? message;
  List<CauseListSummary>? causeListSummary;
  List<CauseData>? data;
  List<Pagination>? pagination;

  GetCauseListResponseModel(
      {this.status,
        this.message,
        this.causeListSummary,
        this.data,
        this.pagination});

  GetCauseListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['causeListSummary'] != null) {
      causeListSummary = <CauseListSummary>[];
      json['causeListSummary'].forEach((v) {
        causeListSummary!.add(new CauseListSummary.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <CauseData>[];
      json['data'].forEach((v) {
        data!.add(new CauseData.fromJson(v));
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
    if (this.causeListSummary != null) {
      data['causeListSummary'] =
          this.causeListSummary!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CauseListSummary {
  int? causeListRecords;
  int? matchByCRNRecords;
  int? matchByCaseNoRecords;
  int? unMatchRecords;

  CauseListSummary(
      {this.causeListRecords,
        this.matchByCRNRecords,
        this.matchByCaseNoRecords,
        this.unMatchRecords});

  CauseListSummary.fromJson(Map<String, dynamic> json) {
    causeListRecords = json['CauseListRecords'];
    matchByCRNRecords = json['MatchByCRNRecords'];
    matchByCaseNoRecords = json['MatchByCaseNoRecords'];
    unMatchRecords = json['UnMatchRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CauseListRecords'] = this.causeListRecords;
    data['MatchByCRNRecords'] = this.matchByCRNRecords;
    data['MatchByCaseNoRecords'] = this.matchByCaseNoRecords;
    data['UnMatchRecords'] = this.unMatchRecords;
    return data;
  }
}

class CauseData {
  int? rowID;
  String? cDate;
  int? courtRoom;
  String? estt;
  String? judname;
  String? judname2;
  int? causeId;
  String? causelistDate;
  String? cno;
  int? cyear;
  String? caseTypeNo;
  String? caseTitle;
  String? advocateName;
  String? deparmentName;
  String? petitionerDeparmentName;
  String? respondentDeparmentName;
  String? cRNNo;
  dynamic? caseId;
  dynamic? caseNo;
  dynamic? caseYear;
  dynamic? courtId;
  dynamic? cRNNumber;
  String? lawyerEmail;
  dynamic? lawyerId;
  dynamic? lawyerMobileNo;
  String? lawyerName;
  String? litesDeparmentName;
  dynamic? matchType;
  String? oICEmail;
  dynamic? oICId;
  dynamic? oICMobile;
  String? oICName;

  CauseData(
      {this.rowID,
        this.cDate,
        this.courtRoom,
        this.estt,
        this.judname,
        this.judname2,
        this.causeId,
        this.causelistDate,
        this.cno,
        this.cyear,
        this.caseTypeNo,
        this.caseTitle,
        this.advocateName,
        this.deparmentName,
        this.petitionerDeparmentName,
        this.respondentDeparmentName,
        this.cRNNo,
        this.caseId,
        this.caseNo,
        this.caseYear,
        this.courtId,
        this.cRNNumber,
        this.lawyerEmail,
        this.lawyerId,
        this.lawyerMobileNo,
        this.lawyerName,
        this.litesDeparmentName,
        this.matchType,
        this.oICEmail,
        this.oICId,
        this.oICMobile,
        this.oICName});

  CauseData.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    cDate = json['CDate'];
    courtRoom = json['CourtRoom'];
    estt = json['Estt'];
    judname = json['judname'];
    judname2 = json['judname2'];
    causeId = json['CauseId'];
    causelistDate = json['CauselistDate'];
    cno = json['cno'];
    cyear = json['cyear'];
    caseTypeNo = json['CaseTypeNo'];
    caseTitle = json['CaseTitle'];
    advocateName = json['AdvocateName'];
    deparmentName = json['DeparmentName'];
    petitionerDeparmentName = json['PetitionerDeparmentName'];
    respondentDeparmentName = json['RespondentDeparmentName'];
    cRNNo = json['CRNNo'];
    caseId = json['CaseId'];
    caseNo = json['CaseNo'];
    caseYear = json['CaseYear'];
    courtId = json['CourtId'];
    cRNNumber = json['CRNNumber'];
    lawyerEmail = json['LawyerEmail'];
    lawyerId = json['LawyerId'];
    lawyerMobileNo = json['LawyerMobileNo'];
    lawyerName = json['LawyerName'];
    litesDeparmentName = json['LitesDeparmentName'];
    matchType = json['MatchType'];
    oICEmail = json['OICEmail'];
    oICId = json['OICId'];
    oICMobile = json['OICMobile'];
    oICName = json['OICName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['CDate'] = this.cDate;
    data['CourtRoom'] = this.courtRoom;
    data['Estt'] = this.estt;
    data['judname'] = this.judname;
    data['judname2'] = this.judname2;
    data['CauseId'] = this.causeId;
    data['CauselistDate'] = this.causelistDate;
    data['cno'] = this.cno;
    data['cyear'] = this.cyear;
    data['CaseTypeNo'] = this.caseTypeNo;
    data['CaseTitle'] = this.caseTitle;
    data['AdvocateName'] = this.advocateName;
    data['DeparmentName'] = this.deparmentName;
    data['PetitionerDeparmentName'] = this.petitionerDeparmentName;
    data['RespondentDeparmentName'] = this.respondentDeparmentName;
    data['CRNNo'] = this.cRNNo;
    data['CaseId'] = this.caseId;
    data['CaseNo'] = this.caseNo;
    data['CaseYear'] = this.caseYear;
    data['CourtId'] = this.courtId;
    data['CRNNumber'] = this.cRNNumber;
    data['LawyerEmail'] = this.lawyerEmail;
    data['LawyerId'] = this.lawyerId;
    data['LawyerMobileNo'] = this.lawyerMobileNo;
    data['LawyerName'] = this.lawyerName;
    data['LitesDeparmentName'] = this.litesDeparmentName;
    data['MatchType'] = this.matchType;
    data['OICEmail'] = this.oICEmail;
    data['OICId'] = this.oICId;
    data['OICMobile'] = this.oICMobile;
    data['OICName'] = this.oICName;
    return data;
  }
}

class Pagination {
  int? pageNo;
  int? pageSize;
  int? totalRecords;

  Pagination({this.pageNo, this.pageSize, this.totalRecords});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNo = json['PageNo'];
    pageSize = json['PageSize'];
    totalRecords = json['TotalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageNo'] = this.pageNo;
    data['PageSize'] = this.pageSize;
    data['TotalRecords'] = this.totalRecords;
    return data;
  }
}

class CauseListReqModel {
  String? causeListDateFrom;
  String? causeListDateTo;
  String? estt;
  String? causeListType;
  int? courtRoom;
  String? judgeName;
  String? departmentName;
  int? lawyerId;
  int? oicId;
  String? recordsType;
  int? pageNo;
  int? pageSize;

  CauseListReqModel(
      {this.causeListDateFrom,
        this.causeListDateTo,
        this.estt,
        this.causeListType,
        this.courtRoom,
        this.judgeName,
        this.departmentName,
        this.lawyerId,
        this.oicId,
        this.recordsType,
        this.pageNo,
        this.pageSize});

  CauseListReqModel.fromJson(Map<String, dynamic> json) {
    causeListDateFrom = json['causeListDateFrom'];
    causeListDateTo = json['causeListDateTo'];
    estt = json['estt'];
    causeListType = json['causeListType'];
    courtRoom = json['courtRoom'];
    judgeName = json['judgeName'];
    departmentName = json['departmentName'];
    lawyerId = json['lawyerId'];
    oicId = json['oicId'];
    recordsType = json['recordsType'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['causeListDateFrom'] = this.causeListDateFrom;
    data['causeListDateTo'] = this.causeListDateTo;
    data['estt'] = this.estt;
    data['causeListType'] = this.causeListType;
    data['courtRoom'] = this.courtRoom;
    data['judgeName'] = this.judgeName;
    data['departmentName'] = this.departmentName;
    data['lawyerId'] = this.lawyerId;
    data['oicId'] = this.oicId;
    data['recordsType'] = this.recordsType;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    return data;
  }
}

