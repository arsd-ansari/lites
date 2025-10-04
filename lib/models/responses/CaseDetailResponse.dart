// To parse this JSON data, do
//
//     final caseDetailResponse = caseDetailResponseFromJson(jsonString);

import 'dart:convert';

CaseDetailResponse caseDetailResponseFromJson(String str) => CaseDetailResponse.fromJson(json.decode(str));

String caseDetailResponseToJson(CaseDetailResponse data) => json.encode(data.toJson());

class CaseDetailResponse {
  bool? status;
  String? message;
  CaseDetailData? data;

  CaseDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CaseDetailResponse.fromJson(Map<String, dynamic> json) => CaseDetailResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : CaseDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class CaseDetailData {
  String? establishmentName;
  Casenos? casenos;

  CaseDetailData({
    this.establishmentName,
    this.casenos,
  });

  factory CaseDetailData.fromJson(Map<String, dynamic> json) => CaseDetailData(
    establishmentName: json["establishment_name"],
    casenos: json["casenos"] == null ? null : Casenos.fromJson(json["casenos"]),
  );

  Map<String, dynamic> toJson() => {
    "establishment_name": establishmentName,
    "casenos": casenos?.toJson(),
  };
}

class Casenos {
  Case1? case1;

  Casenos({
    this.case1,
  });

  factory Casenos.fromJson(Map<String, dynamic> json) => Casenos(
    case1: json["case1"] == null ? null : Case1.fromJson(json["case1"]),
  );

  Map<String, dynamic> toJson() => {
    "case1": case1?.toJson(),
  };
}

class Case1 {
  String? cino;
  String? typeName;
  String? regNo;
  String? regYear;
  String? petName;
  String? resName;
  String? policeStCode;

  Case1({
    this.cino,
    this.typeName,
    this.regNo,
    this.regYear,
    this.petName,
    this.resName,
    this.policeStCode,
  });

  factory Case1.fromJson(Map<String, dynamic> json) => Case1(
    cino: json["cino"],
    typeName: json["type_name"],
    regNo: json["reg_no"],
    regYear: json["reg_year"],
    petName: json["pet_name"],
    resName: json["res_name"],
    policeStCode: json["police_st_code"],
  );

  Map<String, dynamic> toJson() => {
    "cino": cino,
    "type_name": typeName,
    "reg_no": regNo,
    "reg_year": regYear,
    "pet_name": petName,
    "res_name": resName,
    "police_st_code": policeStCode,
  };
}
