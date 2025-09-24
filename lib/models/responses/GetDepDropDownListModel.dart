class GetDepDropDownListModel {
  bool? status;
  String? message;
  List<Data>? data;

  GetDepDropDownListModel({this.status, this.message, this.data});

  GetDepDropDownListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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


class Data {
  String? text;
  String? value;

  Data({this.text, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    text = json['text']?.toString() ?? '';
    value = json['value']?.toString() ?? '';
  }


  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }
}


/*class Data {
  String? text;
  String? value;

  Data({this.text, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}*/
