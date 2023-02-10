part of 'rate_card_bloc.dart';

abstract class RateCardEvent extends Equatable {
  const RateCardEvent();

  @override
  List<Object> get props => [];
}

class GetRateCard extends RateCardEvent {}
