import 'package:dio/dio.dart';

import '../models/response/favourite_response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

/// Scope-tag used by `GET /patient/favorites?type=`.
enum FavouriteType { doctor, offer, medicalCenter }

extension FavouriteTypeApi on FavouriteType {
  String get apiValue => switch (this) {
        FavouriteType.doctor => 'doctor',
        FavouriteType.offer => 'offer',
        FavouriteType.medicalCenter => 'medical_center',
      };
}

class FavouritesRepository extends BaseRepository {
  FavouritesRepository({required this.client});

  final FavouritesClient client;

  Future<BaseModel<List<FavouriteItem>>> list(FavouriteType type) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.list(type.apiValue);
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<void>> add(FavouriteType type, int id) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      switch (type) {
        case FavouriteType.doctor:
          await client.addDoctor(id);
        case FavouriteType.medicalCenter:
          await client.addMedicalCenter(id);
        case FavouriteType.offer:
          await client.addOffer(id);
      }
      return BaseModel(data: null);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<void>> remove(FavouriteType type, int id) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      switch (type) {
        case FavouriteType.doctor:
          await client.removeDoctor(id);
        case FavouriteType.medicalCenter:
          await client.removeMedicalCenter(id);
        case FavouriteType.offer:
          await client.removeOffer(id);
      }
      return BaseModel(data: null);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }
}
