import 'package:lites/models/responses/common/LoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppConstants {

  static var authToken = "";
  static Future<void> saveToken(String token) async {
    authToken = token;
    authToken = token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }


  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


  static Future<Map<String, String>>
  getHeaders() async {
    final tokens = await getToken() ?? "";

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokens}',
    };


return headers;
  }


  static Future<Map<String, String>> getAuthHeaders() async {
    final tokens = await getToken() ?? "";

    var headers = {
      'Content-Type': 'application/json',
     // 'Authorization': 'Bearer ${tokens}',
    };


    return headers;
  }

  // latest Development Url
  static const baseUrl = "https://testlites.rajasthan.gov.in/masterservices/api/";
  static const reportUrl = "https://testlites.rajasthan.gov.in/reportservice/api/";
  static const caseUrl = "https://testlites.rajasthan.gov.in/caseservices/api/";
  static const authUrl = "https://testlites.rajasthan.gov.in/AuthService/api/";
  static const masterUrl = "https://testlites.rajasthan.gov.in/LitesGateway/Master/";

  // SIT PUBLIC Development Url
  /*static const baseUrl = "http://103.203.138.228/masterservices/api/";
  static const reportUrl = "http://103.203.138.228/reportservice/api/";
  static const caseUrl = "http://103.203.138.228/caseservices/api/";
  static const authUrl = "http://103.203.138.228/AuthService/api/";*/

  // static const baseUrl = "http://10.70.236.252/masterservices/api/";
  // static const reportUrl = "http://10.70.236.252/reportservice/api/";
  // static const caseUrl = "http://10.70.236.252/caseservices/api/";
 // static const authUrl = "http://10.70.236.252/AuthService/api/";
  // it will be used in all
  static LoginResModel? user = LoginResModel();

  static var receiveTimeout = const Duration(milliseconds: 60000);
  static var sendTimeout = const Duration(milliseconds: 60000);

  static var receiveTimeout2 = const Duration(milliseconds: 250000);
  static var sendTimeout2 = const Duration(milliseconds: 250000);
}
