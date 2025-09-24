import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/material.dart';

import '../models/essentialdialog_model.dart';

class ServerErrorPage implements Exception {
  late int _errorCode;
  String _errorMessage = "";
  late BuildContext context;
  EssentialDialogModel appDialog = EssentialDialogModel();

  String routeName = '/ServerErrorPage';
  ServerErrorPage.withError({required DioError error, required this.context}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        _errorMessage = "Request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        _errorMessage = "Connection timeout";
        break;
      case DioExceptionType.connectionError:
        _errorMessage = "Connection failed due to internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        break;
      case DioExceptionType.badResponse:
        _errorMessage =
        "Received invalid status code: ${error.response?.statusCode}";
        break;
      case DioExceptionType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        break;
      case DioExceptionType.badCertificate:
      // TODO: Handle this case.
      case DioExceptionType.unknown:
      // TODO: Handle this case.
    }
    //Routes().serverErrorPage
    //Navigator.pushNamed(context, Routes().serverErrorPage);
    /*Navigator.of(context).pushNamed(RouteNames.serverError, arguments: {
      "_errorMessage": _errorMessage,
    });*/
  }
}
