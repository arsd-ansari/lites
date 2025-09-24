import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/AppConstants.dart';
part 'authClient.g.dart';

// var token;
@RestApi(baseUrl: AppConstants.authUrl)
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST('Auth/MobileAppAuth')
  Future<String> login(@Body() Map<String, dynamic> body);

}



class ApiServiceAuthclient {
  static Future<AuthClient> createService() async {
    final dio = Dio();
    final headers = await AppConstants.getAuthHeaders();

    dio.options = BaseOptions(
      receiveTimeout: AppConstants.receiveTimeout2,
      sendTimeout: AppConstants.sendTimeout2,
      headers: headers,
      validateStatus: (code) {
        if (code == 200) {
          return true;
        }
        return false;
      },
    );
    dio.httpClientAdapter = IOHttpClientAdapter(
      onHttpClientCreate: (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    dio
      ..interceptors.add(
        LogInterceptor(
          requestBody: kDebugMode ? true : false,
          responseBody: kDebugMode ? true : false,
          requestHeader: kDebugMode ? true : false,
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onError: (DioException e, handler) {
            if (e.response?.statusCode == 402) {
              //logout user and go to login page
            }
            return handler.next(e);
          },
        ),
      );

    return AuthClient(dio);
  }
}
