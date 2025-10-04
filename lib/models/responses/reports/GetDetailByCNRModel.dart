// To parse this JSON data, do
//
//     final getECourtComplex = getECourtComplexFromJson(jsonString);

import 'dart:convert';

GetDetailByCnrModel getECourtComplexFromJson(String str) => GetDetailByCnrModel.fromJson(json.decode(str));

String getECourtComplexToJson(GetDetailByCnrModel data) => json.encode(data.toJson());

class GetDetailByCnrModel {
  bool? status;
  String? message;
  Data? data;

  GetDetailByCnrModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetDetailByCnrModel.fromJson(Map<String, dynamic> json) => GetDetailByCnrModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? dateOfFiling;
  String? cino;
  String? dtRegis;
  String? typeNameFil;
  String? typeNameReg;
  int? caseTypeId;
  String? filNo;
  String? filYear;
  String? regNo;
  String? regYear;
  String? dateFirstList;
  String? dateNextList;
  String? pendDisp;
  dynamic dateOfDecision;
  dynamic disposalType;
  int? benchType;
  String? causelistType;
  String? benchName;
  String? judicialBranch;
  String? coram;
  dynamic shortOrder;
  String? desgname;
  int? benchId;
  String? courtEstName;
  String? estCode;
  String? stateName;
  dynamic distName;
  String? purposeName;
  String? petName;
  String? petAdv;
  String? petLegalHeir;
  String? resName;
  String? resAdv;
  String? resLegalHeir;
  String? mainMatterCino;
  String? mainMatter;
  dynamic firNo;
  dynamic policeStation;
  dynamic uniformCode;
  dynamic policeStCode;
  dynamic firYear;
  String? lowerCourtName;
  String? lowerCourtCaseno;
  String? lowerCourtDecDt;
  String? trialLowerCourtName;
  String? trialLowerCourtCaseno;
  String? trialLowerCourtDecDt;
  String? dateLastList;
  String? dateFilingDisp;
  String? reasonForRej;
  Acts? acts;
  List<dynamic>? petExtraParty;
  ResExtraParty? resExtraParty;
  Historyofcasehearing? historyofcasehearing;
  Interimorder? interimorder;
  dynamic finalorder;
  CategoryDetails? categoryDetails;

  Data({
    this.dateOfFiling,
    this.cino,
    this.dtRegis,
    this.typeNameFil,
    this.typeNameReg,
    this.caseTypeId,
    this.filNo,
    this.filYear,
    this.regNo,
    this.regYear,
    this.dateFirstList,
    this.dateNextList,
    this.pendDisp,
    this.dateOfDecision,
    this.disposalType,
    this.benchType,
    this.causelistType,
    this.benchName,
    this.judicialBranch,
    this.coram,
    this.shortOrder,
    this.desgname,
    this.benchId,
    this.courtEstName,
    this.estCode,
    this.stateName,
    this.distName,
    this.purposeName,
    this.petName,
    this.petAdv,
    this.petLegalHeir,
    this.resName,
    this.resAdv,
    this.resLegalHeir,
    this.mainMatterCino,
    this.mainMatter,
    this.firNo,
    this.policeStation,
    this.uniformCode,
    this.policeStCode,
    this.firYear,
    this.lowerCourtName,
    this.lowerCourtCaseno,
    this.lowerCourtDecDt,
    this.trialLowerCourtName,
    this.trialLowerCourtCaseno,
    this.trialLowerCourtDecDt,
    this.dateLastList,
    this.dateFilingDisp,
    this.reasonForRej,
    this.acts,
    this.petExtraParty,
    this.resExtraParty,
    this.historyofcasehearing,
    this.interimorder,
    this.finalorder,
    this.categoryDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dateOfFiling: json["date_of_filing"],
    cino: json["cino"],
    dtRegis: json["dt_regis"],
    typeNameFil: json["type_name_fil"],
    typeNameReg: json["type_name_reg"],
    caseTypeId: json["case_type_id"],
    filNo: json["fil_no"],
    filYear: json["fil_year"],
    regNo: json["reg_no"],
    regYear: json["reg_year"],
    dateFirstList: json["date_first_list"],
    dateNextList: json["date_next_list"],
    pendDisp: json["pend_disp"],
    dateOfDecision: json["date_of_decision"],
    disposalType: json["disposal_type"],
    benchType: json["bench_type"],
    causelistType: json["causelist_type"],
    benchName: json["bench_name"],
    judicialBranch: json["judicial_branch"],
    coram: json["coram"],
    shortOrder: json["short_order"],
    desgname: json["desgname"],
    benchId: json["bench_id"],
    courtEstName: json["court_est_name"],
    estCode: json["est_code"],
    stateName: json["state_name"],
    distName: json["dist_name"],
    purposeName: json["purpose_name"],
    petName: json["pet_name"],
    petAdv: json["pet_adv"],
    petLegalHeir: json["pet_legal_heir"],
    resName: json["res_name"],
    resAdv: json["res_adv"],
    resLegalHeir: json["res_legal_heir"],
    mainMatterCino: json["main_matter_cino"],
    mainMatter: json["main_matter"],
    firNo: json["fir_no"],
    policeStation: json["police_station"],
    uniformCode: json["uniform_code"],
    policeStCode: json["police_st_code"],
    firYear: json["fir_year"],
    lowerCourtName: json["lower_court_name"],
    lowerCourtCaseno: json["lower_court_caseno"],
    lowerCourtDecDt: json["lower_court_dec_dt"],
    trialLowerCourtName: json["trial_lower_court_name"],
    trialLowerCourtCaseno: json["trial_lower_court_caseno"],
    trialLowerCourtDecDt: json["trial_lower_court_dec_dt"],
    dateLastList: json["date_last_list"],
    dateFilingDisp: json["date_filing_disp"],
    reasonForRej: json["reason_for_rej"],
    acts: json["acts"] == null ? null : Acts.fromJson(json["acts"]),
    resExtraParty: json["res_extra_party"] == null ? null : ResExtraParty.fromJson(json["res_extra_party"]),
    historyofcasehearing: json["historyofcasehearing"] == null ? null : Historyofcasehearing.fromJson(json["historyofcasehearing"]),
    finalorder: json["finalorder"],
  );

  Map<String, dynamic> toJson() => {
    "date_of_filing":dateOfFiling,
    "cino": cino,
    "dt_regis":dtRegis,
    "type_name_fil": typeNameFil,
    "type_name_reg": typeNameReg,
    "case_type_id": caseTypeId,
    "fil_no": filNo,
    "fil_year": filYear,
    "reg_no": regNo,
    "reg_year": regYear,
    "date_first_list":dateFirstList,
    "date_next_list":dateNextList,
    "pend_disp": pendDisp,
    "date_of_decision": dateOfDecision,
    "disposal_type": disposalType,
    "bench_type": benchType,
    "causelist_type": causelistType,
    "bench_name": benchName,
    "judicial_branch": judicialBranch,
    "coram": coram,
    "short_order": shortOrder,
    "desgname": desgname,
    "bench_id": benchId,
    "court_est_name": courtEstName,
    "est_code": estCode,
    "state_name": stateName,
    "dist_name": distName,
    "purpose_name": purposeName,
    "pet_name": petName,
    "pet_adv": petAdv,
    "pet_legal_heir": petLegalHeir,
    "res_name": resName,
    "res_adv": resAdv,
    "res_legal_heir": resLegalHeir,
    "main_matter_cino": mainMatterCino,
    "main_matter": mainMatter,
    "fir_no": firNo,
    "police_station": policeStation,
    "uniform_code": uniformCode,
    "police_st_code": policeStCode,
    "fir_year": firYear,
    "lower_court_name": lowerCourtName,
    "lower_court_caseno": lowerCourtCaseno,
    "lower_court_dec_dt": lowerCourtDecDt,
    "trial_lower_court_name": trialLowerCourtName,
    "trial_lower_court_caseno": trialLowerCourtCaseno,
    "trial_lower_court_dec_dt": trialLowerCourtDecDt,
    "date_last_list": dateLastList,
    "date_filing_disp": dateFilingDisp,
    "reason_for_rej": reasonForRej,
    "acts": acts?.toJson(),
    "res_extra_party": resExtraParty?.toJson(),
    "historyofcasehearing": historyofcasehearing?.toJson(),
    "finalorder": finalorder,
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

class CategoryDetails {
  String? category;

  CategoryDetails({
    this.category,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) => CategoryDetails(
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
  };
}

class Historyofcasehearing {
  HistoryofcasehearingSrNo1? srNo1;

  Historyofcasehearing({
    this.srNo1,
  });

  factory Historyofcasehearing.fromJson(Map<String, dynamic> json) => Historyofcasehearing(
    srNo1: json["sr_no1"] == null ? null : HistoryofcasehearingSrNo1.fromJson(json["sr_no1"]),
  );

  Map<String, dynamic> toJson() => {
    "sr_no1": srNo1?.toJson(),
  };
}

class HistoryofcasehearingSrNo1 {
  String? judgeName;
  String? businessDate;
  String? hearingDate;
  String? purposeOfListing;

  HistoryofcasehearingSrNo1({
    this.judgeName,
    this.businessDate,
    this.hearingDate,
    this.purposeOfListing,
  });

  factory HistoryofcasehearingSrNo1.fromJson(Map<String, dynamic> json) => HistoryofcasehearingSrNo1(
    judgeName: json["judge_name"],
    businessDate: json["business_date"],
    hearingDate: json["hearing_date"],
    purposeOfListing: json["purpose_of_listing"],
  );

  Map<String, dynamic> toJson() => {
    "judge_name": judgeName,
    "business_date": businessDate,
    "hearing_date": hearingDate,
    "purpose_of_listing": purposeOfListing,
  };
}

class Interimorder {
  InterimorderSrNo1? srNo1;

  Interimorder({
    this.srNo1,
  });

  factory Interimorder.fromJson(Map<String, dynamic> json) => Interimorder(
    srNo1: json["sr_no1"] == null ? null : InterimorderSrNo1.fromJson(json["sr_no1"]),
  );

  Map<String, dynamic> toJson() => {
    "sr_no1": srNo1?.toJson(),
  };
}

class InterimorderSrNo1 {
  String? orderNo;
  String? orderDate;
  String? orderDetails;

  InterimorderSrNo1({
    this.orderNo,
    this.orderDate,
    this.orderDetails,
  });

  factory InterimorderSrNo1.fromJson(Map<String, dynamic> json) => InterimorderSrNo1(
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

class ResExtraParty {
  String? partyNo1;
  String? partyNo2;

  ResExtraParty({
    this.partyNo1,
    this.partyNo2,
  });

  factory ResExtraParty.fromJson(Map<String, dynamic> json) => ResExtraParty(
    partyNo1: json["party_no1"],
    partyNo2: json["party_no2"],
  );

  Map<String, dynamic> toJson() => {
    "party_no1": partyNo1,
    "party_no2": partyNo2,
  };
}
