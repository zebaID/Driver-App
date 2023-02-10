import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/booking/model/assigned_booking_response_model.dart';
import 'package:id_driver/logic/booking/model/booking_response_model.dart';
import 'package:id_driver/logic/booking/model/current_duty_response_model.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final AuthRepository authRepository;
  BookingBloc({required this.authRepository}) : super(BookingState()) {
    on<CalculateFareSubmitted>(_onCalculateFare);
    on<BookingSubmit>(_onBookingSubmit);
    on<AcceptBooking>(_onAcceptBooking);
    on<GetBooking>(_onGetBooking);
    on<GetBookingAssigned>(_onGetBookingAssigned);
    on<GetBookingTomorrow>(_onGetBookingTomorrow);
    on<GetCancellationReasons>(_onGetCancellationReasons);
    on<CancelBookingEvent>(_onCancelBooking);
    on<GetBookingDetails>(_onGetBookingDetails);
    on<StartDuty>(_onStartDuty);
    on<OffDuty>(_onOffDuty);
    on<AcceptCash>(_onAcceptCash);
    on<GetLocalDriverSummary>(_getLocalDriverSummary);
    on<GetOutstationDriverSummary>(_getOutstationDriverSummary);
    on<CancelDuty>(_onCancelDuty);
  }

  void _getLocalDriverSummary(
      GetLocalDriverSummary event, Emitter<BookingState> emiter) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));
    try {
      final getLocalDriverSummary =
          await authRepository.getLocalDriverSummary();
      if (getLocalDriverSummary != null) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          driverLocalBookingSummary: jsonDecode(getLocalDriverSummary)
              .map<AssignedBookingResponseModel>(
                  (booking) => AssignedBookingResponseModel.fromJson(booking))
              .toList(),
        ));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _getOutstationDriverSummary(
      GetOutstationDriverSummary event, Emitter<BookingState> emiter) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));
    try {
      final getOutstationDriverSummary =
          await authRepository.getOutstationDriverSummary();
      if (getOutstationDriverSummary != null) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          driverOutstationBookingSummary: jsonDecode(getOutstationDriverSummary)
              .map<AssignedBookingResponseModel>(
                  (booking) => AssignedBookingResponseModel.fromJson(booking))
              .toList(),
        ));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onAcceptCash(AcceptCash event, Emitter<BookingState> emiter) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));

    try {
      final paidDutyFunction =
          await authRepository.paidDutyFunction(event.currentDutyResponseModel);

      if (paidDutyFunction != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess, response: paidDutyFunction));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onStartDuty(StartDuty event, Emitter<BookingState> emiter) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));

    try {
      final startDuty =
          await authRepository.startDuty(event.assignedBookingResponseModel);

      if (startDuty != null) {
        final updateInvoiceOnStartDuty =
            await authRepository.updateInvoiceOnStartDuty(
                event.assignedBookingResponseModel, "DRIVER_START");
        if (updateInvoiceOnStartDuty != null) {
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess, response: startDuty));
        } else {}
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onCancelDuty(CancelDuty event, Emitter<BookingState> emiter) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));

    try {
      final cancelDuty =
          await authRepository.cancelDuty(event.assignedBookingResponseModel);

      if (cancelDuty != null) {
        final cancelResp = jsonDecode(cancelDuty);
        if (cancelResp[0]['driver_cancel_duty1'] == 'Cancelled') {
          final createAllocationReps =
              await authRepository.createAllocationHistory(
                  event.assignedBookingResponseModel.id, "Deallocation");
          if (createAllocationReps != null) {
            emit(state.copyWith(
                status: FormzStatus.submissionSuccess, response: cancelDuty));
          } else {
            emit(state.copyWith(
                status: FormzStatus.submissionFailure, response: cancelDuty));
          }
        } else {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure, response: cancelDuty));
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onOffDuty(OffDuty event, Emitter<BookingState> emiter) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));

    try {
      final offDuty =
          await authRepository.offDuty(event.currentDutyResponseModel);

      if (offDuty != null) {
        final json = jsonDecode(offDuty);
        if (json[0]['off_duty_for_driver'] == "Done" ||
            json[0]['off_duty_for_driver'] == "Success") {
          final updateInvoiceOnOffDuty =
              await authRepository.updateInvoiceOnOffDuty(
                  event.currentDutyResponseModel, "DRIVER_OFF");
          if (updateInvoiceOnOffDuty != null) {
            String? bookings = await authRepository.getBookingDetails(
                int.parse(event.currentDutyResponseModel.bookingId!));
            if (bookings != null) {
              final json = jsonDecode(bookings);
              String? currentDutyRes = await authRepository.getCurrentDuty();
              if (currentDutyRes != null) {
                final jsonCurrent = jsonDecode(currentDutyRes);
                List<CurrentDutyResponseModel> currentDuty = [];
                currentDuty
                    .add(CurrentDutyResponseModel.fromJson(jsonCurrent[0]));
                print(currentDuty);
                emit(state.copyWith(
                    status: FormzStatus.submissionSuccess,
                    currentDuty: currentDuty,
                    bookingDetailsReponse: bookings,
                    response: offDuty));
              } else {
                emit(state.copyWith(
                    status: FormzStatus.submissionSuccess,
                    bookingDetailsReponse: bookings,
                    response: offDuty));
              }
            } else {
              emit(state.copyWith(status: FormzStatus.submissionFailure));
            }
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onCreateAllocationHistory(
      CreateAllocationHistory event, Emitter<BookingState> emit) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));

    try {
      final createAllocationReps = await authRepository.createAllocationHistory(
          event.bookingId, "Allocation");
      print("accept $createAllocationReps");

      if (createAllocationReps != null) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onAcceptBooking(AcceptBooking event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      response: "",
    ));

    try {
      final acceptBookingResponse = await authRepository.acceptDuty(
          event.bookingId, event.bookingResponseModel);
      print("accept $acceptBookingResponse");

      if (acceptBookingResponse != null) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          response: acceptBookingResponse,
        ));
        final resp = jsonDecode(state.response);
        if (resp[0]['accept_duty'] == 'Accepted' ||
            resp[0]['accept_duty'] == 'License Expire Soon') {
          final createAllocationReps = await authRepository
              .createAllocationHistory(event.bookingId, "Allocation");
          print("createAllocation $createAllocationReps");
          if (createAllocationReps != null) {
            emit(state.copyWith(
                status: FormzStatus.submissionSuccess,
                response: acceptBookingResponse));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onCalculateFare(
      CalculateFareSubmitted event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
        response: "[]",
        bookingResp: ""));

    try {
      final response = await authRepository.calculateFare(
          event.carType,
          event.isRoundTrip,
          event.isOutstation,
          event.actualReportingDate,
          event.actualReportingTime,
          event.actualReleivingDate,
          event.actualReleivingTime,
          event.pickupLat,
          event.pickupLng,
          event.dropLat,
          event.dropLng,
          event.operationCityId);

      if (response != null) {
        print("calFare Response" + response);

        emit(state.copyWith(
            status: FormzStatus.submissionSuccess, response: response));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
        print("calFare Response" + response!);
      }
    } catch (e) {
      print("calFare Exp $e");
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onBookingSubmit(BookingSubmit event, Emitter<BookingState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      String? book = await authRepository.createNewBoking(
          event.carType,
          event.isRoundTrip,
          event.isOutstation,
          event.reportingDate,
          event.reportingTime,
          event.releivingDate,
          event.releivingTime,
          event.releavingDuration,
          // event.landmark,
          event.pickupAddress,
          event.pickupLat,
          event.pickupLng,
          event.dropAddress,
          event.dropLat,
          event.dropLng,
          event.cityName,
          event.cityLat,
          event.cityLng,
          event.totalAmount,
          event.promoCode!);
      print(book);

      if (book != null) {
        final res = jsonDecode(book);

        if (res[0]['create_booking_promocode'].toString().isNotEmpty ||
            res[0]['create_booking'].toString().isNotEmpty) {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            bookingResp: book,
          ));
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      print("BookingSubmitBloc $e");
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onGetBooking(GetBooking event, Emitter<BookingState> emit) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));
    try {
      String? bookings = await authRepository.getBookingsToday();
      if (bookings != null) {
        String? assignedBookings = await authRepository.getBookingsAssigned();
        if (assignedBookings != null) {
          String? currentDuty = await authRepository.getCurrentDuty();
          if (currentDuty != null) {
            String? tomorrowBookings =
                await authRepository.getBookingsTomorrow();
            if (tomorrowBookings != null) {
              emit(state.copyWith(
                  status: FormzStatus.submissionSuccess,
                  bookingsAssigned: jsonDecode(assignedBookings)
                      .map<AssignedBookingResponseModel>((assignedBookings) =>
                          AssignedBookingResponseModel.fromJson(
                              assignedBookings))
                      .toList(),
                  bookings: jsonDecode(bookings)
                      .map<BookingResponseModel>(
                          (booking) => BookingResponseModel.fromJson(booking))
                      .toList(),
                  bookingsTomorrow: jsonDecode(tomorrowBookings)
                      .map<BookingResponseModel>((tomorrowBookings) =>
                          BookingResponseModel.fromJson(tomorrowBookings))
                      .toList(),
                  currentDuty: jsonDecode(currentDuty)
                      .map<CurrentDutyResponseModel>((currentDuty) =>
                          CurrentDutyResponseModel.fromJson(currentDuty))
                      .toList()));
            } else {
              emit(state.copyWith(status: FormzStatus.submissionFailure));
            }
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onGetBookingAssigned(
      GetBookingAssigned event, Emitter<BookingState> emit) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));
    try {
      String? bookings = await authRepository.getBookingsAssigned();
      if (bookings != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            bookingsAssigned: jsonDecode(bookings)
                .map<BookingResponseModel>(
                    (booking) => BookingResponseModel.fromJson(booking))
                .toList()));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onGetBookingTomorrow(
      GetBookingTomorrow event, Emitter<BookingState> emit) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));
    try {
      String? bookings = await authRepository.getBookingsTomorrow();
      if (bookings != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            bookingsTomorrow: jsonDecode(bookings)
                .map<BookingResponseModel>(
                    (booking) => BookingResponseModel.fromJson(booking))
                .toList()));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onGetBookingDetails(
      GetBookingDetails event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress, bookingDetailsReponse: ""));
    try {
      String? bookings =
          await authRepository.getBookingDetails(event.bookingId);
      if (bookings != null) {
        final json = jsonDecode(bookings);
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            bookingDetailsReponse: bookings));

        // final response = await authRepository.calculateFare(
        //     json['carType'],
        //     json['isRoundTrip'],
        //     json['isOutstation'],
        //     json['actualReportingDate'],
        //     json['actualReportingTime'],
        //     event.actualReleivingDate,
        //     event.actualReleivingTime,
        //     event.pickupLat,
        //     event.pickupLng,
        //     event.dropLat,
        //     event.dropLng,
        //     event.operationCityId);
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onGetCancellationReasons(
      GetCancellationReasons event, Emitter<BookingState> emit) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: ""));

    try {
      String? cancellationReasons =
          await authRepository.getCancellationReasons();
      if (cancellationReasons != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            cancellationReasons: cancellationReasons));
      } else {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
        ));
      }
    } catch (e) {
      print("GetCancellationReasonBLoc $e");
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
      ));
    }
  }

  void _onCancelBooking(
      CancelBookingEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      String? response = await authRepository.cancelBooking(
          event.bookingId, event.cancellationId, event.cancellationReason);

      if (response != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess, response: response));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
