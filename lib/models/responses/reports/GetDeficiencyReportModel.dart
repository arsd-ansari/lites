class GetDeficiencyReportModel {
  bool? status;
  String? message;
  List<DataDeficiency>? data;
  List<Pagination>? pagination;

  GetDeficiencyReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetDeficiencyReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataDeficiency>[];
      json['data'].forEach((v) {
        data!.add(new DataDeficiency.fromJson(v));
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

class DataDeficiency {
  int? depttID;
  int? rowNum;
  int? unitID;
  int? officeID;
  int? districtID;
  int? levelID;
  String? admDepttName;
  String? unitName;
  String? officeName;
  String? districtName;
  int? totalCount;
  int? totalEntryMonthly;
  int? totalPending;
  int? totalNAPPell;
  int? totalNRespo;
  int? totalNLawyers;
  int? totalNOIC;
  int? totalNHearing;
  int? nHoutDated;
  int? totalRedPending;
  int? rplyNotFile;
  int? factualReport;
  int? stayInGovtFavour;
  int? stayInGovtAgainst;
  int? totalContempt;
  int? totalPIL;
  int? decLessRegis;
  int? hLessRegis;
  int? dLessH;

  DataDeficiency(
      {this.depttID,
        this.rowNum,
        this.unitID,
        this.officeID,
        this.districtID,
        this.levelID,
        this.admDepttName,
        this.unitName,
        this.officeName,
        this.districtName,
        this.totalCount,
        this.totalEntryMonthly,
        this.totalPending,
        this.totalNAPPell,
        this.totalNRespo,
        this.totalNLawyers,
        this.totalNOIC,
        this.totalNHearing,
        this.nHoutDated,
        this.totalRedPending,
        this.rplyNotFile,
        this.factualReport,
        this.stayInGovtFavour,
        this.stayInGovtAgainst,
        this.totalContempt,
        this.totalPIL,
        this.decLessRegis,
        this.hLessRegis,
        this.dLessH});

  DataDeficiency.fromJson(Map<String, dynamic> json) {
    depttID = json['depttID'];
    rowNum = json['rowNum'];
    unitID = json['unitID'];
    officeID = json['officeID'];
    districtID = json['districtID'];
    levelID = json['levelID'];
    admDepttName = json['admDepttName'];
    unitName = json['unitName'];
    officeName = json['officeName'];
    districtName = json['districtName'];
    totalCount = json['totalCount'];
    totalEntryMonthly = json['totalEntryMonthly'];
    totalPending = json['totalPending'];
    totalNAPPell = json['totalNAPPell'];
    totalNRespo = json['totalNRespo'];
    totalNLawyers = json['totalNLawyers'];
    totalNOIC = json['totalNOIC'];
    totalNHearing = json['totalNHearing'];
    nHoutDated = json['nHoutDated'];
    totalRedPending = json['totalRedPending'];
    rplyNotFile = json['rplyNotFile'];
    factualReport = json['factualReport'];
    stayInGovtFavour = json['stayInGovtFavour'];
    stayInGovtAgainst = json['stayInGovtAgainst'];
    totalContempt = json['totalContempt'];
    totalPIL = json['totalPIL'];
    decLessRegis = json['dec_less_Regis'];
    hLessRegis = json['h_less_Regis'];
    dLessH = json['d_less_H'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['depttID'] = this.depttID;
    data['rowNum'] = this.rowNum;
    data['unitID'] = this.unitID;
    data['officeID'] = this.officeID;
    data['districtID'] = this.districtID;
    data['levelID'] = this.levelID;
    data['admDepttName'] = this.admDepttName;
    data['unitName'] = this.unitName;
    data['officeName'] = this.officeName;
    data['districtName'] = this.districtName;
    data['totalCount'] = this.totalCount;
    data['totalEntryMonthly'] = this.totalEntryMonthly;
    data['totalPending'] = this.totalPending;
    data['totalNAPPell'] = this.totalNAPPell;
    data['totalNRespo'] = this.totalNRespo;
    data['totalNLawyers'] = this.totalNLawyers;
    data['totalNOIC'] = this.totalNOIC;
    data['totalNHearing'] = this.totalNHearing;
    data['nHoutDated'] = this.nHoutDated;
    data['totalRedPending'] = this.totalRedPending;
    data['rplyNotFile'] = this.rplyNotFile;
    data['factualReport'] = this.factualReport;
    data['stayInGovtFavour'] = this.stayInGovtFavour;
    data['stayInGovtAgainst'] = this.stayInGovtAgainst;
    data['totalContempt'] = this.totalContempt;
    data['totalPIL'] = this.totalPIL;
    data['dec_less_Regis'] = this.decLessRegis;
    data['h_less_Regis'] = this.hLessRegis;
    data['d_less_H'] = this.dLessH;
    return data;
  }
}

class Pagination {
  Null? sortBy;
  Null? isSortByDesc;
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
    isSortByDesc = json['isSortByDesc'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortBy'] = this.sortBy;
    data['isSortByDesc'] = this.isSortByDesc;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    return data;
  }
}
