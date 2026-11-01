import 'package:dio/dio.dart';

import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

class NotificationsRepository extends BaseRepository {
  final NotificationClient notificationsClient;

  NotificationsRepository({required this.notificationsClient});

  Future<BaseModel<List<NotificationModel>>> getNotifications(
      {int? pageKey}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await notificationsClient
                .getNotifications(pageKey)
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

  Future<BaseModel<dynamic>> updateNotificationsStatus(
    var body,
  ) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await notificationsClient
                .updateNotificationsStatus(body)
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

  Future<BaseModel<dynamic>> markAsRead(String id) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data:
                await notificationsClient.markAsRead(id).then((value) => value.data));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<dynamic>> markAllAsRead() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data:
                await notificationsClient.markAllAsRead().then((value) => value.data));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }
}
