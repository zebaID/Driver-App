import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/wallet/model/driver_account_model.dart';
import 'package:id_driver/logic/wallet/model/wallet_response_model.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final AuthRepository authRepository;
  WalletBloc({required this.authRepository}) : super(const WalletState()) {
    on<GetWallet>(onGetWallet);
    on<AddMoney>(_OnAddMoney);
  }

  void _OnAddMoney(AddMoney event, Emitter emit) async {
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress, stringResponse: ""));
    try {
      final addMoneyResponse =
          await authRepository.initiatePayment(event.amount.toStringAsFixed(2));
      if (addMoneyResponse != null) {
        final accountDetails = await authRepository.getDriverAccountDetails();
        if (accountDetails != null) {
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              response: jsonDecode(accountDetails)
                  .map<WalletResponseModel>(
                      (booking) => WalletResponseModel.fromJson(booking))
                  .toList()));
        } else {
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              stringResponse: addMoneyResponse));
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void onGetWallet(GetWallet event, Emitter emit) async {
    emit(
        state.copyWith(status: FormzStatus.submissionInProgress, response: []));
    try {
      final accountDetails = await authRepository.getDriverAccountDetails();
      if (accountDetails != null) {
        final accountBalance = await authRepository.getAccountBalance();
        if (accountBalance != null) {
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              response: jsonDecode(accountDetails)
                  .map<WalletResponseModel>(
                      (booking) => WalletResponseModel.fromJson(booking))
                  .toList(),
              driverAccount: jsonDecode(accountBalance)
                  .map<DriverAccountModel>(
                      (account) => DriverAccountModel.fromJson(account))
                  .toList()));
        }
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            response: jsonDecode(accountDetails)
                .map<WalletResponseModel>(
                    (booking) => WalletResponseModel.fromJson(booking))
                .toList()));
      } else {
        emit(state
            .copyWith(status: FormzStatus.submissionFailure, response: []));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure, response: []));
    }
  }
}
