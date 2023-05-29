class GeneralResponse {
  List<Titles>? titles;
  List<Titles>? mainSpecializations;

  GeneralResponse({this.titles, this.mainSpecializations});

  GeneralResponse.fromJson(Map<String, dynamic> json) {
    if (json['titles'] != null) {
      titles = <Titles>[];
      json['titles'].forEach((v) {
        titles!.add(new Titles.fromJson(v));
      });
    }
    if (json['main_specializations'] != null) {
      mainSpecializations = <Titles>[];
      json['main_specializations'].forEach((v) {
        mainSpecializations!.add(new Titles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.titles != null) {
      data['titles'] = this.titles!.map((v) => v.toJson()).toList();
    }
    if (this.mainSpecializations != null) {
      data['main_specializations'] =
          this.mainSpecializations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Titles {
  int? id;
  String? name;

  Titles({this.id, this.name});

  Titles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
