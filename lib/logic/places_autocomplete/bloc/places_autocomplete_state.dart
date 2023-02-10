part of 'places_autocomplete_bloc.dart';

class PlacesAutocompleteState extends Equatable {
  const PlacesAutocompleteState(
      {this.status = FormzStatus.pure, this.response = ""});

  final FormzStatus status;
  final String response;

  PlacesAutocompleteState copyWith({FormzStatus? status, String? response}) {
    return PlacesAutocompleteState(
        status: status ?? this.status, response: response ?? this.response);
  }

  @override
  List<Object> get props => [status, response];
}
