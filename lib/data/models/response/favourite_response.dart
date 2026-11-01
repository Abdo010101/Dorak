/// Mirrors `FavoriteResource` from `GET /patient/favorites?type=...`.
///
/// Backend returns a flat list of items, each tagged with [type]
/// (`doctor | offer | medical_center`). Shared fields are modeled directly;
/// the raw map stays available via [raw] for type-specific extras.
class FavouriteItem {
  String? type;
  int? id;
  String? name;
  String? image;
  String? rating;
  int? ratingsCount;
  double? distanceKm;
  String? city;
  String? area;
  String? address;
  Map<String, dynamic>? raw;

  FavouriteItem({
    this.type,
    this.id,
    this.name,
    this.image,
    this.rating,
    this.ratingsCount,
    this.distanceKm,
    this.city,
    this.area,
    this.address,
    this.raw,
  });

  FavouriteItem.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    id = json['id'] as int?;
    name = json['name'] as String?;
    image = json['image'] as String?;
    rating = json['rating']?.toString();
    ratingsCount = json['ratings_count'] as int?;
    final dk = json['distance_km'];
    if (dk is num) distanceKm = dk.toDouble();
    if (dk is String) distanceKm = double.tryParse(dk);
    city = json['city'] as String?;
    area = json['area'] as String?;
    address = json['address'] as String?;
    raw = Map<String, dynamic>.from(json);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (type != null) 'type': type,
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (image != null) 'image': image,
        if (rating != null) 'rating': rating,
        if (ratingsCount != null) 'ratings_count': ratingsCount,
        if (distanceKm != null) 'distance_km': distanceKm,
        if (city != null) 'city': city,
        if (area != null) 'area': area,
        if (address != null) 'address': address,
      };
}
