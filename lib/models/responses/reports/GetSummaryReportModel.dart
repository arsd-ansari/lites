class GetSummaryReportModel {
  List<AdmindeptWiseCases>? admindeptWiseCases;
  List<UnitWiseCases>? unitWiseCases;
  List<OfficeWiseCases>? officeWiseCases;
  List<CasesDetails>? casesDetails;
  List<ImpCases>? impCases;
  List<ImpCasesDetails>? impCasesDetails;

  GetSummaryReportModel(
      {this.admindeptWiseCases,
        this.unitWiseCases,
        this.officeWiseCases,
        this.casesDetails,
        this.impCases,
        this.impCasesDetails});

  GetSummaryReportModel.fromJson(Map<String, dynamic> json) {
    if (json['admindeptWiseCases'] != null) {
      admindeptWiseCases = <AdmindeptWiseCases>[];
      json['admindeptWiseCases'].forEach((v) {
        admindeptWiseCases!.add(new AdmindeptWiseCases.fromJson(v));
      });
    }
    if (json['unitWiseCases'] != null) {
      unitWiseCases = <UnitWiseCases>[];
      json['unitWiseCases'].forEach((v) {
        unitWiseCases!.add(new UnitWiseCases.fromJson(v));
      });
    }
    if (json['officeWiseCases'] != null) {
      officeWiseCases = <OfficeWiseCases>[];
      json['officeWiseCases'].forEach((v) {
        officeWiseCases!.add(new OfficeWiseCases.fromJson(v));
      });
    }
    if (json['casesDetails'] != null) {
      casesDetails = <CasesDetails>[];
      json['casesDetails'].forEach((v) {
        casesDetails!.add(new CasesDetails.fromJson(v));
      });
    }
    if (json['impCases'] != null) {
      impCases = <ImpCases>[];
      json['impCases'].forEach((v) {
        impCases!.add(new ImpCases.fromJson(v));
      });
    }
    if (json['impCasesDetails'] != null) {
      impCasesDetails = <ImpCasesDetails>[];
      json['impCasesDetails'].forEach((v) {
        impCasesDetails!.add(new ImpCasesDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.admindeptWiseCases != null) {
      data['admindeptWiseCases'] =
          this.admindeptWiseCases!.map((v) => v.toJson()).toList();
    }
    if (this.unitWiseCases != null) {
      data['unitWiseCases'] =
          this.unitWiseCases!.map((v) => v.toJson()).toList();
    }
    if (this.officeWiseCases != null) {
      data['officeWiseCases'] =
          this.officeWiseCases!.map((v) => v.toJson()).toList();
    }
    if (this.casesDetails != null) {
      data['casesDetails'] = this.casesDetails!.map((v) => v.toJson()).toList();
    }
    if (this.impCases != null) {
      data['impCases'] = this.impCases!.map((v) => v.toJson()).toList();
    }
    if (this.impCasesDetails != null) {
      data['impCasesDetails'] =
          this.impCasesDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdmindeptWiseCases {
  int? rowNum;
  int? admDepttId;
  String? admDepttName;
  int? caseCount;

  AdmindeptWiseCases(
      {this.rowNum, this.admDepttId, this.admDepttName, this.caseCount});

  AdmindeptWiseCases.fromJson(Map<String, dynamic> json) {
    rowNum = json['rowNum'];
    admDepttId = json['admDepttId'];
    admDepttName = json['admDepttName'];
    caseCount = json['caseCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNum'] = this.rowNum;
    data['admDepttId'] = this.admDepttId;
    data['admDepttName'] = this.admDepttName;
    data['caseCount'] = this.caseCount;
    return data;
  }
}

class UnitWiseCases {
  int? rowNum;
  int? unitId;
  String? unitName;
  int? admDepttId;
  int? caseCount;

  UnitWiseCases(
      {this.rowNum,
        this.unitId,
        this.unitName,
        this.admDepttId,
        this.caseCount});

  UnitWiseCases.fromJson(Map<String, dynamic> json) {
    rowNum = json['rowNum'];
    unitId = json['unit_Id'];
    unitName = json['unitName'];
    admDepttId = json['admDepttId'];
    caseCount = json['caseCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNum'] = this.rowNum;
    data['unit_Id'] = this.unitId;
    data['unitName'] = this.unitName;
    data['admDepttId'] = this.admDepttId;
    data['caseCount'] = this.caseCount;
    return data;
  }
}

class OfficeWiseCases {
  int? rowNum;
  int? officeId;
  int? unitId;
  String? officeName;
  int? caseCount;

  OfficeWiseCases(
      {this.rowNum,
        this.officeId,
        this.unitId,
        this.officeName,
        this.caseCount});

  OfficeWiseCases.fromJson(Map<String, dynamic> json) {
    rowNum = json['rowNum'];
    officeId = json['officeId'];
    unitId = json['unit_Id'];
    officeName = json['officeName'];
    caseCount = json['caseCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNum'] = this.rowNum;
    data['officeId'] = this.officeId;
    data['unit_Id'] = this.unitId;
    data['officeName'] = this.officeName;
    data['caseCount'] = this.caseCount;
    return data;
  }
}

class CasesDetails {
  int? rowNum;
  int? caseId;
  int? admDepttId;
  String? primarySecondary;
  int? officeId;
  int? caseNo;
  int? caseYear;
  String? priorityCode;
  String? caseRegistrationDate;
  String? courtName;
  String? abbrevationShort;
  String? subjectCategoryName;
  String? subjectSubCategoryName;
  String? subjectSubMatterName;
  String? oicName;
  String? lawyerName;
  String? placeName;
  String? caseStatus;
  String? token;

  CasesDetails(
      {this.rowNum,
        this.caseId,
        this.admDepttId,
        this.primarySecondary,
        this.officeId,
        this.caseNo,
        this.caseYear,
        this.priorityCode,
        this.caseRegistrationDate,
        this.courtName,
        this.abbrevationShort,
        this.subjectCategoryName,
        this.subjectSubCategoryName,
        this.subjectSubMatterName,
        this.oicName,
        this.lawyerName,
        this.placeName,
        this.caseStatus,
        this.token});

  CasesDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['rowNum'];
    caseId = json['caseId'];
    admDepttId = json['admDepttId'];
    primarySecondary = json['primarySecondary'];
    officeId = json['officeId'];
    caseNo = json['caseNo'];
    caseYear = json['caseYear'];
    priorityCode = json['priorityCode'];
    caseRegistrationDate = json['caseRegistrationDate'];
    courtName = json['courtName'];
    abbrevationShort = json['abbrevation_Short'];
    subjectCategoryName = json['subjectCategoryName'];
    subjectSubCategoryName = json['subjectSubCategoryName'];
    subjectSubMatterName = json['subjectSubMatterName'];
    oicName = json['oicName'];
    lawyerName = json['lawyerName'];
    placeName = json['placeName'];
    caseStatus = json['caseStatus'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNum'] = this.rowNum;
    data['caseId'] = this.caseId;
    data['admDepttId'] = this.admDepttId;
    data['primarySecondary'] = this.primarySecondary;
    data['officeId'] = this.officeId;
    data['caseNo'] = this.caseNo;
    data['caseYear'] = this.caseYear;
    data['priorityCode'] = this.priorityCode;
    data['caseRegistrationDate'] = this.caseRegistrationDate;
    data['courtName'] = this.courtName;
    data['abbrevation_Short'] = this.abbrevationShort;
    data['subjectCategoryName'] = this.subjectCategoryName;
    data['subjectSubCategoryName'] = this.subjectSubCategoryName;
    data['subjectSubMatterName'] = this.subjectSubMatterName;
    data['oicName'] = this.oicName;
    data['lawyerName'] = this.lawyerName;
    data['placeName'] = this.placeName;
    data['caseStatus'] = this.caseStatus;
    data['token'] = this.token;
    return data;
  }
}

class ImpCases {
  int? rowNum;
  int? courtTypeId;
  String? courtTypeName;
  int? caseCount;

  ImpCases({this.rowNum, this.courtTypeId, this.courtTypeName, this.caseCount});

  ImpCases.fromJson(Map<String, dynamic> json) {
    rowNum = json['rowNum'];
    courtTypeId = json['courtTypeId'];
    courtTypeName = json['courtTypeName'];
    caseCount = json['caseCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNum'] = this.rowNum;
    data['courtTypeId'] = this.courtTypeId;
    data['courtTypeName'] = this.courtTypeName;
    data['caseCount'] = this.caseCount;
    return data;
  }
}

class ImpCasesDetails {
  int? courtTypeId;
  int? caseId;
  String? admDepttName;
  String? unitName;
  String? officeName;
  String? priorityName;
  String? subPriorityName;
  String? courtName;
  String? nextHearingDate;
  String? caseDetail;
  String? lawyers;
  String? oicName;
  String? appellantName;
  String? respondedName;
  String? token;

  ImpCasesDetails(
      {this.courtTypeId,
        this.caseId,
        this.admDepttName,
        this.unitName,
        this.officeName,
        this.priorityName,
        this.subPriorityName,
        this.courtName,
        this.nextHearingDate,
        this.caseDetail,
        this.lawyers,
        this.oicName,
        this.appellantName,
        this.respondedName,
        this.token});

  ImpCasesDetails.fromJson(Map<String, dynamic> json) {
    courtTypeId = json['courtTypeId'];
    caseId = json['caseId'];
    admDepttName = json['admDepttName'];
    unitName = json['unitName'];
    officeName = json['officeName'];
    priorityName = json['priorityName'];
    subPriorityName = json['subPriorityName'];
    courtName = json['courtName'];
    nextHearingDate = json['nextHearing_Date'];
    caseDetail = json['caseDetail'];
    lawyers = json['lawyers'];
    oicName = json['oicName'];
    appellantName = json['appellantName'];
    respondedName = json['respondedName'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courtTypeId'] = this.courtTypeId;
    data['caseId'] = this.caseId;
    data['admDepttName'] = this.admDepttName;
    data['unitName'] = this.unitName;
    data['officeName'] = this.officeName;
    data['priorityName'] = this.priorityName;
    data['subPriorityName'] = this.subPriorityName;
    data['courtName'] = this.courtName;
    data['nextHearing_Date'] = this.nextHearingDate;
    data['caseDetail'] = this.caseDetail;
    data['lawyers'] = this.lawyers;
    data['oicName'] = this.oicName;
    data['appellantName'] = this.appellantName;
    data['respondedName'] = this.respondedName;
    data['token'] = this.token;
    return data;
  }
}
