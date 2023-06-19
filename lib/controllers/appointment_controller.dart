import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/constants.dart';
import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class AppointmentsController extends ChangeNotifier {
  String appointmentDate = AppStrings.kUpcoming;
  bool isLoading = false;
  bool pressed = false;
  List<AppointmentResponse> appointmentsList = [];
  final _appointmentsRepository = locator<AppointmentsRepository>();

  changeAppointmentDate(value) {
    appointmentDate = value;
    getAllAppointments();
    notifyListeners();
  }

  Future<void> getAllAppointments() async {
    try {
      isLoading = true;
      appointmentsList.clear();

      notifyListeners();
      final result = await _appointmentsRepository
          .getAllAppointments('reservations/${appointmentDate.toLowerCase()}');
      if (result.data != null) {
        appointmentsList.addAll(result.data!);
        isLoading = false;

        notifyListeners();
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
