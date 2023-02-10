class BookingResponseModel {
  String? id;
  String? customerId;
  String? firstName;
  String? lastName;
  String? reportingDate;
  String? reportingTime;
  bool? isOutstation;
  bool? startOffDuty;
  String? carType;
  bool? isRoundTrip;
  String? pickAddress;
  String? dropAddress;
  String? bookingId;
  double? driverShare;
  String? landmark;
  String? relievingDate;
  String? relievingTime;
  String? outstationCity;
  String? otherInfo;
  String? dutyBasis;
  int? extraCharges;
  bool? acceptFlag;

  BookingResponseModel.empty();

  BookingResponseModel(
      {this.id,
      this.customerId,
      this.firstName,
      this.lastName,
      this.reportingDate,
      this.reportingTime,
      this.isOutstation,
      this.startOffDuty,
      this.carType,
      this.isRoundTrip,
      this.pickAddress,
      this.dropAddress,
      this.bookingId,
      this.driverShare,
      this.landmark,
      this.relievingDate,
      this.relievingTime,
      this.outstationCity,
      this.otherInfo,
      this.dutyBasis,
      this.extraCharges,
      this.acceptFlag});

  BookingResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    reportingDate = json['reporting_date'];
    reportingTime = json['reporting_time'];
    isOutstation = json['is_outstation'];
    startOffDuty = json['start_off_duty'];
    carType = json['car_type'];
    isRoundTrip = json['is_round_trip'];
    pickAddress = json['pick_address'];
    dropAddress = json['drop_address'];
    bookingId = json['booking_id'];
    driverShare = json['driver_share'].runtimeType == double
        ? json['driver_share']
        : json['driver_share'] + .0;
    landmark = json['landmark'];
    relievingDate = json['relieving_date'];
    relievingTime = json['relieving_time'];
    outstationCity = json['outstation_city'];
    otherInfo = json['other_info'];
    dutyBasis = json['duty_basis'];
    extraCharges = json['extra_charges'];
    acceptFlag = json['accept_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['reporting_date'] = this.reportingDate;
    data['reporting_time'] = this.reportingTime;
    data['is_outstation'] = this.isOutstation;
    data['start_off_duty'] = this.startOffDuty;
    data['car_type'] = this.carType;
    data['is_round_trip'] = this.isRoundTrip;
    data['pick_address'] = this.pickAddress;
    data['drop_address'] = this.dropAddress;
    data['booking_id'] = this.bookingId;
    data['driver_share'] = this.driverShare;
    data['landmark'] = this.landmark;
    data['relieving_date'] = this.relievingDate;
    data['relieving_time'] = this.relievingTime;
    data['outstation_city'] = this.outstationCity;
    data['other_info'] = this.otherInfo;
    data['duty_basis'] = this.dutyBasis;
    data['extra_charges'] = this.extraCharges;
    data['accept_flag'] = this.acceptFlag;
    return data;
  }
}
