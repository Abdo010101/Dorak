class GeneralResponse {
  List<Titles>? titles;
  List<Titles>? mainSpecializations;
  List<Titles>? cities;
  List<CancellationReason>? cancellationReasons;
  String? whatsappNumber;

  GeneralResponse({
    this.titles,
    this.cities,
    this.mainSpecializations,
    this.cancellationReasons,
    this.whatsappNumber,
  });

  GeneralResponse.fromJson(Map<String, dynamic> json) {
    if (json['titles'] != null) {
      titles = <Titles>[];
      json['titles'].forEach((v) {
        titles!.add(Titles.fromJson(v));
      });
    }
    if (json['cities'] != null) {
      cities = <Titles>[];
      json['cities'].forEach((v) {
        cities!.add(Titles.fromJson(v));
      });
    }
    if (json['main_specializations'] != null) {
      mainSpecializations = <Titles>[];
      json['main_specializations'].forEach((v) {
        mainSpecializations!.add(Titles.fromJson(v));
      });
    }
    if (json['cancellation_reasons'] != null) {
      cancellationReasons = <CancellationReason>[];
      json['cancellation_reasons'].forEach((v) {
        cancellationReasons!.add(CancellationReason.fromJson(v));
      });
    }
    whatsappNumber = json['whatsapp_number'] as String?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (titles != null) {
      data['titles'] = titles!.map((v) => v.toJson()).toList();
    }
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    if (mainSpecializations != null) {
      data['main_specializations'] =
          mainSpecializations!.map((v) => v.toJson()).toList();
    }
    if (cancellationReasons != null) {
      data['cancellation_reasons'] =
          cancellationReasons!.map((v) => v.toJson()).toList();
    }
    if (whatsappNumber != null) data['whatsapp_number'] = whatsappNumber;
    return data;
  }
}

class Titles {
  int? id;
  String? name;
  String? icon;

  Titles({this.id, this.name, this.icon});

  Titles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

/// Entry from `general.cancellation_reasons`.
///
/// Backend returns `{key, label}`. The key is the stable identifier used
/// when posting to `/patient/reservations/cancel-reservation`; the label
/// is the localized display string (follows `Content-Language`).
class CancellationReason {
  const CancellationReason({this.key, this.label});

  CancellationReason.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        label = json['label'] as String?;

  final String? key;
  final String? label;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'key': key,
        'label': label,
      };
}
