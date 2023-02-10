class PlaceModel {
  late String description;
  late String placeId;

  PlaceModel(this.description, this.placeId);

  PlaceModel.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        placeId = json['place_id'];

  Map<String, dynamic> toJson() =>
      {'description': description, 'placeId': placeId};
}
