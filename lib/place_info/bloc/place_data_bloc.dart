import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:taichung_place/models/taichung_place_models.dart';
import 'package:taichung_place/place_info/repository/place_data_repository.dart';
import 'package:rxdart/rxdart.dart';
part 'place_data_event.dart';

part 'place_data_state.dart';

class RenterDataBloc extends Bloc<RenterDataEvent, RenterDataState> {
  PlaceRepository rentDataRepository = new PlaceRepository();

  RenterDataBloc() : super(RentDataInitial());

  @override
  Stream<RenterDataState> mapEventToState(
    RenterDataEvent event,
  ) async* {
    // TODO: implement mapEventToState

    if (event is RentDataLoadItemsEvent) {
      yield RenterStateLoading();

      List<TaichungPlaceModel> generatedItems =
          await rentDataRepository.getRestaurantData();
      // compute(rentDataRepository.getRestaurantData());
      yield RenterStateLoaded(items: generatedItems);
    }
    if (event is RentDataRefreshEvent) {
      yield RenterStateRefreshing();

      List<TaichungPlaceModel> generatedItems =
          await rentDataRepository.getRestaurantData();

      await Future<void>.delayed(Duration(seconds: 1));

      yield RenterStateLoaded(items: generatedItems);
    }
    if (event is BookInfoSearchUser) {
      // yield RenterStateRefreshing();
      yield RenterStateLoading();
      List<TaichungPlaceModel> generatedItems =
      await rentDataRepository.getRestaurantData();
      // event.items;
      var dummyListData = <TaichungPlaceModel>[];
      String text = event.text;
      await generatedItems.forEach((model) {
        var st2 = TaichungPlaceModel(
            name: model.name,
            summary: model.summary,
            address: model.address,);
        if ((model.name.toLowerCase()).contains(text.toLowerCase()) ||
            model.summary.toLowerCase().contains(text.toLowerCase()) ||
            model.address.toLowerCase().contains(text.toLowerCase())
        ) {
          dummyListData.add(st2);
        }
      });
      print(dummyListData.length.toString()+"EEEEEEE");
      yield RenterStateLoaded(items: dummyListData);
    }
  }

  @override
  Future<Function> close() {
    super.close();
  }

  @override
  Stream<Transition<RenterDataEvent, RenterDataState>> transformEvents(
      Stream<RenterDataEvent> events,
      TransitionFunction<RenterDataEvent, RenterDataState> transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 500)).switchMap(transitionFn);
  }

// @override
  // Stream<Transition<RenterDataEvent, RenterDataState>> transformEvents(
  //     Stream<RenterDataEvent> events,
  //     TransitionFunction<RenterDataEvent, RenterDataState> transitionFn) {
  //   // return (events as Observable<BookInfoSearchUser>)
  //   //     .debounceTime(
  //   //   Duration(milliseconds: 300),
  //   // )
  //   //     .switchMap(transitionFn);
  //   return (events as Observable<BookInfoSearchUser>)
  //       .debounce(Duration(milliseconds: 500));
  // }

}
