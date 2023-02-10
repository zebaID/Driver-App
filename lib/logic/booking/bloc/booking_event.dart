part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CalculateFareSubmitted extends BookingEvent {
  late String carType;
  late String isRoundTrip;
  late String isOutstation;
  late String actualReportingDate;
  late String actualReportingTime;
  late String actualReleivingDate;
  late String actualReleivingTime;
  late String pickupLat;
  late String pickupLng;
  late String dropLat;
  late String dropLng;
  late String operationCityId;

  CalculateFareSubmitted(
      this.carType,
      this.isRoundTrip,
      this.isOutstation,
      this.actualReportingDate,
      this.actualReportingTime,
      this.actualReleivingDate,
      this.actualReleivingTime,
      this.pickupLat,
      this.pickupLng,
      this.dropLat,
      this.dropLng,
      this.operationCityId);

  @override
  List<Object> get props => [
        carType,
        isRoundTrip,
        isOutstation,
        actualReportingDate,
        actualReportingTime,
        actualReleivingDate,
        actualReleivingTime,
        pickupLat,
        pickupLng,
        dropLat,
        dropLng,
        operationCityId,
      ];
}

class BookingSubmit extends BookingEvent {
  late String carType;
  late String isRoundTrip;
  late String isOutstation;
  late String reportingDate;
  late String reportingTime;
  late String releivingDate;

  late String releivingTime;
  late String releavingDuration;
  // late String? landmark;
  late String pickupAddress;
  late String pickupLat;
  late String pickupLng;
  late String dropAddress;
  late String dropLat;
  late String dropLng;
  late String cityName;
  late String cityLat;
  late String cityLng;
  late String totalAmount;
  // late String customerId;
  // late String userId;
  late String? paymentMethod;
  late String? operationCity;
  late String? dutyBasis;
  late String? extraCharges;
  late String? promoCode;

  BookingSubmit({
    required this.carType,
    required this.isRoundTrip,
    required this.isOutstation,
    required this.reportingDate,
    required this.reportingTime,
    required this.releivingDate,
    required this.releivingTime,
    required this.releavingDuration,
    // this.landmark,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropAddress,
    required this.dropLat,
    required this.dropLng,
    required this.cityName,
    required this.cityLat,
    required this.cityLng,
    required this.totalAmount,
    // required this.customerId,
    // required this.userId,
    this.paymentMethod,
    this.operationCity,
    this.dutyBasis,
    this.extraCharges,
    this.promoCode,
  });

  @override
  List<Object> get props => [
        carType,
        isRoundTrip,
        isOutstation,
        reportingDate,
        reportingTime,
        releivingDate,
        releivingTime,
        releavingDuration,
        // landmark!,
        pickupAddress,
        pickupLat,
        pickupLng,
        dropAddress,
        dropLat,
        dropLng,
        cityName,
        cityLat,
        cityLng,
        totalAmount,
        // customerId,
        // userId,
        paymentMethod!,
        operationCity!,
        dutyBasis!,
        extraCharges!,
        promoCode!
      ];
}

class GetBooking extends BookingEvent {}

class GetBookingAssigned extends BookingEvent {}

class GetBookingTomorrow extends BookingEvent {}

class GetCancellationReasons extends BookingEvent {}

class CancelBookingEvent extends BookingEvent {
  late String bookingId;
  late String cancellationId;
  late String cancellationReason;

  CancelBookingEvent(
      this.bookingId, this.cancellationId, this.cancellationReason);

  @override
  List<Object> get props => [bookingId, cancellationId, cancellationReason];
}

class GetBookingDetails extends BookingEvent {
  late int bookingId;

  GetBookingDetails(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class AcceptBooking extends BookingEvent {
  late String bookingId;
  late BookingResponseModel bookingResponseModel;

  AcceptBooking(this.bookingId, this.bookingResponseModel);

  @override
  List<Object> get props => [bookingId, bookingResponseModel];
}

class CreateAllocationHistory extends BookingEvent {
  late String bookingId;

  CreateAllocationHistory(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class StartDuty extends BookingEvent {
  late AssignedBookingResponseModel assignedBookingResponseModel;

  StartDuty(this.assignedBookingResponseModel);

  @override
  List<Object> get props => [assignedBookingResponseModel];
}

class CancelDuty extends BookingEvent {
  late AssignedBookingResponseModel assignedBookingResponseModel;

  CancelDuty(this.assignedBookingResponseModel);

  @override
  List<Object> get props => [assignedBookingResponseModel];
}

class OffDuty extends BookingEvent {
  late CurrentDutyResponseModel currentDutyResponseModel;

  OffDuty(this.currentDutyResponseModel);

  @override
  List<Object> get props => [currentDutyResponseModel];
}

class AcceptCash extends BookingEvent {
  late CurrentDutyResponseModel currentDutyResponseModel;

  AcceptCash(this.currentDutyResponseModel);

  @override
  List<Object> get props => [currentDutyResponseModel];
}

class GetLocalDriverSummary extends BookingEvent {}

class GetOutstationDriverSummary extends BookingEvent {}
