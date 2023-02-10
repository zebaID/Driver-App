class AssignedBookingResponseModel {
  String? id;
  String? customerId;
  String? firstName;
  String? lastName;
  String? bookingDate;
  String? reportingDate;
  String? reportingTime;
  double? fromLat;
  double? fromLong;
  double? dropLat;
  double? dropLong;
  bool? isOutstation;
  String? driverId;
  String? cancellationId;
  String? otherCancellationReason;
  String? status;
  bool? startOffDuty;
  String? carType;
  bool? isRoundTrip;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? pickAddress;
  String? dropAddress;
  double? driverShare;
  double? idShare;
  String? serviceTax;
  String? landmark;
  String? relievingDate;
  String? relievingTime;
  bool? startDutyFlag;
  bool? cancelDutyFlag;
  String? outstationCity;
  String? mobileNumber;

  AssignedBookingResponseModel(
      {this.id,
      this.customerId,
      this.firstName,
      this.lastName,
      this.bookingDate,
      this.reportingDate,
      this.reportingTime,
      this.fromLat,
      this.fromLong,
      this.dropLat,
      this.dropLong,
      this.isOutstation,
      this.driverId,
      this.cancellationId,
      this.otherCancellationReason,
      this.status,
      this.startOffDuty,
      this.carType,
      this.isRoundTrip,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.pickAddress,
      this.dropAddress,
      this.driverShare,
      this.idShare,
      this.serviceTax,
      this.landmark,
      this.relievingDate,
      this.relievingTime,
      this.startDutyFlag,
      this.cancelDutyFlag,
      this.outstationCity,
      this.mobileNumber});

  AssignedBookingResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    bookingDate = json['booking_date'];
    reportingDate = json['reporting_date'];
    reportingTime = json['reporting_time'];
    fromLat = json['from_lat'].runtimeType == int
        ? double.parse(json['from_lat'].toString())
        : json['from_lat'];
    fromLong = json['from_long'].runtimeType == int
        ? double.parse(json['from_long'].toString())
        : json['from_long'];
    dropLat = json['drop_lat'].runtimeType == int
        ? double.parse(json['drop_lat'].toString())
        : json['drop_lat'];
    dropLong = json['drop_long'].runtimeType == int
        ? double.parse(json['drop_long'].toString())
        : json['drop_long'];
    isOutstation = json['is_outstation'];
    driverId = json['driver_id'];
    cancellationId = json['cancellation_id'];
    otherCancellationReason = json['other_cancellation_reason'];
    status = json['status'];
    startOffDuty = json['start_off_duty'];
    carType = json['car_type'];
    isRoundTrip = json['is_round_trip'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    pickAddress = json['pick_address'];
    dropAddress = json['drop_address'];
    driverShare = json['driver_share'].runtimeType == double
        ? json['driver_share']
        : double.parse(json['driver_share'].toString());
    idShare = json['id_share'].runtimeType == double
        ? json['id_share']
        : double.parse(json['id_share'].toString());
    ;
    serviceTax = json['service_tax'].runtimeType == int
        ? json['service_tax'].toString()
        : json['service_tax'];
    landmark = json['landmark'];
    relievingDate = json['relieving_date'];
    relievingTime = json['relieving_time'];
    startDutyFlag = json['start_duty_flag'];
    cancelDutyFlag = json['cancel_duty_flag'];
    outstationCity = json['outstation_city'];
    mobileNumber = json['mobile_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['booking_date'] = this.bookingDate;
    data['reporting_date'] = this.reportingDate;
    data['reporting_time'] = this.reportingTime;
    data['from_lat'] = this.fromLat;
    data['from_long'] = this.fromLong;
    data['drop_lat'] = this.dropLat;
    data['drop_long'] = this.dropLong;
    data['is_outstation'] = this.isOutstation;
    data['driver_id'] = this.driverId;
    data['cancellation_id'] = this.cancellationId;
    data['other_cancellation_reason'] = this.otherCancellationReason;
    data['status'] = this.status;
    data['start_off_duty'] = this.startOffDuty;
    data['car_type'] = this.carType;
    data['is_round_trip'] = this.isRoundTrip;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['pick_address'] = this.pickAddress;
    data['drop_address'] = this.dropAddress;
    data['driver_share'] = this.driverShare;
    data['id_share'] = this.idShare;
    data['service_tax'] = this.serviceTax;
    data['landmark'] = this.landmark;
    data['relieving_date'] = this.relievingDate;
    data['relieving_time'] = this.relievingTime;
    data['start_duty_flag'] = this.startDutyFlag;
    data['cancel_duty_flag'] = this.cancelDutyFlag;
    data['outstation_city'] = this.outstationCity;
    data['mobile_number'] = this.mobileNumber;
    return data;
  }
}
