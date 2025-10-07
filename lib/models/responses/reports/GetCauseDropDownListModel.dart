class GetCauseDropDownListModel {
  bool? status;
  String? message;
  List<CauseDDData>? data;

  GetCauseDropDownListModel({this.status, this.message, this.data});

  GetCauseDropDownListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CauseDDData>[];
      json['data'].forEach((v) {
        data!.add(new CauseDDData.fromJson(v));
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
    return data;
  }
}

class CauseDDData {
  String? text;
  String? value;

  CauseDDData({this.text, this.value});

  CauseDDData.fromJson(Map<String, dynamic> json) {
    text = json['Text'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Text'] = this.text;
    data['Value'] = this.value;
    return data;
  }
}
