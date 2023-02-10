import 'package:intl/intl.dart';

class BookingModel {
  late String? carType;
  late String? isRoundTrip;
  late String? isOutstation;
  late String? reportingDate;
  late String? reportingTime;
  late String? releivingDate;
  late String? releivingTime;
  late String? releavingDuration;
  late String? landmark;
  late String? pickupAddress;
  late String? pickupLat;
  late String? pickupLng;
  late String? dropAddress;
  late String? dropLat;
  late String? dropLng;
  late String? cityName;
  late String? cityLat;
  late String? cityLng;
  late String? totalAmount;
  late String? customerId;
  late String? userId;
  late String? paymentMethod;
  late String? operationCity;
  late String? dutyBasis;
  late String? extraCharges;
  late String? outstationAddress;
  late DateTime? reportingDateTime;

  BookingModel(
      {required this.carType,
      required this.isRoundTrip,
      required this.isOutstation,
      required this.outstationAddress,
      required this.reportingDate,
      required this.reportingTime,
      this.releivingDate,
      this.releivingTime,
      this.releavingDuration,
      this.landmark,
      required this.pickupAddress,
      required this.pickupLat,
      required this.pickupLng,
      required this.dropAddress,
      required this.dropLat,
      required this.dropLng,
      required this.cityName,
      required this.cityLat,
      required this.cityLng,
      this.totalAmount,
      this.customerId,
      this.userId,
      this.paymentMethod,
      this.operationCity,
      this.dutyBasis,
      this.extraCharges,
      this.reportingDateTime});

  BookingModel.fromJson(Map<String, dynamic> json)
      : carType = json['carType'],
        isRoundTrip = json['isRoundTrip'],
        isOutstation = json['isOutstation'],
        outstationAddress = json['outstationAddress'],
        reportingDate = json['reportingDate'],
        releivingDate = json['releivingDate'],
        releivingTime = json['releivingTime'],
        releavingDuration = json['releavingDuration'],
        landmark = json['landmark'],
        pickupAddress = json['pickupAddress'],
        pickupLat = json['pickupLat'],
        pickupLng = json['pickupLng'],
        dropAddress = json['dropAddress'],
        dropLat = json['dropLat'],
        dropLng = json['dropLng'],
        cityName = json['cityName'],
        cityLat = json['cityLat'],
        cityLng = json['cityLng'],
        totalAmount = json['totalAmount'],
        customerId = json['customerId'],
        userId = json['userId'],
        paymentMethod = json['paymentMethod'],
        operationCity = json['operationCity'],
        dutyBasis = json['dutyBasis'],
        extraCharges = json['extraCharges'],
        reportingDateTime = json['reportingDateTime'];

  Map<String, dynamic> toJson() => {
        'carType': carType,
        'isRoundTrip': isRoundTrip,
        'isOutstation': isOutstation,
        'outstationAddress': outstationAddress,
        'reportingDate': reportingDate,
        'releivingDate': releivingDate,
        'releivingTime': releivingTime,
        'releavingDuration': releavingDuration,
        'landmark': landmark,
        'pickupAddress': pickupAddress,
        'pickupLat': pickupLat,
        'pickupLng': pickupLng,
        'dropAddress': dropAddress,
        'dropLat': dropLat,
        'dropLng': dropLng,
        'cityName': cityName,
        'cityLat': cityLat,
        'cityLng': cityLng,
        'totalAmount': totalAmount,
        'customerId': customerId,
        'userId': userId,
        'paymentMethod': paymentMethod,
        'operationCity': operationCity,
        'dutyBasis': dutyBasis,
        'extraCharges': extraCharges,
        'reportingDateTime':
            DateFormat('y-MM-dd hh:mm aa').format(reportingDateTime!)
      };
}
