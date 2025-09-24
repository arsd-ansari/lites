class GetDecisionSummaryReportModel {
  bool? status;
  String? message;
  List<DataDecisionSummary>? data;
  List<Pagination>? pagination;

  GetDecisionSummaryReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetDecisionSummaryReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataDecisionSummary>[];
      json['data'].forEach((v) {
        data!.add(new DataDecisionSummary.fromJson(v));
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

class DataDecisionSummary {
  int? no;
  int? rowNum;
  int? admDepttId;
  String? admDepttName;
  int? totalCases;
  int? decided;
  int? favour;
  int? against;

  DataDecisionSummary(
      {this.no,
        this.rowNum,
        this.admDepttId,
        this.admDepttName,
        this.totalCases,
        this.decided,
        this.favour,
        this.against});

  DataDecisionSummary.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    rowNum = json['rowNum'];
    admDepttId = json['admDepttId'];
    admDepttName = json['admDepttName'];
    totalCases = json['totalCases'];
    decided = json['decided'];
    favour = json['favour'];
    against = json['against'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    data['rowNum'] = this.rowNum;
    data['admDepttId'] = this.admDepttId;
    data['admDepttName'] = this.admDepttName;
    data['totalCases'] = this.totalCases;
    data['decided'] = this.decided;
    data['favour'] = this.favour;
    data['against'] = this.against;
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


class DecisionSummaryReqModel {
  bool? paging;
  int? currentPageID;
  int? totalPages;
  int? startPageNumber;
  int? endPageNumber;
  int? totalRecords;
  int? startRecord;
  int? endRecord;
  int? pageSize;
  String? pageUrl;
  String? ajaxUrl;
  String? sortingColumn;
  int? sortingOrder;
  String? searchText;
  SearchParameter? searchParameter;

  DecisionSummaryReqModel(
      {this.paging,
        this.currentPageID,
        this.totalPages,
        this.startPageNumber,
        this.endPageNumber,
        this.totalRecords,
        this.startRecord,
        this.endRecord,
        this.pageSize,
        this.pageUrl,
        this.ajaxUrl,
        this.sortingColumn,
        this.sortingOrder,
        this.searchText,
        this.searchParameter});

  DecisionSummaryReqModel.fromJson(Map<String, dynamic> json) {
    paging = json['paging'];
    currentPageID = json['currentPageID'];
    totalPages = json['totalPages'];
    startPageNumber = json['startPageNumber'];
    endPageNumber = json['endPageNumber'];
    totalRecords = json['totalRecords'];
    startRecord = json['startRecord'];
    endRecord = json['endRecord'];
    pageSize = json['pageSize'];
    pageUrl = json['pageUrl'];
    ajaxUrl = json['ajaxUrl'];
    sortingColumn = json['sortingColumn'];
    sortingOrder = json['sortingOrder'];
    searchText = json['searchText'];
    searchParameter = json['searchParameter'] != null
        ? new SearchParameter.fromJson(json['searchParameter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paging'] = this.paging;
    data['currentPageID'] = this.currentPageID;
    data['totalPages'] = this.totalPages;
    data['startPageNumber'] = this.startPageNumber;
    data['endPageNumber'] = this.endPageNumber;
    data['totalRecords'] = this.totalRecords;
    data['startRecord'] = this.startRecord;
    data['endRecord'] = this.endRecord;
    data['pageSize'] = this.pageSize;
    data['pageUrl'] = this.pageUrl;
    data['ajaxUrl'] = this.ajaxUrl;
    data['sortingColumn'] = this.sortingColumn;
    data['sortingOrder'] = this.sortingOrder;
    data['searchText'] = this.searchText;
    if (this.searchParameter != null) {
      data['searchParameter'] = this.searchParameter!.toJson();
    }
    return data;
  }
}

class SearchParameter {
  String? fromdate;
  String? todate;
  String? dfromdate;
  String? dtodate;
  String? level;

  SearchParameter(
      {this.fromdate, this.todate, this.dfromdate, this.dtodate, this.level});

  SearchParameter.fromJson(Map<String, dynamic> json) {
    fromdate = json['fromdate'];
    todate = json['todate'];
    dfromdate = json['dfromdate'];
    dtodate = json['dtodate'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromdate'] = this.fromdate;
    data['todate'] = this.todate;
    data['dfromdate'] = this.dfromdate;
    data['dtodate'] = this.dtodate;
    data['level'] = this.level;
    return data;
  }
}
