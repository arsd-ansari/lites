import 'dart:convert';

CaseTypeResponse caseTypeResponseFromJson(String str) =>
    CaseTypeResponse.fromJson(json.decode(str));

String caseTypeResponseToJson(CaseTypeResponse data) =>
    json.encode(data.toJson());

class CaseTypeResponse {
  bool? status;
  String? message;
  List<CaseType>? caseTypes;
  String? error;

  CaseTypeResponse({
    this.status,
    this.message,
    this.caseTypes,
    this.error,
  });

  factory CaseTypeResponse.fromJson(Map<String, dynamic> json) {
    List<CaseType> parsedList = [];
    String? errorMessage;

    if (json["data"] != null && json["data"] is Map<String, dynamic>) {
      final map = json["data"] as Map<String, dynamic>;

      // Check if it's an error payload
      if (map.containsKey("Error")) {
        errorMessage = map["Error"].toString();
      } else {
        // Otherwise treat it as list of case types
        map.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            parsedList.add(CaseType.fromJson(value));
          }
        });
      }
    }

    return CaseTypeResponse(
      status: json["status"],
      message: json["message"],
      caseTypes: parsedList.isNotEmpty ? parsedList : null,
      error: errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": error != null
        ? {"Error": error}
        : {
      for (var i = 0; i < (caseTypes?.length ?? 0); i++)
        "casetype${i + 1}": caseTypes![i].toJson()
    },
  };
}

class CaseTypeData {
  String? error;

  CaseTypeData({
    this.error,
  });

  factory CaseTypeData.fromJson(Map<String, dynamic> json) => CaseTypeData(
    error: json["Error"],
  );

  Map<String, dynamic> toJson() => {
    "Error": error,
  };
}

class CaseType {
  String? caseType;
  String? typeName;

  CaseType({
    this.caseType,
    this.typeName,
  });

  factory CaseType.fromJson(Map<String, dynamic> json) => CaseType(
    caseType: json["case_type"],
    typeName: json["type_name"],
  );

  Map<String, dynamic> toJson() => {
    "case_type": caseType,
    "type_name": typeName,
  };
}