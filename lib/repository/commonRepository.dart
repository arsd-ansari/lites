import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/responses/GetDepDropDownListModel.dart';
import 'masterApi/apiClient.dart';

class CommonRepository {
  Future<List<Data>> getOfficeList(BuildContext context, int unitDeptId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getOfficeList(unitDeptId);

    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to fetch office list');
    }
  }


  Future<List<Data>> getCourtTypeList(BuildContext context, int CourtTypeId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getCourtTypeList(CourtTypeId);

    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to fetch court type list');
    }
  }


  Future<List<Data>> getCourtPlaceList(BuildContext context,int CourtTypeId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getCourtPlaceList(CourtTypeId);

    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to fetch court place list');
    }
  }


  Future<List<Data>> getAbbrevationList(BuildContext context) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getAbbreviationList();

    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to fetch Abbrevation list');
    }
  }

  Future<List<Data>> getYearList(BuildContext context) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getYearList();

    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to fetch year list');
    }
  }


  Future<List<Data>> getGroupTypeList(BuildContext context,int AdmDeptId, int UnitId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getGroupTypeList(AdmDeptId, UnitId);

    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to fetch group type list');
    }
  }

  Future<List<Data>> getAdminDepartments(BuildContext context) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getAdmDep();
    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      print('getAdmDepList result: ${response.data}');

      throw Exception(response.message ?? 'Failed to load admin departments');
    }
  }

  Future<List<Data>> getUnits(BuildContext context,int adminDeptId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getUnitList(adminDeptId);
    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to load hod/units');
    }
  }

  Future<List<Data>> getDistricts(BuildContext context,int DivisionId, int StateId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getDistrictList(DivisionId, StateId);
    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to load hod/units');
    }
  }

  Future<List<Data>> getOICs(BuildContext context,int AdmDeptId, int UnitId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getOICList(AdmDeptId, UnitId);
    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to load OICs');
    }
  }

  Future<List<Data>> getAdvocates(BuildContext context,int LDesignation, int LawyerId) async {
    final apiClient = await ApiServiceApiclient.createService(context);
    final response = await apiClient.getAdvocateList(LDesignation, LawyerId);
    if (response.status == true && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to load Advocate');
    }
  }

}
