import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/networks/clients/general_client.dart';
import 'package:dorakpattient/data/repository/base_repo.dart';
import 'package:flutter/material.dart';
import '../models/response/response.dart';
import '../networks/clients/clients.dart';
import 'package:geolocator/geolocator.dart';

class GeneralRepository extends BaseRepository {
  final GeneralClient generalClient;

  GeneralRepository({required this.generalClient});

  Future<BaseModel<GeneralResponse>> getGeneralData() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await generalClient.getGeneralData().then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<List<Titles>>> getAreas() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await generalClient.getAreas().then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  /*Future<BaseModel<SpecializationResponse>> getSupSpecialization(
      {required int specialId}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await generalClient
                .getSubSpecialization(specialId)
                .then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }



  Future<BaseModel<List<MedicalCenterResponse>>> getMedicalCenters() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await generalClient.getMedicalCenters().then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<TermsPolicyResponse>> getTermsAndService() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await generalClient.getTermsAndService().then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<TermsPolicyResponse>> getPrivacyAndPolicy() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await generalClient.getPrivacyAndPolicy().then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }*/
}
