class LocalCoordinates {
  late int id;
  late String cityId;
  late String latitude;
  late String longitude;

  LocalCoordinates(this.id, this.cityId, this.latitude, this.longitude);

  LocalCoordinates.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cityId = json['city_id'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'cityId': cityId,
        'latitude': latitude,
        'longitude': longitude
      };
}
