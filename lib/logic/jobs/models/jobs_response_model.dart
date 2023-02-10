import 'package:id_driver/logic/jobs/models/driver_job_request_model.dart';

class JobsResponseModel {
  int? id;
  String? customerId;
  String? area;
  String? carType;
  int? dutyHours;
  String? status;
  String? dutyType;
  String? createdByName;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? clientId;
  List<String>? weeklyOff;
  String? dutyTime;
  String? outstationDays;
  String? driverAge;
  int? drivingExperience;
  String? vehicleName;
  String? clientSalary;
  String? driverSalary;
  String? role;
  String? other;
  String? location;
  List<DriverJobRequestModel>? driverJobRequest;

  JobsResponseModel(
      {this.id,
      this.customerId,
      this.area,
      this.carType,
      this.dutyHours,
      this.status,
      this.dutyType,
      this.createdByName,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.clientId,
      this.weeklyOff,
      this.dutyTime,
      this.outstationDays,
      this.driverAge,
      this.drivingExperience,
      this.vehicleName,
      this.clientSalary,
      this.driverSalary,
      this.role,
      this.other,
      this.location,
      this.driverJobRequest});

  JobsResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    area = json['area'];
    carType = json['carType'];
    dutyHours = json['dutyHours'];
    status = json['status'];
    dutyType = json['dutyType'];
    createdByName = json['createdByName'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    clientId = json['clientId'];
    weeklyOff = json['weeklyOff'].cast<String>();
    dutyTime = json['dutyTime'];
    outstationDays = json['outstationDays'];
    driverAge = json['driverAge'];
    drivingExperience = json['drivingExperience'];
    vehicleName = json['vehicleName'];
    clientSalary = json['clientSalary'];
    driverSalary = json['driverSalary'];
    role = json['role'];
    other = json['other'];
    location = json['location'];
    if (json['driverJobRequest'] != null) {
      driverJobRequest = <DriverJobRequestModel>[];
      json['driverJobRequest'].forEach((v) {
        driverJobRequest!.add(new DriverJobRequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['area'] = this.area;
    data['carType'] = this.carType;
    data['dutyHours'] = this.dutyHours;
    data['status'] = this.status;
    data['dutyType'] = this.dutyType;
    data['createdByName'] = this.createdByName;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['clientId'] = this.clientId;
    data['weeklyOff'] = this.weeklyOff;
    data['dutyTime'] = this.dutyTime;
    data['outstationDays'] = this.outstationDays;
    data['driverAge'] = this.driverAge;
    data['drivingExperience'] = this.drivingExperience;
    data['vehicleName'] = this.vehicleName;
    data['clientSalary'] = this.clientSalary;
    data['driverSalary'] = this.driverSalary;
    data['role'] = this.role;
    data['other'] = this.other;
    data['location'] = this.location;
    if (this.driverJobRequest != null) {
      data['driverJobRequest'] =
          this.driverJobRequest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
