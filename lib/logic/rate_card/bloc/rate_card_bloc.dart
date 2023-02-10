import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/rate_card/rate_card_model.dart';

part 'rate_card_event.dart';
part 'rate_card_state.dart';

class RateCardBloc extends Bloc<RateCardEvent, RateCardState> {
  final AuthRepository authRepository;
  RateCardBloc({required this.authRepository}) : super(const RateCardState()) {
    on<GetRateCard>(_OnGetRateCard);
  }

  void _OnGetRateCard(GetRateCard event, Emitter<RateCardState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final getRateCard = await authRepository.getRateCard();
      final getDriverRateCard = await authRepository.getDriverRateCard();

      List<RateCardModel> list = [];

      if (getRateCard != null && getDriverRateCard != null) {
        final List<dynamic> clientRateCard = jsonDecode(getRateCard);
        final List<dynamic> driverRateCard = jsonDecode(getDriverRateCard);
        list.add(RateCardModel.fromJson(clientRateCard[0]));
        list.add(RateCardModel.fromJson(driverRateCard[0]));

        emit(state.copyWith(
            status: FormzStatus.submissionSuccess, rateCardList: list));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
