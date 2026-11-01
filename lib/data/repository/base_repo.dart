import 'package:connectivity_plus/connectivity_plus.dart';
import '../networks/base_model.dart';
import 'package:dio/dio.dart';

class BaseRepository {
  Future<bool> checkForConnectivity() async {
    final ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  /// Returns `true` when the Dio error is a 401. Caller decides what to
  /// do: `AuthInterceptor` triggers logout, feature cubits surface a toast.
  bool isUnauthorized(DioError dioError) =>
      dioError.response?.statusCode == 401;
}
