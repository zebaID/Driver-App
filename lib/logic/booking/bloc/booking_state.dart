part of 'booking_bloc.dart';

class BookingState extends Equatable {
  BookingState(
      {this.status = FormzStatus.pure,
      this.response = "",
      this.bookingResp = "",
      this.bookings = const [],
      this.bookingsTomorrow = const [],
      this.bookingsAssigned = const [],
      this.driverLocalBookingSummary = const [],
      this.driverOutstationBookingSummary = const [],
      this.currentDuty = const [],
      this.cancellationReasons = "",
      this.bookingDetailsReponse = ""});

  final FormzStatus status;
  final String response;
  final String bookingResp;
  final List<BookingResponseModel> bookings;
  final List<BookingResponseModel> bookingsTomorrow;
  final List<AssignedBookingResponseModel> bookingsAssigned;
  final List<CurrentDutyResponseModel> currentDuty;
  final List<AssignedBookingResponseModel> driverLocalBookingSummary;
  final List<AssignedBookingResponseModel> driverOutstationBookingSummary;

  final String cancellationReasons;
  final String bookingDetailsReponse;

  BookingState copyWith(
      {FormzStatus? status,
      String? response,
      String? bookingResp,
      List<BookingResponseModel>? bookings,
      List<AssignedBookingResponseModel>? driverLocalBookingSummary,
      List<AssignedBookingResponseModel>? driverOutstationBookingSummary,
      List<BookingResponseModel>? bookingsTomorrow,
      List<AssignedBookingResponseModel>? bookingsAssigned,
      List<CurrentDutyResponseModel>? currentDuty,
      String? bookingDetailsReponse,
      String? cancellationReasons}) {
    return BookingState(
        status: status ?? this.status,
        response: response ?? this.response,
        bookingResp: bookingResp ?? this.bookingResp,
        bookings: bookings ?? this.bookings,
        driverLocalBookingSummary:
            driverLocalBookingSummary ?? this.driverLocalBookingSummary,
        driverOutstationBookingSummary: driverOutstationBookingSummary ??
            this.driverOutstationBookingSummary,
        bookingsTomorrow: bookingsTomorrow ?? this.bookingsTomorrow,
        bookingsAssigned: bookingsAssigned ?? this.bookingsAssigned,
        currentDuty: currentDuty ?? this.currentDuty,
        bookingDetailsReponse:
            bookingDetailsReponse ?? this.bookingDetailsReponse,
        cancellationReasons: cancellationReasons ?? this.cancellationReasons);
  }

  @override
  List<Object> get props => [
        status,
        response,
        bookingResp,
        bookings,
        bookingsTomorrow,
        bookingsAssigned,
        cancellationReasons,
        bookingDetailsReponse,
        currentDuty,
        driverLocalBookingSummary,
        driverOutstationBookingSummary
      ];
}
