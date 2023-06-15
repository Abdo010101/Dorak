import 'package:dio/dio.dart';

import '../../utis/util.dart';
import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'base_repo.dart';

class DoctorsSearchResultRepository extends BaseRepository {
  final DoctorsSearchResultClient searchResultClient;

  DoctorsSearchResultRepository({required this.searchResultClient});

  Future<BaseModel<SearchResultResponse>> getDoctors(
      Map<String, dynamic> prams) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data:
                await searchResultClient.getDoctorsResults(prams).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      Util.kToastNOInternet();
      return BaseModel.noNetworkConnection();
    }
  }
}
