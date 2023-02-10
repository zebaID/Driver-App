import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/repository.dart';

part 'places_autocomplete_event.dart';
part 'places_autocomplete_state.dart';

class PlacesAutocompleteBloc
    extends Bloc<PlacesAutocompleteEvent, PlacesAutocompleteState> {
  final AuthRepository authRepository;
  PlacesAutocompleteBloc({required this.authRepository})
      : super(PlacesAutocompleteState()) {
    on<PlaceAutocompleteSubmit>(_onSearchPlace);
  }

  void _onSearchPlace(PlaceAutocompleteSubmit event,
      Emitter<PlacesAutocompleteState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      String? response = await authRepository.getPlaces(event.text);
      if (response != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess, response: response));
      } else {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, response: response));
      }
    } catch (e) {
      print(e);
    }
  }
}
