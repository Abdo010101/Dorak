import 'package:dio/dio.dart';

import '../../models/response/favourite_response.dart';
import '../network_constant.dart';

/// Dio-direct client for the favourites endpoints.
///
/// Retrofit is not used here because the repo's generator pin is broken
/// (`retrofit 4.10.0` vs `retrofit_generator 10.0.6`, see the Round 1
/// notes); plain Dio calls keep this feature decoupled from `build_runner`.
///
/// Endpoints (scope §10.2):
/// - `GET /patient/favorites?type=` → `FavoriteResource[]`
/// - `POST /patient/add-doctor-to-favorite/{doctor_id}`
/// - `POST /patient/remove-doctor-from-favorite/{doctor_id}`
/// - `POST /patient/add-medical-center-to-favorite/{medical_center_id}`
/// - `POST /patient/remove-medical-center-from-favorite/{medical_center_id}`
/// - `POST /patient/add-offer-to-favorite/{offer_id}`
/// - `POST /patient/remove-offer-from-favorite/{offer_id}`
class FavouritesClient {
  FavouritesClient(this._dio);

  final Dio _dio;

  /// Scope requires `?type=doctor|offer|medical_center`.
  Future<List<FavouriteItem>> list(String type) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kFavorites,
      queryParameters: {'type': type},
    );
    final raw = res.data?['data'];
    final rows = <FavouriteItem>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map<String, dynamic>) rows.add(FavouriteItem.fromJson(e));
      }
    }
    return rows;
  }

  Future<void> addDoctor(int id) =>
      _dio.post('${NetworkConstant.kAddDoctorToFavorite}/$id');

  Future<void> removeDoctor(int id) =>
      _dio.post('${NetworkConstant.kRemoveDoctorFromFavorite}/$id');

  Future<void> addMedicalCenter(int id) =>
      _dio.post('${NetworkConstant.kAddMedicalCenterToFavorite}/$id');

  Future<void> removeMedicalCenter(int id) =>
      _dio.post('${NetworkConstant.kRemoveMedicalCenterFromFavorite}/$id');

  Future<void> addOffer(int id) =>
      _dio.post('${NetworkConstant.kAddOfferToFavorite}/$id');

  Future<void> removeOffer(int id) =>
      _dio.post('${NetworkConstant.kRemoveOfferFromFavorite}/$id');
}
