import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lites/models/responses/GetDepDropDownListModel.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../utils/AppConstants.dart';
import '../../../utils/routes.dart';
import '../../../utils/storageService.dart';
import '../../models/responses/reports/GetCauseDropDownListModel.dart';

part 'masterApiClient.g.dart';

@RestApi(baseUrl: AppConstants.masterUrl)
abstract class MasterApiClient {
  factory MasterApiClient(Dio dio, {String? baseUrl}) = _MasterApiClient;

  // cause lawyer

  @GET('Lawyers/GetDepDropdown')
  Future<GetCauseDropDownListModel> getCauseLawyerList( );

  @GET('OICs/GetDropdown')
  Future<GetCauseDropDownListModel> getCauseOicList(
      @Query("UnitId") int UnitId
      );
}



class MasterApiServiceApiclient {
  static Future<MasterApiClient> createService(BuildContext? context) async {
    final dio = Dio();
    final headers = await AppConstants.getHeaders();

    dio.options = BaseOptions(
      receiveTimeout: AppConstants.receiveTimeout2,
      sendTimeout: AppConstants.sendTimeout2,
      headers: headers,
      validateStatus: (code) => code == 200,
    );
    dio.httpClientAdapter = IOHttpClientAdapter(
      onHttpClientCreate: (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        requestHeader: kDebugMode,
      ),

      InterceptorsWrapper(
          onRequest: (options, handler) async {
            bool isValid = await isTokenValid();
            if (!isValid) {
              await SecureStorageService.deleteAll();
              AppConstants.user = null;

              if (context != null) {
                if (ModalRoute.of(context)?.settings.name != Routes().loginPage) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(Routes().loginPage, (route) => false);
                }
              }
              return;
            }

            handler.next(options);
          },
          onError: (DioException e, handler) {
            if (e.response?.statusCode == 401 || e.response?.statusCode == 402) {
              if (context != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes().loginPage,
                      (route) => false,
                );
              }
            }

            handler.next(e);
          }

      ),
    ]);

    return MasterApiClient(dio);
  }

  static Future<bool> isTokenValid() async {
    final timestampString = await SecureStorageService.read(
      key: 'tokenTimestamp',
    );
    final expiresInString = await SecureStorageService.read(
      key: 'tokenExpiresIn',
    );
    if (timestampString == null || expiresInString == null) return false;

    final receivedTime = DateTime.parse(timestampString);
    final expiresIn = int.parse(expiresInString);
    // final expiresIn = 60;
    final secondsElapsed = DateTime.now().difference(receivedTime).inSeconds;

    return secondsElapsed < expiresIn;
  }
}
