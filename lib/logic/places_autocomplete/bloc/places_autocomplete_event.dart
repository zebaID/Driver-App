part of 'places_autocomplete_bloc.dart';

abstract class PlacesAutocompleteEvent extends Equatable {
  const PlacesAutocompleteEvent();

  @override
  List<Object> get props => [];
}

class PlaceAutocompleteSubmit extends PlacesAutocompleteEvent {
  late String text;
  PlaceAutocompleteSubmit(this.text);

  @override
  List<Object> get props => [text];
}
