import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taichung_place/place_info/bloc/place_data_bloc.dart';
import 'package:taichung_place/place_info/place_listview_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RenterDataBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/": (context) => PlaceListPage(),
          "/mainPage": (context) => PlaceListPage()
        },
      ),
    );
    ;
  }
}
