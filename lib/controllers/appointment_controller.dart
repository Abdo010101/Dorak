import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constants/constants.dart';
import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

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

  void startPagingControllerListener() {
    pagingController = PagingController<int, AppointmentResponse>(
      // 2
      firstPageKey: 1,
    );
    pagingController?.addPageRequestListener((pageKey) {
      getAllAppointments(pageKey: pageKey);
    });
  }

  Future<void> getAllAppointments({required int pageKey}) async {
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
