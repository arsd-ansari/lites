class GetActionPendingReportModel {
  bool? status;
  String? message;
  List<ActionPendingData>? data;
  List<Pagination>? pagination;

  GetActionPendingReportModel(
      {this.status, this.message, this.data, this.pagination});

  GetActionPendingReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ActionPendingData>[];
      json['data'].forEach((v) {
        data!.add(new ActionPendingData.fromJson(v));
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

class ActionPendingData {
  String? courtName;
  int? totalCases;
  int? decisionNotImplemented;
  int? hcReplyNotFiled;
  Null? scReplyNotFiled;
  Null? sbReplyNotFiled;
  int? orderPendingforAppeal;
  int? contemptCases;
  int? dueCourse;

  ActionPendingData(
      {this.courtName,
        this.totalCases,
        this.decisionNotImplemented,
        this.hcReplyNotFiled,
        this.scReplyNotFiled,
        this.sbReplyNotFiled,
        this.orderPendingforAppeal,
        this.contemptCases,
        this.dueCourse});

  ActionPendingData.fromJson(Map<String, dynamic> json) {
    courtName = json['courtName'];
    totalCases = json['totalCases'];
    decisionNotImplemented = json['decisionNotImplemented'];
    hcReplyNotFiled = json['hcReplyNotFiled'];
    scReplyNotFiled = json['scReplyNotFiled'];
    sbReplyNotFiled = json['sbReplyNotFiled'];
    orderPendingforAppeal = json['orderPendingforAppeal'];
    contemptCases = json['contemptCases'];
    dueCourse = json['dueCourse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courtName'] = this.courtName;
    data['totalCases'] = this.totalCases;
    data['decisionNotImplemented'] = this.decisionNotImplemented;
    data['hcReplyNotFiled'] = this.hcReplyNotFiled;
    data['scReplyNotFiled'] = this.scReplyNotFiled;
    data['sbReplyNotFiled'] = this.sbReplyNotFiled;
    data['orderPendingforAppeal'] = this.orderPendingforAppeal;
    data['contemptCases'] = this.contemptCases;
    data['dueCourse'] = this.dueCourse;
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

class GetActionPendingReqModel {
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
  ActionSearchParameter? searchParameter;

  GetActionPendingReqModel(
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

  GetActionPendingReqModel.fromJson(Map<String, dynamic> json) {
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
        ? new ActionSearchParameter.fromJson(json['searchParameter'])
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

class ActionSearchParameter {
  String? roleID;
  String? admdepttid;
  String? unitid;
  String? officeid;
  String? fromdate;
  String? todate;

  ActionSearchParameter(
      {this.roleID,
        this.admdepttid,
        this.unitid,
        this.officeid,
        this.fromdate,
        this.todate});

  ActionSearchParameter.fromJson(Map<String, dynamic> json) {
    roleID = json['RoleID'];
    admdepttid = json['admdepttid'];
    unitid = json['unitid'];
    officeid = json['officeid'];
    fromdate = json['fromdate'];
    todate = json['todate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RoleID'] = this.roleID;
    data['admdepttid'] = this.admdepttid;
    data['unitid'] = this.unitid;
    data['officeid'] = this.officeid;
    data['fromdate'] = this.fromdate;
    data['todate'] = this.todate;
    return data;
  }
}
