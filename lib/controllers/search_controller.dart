import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class SearchController extends ChangeNotifier {
  bool isLoading = false;
  List<AppointmentResponse> appointmentsList = [];
  final _appointmentsRepository = locator<AppointmentsRepository>();

  /* Future<void> getAllAppointments() async {
    try {
      isLoading = true;
      final result = await _appointmentsRepository
          .getAllAppointments('reservations/${appointmentDate.toLowerCase()}');
      if (result.data != null) {
        appointmentsList
          ..clear()
          ..addAll(result.data!);
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
  }*/
}
