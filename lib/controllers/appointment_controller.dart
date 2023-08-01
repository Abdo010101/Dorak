import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';
import '../utis/util.dart';

class AppointmentsController extends ChangeNotifier {
  String appointmentDate = AppStrings.kUpcoming;
  bool pressed = false;
  List<AppointmentResponse> appointmentsList = [];
  final _appointmentsRepository = locator<AppointmentsRepository>();
  PagingController<int, AppointmentResponse>? pagingController;

  changeAppointmentDate(value) {
    appointmentDate = value;
    notifyListeners();
    pagingController?.refresh();
    //startPagingControllerListener();
  }

  void startPagingControllerListener({required BuildContext context}) {
    pagingController = PagingController<int, AppointmentResponse>(
      // 2
      firstPageKey: 1,
    );
    pagingController?.addPageRequestListener((pageKey) {
      getAllAppointments(pageKey: pageKey, context: context);
    });
  }

  Future<void> getAllAppointments(
      {required int pageKey, required BuildContext context}) async {
    try {
      final result = await _appointmentsRepository.getAllAppointments(
          'reservations/${appointmentDate.toLowerCase()}',
          pageKey: pageKey);

      if (result.data != null) {
        final isLastPage = result.data!.length < NetworkConstant.kPageSize;
        if (isLastPage) {
          pagingController?.appendLastPage(result.data!);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController?.appendPage(result.data!, nextPageKey);
        }
        /*  appointmentsList.addAll(result.data!);
        isLoading = false;
        notifyListeners();*/
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            context
                .read<MainScreenController>()
                .onBottomSheetChanged(0, context);
            Util.unLoginedDialog(context);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     NameRoutes.kLoginScreen, (route) => false);
            // Util.showSnackBar(context, message: result.error?.message);
          }
        }
        if (result.error != null) {
          if (context.mounted && result.error!.statusCode! >= 500) {
            Util.showSnackBar(context, message: AppStrings.kUnknownError.tr(),
                onTap: () async {
              await getAllAppointments(context: context, pageKey: pageKey);
            });
          }
        }
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (e) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);

      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> declineAppointment(int index) async {
    try {
      EasyLoading.show();
      notifyListeners();
      var data = {
        'id': appointmentsList[index].id,
      };
      final result = await _appointmentsRepository.declineAppointment(data);
      if (result.data != null) {
        appointmentsList[index].status = AppStatus.cancelled.name;
      } else {
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (e) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }
}
