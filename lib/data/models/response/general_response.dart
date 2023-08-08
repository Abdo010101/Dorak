class GeneralResponse {
  List<Titles>? titles;
  List<Titles>? mainSpecializations;
  List<Titles>? cities;
  GeneralResponse({this.titles, this.cities, this.mainSpecializations});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (titles != null) {
      data['titles'] = titles!.map((v) => v.toJson()).toList();
    }
    if (mainSpecializations != null) {
      data['main_specializations'] =
          mainSpecializations!.map((v) => v.toJson()).toList();
    }
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}
