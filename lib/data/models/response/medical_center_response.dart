class MedicalsCenter {
  int? id;
  String? logo;
  String? name;
  String? description;

  MedicalsCenter({this.id, this.logo, this.name, this.description});

  MedicalsCenter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo'] = logo;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
