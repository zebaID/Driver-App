class CityModel {
  int? id;
  String? cityName;
  String? contactNumber;
  String? address;
  String? stateId;

  CityModel(
      {this.id, this.cityName, this.contactNumber, this.address, this.stateId});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityName = json['cityName'];
    contactNumber = json['contactNumber'];
    address = json['Address'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cityName'] = this.cityName;
    data['contactNumber'] = this.contactNumber;
    data['Address'] = this.address;
    data['stateId'] = this.stateId;
    return data;
  }

  static List<CityModel> fromJsonList(List list) {
    return list.map((item) => CityModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '${this.cityName}';
  }

  @override
  String toString() => cityName!;
}
