part of 'rate_card_bloc.dart';

class RateCardState extends Equatable {
  final FormzStatus status;
  final List<RateCardModel> rateCardList;
  const RateCardState(
      {this.status = FormzStatus.pure, this.rateCardList = const []});

  RateCardState copyWith({
    FormzStatus? status,
    List<RateCardModel>? rateCardList,
  }) {
    return RateCardState(
      status: status ?? this.status,
      rateCardList: rateCardList ?? this.rateCardList,
    );
  }

  @override
  List<Object> get props => [status, rateCardList];
}
