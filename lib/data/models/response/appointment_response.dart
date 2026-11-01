/// Mirrors `PatientReservationResource` from
/// `GET /patient/reservations/{upcoming|past|cancelled}` + the detail
/// endpoint `GET /patient/reservations/{id}`.
///
/// Field set (scope §11):
///   id, booking_number, status, display_status, status_label,
///   place{type, name, image, branch, phone, address, lat, lng},
///   date_label, time_label, service, payment_type, payment_method,
///   can_cancel, can_reschedule, change_deadline,
///   specialization {id, name}, can_rate, cancellation.
///
/// `can_rate` is server-truth: true only when `status == completed` AND the
/// patient has not rated the doctor; the server flips it across all rows
/// after a rating lands, so mobile needs no local "already rated" flag.
///
/// The legacy flat fields (`name`, `phone`, `date`, `day`, `month`,
/// `mainSpecialization`, `image`, `rate`) are kept temporarily so pages that
/// have not been migrated to the new shape still compile.
/// TODO(booking-ui): drop legacy fields once appointments_page.dart,
/// booking_details_page.dart and cancel_booking_sheet.dart move to the new
/// field set in Round 3.
class AppointmentResponse {
  int? id;
  String? bookingNumber;

  /// Raw backend status: `pending | confirmed | completed | cancelled | no_show`.
  String? status;

  /// `display_status` equals `status` today; kept as its own field in case
  /// backend ever derives it (scope §9.6 removed the historical `expired`).
  String? displayStatus;

  /// Localized status label — follows `Content-Language`.
  String? statusLabel;

  ReservationPlace? place;
  String? dateLabel;
  String? timeLabel;
  String? service;
  String? paymentType; // "cash"
  String? paymentMethod; // "الدفع في العيادة"
  bool? canCancel;
  bool? canReschedule;
  String? changeDeadline;
  ReservationSpecialization? specialization;
  bool? canRate;
  ReservationCancellation? cancellation;

  // --- Legacy fields (populated for backward UI compat; prefer new fields) ---
  @Deprecated('Use place.name instead')
  String? name;
  @Deprecated('Use place.phone instead')
  String? phone;
  @Deprecated('Use dateLabel + timeLabel instead')
  String? date;
  @Deprecated('Use dateLabel instead')
  String? day;
  @Deprecated('Use timeLabel instead')
  String? month;
  @Deprecated('Use specialization.name or service instead')
  String? mainSpecialization;
  @Deprecated('Use place.image instead')
  String? image;
  @Deprecated('No longer surfaced on reservation resource')
  String? rate;

  AppointmentResponse({
    this.id,
    this.bookingNumber,
    this.status,
    this.displayStatus,
    this.statusLabel,
    this.place,
    this.dateLabel,
    this.timeLabel,
    this.service,
    this.paymentType,
    this.paymentMethod,
    this.canCancel,
    this.canReschedule,
    this.changeDeadline,
    this.specialization,
    this.canRate,
    this.cancellation,
    this.name,
    this.phone,
    this.date,
    this.day,
    this.month,
    this.mainSpecialization,
    this.image,
    this.rate,
  });

  AppointmentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    bookingNumber = json['booking_number'] as String?;
    status = json['status'] as String?;
    displayStatus = json['display_status'] as String?;
    statusLabel = json['status_label'] as String?;
    if (json['place'] is Map<String, dynamic>) {
      place = ReservationPlace.fromJson(json['place'] as Map<String, dynamic>);
    }
    dateLabel = json['date_label'] as String?;
    timeLabel = json['time_label'] as String?;
    service = json['service'] as String?;
    paymentType = json['payment_type'] as String?;
    paymentMethod = json['payment_method'] as String?;
    canCancel = json['can_cancel'] as bool?;
    canReschedule = json['can_reschedule'] as bool?;
    changeDeadline = json['change_deadline'] as String?;
    if (json['specialization'] is Map<String, dynamic>) {
      specialization = ReservationSpecialization.fromJson(
          json['specialization'] as Map<String, dynamic>);
    }
    canRate = json['can_rate'] as bool?;
    if (json['cancellation'] is Map<String, dynamic>) {
      cancellation = ReservationCancellation.fromJson(
          json['cancellation'] as Map<String, dynamic>);
    }
    // Legacy fields — still parsed from older payloads.
    name = json['name'] as String?;
    phone = json['phone'] as String?;
    date = json['date'] as String?;
    day = json['day'] as String?;
    month = json['month'] as String?;
    mainSpecialization = json['main_specialization'] as String?;
    image = json['full_image_path'] as String?;
    rate = json['rate'] as String?;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (id != null) 'id': id,
        if (bookingNumber != null) 'booking_number': bookingNumber,
        if (status != null) 'status': status,
        if (displayStatus != null) 'display_status': displayStatus,
        if (statusLabel != null) 'status_label': statusLabel,
        if (place != null) 'place': place!.toJson(),
        if (dateLabel != null) 'date_label': dateLabel,
        if (timeLabel != null) 'time_label': timeLabel,
        if (service != null) 'service': service,
        if (paymentType != null) 'payment_type': paymentType,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (canCancel != null) 'can_cancel': canCancel,
        if (canReschedule != null) 'can_reschedule': canReschedule,
        if (changeDeadline != null) 'change_deadline': changeDeadline,
        if (specialization != null) 'specialization': specialization!.toJson(),
        if (canRate != null) 'can_rate': canRate,
        if (cancellation != null) 'cancellation': cancellation!.toJson(),
      };
}

/// Place block embedded inside a reservation resource.
class ReservationPlace {
  String? type; // "medical_center" | "clinic"
  int? id;
  String? name;
  String? image;
  String? branch;
  String? phone;
  String? address;
  double? lat;
  double? lng;

  ReservationPlace({
    this.type,
    this.id,
    this.name,
    this.image,
    this.branch,
    this.phone,
    this.address,
    this.lat,
    this.lng,
  });

  ReservationPlace.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    id = json['id'] as int?;
    name = json['name'] as String?;
    image = json['image'] as String?;
    branch = json['branch'] as String?;
    phone = json['phone'] as String?;
    address = json['address'] as String?;
    lat = _toDouble(json['lat']);
    lng = _toDouble(json['lng']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (type != null) 'type': type,
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (image != null) 'image': image,
        if (branch != null) 'branch': branch,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      };
}

/// `specialization` row on a reservation — the service's parent specialty.
class ReservationSpecialization {
  int? id;
  String? name;

  ReservationSpecialization({this.id, this.name});

  ReservationSpecialization.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (id != null) 'id': id,
        if (name != null) 'name': name,
      };
}

/// Populated only on cancelled reservations.
///
/// `reason` is the stable `CancellationReason.key`; `label` is the localized
/// label from the same lookup. `note` is the patient's free-text input, if any.
class ReservationCancellation {
  String? reason;
  String? label;
  String? note;

  ReservationCancellation({this.reason, this.label, this.note});

  ReservationCancellation.fromJson(Map<String, dynamic> json)
      : reason = json['reason'] as String?,
        label = json['label'] as String?,
        note = json['note'] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (reason != null) 'reason': reason,
        if (label != null) 'label': label,
        if (note != null) 'note': note,
      };
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
