class GetAAGReportModel {
  bool? status;
  String? message;
  List<DataAAG>? data;
  List<Pagination>? pagination;

  GetAAGReportModel({this.status, this.message, this.data, this.pagination});

  GetAAGReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataAAG>[];
      json['data'].forEach((v) {
        data!.add(new DataAAG.fromJson(v));
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

class DataAAG {
  int? no;
  int? rowNum;
  int? lawyerId;
  String? name;
  int? totalCases;
  String? lname;
  String? rname;
  int? decided;
  int? favour;
  int? against;

  DataAAG(
      {this.no,
        this.rowNum,
        this.lawyerId,
        this.name,
        this.totalCases,
        this.lname,
        this.rname,
        this.decided,
        this.favour,
        this.against});

  DataAAG.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    rowNum = json['rowNum'];
    lawyerId = json['lawyerId'];
    name = json['name'];
    totalCases = json['totalCases'];
    lname = json['lname'];
    rname = json['rname'];
    decided = json['decided'];
    favour = json['favour'];
    against = json['against'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    data['rowNum'] = this.rowNum;
    data['lawyerId'] = this.lawyerId;
    data['name'] = this.name;
    data['totalCases'] = this.totalCases;
    data['lname'] = this.lname;
    data['rname'] = this.rname;
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


class AAGReportReqModel {
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

  AAGReportReqModel({
    this.paging,
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
    this.searchParameter,
  });

  AAGReportReqModel.fromJson(Map<String, dynamic> json) {
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
        ? SearchParameter.fromJson(json['searchParameter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'paging': paging,
      'currentPageID': currentPageID,
      'totalPages': totalPages,
      'startPageNumber': startPageNumber,
      'endPageNumber': endPageNumber,
      'totalRecords': totalRecords,
      'startRecord': startRecord,
      'endRecord': endRecord,
      'pageSize': pageSize,
      'pageUrl': pageUrl ?? "",
      'ajaxUrl': ajaxUrl ?? "",
      'sortingColumn': sortingColumn ?? "",
      'sortingOrder': sortingOrder,
      'searchText': searchText ?? "",
      'searchParameter': searchParameter?.toJson() ?? SearchParameter().toJson(),
    };
  }
}

class SearchParameter {
  String? admdepttid;
  String? unitid;
  String? fromdate;
  String? todate;

  SearchParameter({
    this.admdepttid,
    this.unitid,
    this.fromdate,
    this.todate,
  });

  SearchParameter.fromJson(Map<String, dynamic> json) {
    admdepttid = json['admdepttid'];
    unitid = json['unitid'];
    fromdate = json['fromdate'];
    todate = json['todate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'admdepttid': admdepttid ?? "",
      'unitid': unitid ?? "",
      'fromdate': fromdate ?? "",
      'todate': todate ?? "",
    };
  }
}

