import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/models/response/response.dart';
import '../data/networks/network_constant.dart';
import '../data/repository/repository.dart';
import '../main.dart';
import '../utis/util.dart';

class NotificationController extends ChangeNotifier {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    var iosInitialize = const DarwinInitializationSettings();

    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "...........................................onMessage..........................");
      print(
          "onForeGround : ${message.notification?.title}/${message.notification?.body}/${message.notification?.toMap().toString()}");
      print(message.data);
      print(
          "...........................................onMessage..........................");
      flutterLocalNotificationsPlugin.show(
        1,
        message.notification?.title ?? 'Title',
        message.notification?.body ?? 'Body',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'main_channel',
            'Main Channel',
            channelDescription: 'Main Channel notification',
            importance: Importance.max,
            priority: Priority.max,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    });
  }

  bool isLoading = false;
  final _notificationsRepository = locator<NotificationsRepository>();
  PagingController<int, NotificationModel>? pagingController;

  startPagingControllerListener({required BuildContext context}) {
    pagingController = PagingController<int, NotificationModel>(
      // 2
      firstPageKey: 1,
    );

    pagingController?.addPageRequestListener((pageKey) {
      getNotifications(pageKey: pageKey, context: context);
    });
  }

  Future<void> getNotifications(
      {required int pageKey, required BuildContext context}) async {
    try {
      final result =
          await _notificationsRepository.getNotifications(pageKey: pageKey);
      if (result.data != null) {
        final isLastPage = result.data!.length < NetworkConstant.kPageSize;
        if (isLastPage) {
          pagingController?.appendLastPage(result.data!);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController?.appendPage(result.data!, nextPageKey);
        }
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            Navigator.pop(context);
            Util.unLoginedDialog(context);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     NameRoutes.kLoginScreen, (route) => false);
            // Util.showSnackBar(context, message: result.error?.message);
          }
        }
      }
      {
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (e) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);

      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  bool notificationsStatus = false;

  changeNotificationStatus(value, BuildContext context) {
    notificationsStatus = value;
    notifyListeners();
    updateNotificationsStatus(
      value,
      context,
    );
  }

  PermissionStatus status = PermissionStatus.denied;

  Future<bool> updateNotificationsStatus(
    bool value,
    BuildContext context,
  ) async {
    status == PermissionStatus.permanentlyDenied
        ? null
        : status = await Permission.notification.status;
    if (status.isGranted || !value) {
      print('status isGranted');
    } else if (status.isDenied) {
      print('status isDenied');
      bool? request = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
      if (request == true) {
        status = PermissionStatus.granted;
      } else {
        status = PermissionStatus.permanentlyDenied;
      }
    } else if (status.isPermanentlyDenied) {
      print('status isPermanentlyDenied');
      status = await Permission.notification.status;
      status != PermissionStatus.granted
          ? status = PermissionStatus.permanentlyDenied
          : null;
      status != PermissionStatus.granted
          ? Dialogue.showNotificationDialog(
              context: context,
              confirmTab: () async {
                await openAppSettings();
                Navigator.pop(context);
              },
              cancelTab: () => Navigator.pop(context),
            )
          : null;
    }
    if (status.isGranted || !value) {
      try {
        print('status isGranted222222');
        var data = dio.FormData.fromMap({
          'allow_notifications': value ? 1 : 0,
        });

        /// Change value of IsActive until response confirmed or return value as it was
        final result =
            await _notificationsRepository.updateNotificationsStatus(data);
        if (result.data != null) {
          return true;
        } else {
          /// return value of IsActive as it was
          notificationsStatus = !value;
          notifyListeners();
          //GetSnackBar(message: (result.error?.message));
          return false;
        }
      } on DioError catch (e) {
        return false;
        // return Error(errorMessage: DioExceptions.fromDioError(e).message);
        //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
      } finally {
        // isLoading.value = false;
      }
    } else {
      notificationsStatus = !value;
      notifyListeners();
      return false;
    }
  }
}
