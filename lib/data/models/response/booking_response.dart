import 'appointment_response.dart';

/// Scope §11 `BookingDay`. One of the 28 cells on step 2 (day strip).
///
/// `status` is `available | full | closed`.
/// `date` is `Y-m-d` for subsequent slot calls.
class BookingDay {
  String? date;
  String? dayLabel;
  String? dateLabel;
  String? status;

  BookingDay({this.date, this.dayLabel, this.dateLabel, this.status});

  BookingDay.fromJson(Map<String, dynamic> json)
      : date = json['date'] as String?,
        dayLabel = json['day_label'] as String?,
        dateLabel = json['date_label'] as String?,
        status = json['status'] as String?;

  bool get isAvailable => status == 'available';
  bool get isFull => status == 'full';
  bool get isClosed => status == 'closed';
}

/// Scope §11 `BookingSlot`. Rows under `morning[]` / `evening[]` on
/// `GET /patient/booking/slots`.
class BookingSlot {
  String? time; // "h:i A"
  String? label;
  bool? available;
  int? doctorId;

  BookingSlot({this.time, this.label, this.available, this.doctorId});

  BookingSlot.fromJson(Map<String, dynamic> json)
      : time = json['time'] as String?,
        label = json['label'] as String?,
        available = json['available'] as bool?,
        doctorId = json['doctor_id'] as int?;
}

/// Full response of `GET /patient/booking/slots`.
class BookingSlotsResponse {
  List<BookingSlot> morning;
  List<BookingSlot> evening;

  BookingSlotsResponse({this.morning = const [], this.evening = const []});

  BookingSlotsResponse.fromJson(Map<String, dynamic> json)
      : morning = _parse(json['morning']),
        evening = _parse(json['evening']);

  static List<BookingSlot> _parse(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(BookingSlot.fromJson)
          .toList();
    }
    return const <BookingSlot>[];
  }
}

/// `POST /patient/booking/preview` returns the exact same shape as
/// `PatientReservationResource` so we reuse [AppointmentResponse].
typedef BookingPreview = AppointmentResponse;
