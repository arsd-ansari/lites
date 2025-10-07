import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lites/models/responses/GetDepDropDownListModel.dart';
import 'package:lites/models/responses/reports/GetAttentionWarrantReportModel.dart';
import 'package:lites/models/responses/reports/GetDeficiencyReportModel.dart';
import 'package:lites/models/responses/reports/GetEnytryStatusReportModel.dart';
import 'package:lites/models/responses/reports/GetEvaluationSummaryModel.dart';
import 'package:lites/models/responses/reports/GetSummaryReportModel.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/AppConstants.dart';
import '../../models/responses/reports/GetCauseDropDownListModel.dart';
import '../../utils/routes.dart';
import '../../utils/storageService.dart';
import '../masterApi/apiClient.dart';
part 'reportApiClient.g.dart';

// var token;
@RestApi(baseUrl: AppConstants.reportUrl)
abstract class ReportApiClient {
  factory ReportApiClient(Dio dio, {String? baseUrl}) = _ReportApiClient;

  @POST('Dashboard/GetDashboardData')
  Future<String> getDashboardDetails(@Body() Map<String, dynamic> body);

  @POST('AnalysisReport/GetImportantCasesReportsCourtTypeList')
  Future<String> getImpCaseReportDetails(@Body() Map<String, dynamic> body);

  @GET('MISReport/ActionTobeTakenDeptWiseGridNew')
  Future<GetAttentionWarrantReportModel> getAttentionWarrantReportDetails(
      @Query("RoleID") int RoleID,
      @Query("DepartmentId") int DepartmentId,
      @Query("UnitId") int UnitId,
      @Query("OfficeId") int OfficeId,
      @Query("districtId") int districtId,
      @Query("oicId") int oicId,
      @Query("pageSize") int pageSize,
      @Query("currentPage") int currentPage,
      @Query("level") int level,
      );

  @GET('MISReport/Dashboarddetails')
  Future<GetSummaryReportModel> getSummaryReportDetails(
      @Query("deptId") int deptId,
      @Query("unitId") int unitId,
      @Query("officeId") int officeId,
      @Query("fromDate") String fromDate,
      @Query("toDate") String toDate,
      );

  @POST('MISReport/TalkingPointsGirdNew')
  Future<String> getTalkingPointsReportDetails(@Body() Map<String, dynamic> body);

  @POST('Dashboard/GetDashboardPendencyReport')
  Future<String> getDashboardPendingReportDetails(@Body() Map<String, dynamic> body);

  @GET('MISReport/SummaryReportGrid')
  Future<GetEnytryStatusReportModel> getEntryStatusReportDetails(
      @Query("fromYear") int fromYear,
      @Query("toYear") int toYear,
      @Query("admnDeptId") int admnDeptId,
      @Query("unitId") int unitId,
      @Query("officeId") int officeId,
      @Query("status") int status,
      @Query("fromDate") String fromDate,
      @Query("toDate") String toDate,
      );

  @POST('MISReport/AAGPerformanceGrid')
  Future<String> getAAGReportDetails(@Body() Map<String, dynamic> body);

  @POST('MISReport/DecisionSummaryGrid')
  Future<String> getDecisionSummaryReportDetails(@Body() Map<String, dynamic> body);

 @GET('MISReport/EvaluationSummaryReportGrid')
  Future<GetEvaluationSummaryModel> getEvaluationSummaryReportDetails(
      @Query("major_miner") int major_miner,
      @Query("fromDate") String fromDate,
      @Query("toDate") String toDate,
      @Query("pageSize") int pageSize,
      @Query("currentPage") int currentPage,
      );

  @GET('SummaryReport/ValidationReportGridNew')
  Future<GetDeficiencyReportModel> getDeficiencyReportDetails(
      @Query("AdmDeptt") int AdmDeptt,
      @Query("UnitName") int UnitName,
      @Query("OfficeName") int OfficeName,
      @Query("Status") String Status,
      @Query("Level") String Level,
      @Query("MainPerforma") String MainPerforma,
      @Query("districtId") int districtId,
      @Query("roleid") int roleid,
      @Query("pageSize") int pageSize,
      @Query("currentPage") int currentPage,
      @Query("fromDate") String fromDate,
      @Query("toDate") String toDate,
      );

  // new reports development(3August)

  @POST('MISReport/ActionPendingReportGrid')  // to be clear url
  Future<String> getActionPendingReportDetails(@Body() Map<String, dynamic> body);

  @POST('DetailReports/GetCourtWiseReport')
  Future<String> getCourtWiseReportDetails(@Body() Map<String, dynamic> body);

  @POST('DetailReports/GetPrioritysWiseReport')
  Future<String> getPriorityWiseReportDetails(@Body() Map<String, dynamic> body);

  @POST('AnalysisReport/GetOICPerformanceReport')
  Future<String> getOICPerformanceReportDetails(@Body() Map<String, dynamic> body);

  @POST('AnalysisReport/GetLawyerPerformanceReport')
  Future<String> getAdvocatePerformanceReportDetails(@Body() Map<String, dynamic> body);

  @POST('PendingCasesReport/GetOrderPendingForAppealReport')
  Future<String> getOrderPendingReportDetails(@Body() Map<String, dynamic> body);

  @POST('PendingCasesReport/GetReplyNotFiledReport')
  Future<String> getReplyNtFiledReportDetails(@Body() Map<String, dynamic> body);

  // cause list
  @GET('CauseList/GetCourtRoomDropdownList')
  Future<GetCauseDropDownListModel> getCourtRoomDetails(
      @Query("CauseListDateFrom") String CauseListDateFrom,
      @Query("CauseListDateTo") String CauseListDateTo,
      @Query("Estt") String Estt,
      );

  @GET('CauseList/GetJudgeNameDropdownList')
  Future<GetCauseDropDownListModel> getJudgeNameDetails(
      @Query("CauseListDateFrom") String CauseListDateFrom,
      @Query("CauseListDateTo") String CauseListDateTo,
      @Query("Estt") String Estt,
      );

  @GET('CauseList/GetDepartmentNameDropdownList')
  Future<GetCauseDropDownListModel> getCauseDeptDDDetails( );

  @POST('CauseList/GetCauseListReport')
  Future<String> getCauseListDetails(@Body() Map<String, dynamic> body);

  @POST('GenericSearch/GetGenericSearchList')
  Future<String> getAdvanceSearchDetails(@Body() Map<String, dynamic> body);

}

class ReportApiServiceApiclient {
  static Future<ReportApiClient> createService(BuildContext context) async {
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
            }
        )
      ]);

    return ReportApiClient(dio);
  }
}

