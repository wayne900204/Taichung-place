part of 'place_data_bloc.dart';

@immutable
abstract class RenterDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RentDataLoadItemsEvent extends RenterDataEvent {}

class RentDataRefreshEvent extends RenterDataEvent {}

class BookInfoSearchUser extends RenterDataEvent {
  final String text;
  final List<TaichungPlaceModel> items;

  BookInfoSearchUser(this.text, this.items);
}
