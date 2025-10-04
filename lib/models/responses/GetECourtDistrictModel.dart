// To parse this JSON data, do
//
//     final getECourtDistrict = getECourtDistrictFromJson(jsonString);

import 'dart:convert';

GetECourtDistrict getECourtDistrictFromJson(String str) => GetECourtDistrict.fromJson(json.decode(str));

String getECourtDistrictToJson(GetECourtDistrict data) => json.encode(data.toJson());

class GetECourtDistrict {
  bool? status;
  String? message;
  DistrictData? data;

  GetECourtDistrict({
    this.status,
    this.message,
    this.data,
  });

  factory GetECourtDistrict.fromJson(Map<String, dynamic> json) => GetECourtDistrict(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : DistrictData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DistrictData {
  Map<String, District>? district;

  DistrictData({
    this.district,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) => DistrictData(
    district: Map.from(json["district"]!).map((k, v) => MapEntry<String, District>(k, District.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "district": Map.from(district!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class District {
  int? distCode;
  String? distName;

  District({
    this.distCode,
    this.distName,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    distCode: json["dist_code"],
    distName: json["dist_name"],
  );

  Map<String, dynamic> toJson() => {
    "dist_code": distCode,
    "dist_name": distName,
  };
}
