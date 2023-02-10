class DriverAccountModel {
  int? id;
  String? driverId;
  double? balance;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;

  DriverAccountModel(
      {this.id,
      this.driverId,
      this.balance,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  DriverAccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    balance = json['balance'].runtimeType == int
        ? double.parse(json['balance'].toString())
        : json['balance'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driverId'] = this.driverId;
    data['balance'] = this.balance;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
