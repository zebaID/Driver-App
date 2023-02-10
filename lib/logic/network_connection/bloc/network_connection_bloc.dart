import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:formz/formz.dart';

part 'network_connection_event.dart';
part 'network_connection_state.dart';

class NetworkConnectionBloc
    extends Bloc<NetworkConnectionEvent, NetworkConnectionState> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  NetworkConnectionBloc() : super(const NetworkConnectionState()) {
    on<CheckConnection>(_checkNetwork);
  }

  void _checkNetwork(
      CheckConnection event, Emitter<NetworkConnectionState> emit) async {
    ConnectivityResult? connectionResult = await initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress, msg: connectionResult));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<ConnectivityResult?> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status error:' + e.details);
      return null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

  Future<ConnectivityResult?> _updateConnectionStatus(
      ConnectivityResult result) async {
    return result;
  }
}
