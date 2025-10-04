import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lites/models/responses/GetDepDropDownListModel.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/AppConstants.dart';
import '../../utils/routes.dart';
import '../../utils/storageService.dart';

part 'apiClient.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET('AdminDepartment/AdmDepDropdownList')
  Future<GetDepDropDownListModel> getAdmDep();

  @GET('UnitsDepartment/GetDepartmentWiseUnitDropdownList')
  Future<GetDepDropDownListModel> getUnitList(@Query("AdmDptID") int AdmDptID);

  @GET('Offices/GetOfficesDropdownList')
  Future<GetDepDropDownListModel> getOfficeList(@Query("UnitId") int UnitId);

  @GET('CourtTypes/GetCourtTypesDropdownList')

  Future<GetDepDropDownListModel> getCourtTypeList(
    @Query("CourtTypeId") int CourtTypeId,
  );

  @GET('CourtPlaces/GetCourtPlacesDropdownList')
  Future<GetDepDropDownListModel> getCourtPlaceList(
    @Query("CourtTypeId") int CourtTypeId,
  );

  @GET('CaseAbbrevation/GetCaseAbbrevationDropdownList')
  Future<GetDepDropDownListModel> getAbbreviationList();

  @GET('FactualActionTypes/GetYearList')
  Future<GetDepDropDownListModel> getYearList();

  @GET('GroupingMasters/GetGroupingDropdownList')
  Future<GetDepDropDownListModel> getGroupTypeList(
    @Query("AdmDeptId") int AdmDeptId,
    @Query("UnitId") int UnitId,
  );

  @GET('State/GetDistrictsList')
  Future<GetDepDropDownListModel> getDistrictList(
    @Query("DivisionId") int DivisionId,
    @Query("StateId") int StateId,
  );

  @GET('OICs/GetOICDropdownList')
  Future<GetDepDropDownListModel> getOICList(
    @Query("AdmDeptId") int AdmDeptId,
    @Query("UnitId") int UnitId,
  );

  @GET('Lawyers/GetLawyersDepDropdownList')
  Future<GetDepDropDownListModel> getAdvocateList(
    @Query("LDesignation") int LDesignation,
    @Query("LawyerId") int LawyerId,
  );
}

class ApiServiceApiclient {
  static Future<ApiClient> createService(BuildContext? context) async {
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

    return ApiClient(dio);
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
