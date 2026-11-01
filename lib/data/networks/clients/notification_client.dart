import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'notification_client.g.dart';

@RestApi()
abstract class NotificationClient {
  factory NotificationClient(Dio dio, {String baseUrl}) = _NotificationClient;

  @GET('${NetworkConstant.kNotifications}?page={pageKey}')
  Future<BaseResponseList<NotificationModel>> getNotifications(
      @Path('pageKey') int? pageKey);

  @POST(NetworkConstant.kUpdateNotificationsStatus)
  Future<BaseResponse<dynamic>> updateNotificationsStatus(@Body() var body);

  /// `POST /patient/notifications/{notification_id}/mark-as-read` (UUID path).
  @POST('${NetworkConstant.kNotifications}/{id}/${NetworkConstant.kMarkAsRead}')
  Future<BaseResponse<dynamic>> markAsRead(@Path('id') String id);

  /// `POST /patient/notifications/mark-all-as-read`.
  @POST(NetworkConstant.kMarkAllAsRead)
  Future<BaseResponse<dynamic>> markAllAsRead();
}
