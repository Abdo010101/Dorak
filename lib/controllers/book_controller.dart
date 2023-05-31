/*
import 'package:dio/dio.dart';
import 'package:dorak/data/models/response/doctor_available_schedules.dart';
import 'package:dorak/data/models/response/make_reservation_response.dart';
import 'package:dorak/data/networks/base_model.dart';
import 'package:dorak/utis/util.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:flutter/cupertino.dart';

import '../constants/enums.dart';
import '../data/di/locator.dart';
import '../data/repository/repository.dart';

class ManualAppointmentController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  int? placeId;
  Week? selectedDay;
  String? selectedDayId;
  String? selectedTime;
  final _availableAppointmentRepository =
      locator<AvailableAppointmentRepository>();
  List<Places> placesList = [];
  List<AvailableSchedules> availableSchedulesList = [];
  List<TimeSlots> timeSlotsList = [];

  Future<void> getAvailableSchedules({int? id}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result =
          await _availableAppointmentRepository.getAvailableSchedules(id: id);
      if (result.data != null) {
        if (result.data!.places!.isNotEmpty) {
          placesList
            ..clear()
            ..addAll(result.data!.places!);

          if (placesList.isNotEmpty && placesList.length == 1) {
            placeId = placesList[0].id;
          }
        }
        if (result.data!.schedules!.isNotEmpty) {
          availableSchedulesList
            ..clear()
            ..addAll(result.data!.schedules!);
          if (placeId == null) {
            selectedDayId = availableSchedulesList[0].week?[0].date;
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
      isLoading = false;
      notifyListeners();
      // isLoading.value = false;
    }
  }

  Future<void> makeReservations(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    try {
      isLoading = true;
      notifyListeners();

      Map<String, dynamic> reservationsData = {
        "name": nameController.text,
        "phone": phoneController.text,
        "medical_center_id": placeId == 0 ? '' : placeId,
        "date": selectedDay?.date,
        "time": selectedTime,
        "day_of_week": selectedDay?.name,
      };
      final result = await _availableAppointmentRepository.makeReservations(
          data: reservationsData);
      if (result.data != null) {
        Util.kToastAddAppointment(UpdatedResult.success);
        Navigator.pop(context);
      } else {
        Util.showSnackBar(context,
            message: (result as BaseModel<ReservationResponse>).error?.message);
      }
    } on DioError catch (e) {
      Util.showSnackBar(context, message: e.message);
      Util.kToastAddAppointment(UpdatedResult.fail);
      isLoading = false;
      notifyListeners();
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);

      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      isLoading = false;
      notifyListeners();
      // isLoading.value = false;
    }
  }

  void onPlaceChanged(var id) {
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
  }

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
    nameController = TextEditingController();
    phoneController = TextEditingController();
    placeId = null;
    selectedDay = null;
    selectedDayId = null;
    selectedTime = null;
    placesList = [];
    availableSchedulesList = [];
    timeSlotsList = [];
  }
}
*/
