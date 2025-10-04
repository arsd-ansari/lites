// To parse this JSON data, do
//
//     final getECourtState = getECourtStateFromJson(jsonString);

import 'dart:convert';

GetECourtState getECourtStateFromJson(String str) => GetECourtState.fromJson(json.decode(str));

String getECourtStateToJson(GetECourtState data) => json.encode(data.toJson());

class GetECourtState {
  bool? status;
  String? message;
  Data? data;

  GetECourtState({
    this.status,
    this.message,
    this.data,
  });

  factory GetECourtState.fromJson(Map<String, dynamic> json) => GetECourtState(
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
  Map<String, StateData>? state;

  Data({
    this.state,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    state: Map.from(json["state"]!).map((k, v) => MapEntry<String, StateData>(k, StateData.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "state": Map.from(state!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class StateData {
  int? stateCode;
  String? stateName;

  StateData({
    this.stateCode,
    this.stateName,
  });

  factory StateData.fromJson(Map<String, dynamic> json) => StateData(
    stateCode: json["state_code"],
    stateName: json["state_name"],
  );

  Map<String, dynamic> toJson() => {
    "state_code": stateCode,
    "state_name": stateName,
  };
}
