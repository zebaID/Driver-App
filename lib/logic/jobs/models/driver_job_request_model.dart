class DriverJobRequestModel {
  int? id;
  String? driverJobId;
  String? driverId;
  String? remark;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? createdByName;
  String? status;

  DriverJobRequestModel(
      {this.id,
      this.driverJobId,
      this.driverId,
      this.remark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.createdByName,
      this.status});

  DriverJobRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverJobId = json['driverJobId'];
    driverId = json['driverId'];
    remark = json['remark'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    createdByName = json['createdByName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driverJobId'] = this.driverJobId;
    data['driverId'] = this.driverId;
    data['remark'] = this.remark;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['createdByName'] = this.createdByName;
    data['status'] = this.status;
    return data;
  }
}
