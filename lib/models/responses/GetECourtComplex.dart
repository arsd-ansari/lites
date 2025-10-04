// To parse this JSON data, do
//
//     final getECourtComplex = getECourtComplexFromJson(jsonString);

import 'dart:convert';

GetECourtComplex getECourtComplexFromJson(String str) => GetECourtComplex.fromJson(json.decode(str));

String getECourtComplexToJson(GetECourtComplex data) => json.encode(data.toJson());

class GetECourtComplex {
  bool? status;
  String? message;
  Data? data;

  GetECourtComplex({
    this.status,
    this.message,
    this.data,
  });

  factory GetECourtComplex.fromJson(Map<String, dynamic> json) => GetECourtComplex(
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
  Complex1Class? complex1;
  Complex10Class? complex2;
  Complex1Class? complex3;
  Complex4? complex4;
  Complex1Class? complex5;
  Complex10Class? complex6;
  Complex1Class? complex7;
  Complex1Class? complex8;
  Complex9? complex9;
  Complex10Class? complex10;
  Complex10Class? complex11;

  Data({
    this.complex1,
    this.complex2,
    this.complex3,
    this.complex4,
    this.complex5,
    this.complex6,
    this.complex7,
    this.complex8,
    this.complex9,
    this.complex10,
    this.complex11,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    complex1: json["complex1"] == null ? null : Complex1Class.fromJson(json["complex1"]),
    complex2: json["complex2"] == null ? null : Complex10Class.fromJson(json["complex2"]),
    complex3: json["complex3"] == null ? null : Complex1Class.fromJson(json["complex3"]),
    complex4: json["complex4"] == null ? null : Complex4.fromJson(json["complex4"]),
    complex5: json["complex5"] == null ? null : Complex1Class.fromJson(json["complex5"]),
    complex6: json["complex6"] == null ? null : Complex10Class.fromJson(json["complex6"]),
    complex7: json["complex7"] == null ? null : Complex1Class.fromJson(json["complex7"]),
    complex8: json["complex8"] == null ? null : Complex1Class.fromJson(json["complex8"]),
    complex9: json["complex9"] == null ? null : Complex9.fromJson(json["complex9"]),
    complex10: json["complex10"] == null ? null : Complex10Class.fromJson(json["complex10"]),
    complex11: json["complex11"] == null ? null : Complex10Class.fromJson(json["complex11"]),
  );

  Map<String, dynamic> toJson() => {
    "complex1": complex1?.toJson(),
    "complex2": complex2?.toJson(),
    "complex3": complex3?.toJson(),
    "complex4": complex4?.toJson(),
    "complex5": complex5?.toJson(),
    "complex6": complex6?.toJson(),
    "complex7": complex7?.toJson(),
    "complex8": complex8?.toJson(),
    "complex9": complex9?.toJson(),
    "complex10": complex10?.toJson(),
    "complex11": complex11?.toJson(),
  };
}

class Complex1Class {
  String? courtComplexName;
  Establishment? establishment1;
  Establishment? establishment2;
  Establishment? establishment3;
  Establishment? establishment4;

  Complex1Class({
    this.courtComplexName,
    this.establishment1,
    this.establishment2,
    this.establishment3,
    this.establishment4,
  });

  factory Complex1Class.fromJson(Map<String, dynamic> json) => Complex1Class(
    courtComplexName: json["court_complex_name"],
    establishment1: json["establishment1"] == null ? null : Establishment.fromJson(json["establishment1"]),
    establishment2: json["establishment2"] == null ? null : Establishment.fromJson(json["establishment2"]),
    establishment3: json["establishment3"] == null ? null : Establishment.fromJson(json["establishment3"]),
    establishment4: json["establishment4"] == null ? null : Establishment.fromJson(json["establishment4"]),
  );

  Map<String, dynamic> toJson() => {
    "court_complex_name": courtComplexName,
    "establishment1": establishment1?.toJson(),
    "establishment2": establishment2?.toJson(),
    "establishment3": establishment3?.toJson(),
    "establishment4": establishment4?.toJson(),
  };
}

class Establishment {
  String? estCode;
  String? courtEstName;

  Establishment({
    this.estCode,
    this.courtEstName,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) => Establishment(
    estCode: json["est_code"],
    courtEstName: json["court_est_name"],
  );

  Map<String, dynamic> toJson() => {
    "est_code": estCode,
    "court_est_name": courtEstName,
  };
}

class Complex10Class {
  String? courtComplexName;
  Establishment? establishment1;
  Establishment? establishment2;

  Complex10Class({
    this.courtComplexName,
    this.establishment1,
    this.establishment2,
  });

  factory Complex10Class.fromJson(Map<String, dynamic> json) => Complex10Class(
    courtComplexName: json["court_complex_name"],
    establishment1: json["establishment1"] == null ? null : Establishment.fromJson(json["establishment1"]),
    establishment2: json["establishment2"] == null ? null : Establishment.fromJson(json["establishment2"]),
  );

  Map<String, dynamic> toJson() => {
    "court_complex_name": courtComplexName,
    "establishment1": establishment1?.toJson(),
    "establishment2": establishment2?.toJson(),
  };
}

class Complex4 {
  String? courtComplexName;
  Establishment? establishment1;

  Complex4({
    this.courtComplexName,
    this.establishment1,
  });

  factory Complex4.fromJson(Map<String, dynamic> json) => Complex4(
    courtComplexName: json["court_complex_name"],
    establishment1: json["establishment1"] == null ? null : Establishment.fromJson(json["establishment1"]),
  );

  Map<String, dynamic> toJson() => {
    "court_complex_name": courtComplexName,
    "establishment1": establishment1?.toJson(),
  };
}

class Complex9 {
  String? courtComplexName;
  Establishment? establishment1;
  Establishment? establishment2;
  Establishment? establishment3;
  Establishment? establishment4;
  Establishment? establishment5;
  Establishment? establishment6;
  Establishment? establishment7;
  Establishment? establishment8;

  Complex9({
    this.courtComplexName,
    this.establishment1,
    this.establishment2,
    this.establishment3,
    this.establishment4,
    this.establishment5,
    this.establishment6,
    this.establishment7,
    this.establishment8,
  });

  factory Complex9.fromJson(Map<String, dynamic> json) => Complex9(
    courtComplexName: json["court_complex_name"],
    establishment1: json["establishment1"] == null ? null : Establishment.fromJson(json["establishment1"]),
    establishment2: json["establishment2"] == null ? null : Establishment.fromJson(json["establishment2"]),
    establishment3: json["establishment3"] == null ? null : Establishment.fromJson(json["establishment3"]),
    establishment4: json["establishment4"] == null ? null : Establishment.fromJson(json["establishment4"]),
    establishment5: json["establishment5"] == null ? null : Establishment.fromJson(json["establishment5"]),
    establishment6: json["establishment6"] == null ? null : Establishment.fromJson(json["establishment6"]),
    establishment7: json["establishment7"] == null ? null : Establishment.fromJson(json["establishment7"]),
    establishment8: json["establishment8"] == null ? null : Establishment.fromJson(json["establishment8"]),
  );

  Map<String, dynamic> toJson() => {
    "court_complex_name": courtComplexName,
    "establishment1": establishment1?.toJson(),
    "establishment2": establishment2?.toJson(),
    "establishment3": establishment3?.toJson(),
    "establishment4": establishment4?.toJson(),
    "establishment5": establishment5?.toJson(),
    "establishment6": establishment6?.toJson(),
    "establishment7": establishment7?.toJson(),
    "establishment8": establishment8?.toJson(),
  };
}
