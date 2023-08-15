import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class ReservationAppointmentController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  int? placeId;
  Week? selectedDay;
  String? selectedDayId;
  String? selectedTime;
  final _availableAppointmentRepository =
      locator<AvailableAppointmentRepository>();
  List<Places> placesList = [];
  List<Schedules> availableSchedulesList = [];
  List<TimeSlots> timeSlotsList = [];

  Future<void> getAvailableSchedules({int? id, required int doctorId}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _availableAppointmentRepository
          .getAvailableSchedules(id: id, doctorId: doctorId);
      if (result.data != null) {
        if (result.data!.schedules!.isNotEmpty) {
          availableSchedulesList
            ..clear()
            ..addAll(result.data!.schedules!);
          /*  if (placeId == null) {
            selectedDayId = availableSchedulesList[0].week?[0].date;
          }*/
        }
      }
      {
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (_) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);

      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      isLoading = false;
      notifyListeners();
      // isLoading.value = false;
    }
  }

  Future<void> makeReservations(
    BuildContext context, {
    required int? doctorId,
  }) async {
    if (formKey.currentState?.validate() == false) return;
    try {
      EasyLoading.show();
      notifyListeners();
      Map<String, dynamic> reservationsData = {
        "medical_center_id": placeId == 0 ? '' : placeId,
        "doctor_id": doctorId,
        "date": selectedDay?.date,
        "time": selectedTime,
        "day_of_week": selectedDay?.name,
      };
      final result = await _availableAppointmentRepository.makeReservations(
          data: reservationsData);
      if (result.data != null && context.mounted) {
        Util.kToastAddAppointment(UpdatedResult.success);
        context
            .read<AppointmentsController>()
            .startPagingControllerListener(context: context);
        context.read<HomeController>().getHomeData(context);
        resetController();
        Navigator.pop(context);
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            Util.unLoginedBottomSheet(context);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     NameRoutes.kLoginScreen, (route) => false);
            // Util.showSnackBar(context, message: result.error?.message);
          }
        }
      }
    } on DioError catch (e) {
      Util.showSnackBar(context, message: e.message);
      Util.kToastAddAppointment(UpdatedResult.fail);
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

/*  void onPlaceChanged(var id) {
    if (id != placeId) {
      selectedTime = null;
      selectedDay = null;
      selectedDayId = null;
      placeId = id;
      if (id == 0) {
        getAvailableSchedules();
      } else {
        getAvailableSchedules(id: placeId);
      }
      notifyListeners();
    }
  }*/

  void onDaySelectedChange(Week dayOfWeek) {
    selectedTime = null;
    selectedDay = dayOfWeek;
    selectedDayId = dayOfWeek.date;
    timeSlotsList
      ..clear()
      ..addAll(selectedDay!.timeSlots!);
    notifyListeners();
  }

  void onTimeSelectedChange(String? value) {
    selectedTime = value;

    notifyListeners();
  }

  void resetController() {
    placeId = null;
    selectedDay = null;
    selectedDayId = null;
    selectedTime = null;
    placesList = [];
    availableSchedulesList = [];
    timeSlotsList = [];
  }
}
