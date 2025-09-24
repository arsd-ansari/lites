class GetEvaluationSummaryModel {
  bool? status;
  String? message;
  List<DataEvaluationSummary>? data;
  List<Pagination>? pagination;

  GetEvaluationSummaryModel(
      {this.status, this.message, this.data, this.pagination});

  GetEvaluationSummaryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataEvaluationSummary>[];
      json['data'].forEach((v) {
        data!.add(new DataEvaluationSummary.fromJson(v));
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

class DataEvaluationSummary {
  int? admDepttID;
  String? admDepttName;
  int? totalCases;
  int? caseregAfter;
  int? docsAdded;
  double? a;
  int? replyFileCout;
  double? b;
  int? contemptCaseCount;
  double? e;
  int? totalDecidedAgainst;
  int? orderPendingforAppeal;
  double? c;
  int? decisionNotImplemented;
  double? d;
  double? formula;

  DataEvaluationSummary(
      {this.admDepttID,
        this.admDepttName,
        this.totalCases,
        this.caseregAfter,
        this.docsAdded,
        this.a,
        this.replyFileCout,
        this.b,
        this.contemptCaseCount,
        this.e,
        this.totalDecidedAgainst,
        this.orderPendingforAppeal,
        this.c,
        this.decisionNotImplemented,
        this.d,
        this.formula});

  DataEvaluationSummary.fromJson(Map<String, dynamic> json) {
    admDepttID = json['admDepttID'];
    admDepttName = json['admDepttName'];
    totalCases = json['totalCases'];
    caseregAfter = json['caseregAfter'];
    docsAdded = json['docsAdded'];
    a = json['a'];
    replyFileCout = json['replyFileCout'];
    b = json['b'];
    contemptCaseCount = json['contemptCaseCount'];
    e = json['e'];
    totalDecidedAgainst = json['totalDecidedAgainst'];
    orderPendingforAppeal = json['orderPendingforAppeal'];
    c = json['c'];
    decisionNotImplemented = json['decisionNotImplemented'];
    d = json['d'];
    formula = json['formula'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admDepttID'] = this.admDepttID;
    data['admDepttName'] = this.admDepttName;
    data['totalCases'] = this.totalCases;
    data['caseregAfter'] = this.caseregAfter;
    data['docsAdded'] = this.docsAdded;
    data['a'] = this.a;
    data['replyFileCout'] = this.replyFileCout;
    data['b'] = this.b;
    data['contemptCaseCount'] = this.contemptCaseCount;
    data['e'] = this.e;
    data['totalDecidedAgainst'] = this.totalDecidedAgainst;
    data['orderPendingforAppeal'] = this.orderPendingforAppeal;
    data['c'] = this.c;
    data['decisionNotImplemented'] = this.decisionNotImplemented;
    data['d'] = this.d;
    data['formula'] = this.formula;
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
