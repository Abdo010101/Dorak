import 'package:flutter/cupertino.dart';

import '../data/models/response/response.dart';

class ManualAppointmentController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  Week? selectedDay;
  String? selectedDayId;
  String? selectedTime;

  List<Places> placesList = [];
  List<Schedules> availableSchedulesList = [];
  List<TimeSlots> timeSlotsList = [];

/*  Future<void> getAvailableSchedules({int? id}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result =
          await _availableAppointmentRepository.getAvailableSchedules(id: id);
      if (result.data != null) {}
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
  }*/

/*  Future<void> makeReservations(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    try {
      isLoading = true;
      notifyListeners();

      Map<String, dynamic> reservationsData = {
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
    selectedDay = null;
    selectedDayId = null;
    selectedTime = null;
    placesList = [];
    availableSchedulesList = [];
    timeSlotsList = [];
  }
}
