class InvoiceResponseModel {
  int? id;
  String? bookingId;
  String? reportingDate;
  String? reportingTime;
  String? releavingDate;
  String? releavingTime;
  int? totalTravelTime;
  Null? haltTime;
  bool? isOutstation;
  String? dropLocation;
  double? dropLat;
  double? dropLong;
  bool? isRoundTrip;
  double? grossAmount;
  double? netAmount;
  Null? paymentModeId;
  Null? commissionAmount;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? pickupLocation;
  double? pickupLat;
  double? pickupLong;
  String? carType;
  String? invoiceType;

  InvoiceResponseModel(
      {this.id,
      this.bookingId,
      this.reportingDate,
      this.reportingTime,
      this.releavingDate,
      this.releavingTime,
      this.totalTravelTime,
      this.haltTime,
      this.isOutstation,
      this.dropLocation,
      this.dropLat,
      this.dropLong,
      this.isRoundTrip,
      this.grossAmount,
      this.netAmount,
      this.paymentModeId,
      this.commissionAmount,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.pickupLocation,
      this.pickupLat,
      this.pickupLong,
      this.carType,
      this.invoiceType});

  InvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    reportingDate = json['reportingDate'];
    reportingTime = json['reportingTime'];
    releavingDate = json['releavingDate'];
    releavingTime = json['releavingTime'];
    totalTravelTime = json['totalTravelTime'];
    haltTime = json['haltTime'];
    isOutstation = json['isOutstation'];
    dropLocation = json['dropLocation'];
    dropLat = json['dropLat'];
    dropLong = json['dropLong'];
    isRoundTrip = json['isRoundTrip'];
    grossAmount = json['grossAmount'].runtimeType == int
        ? double.parse(json['grossAmount'].toString())
        : json['grossAmount'];
    netAmount = json['netAmount'].runtimeType == int
        ? double.parse(json['netAmount'].toString())
        : json['netAmount'];
    paymentModeId = json['paymentModeId'];
    commissionAmount = json['commissionAmount'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    pickupLocation = json['pickupLocation'];
    pickupLat = json['pickupLat'];
    pickupLong = json['pickupLong'];
    carType = json['carType'];
    invoiceType = json['invoiceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookingId'] = this.bookingId;
    data['reportingDate'] = this.reportingDate;
    data['reportingTime'] = this.reportingTime;
    data['releavingDate'] = this.releavingDate;
    data['releavingTime'] = this.releavingTime;
    data['totalTravelTime'] = this.totalTravelTime;
    data['haltTime'] = this.haltTime;
    data['isOutstation'] = this.isOutstation;
    data['dropLocation'] = this.dropLocation;
    data['dropLat'] = this.dropLat;
    data['dropLong'] = this.dropLong;
    data['isRoundTrip'] = this.isRoundTrip;
    data['grossAmount'] = this.grossAmount;
    data['netAmount'] = this.netAmount;
    data['paymentModeId'] = this.paymentModeId;
    data['commissionAmount'] = this.commissionAmount;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['pickupLocation'] = this.pickupLocation;
    data['pickupLat'] = this.pickupLat;
    data['pickupLong'] = this.pickupLong;
    data['carType'] = this.carType;
    data['invoiceType'] = this.invoiceType;
    return data;
  }
}
