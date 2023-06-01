import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'notification_client.g.dart';

@RestApi()
abstract class NotificationClient {
  factory NotificationClient(Dio dio, {String baseUrl}) = _NotificationClient;

  @GET(NetworkConstant.kNotifications)
  Future<BaseResponseList<NotificationModel>> getNotifications();

  @POST(NetworkConstant.kUpdateNotificationsStatus)
  Future<BaseResponse<dynamic>> updateNotificationsStatus(@Body() var body);
}
