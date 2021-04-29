import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:taichung_place/models/taichung_place_models.dart';
import 'package:http/http.dart' as http;

class PlaceRepository {
  @override
  Future<List<TaichungPlaceModel>> getRestaurantData() async {
    // "https://datacenter.taichung.gov.tw/swagger/OpenData/c60986c5-03fb-49b9-b24f-6656e1de02aa")
    final response = await http.get( Uri(
      scheme: 'https',
      host: 'datacenter.taichung.gov.tw',
      path: 'swagger/OpenData/c60986c5-03fb-49b9-b24f-6656e1de02aa',
      // queryParameters: {'q': username},
    ));

    if (response.statusCode == 200) {
      // List<int> bytes = response.body.toString().codeUnits;
      // var responseString = utf8.decode(bytes);
      // return TaichungPlaceModel.fromJson(jsonDecode(response.body.toString()));
      List<TaichungPlaceModel> userFromJson(String str) => List<TaichungPlaceModel>.from(json.decode(str).map((x) => TaichungPlaceModel.fromJson(x)));
      return userFromJson(response.body.toString());
      // return userFromJson, response.body;
    } else {

      throw Exception();
    }
  }
}
