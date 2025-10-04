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
import '../../models/responses/CaseDetailResponse.dart';
import '../../models/responses/CaseTypeModel.dart';
import '../../models/responses/GetCaseAdvocateListModel.dart';
import '../../models/responses/GetCaseDecisionListModel.dart';
import '../../models/responses/GetCaseHearingListModel.dart';
import '../../models/responses/GetCaseOICListModel.dart';
import '../../models/responses/GetCaseRespondantListModel.dart';
import '../../models/responses/GetDepDropDownListModel.dart';
import '../../models/responses/GetECourtComplex.dart';
import '../../models/responses/GetECourtDistrictModel.dart';
import '../../models/responses/GetECourtStateModel.dart';
import '../../models/responses/reports/GetDetailByCNRModel.dart';
import '../../models/responses/reports/GetDetailByECNRModel.dart';
import '../../utils/routes.dart';
import '../../utils/storageService.dart';
import '../masterApi/apiClient.dart';
part 'eCourtApiClient.g.dart';

@RestApi(baseUrl: AppConstants.EcUrl)
abstract class ECourtApiClient {
  factory ECourtApiClient(Dio dio, {String? baseUrl}) = _ECourtApiClient;

  @GET('EcourtService/GetDetailByCNR/SearchByCnr')
  Future<GetDetailByECnrModel> getDetailByCNR(@Query("CinNo") String CinNo);

  @GET('EcourtService/GetECourtStateDetail/ECourtState')
  Future<GetECourtState> getECourtStateDetail();

  @GET('EcourtService/GetDistrictDetail/District')
  Future<GetECourtDistrict> getDistrictDetail(@Query("StateCode") String StateCode);

  @GET('EcourtService/GetCourtComplexDetail/CourtComplex')
  Future<GetECourtComplex> getCourtComplexDetail(@Query("StateCode") String StateCode, @Query("DistCode") String DistCode);

  @GET('EcourtService/GetDetailCaseType/CaseTypeMaster')
  Future<CaseTypeResponse> getDetailCaseType(@Query("EstCode") String EstCode);

  @POST('EcourtService/GetDetailByCaseNumber/SearchByCaseNumber')
  Future<CaseDetailResponse> getDetailByCaseNumber(@Query("EstCode") String EstCode, @Query("CaseType") String caseType, @Query("CaseNumber") String caseNo, @Query("RegYear") String regYear);

}


class ECourtApiServiceApiclient {
  static Future<ECourtApiClient> createService(BuildContext context) async {
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

    return ECourtApiClient(dio);
  }
}
