// To parse this JSON data, do
//
//     final getDetailByECnrModel = getDetailByECnrModelFromJson(jsonString);

import 'dart:convert';

GetDetailByECnrModel getDetailByECnrModelFromJson(String str) => GetDetailByECnrModel.fromJson(json.decode(str));

String getDetailByECnrModelToJson(GetDetailByECnrModel data) => json.encode(data.toJson());

class GetDetailByECnrModel {
  bool? status;
  String? message;
  GetDetailByECnrModelData? data;

  GetDetailByECnrModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetDetailByECnrModel.fromJson(Map<String, dynamic> json) => GetDetailByECnrModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : GetDetailByECnrModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class GetDetailByECnrModelData {
  bool? status;
  String? message;
  DataData? data;

  GetDetailByECnrModelData({
    this.status,
    this.message,
    this.data,
  });

  factory GetDetailByECnrModelData.fromJson(Map<String, dynamic> json) => GetDetailByECnrModelData(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : DataData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataData {
  int? stateCode;
  int? districtCode;
  String? dateOfFiling;
  String? cino;
  String? dtRegis;
  String? typeName;
  int? caseTypeId;
  String? filNo;
  String? filYear;
  String? regNo;
  String? regYear;
  String? dateFirstList;
  String? dateNextList;
  String? pendDisp;
  dynamic dateOfDecision;
  String? goshwaraNo;
  dynamic dispName;
  String? desgname;
  int? courtNo;
  String? courtEstName;
  String? establishmentName;
  String? estCode;
  String? stateName;
  String? distName;
  String? purposeName;
  String? petName;
  String? petAdv;
  String? petLegalHeir;
  String? petAdvCd;
  String? resAdvCd;
  String? petAdvBarReg;
  String? resAdvBarReg;
  String? resName;
  String? resAdv;
  String? resLegalHeir;
  String? firNo;
  dynamic policeStation;
  dynamic policeStCode;
  dynamic uniformCode;
  dynamic firYear;
  dynamic lowerCourtName;
  int? lowerCourtCaseno;
  dynamic lowerCourtDecDt;
  String? dateLastList;
  String? mainMatterCino;
  dynamic dateFilingDisp;
  dynamic reasonForRej;
  Acts? acts;
  dynamic petExtraParty;
  dynamic resExtraParty;
  Map<String, Historyofcasehearing>? historyofcasehearing;
  String? hidePetName;
  String? hideResName;
  dynamic hidePartyname;
  String? hidePartynameEst;
  Interimorder? interimorder;
  dynamic finalorder;
  dynamic transfer;
  dynamic writinfo;
  dynamic processes;
  dynamic iafiling;
  dynamic linkCases;
  dynamic objections;

  DataData({
    this.stateCode,
    this.districtCode,
    this.dateOfFiling,
    this.cino,
    this.dtRegis,
    this.typeName,
    this.caseTypeId,
    this.filNo,
    this.filYear,
    this.regNo,
    this.regYear,
    this.dateFirstList,
    this.dateNextList,
    this.pendDisp,
    this.dateOfDecision,
    this.goshwaraNo,
    this.dispName,
    this.desgname,
    this.courtNo,
    this.courtEstName,
    this.establishmentName,
    this.estCode,
    this.stateName,
    this.distName,
    this.purposeName,
    this.petName,
    this.petAdv,
    this.petLegalHeir,
    this.petAdvCd,
    this.resAdvCd,
    this.petAdvBarReg,
    this.resAdvBarReg,
    this.resName,
    this.resAdv,
    this.resLegalHeir,
    this.firNo,
    this.policeStation,
    this.policeStCode,
    this.uniformCode,
    this.firYear,
    this.lowerCourtName,
    this.lowerCourtCaseno,
    this.lowerCourtDecDt,
    this.dateLastList,
    this.mainMatterCino,
    this.dateFilingDisp,
    this.reasonForRej,
    this.acts,
    this.petExtraParty,
    this.resExtraParty,
    this.historyofcasehearing,
    this.hidePetName,
    this.hideResName,
    this.hidePartyname,
    this.hidePartynameEst,
    this.interimorder,
    this.finalorder,
    this.transfer,
    this.writinfo,
    this.processes,
    this.iafiling,
    this.linkCases,
    this.objections,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    stateCode: json["state_code"],
    districtCode: json["district_code"],
    dateOfFiling: json["date_of_filing"],
    cino: json["cino"],
    dtRegis: json["dt_regis"],
    typeName: json["type_name"],
    caseTypeId: json["case_type_id"],
    filNo: json["fil_no"],
    filYear: json["fil_year"],
    regNo: json["reg_no"],
    regYear: json["reg_year"],
    dateFirstList: json["date_first_list"],
    dateNextList: json["date_next_list"],
    pendDisp: json["pend_disp"],
    dateOfDecision: json["date_of_decision"],
    goshwaraNo: json["goshwara_no"],
    dispName: json["disp_name"],
    desgname: json["desgname"],
    courtNo: json["court_no"],
    courtEstName: json["court_est_name"],
    establishmentName: json["establishment_name"],
    estCode: json["est_code"],
    stateName: json["state_name"],
    distName: json["dist_name"],
    purposeName:json["purpose_name"],
    petName: json["pet_name"],
    petAdv: json["pet_adv"],
    petLegalHeir: json["pet_legal_heir"],
    petAdvCd: json["pet_adv_cd"],
    resAdvCd: json["res_adv_cd"],
    petAdvBarReg: json["pet_adv_bar_reg"],
    resAdvBarReg: json["res_adv_bar_reg"],
    resName: json["res_name"],
    resAdv: json["res_adv"],
    resLegalHeir: json["res_legal_heir"],
    firNo: json["fir_no"],
    policeStation: json["police_station"],
    policeStCode: json["police_st_code"],
    uniformCode: json["uniform_code"],
    firYear: json["fir_year"],
    lowerCourtName: json["lower_court_name"],
    lowerCourtCaseno: json["lower_court_caseno"],
    lowerCourtDecDt: json["lower_court_dec_dt"],
    dateLastList: json["date_last_list"],
    mainMatterCino: json["main_matter_cino"],
    dateFilingDisp: json["date_filing_disp"],
    reasonForRej: json["reason_for_rej"],
    acts: json["acts"] == null ? null : Acts.fromJson(json["acts"]),
    petExtraParty: json["pet_extra_party"],
    resExtraParty: json["res_extra_party"],
    historyofcasehearing: Map.from(json["historyofcasehearing"]!).map((k, v) => MapEntry<String, Historyofcasehearing>(k, Historyofcasehearing.fromJson(v))),
    hidePetName: json["hide_pet_name"],
    hideResName: json["hide_res_name"],
    hidePartyname: json["hide_partyname"],
    hidePartynameEst: json["hide_partyname_est"],
    interimorder: json["interimorder"] == null ? null : Interimorder.fromJson(json["interimorder"]),
    finalorder: json["finalorder"],
    transfer: json["transfer"],
    writinfo: json["writinfo"],
    processes: json["processes"],
    iafiling: json["iafiling"],
    linkCases: json["link_cases"],
    objections: json["objections"],
  );

  Map<String, dynamic> toJson() => {
    "state_code": stateCode,
    "district_code": districtCode,
    "date_of_filing": dateOfFiling,
    "cino": cino,
    "dt_regis": dtRegis,
    "type_name": typeName,
    "case_type_id": caseTypeId,
    "fil_no": filNo,
    "fil_year": filYear,
    "reg_no": regNo,
    "reg_year": regYear,
    "date_first_list":dateFirstList,
    "date_next_list":dateNextList,
    "pend_disp": pendDisp,
    "date_of_decision": dateOfDecision,
    "goshwara_no": goshwaraNo,
    "disp_name": dispName,
    "desgname": desgnameValues.reverse[desgname],
    "court_no": courtNo,
    "court_est_name": courtEstName,
    "establishment_name": establishmentName,
    "est_code": estCode,
    "state_name": stateName,
    "dist_name": distName,
    "purpose_name": purposeValues.reverse[purposeName],
    "pet_name": petName,
    "pet_adv": petAdv,
    "pet_legal_heir": petLegalHeir,
    "pet_adv_cd": petAdvCd,
    "res_adv_cd": resAdvCd,
    "pet_adv_bar_reg": petAdvBarReg,
    "res_adv_bar_reg": resAdvBarReg,
    "res_name": resName,
    "res_adv": resAdv,
    "res_legal_heir": resLegalHeir,
    "fir_no": firNo,
    "police_station": policeStation,
    "police_st_code": policeStCode,
    "uniform_code": uniformCode,
    "fir_year": firYear,
    "lower_court_name": lowerCourtName,
    "lower_court_caseno": lowerCourtCaseno,
    "lower_court_dec_dt": lowerCourtDecDt,
    "date_last_list": dateLastList,
    "main_matter_cino": mainMatterCino,
    "date_filing_disp": dateFilingDisp,
    "reason_for_rej": reasonForRej,
    "acts": acts?.toJson(),
    "pet_extra_party": petExtraParty,
    "res_extra_party": resExtraParty,
    "historyofcasehearing": Map.from(historyofcasehearing!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "hide_pet_name": hidePetName,
    "hide_res_name": hideResName,
    "hide_partyname": hidePartyname,
    "hide_partyname_est": hidePartynameEst,
    "interimorder": interimorder?.toJson(),
    "finalorder": finalorder,
    "transfer": transfer,
    "writinfo": writinfo,
    "processes": processes,
    "iafiling": iafiling,
    "link_cases": linkCases,
    "objections": objections,
  };
}

class Acts {
  Act1? act1;

  Acts({
    this.act1,
  });

  factory Acts.fromJson(Map<String, dynamic> json) => Acts(
    act1: json["act1"] == null ? null : Act1.fromJson(json["act1"]),
  );

  Map<String, dynamic> toJson() => {
    "act1": act1?.toJson(),
  };
}

class Act1 {
  String? actname;
  String? section;

  Act1({
    this.actname,
    this.section,
  });

  factory Act1.fromJson(Map<String, dynamic> json) => Act1(
    actname: json["actname"],
    section: json["section"],
  );

  Map<String, dynamic> toJson() => {
    "actname": actname,
    "section": section,
  };
}

enum Desgname {
  SR_CJ_CUM_CJM
}

final desgnameValues = EnumValues({
  "Sr. CJ-CUM-CJM": Desgname.SR_CJ_CUM_CJM
});

class Historyofcasehearing {
  String? desgname;
  String? businessDate;
  String? hearingDate;
  String? purposeOfListing;

  Historyofcasehearing({
    this.desgname,
    this.businessDate,
    this.hearingDate,
    this.purposeOfListing,
  });

  factory Historyofcasehearing.fromJson(Map<String, dynamic> json) => Historyofcasehearing(
    desgname:json["desgname"],
    businessDate: json["business_date"],
    hearingDate: json["hearing_date"],
    purposeOfListing: json["purpose_of_listing"],
  );

  Map<String, dynamic> toJson() => {
    "desgname": desgnameValues.reverse[desgname],
    "business_date": businessDate,
    "hearing_date": hearingDate,
    "purpose_of_listing": purposeValues.reverse[purposeOfListing],
  };
}

enum Purpose {
  APPEARANCE_OF_PARTIES_ADVOCATES,
  ARGUMENTS_ON_APPLICATIONS_ARGUMENTS_IN_MISC_PROCEEDINGS
}

final purposeValues = EnumValues({
  "Appearance of parties/ advocates": Purpose.APPEARANCE_OF_PARTIES_ADVOCATES,
  "Arguments on Applications / Arguments in Misc. Proceedings": Purpose.ARGUMENTS_ON_APPLICATIONS_ARGUMENTS_IN_MISC_PROCEEDINGS
});

class Interimorder {
  SrNo1? srNo1;

  Interimorder({
    this.srNo1,
  });

  factory Interimorder.fromJson(Map<String, dynamic> json) => Interimorder(
    srNo1: json["sr_no1"] == null ? null : SrNo1.fromJson(json["sr_no1"]),
  );

  Map<String, dynamic> toJson() => {
    "sr_no1": srNo1?.toJson(),
  };
}

class SrNo1 {
  int? orderNo;
  String? orderDate;
  String? orderDetails;

  SrNo1({
    this.orderNo,
    this.orderDate,
    this.orderDetails,
  });

  factory SrNo1.fromJson(Map<String, dynamic> json) => SrNo1(
    orderNo: json["order_no"],
    orderDate: json["order_date"],
    orderDetails: json["order_details"],
  );

  Map<String, dynamic> toJson() => {
    "order_no": orderNo,
    "order_date":orderDate,
    "order_details": orderDetails,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
