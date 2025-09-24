import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lites/models/responses/GetCaseAppellantListModel.dart';
import 'package:lites/models/responses/GetCaseDataByCaseIdModel.dart';
import 'package:lites/models/responses/GetDashboardDetailModel.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/AppConstants.dart';
import '../../models/responses/GetCaseAdvocateListModel.dart';
import '../../models/responses/GetCaseDecisionListModel.dart';
import '../../models/responses/GetCaseHearingListModel.dart';
import '../../models/responses/GetCaseOICListModel.dart';
import '../../models/responses/GetCaseRespondantListModel.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../utils/routes.dart';
import '../../utils/storageService.dart';
import '../masterApi/apiClient.dart';
part 'caseApiClient.g.dart';

// var token;
@RestApi(baseUrl: AppConstants.caseUrl)
abstract class CaseApiClient {
  factory CaseApiClient(Dio dio, {String? baseUrl}) = _CaseApiClient;

  @POST('CaseRegistrations/GetCaseList')
  Future<String> getCaseList(@Body() Map<String, dynamic> body);



  //change model for all
  @POST('CaseRegistrations/GetCaseDataByCaseId')   // update model
  Future<GetCaseDataByCaseIdModel> getCaseDataByCaseId(
      @Query("CaseId") int CaseId);


  @GET('CaseRegistrations/GetAppellantsList')
  Future<GetCaseAppellantListModel> getAppellantsList(
      @Query("CaseId") int CaseId);

  @GET('CaseRegistrations/GetRespondentsList')
  Future<GetCaseRespondantListModel> getRespondentsList(
      @Query("CaseId") int CaseId);

  @GET('CaseLawyers/GetCaseLawyersList')
  Future<GetCaseAdvocateListModel> getCaseLawyersList(
      @Query("CaseId") int CaseId);

  @GET('CaseOICs/GetCaseOICsList')
  Future<GetCaseOICListModel> getCaseOICList(
      @Query("CaseId") int CaseId);

  @GET('CaseHearings/GetCaseHearingsList')
  Future<GetCaseHearingListModel> getCaseHearingsList(
      @Query("CaseId") int CaseId);

  @GET('CaseDecision/GetCaseDecisionList')
  Future<GetCaseDecisionListModel> getCaseDecisionList(
      @Query("CaseId") int CaseId);

// without case no
  @POST('CaseRegistrations/GetCaseListWithoutCaseNo')
  Future<String> getCaseWithoutCaseNoList(@Body() Map<String, dynamic> body);

  // first hearing
  @POST('CasesDecidedOnIstHearing/GetCaseList')
  Future<String> getCaseDecidedFirstHearingList(@Body() Map<String, dynamic> body);

}

class CaseApiServiceApiclient {
  static Future<CaseApiClient> createService(BuildContext context) async {
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
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    dio
      ..interceptors.addAll([
        LogInterceptor(requestBody: kDebugMode, responseBody: kDebugMode, requestHeader: kDebugMode),
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            bool isValid = await ApiServiceApiclient.isTokenValid();
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
          },
        ),
      ]);

    return CaseApiClient(dio);
  }
}

