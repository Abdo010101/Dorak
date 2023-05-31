import 'package:dio/dio.dart';

import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

class ProfileRepository extends BaseRepository {
  final ProfileClient profileClient;

  ProfileRepository({required this.profileClient});

  Future<BaseModel<Patient>> updateProfile(var body) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await profileClient.updateProfile(body).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }
}
