class CurrentDutyResponseModel {
  String? bookingId;
  String? customerId;
  String? invoiceId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? reportingDate;
  String? reportingTime;
  bool? isOutstation;
  String? driverId;
  String? status;
  bool? startOffDuty;
  String? carType;
  bool? isRoundTrip;
  String? pickAddress;
  String? dropAddress;
  double? driverShare;
  int? serviceTax;
  String? landmark;
  String? relievingDate;
  String? relievingTime;
  double? netAmount;
  int? returnTravelTime;
  int? baseFare;
  String? overTime;
  double? dropLat;
  double? dropLong;
  double? pickLat;
  double? pickLong;
  String? tripType;

  CurrentDutyResponseModel(
      {this.bookingId,
      this.customerId,
      this.invoiceId,
      this.firstName,
      this.lastName,
      this.mobileNumber,
      this.reportingDate,
      this.reportingTime,
      this.isOutstation,
      this.driverId,
      this.status,
      this.startOffDuty,
      this.carType,
      this.isRoundTrip,
      this.pickAddress,
      this.dropAddress,
      this.driverShare,
      this.serviceTax,
      this.landmark,
      this.relievingDate,
      this.relievingTime,
      this.netAmount,
      this.returnTravelTime,
      this.baseFare,
      this.overTime,
      this.dropLat,
      this.dropLong,
      this.pickLat,
      this.pickLong,
      this.tripType});

  CurrentDutyResponseModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    customerId = json['customer_id'];
    invoiceId = json['invoice_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    reportingDate = json['reporting_date'];
    reportingTime = json['reporting_time'];
    isOutstation = json['is_outstation'];
    driverId = json['driver_id'];
    status = json['status'];
    startOffDuty = json['start_off_duty'];
    carType = json['car_type'];
    isRoundTrip = json['is_round_trip'];
    pickAddress = json['pick_address'];
    dropAddress = json['drop_address'];
    driverShare = json['driver_share'].runtimeType == int
        ? double.parse(json['driver_share'].toString())
        : json['driver_share'];
    serviceTax = json['service_tax'];
    landmark = json['landmark'];
    relievingDate = json['relieving_date'];
    relievingTime = json['relieving_time'];
    netAmount = json['net_amount'].runtimeType == int
        ? double.parse(json['net_amount'].toString())
        : json['net_amount'];
    returnTravelTime = json['return_travel_time'];
    baseFare = json['base_fare'];
    overTime = json['over_time'].toString();
    dropLat = json['drop_lat'].runtimeType == int ? 0.0 : json['drop_lat'];
    dropLong = json['drop_long'].runtimeType == int ? 0.0 : json['drop_long'];
    pickLat = json['pick_lat'].runtimeType == int
        ? double.parse(json['pick_lat'].toString())
        : json['pick_lat'];
    pickLong = json['pick_long'].runtimeType == int
        ? double.parse(json['pick_long'].toString())
        : json['pick_long'];
    tripType = json['trip_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['customer_id'] = this.customerId;
    data['invoice_id'] = this.invoiceId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['reporting_date'] = this.reportingDate;
    data['reporting_time'] = this.reportingTime;
    data['is_outstation'] = this.isOutstation;
    data['driver_id'] = this.driverId;
    data['status'] = this.status;
    data['start_off_duty'] = this.startOffDuty;
    data['car_type'] = this.carType;
    data['is_round_trip'] = this.isRoundTrip;
    data['pick_address'] = this.pickAddress;
    data['drop_address'] = this.dropAddress;
    data['driver_share'] = this.driverShare;
    data['service_tax'] = this.serviceTax;
    data['landmark'] = this.landmark;
    data['relieving_date'] = this.relievingDate;
    data['relieving_time'] = this.relievingTime;
    data['net_amount'] = this.netAmount;
    data['return_travel_time'] = this.returnTravelTime;
    data['base_fare'] = this.baseFare;
    data['over_time'] = this.overTime;
    data['drop_lat'] = this.dropLat;
    data['drop_long'] = this.dropLong;
    data['pick_lat'] = this.pickLat;
    data['pick_long'] = this.pickLong;
    data['trip_type'] = this.tripType;
    return data;
  }
}
