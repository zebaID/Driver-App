part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class GetWallet extends WalletEvent {}

class AddMoney extends WalletEvent {
  late int amount;
  AddMoney({required this.amount});

  @override
  List<Object> get props => [amount];
}
