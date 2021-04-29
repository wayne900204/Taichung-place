part of 'place_data_bloc.dart';

@immutable
abstract class RenterDataState extends Equatable {
  @override
  List<Object> get props => [];
}

class RentDataInitial extends RenterDataState {}

class RenterStateLoading extends RenterDataState {}

class RenterStateLoaded extends RenterDataState {
  final List<TaichungPlaceModel> items;

  RenterStateLoaded({this.items});
}

class RenterStateRefreshing extends RenterDataState {}
