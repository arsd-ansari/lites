class LoginReqModel {
  String? username;
  String? password;
  String? ipAddress;

  LoginReqModel({this.username, this.password, this.ipAddress});

  LoginReqModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    ipAddress = json['ipAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['ipAddress'] = ipAddress;
    return data;
  }
}


class LoginResModel {
  bool? status;
  String? message;
  List<AuthenticationResponse>? authenticationResponse;

  LoginResModel({this.status, this.message, this.authenticationResponse});

  LoginResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['authenticationResponse'] != null) {
      authenticationResponse = <AuthenticationResponse>[];
      json['authenticationResponse'].forEach((v) {
        authenticationResponse!.add(new AuthenticationResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.authenticationResponse != null) {
      data['authenticationResponse'] =
          this.authenticationResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuthenticationResponse {
  String? userName;
  int? roleId;
  String? authToken;
  int? expiresIn;
  LoginUserData? loginUserData;

  AuthenticationResponse(
      {this.userName,
        this.roleId,
        this.authToken,
        this.expiresIn,
        this.loginUserData});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    roleId = json['roleId'];
    authToken = json['authToken'];
    expiresIn = json['expiresIn'];
    loginUserData = json['loginUserData'] != null
        ? new LoginUserData.fromJson(json['loginUserData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['roleId'] = this.roleId;
    data['authToken'] = this.authToken;
    data['expiresIn'] = this.expiresIn;
    if (this.loginUserData != null) {
      data['loginUserData'] = this.loginUserData!.toJson();
    }
    return data;
  }
}

class LoginUserData {
  String? token;
  int? userId;
  String? userName;
  String? name;
  int? roleId;
  String? roleName;
  int? departmentId;
  String? departmentName;
  int? unitId;
  String? unitName;
  int? officeId;
  String? officeName;
  int? districtId;
  String? districtName;
  int? lawyerId;
  String? lawyerName;
  String? ssoid;

  LoginUserData(
      {this.token,
        this.userId,
        this.userName,
        this.name,
        this.roleId,
        this.roleName,
        this.departmentId,
        this.departmentName,
        this.unitId,
        this.unitName,
        this.officeId,
        this.officeName,
        this.districtId,
        this.districtName,
        this.lawyerId,
        this.lawyerName,
        this.ssoid});

  LoginUserData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['userId'];
    userName = json['userName'];
    name = json['name'];
    roleId = json['roleId'];
    roleName = json['roleName'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    officeId = json['officeId'];
    officeName = json['officeName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    lawyerId = json['lawyerId'];
    lawyerName = json['lawyerName'];
    ssoid = json['ssoid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['roleId'] = this.roleId;
    data['roleName'] = this.roleName;
    data['departmentId'] = this.departmentId;
    data['departmentName'] = this.departmentName;
    data['unitId'] = this.unitId;
    data['unitName'] = this.unitName;
    data['officeId'] = this.officeId;
    data['officeName'] = this.officeName;
    data['districtId'] = this.districtId;
    data['districtName'] = this.districtName;
    data['lawyerId'] = this.lawyerId;
    data['lawyerName'] = this.lawyerName;
    data['ssoid'] = this.ssoid;
    return data;
  }
}

