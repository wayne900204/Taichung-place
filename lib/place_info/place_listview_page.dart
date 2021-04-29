import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';
import 'package:taichung_place/models/taichung_place_models.dart';
import 'package:taichung_place/place_info/web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bloc/place_data_bloc.dart';

class PlaceListPage extends StatefulWidget {
  @override
  _PlaceListPageState createState() => _PlaceListPageState();
}

class _PlaceListPageState extends State<PlaceListPage> {
  RenterDataBloc _rentDataBloc;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _rentDataBloc = BlocProvider.of<RenterDataBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rentDataBloc..add(RentDataRefreshEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('台中景點',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          // ignore: close_sinks
          final itemsBloc = _rentDataBloc..add(RentDataRefreshEvent());
          return itemsBloc.stream.firstWhere((e) => e is! RentDataRefreshEvent);

        },
        child: _buildItemsList(),
      ),
    );
  }

  Widget _buildItemsList() {
    final theme = Theme.of(context);

    return BlocBuilder<RenterDataBloc, RenterDataState>(
      buildWhen: (previous, current) => current is RenterStateLoaded,
      builder: (context, state) {
        if (state is RenterStateLoaded) {
          print("EEEEEEE"+state.items.length.toString());
          final items = state.items;
          return Column(
            children: [
              _searchField(items),
              Expanded(
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    // return WebViewExample(item: item,);
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaceWebView(item: item,)));
                      },
                      child: ListTile(
                        title: Text(
                          // "景點名稱：\n" +
                              item.address,
                          style: theme.textTheme.headline6.copyWith(
                            color: Colors.green,
                          ),
                        ),
                        subtitle: Text(
                            // "景點簡述：" +
                            item.summary),
                        leading: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text(
                            // "景點地址：\n" +
                                item.name,
                            style: theme.textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                    // return GestureDetector(
                    //   onTap: (){
                    //
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //     Text(
                    //         // "景點名稱：\n" +
                    //             item.name,
                    //         style: theme.textTheme.headline6.copyWith(
                    //           color: Colors.black87,
                    //         ),
                    //       ),
                    //   Text(
                    //           // "景點簡述：" +
                    //           item.summary),
                    //   Text(
                    //     // "景點地址：\n" +
                    //         item.address,
                    //         style: theme.textTheme.subtitle1.copyWith(
                    //           fontWeight: FontWeight.w600,
                    //           color: Colors.green,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: items.length,
                ),
              ),
            ],
          );
        }
        // if(state is RenterStateRefreshing){
        //   return Center(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         CircularProgressIndicator(),
        //             Text('資料大量，請等待'),
        //       ],
        //     ),
        //   );
        // }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  Widget _searchField(List<TaichungPlaceModel> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,right: 16,left: 16),
      child: TextFormField(
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        controller: _searchController,
        onChanged: (changed) {
          // _rentDataBloc.close();
          // _rentDataBloc.mapEventToState(BookInfoSearchUser(changed, items));
          // _rentDataBloc.close();
          // _rentDataBloc.emit(BookInfoSearchUser(changed, items));
          // _rentDataBloc.
          _rentDataBloc.add(BookInfoSearchUser(changed, items));
          // _rentDataBloc.onEvent(BookInfoSearchUser(changed, items));
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: _searchController.text.length > 0
              ? IconButton(
              icon: Icon(
                Icons.search_outlined,
                color: Colors.grey[500],
                size: 16.0,
              ),
              onPressed: () {})
              : Icon(
            Icons.search_outlined,
            color: Colors.grey[500],
            size: 16.0,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100].withOpacity(0.3)),
              borderRadius: BorderRadius.circular(30.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100].withOpacity(0.3)),
              borderRadius: BorderRadius.circular(30.0)),
          contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
          labelText: "Search...",
          hintStyle: TextStyle(
              fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w500),
          labelStyle: TextStyle(
              fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        autocorrect: false,
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }
}
