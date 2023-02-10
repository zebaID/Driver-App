class UpdateRequestModel {
  late int id;
  late String firstName;
  late String lastName;
  late String address;
  late String email;
  late String addressLine2;
  late int updatedBy;
  late String updatedDate;
  late double addressLat;
  late double addressLong;

  UpdateRequestModel(
      this.address,
      this.addressLat,
      this.addressLine2,
      this.addressLong,
      this.email,
      this.firstName,
      this.id,
      this.lastName,
      this.updatedBy,
      this.updatedDate);

  UpdateRequestModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        addressLine2 = json['addressLine2'],
        updatedBy = json['updatedBy'],
        updatedDate = json['updatedDate'],
        addressLat = json['addressLat'],
        addressLong = json['addressLong'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'addressLine2': addressLine2,
        'updatedBy': updatedBy,
        'updatedDate': updatedDate,
        'addressLat': addressLat,
        'addressLong': addressLong,
      };
}
