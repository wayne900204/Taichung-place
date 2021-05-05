import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taichung_place/models/taichung_place_models.dart';
import 'package:taichung_place/place_info/place_listview_page.dart';

class PlaceWebView extends StatefulWidget {
  final TaichungPlaceModel item;

  PlaceWebView({this.item});

  @override
  _PlaceWebViewState createState() => _PlaceWebViewState();
}

class _PlaceWebViewState extends State<PlaceWebView> {
  @override
  Widget build(BuildContext context) {
    print(widget.item.phoneNumber.toString() + "EEEEEEE");
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.cyan[400],
            title: Text(
              widget.item.name,
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PlaceListPage()));
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.item.phoneNumber == null || widget.item.phoneNumber == ""
                    ? Container()
                    : ListTile(
                        leading: Text('電話號碼：'),
                        title: Text(widget.item.phoneNumber ?? ""),
                      ),
                widget.item.address == '' || widget.item.address == null
                    ? Container()
                    : ListTile(
                        leading: Text('地址'),
                        title: Text(widget.item.address ?? ""),
                      ),
                widget.item.drivingInfo == null || widget.item.drivingInfo == ""
                    ? Container()
                    : ListTile(
                        leading: Text('行車資訊：'),
                        title: Text(widget.item.drivingInfo ?? ""),
                      ),
                widget.item.travelInfo == '' || widget.item.drivingInfo == null
                    ? Container()
                    : ListTile(
                        leading: Text('旅遊資訊：'),
                        title: Text(widget.item.travelInfo ?? ""),
                      ),
                makeHtml(),
                widget.item.northLatitude == "" ||
                        widget.item.northLatitude == null ||
                        widget.item.eastLongitude == "" ||
                        widget.item.eastLongitude == null
                    ? Container()
                    : _MyMap(
                        eastLongitude: widget.item.eastLongitude,
                        northLatitude: widget.item.northLatitude),
              ],
            ),
          ),
        ));
  }

  Html makeHtml() {
    return Html(
      data: widget.item.introduction ?? "",
      //Optional parameters:
      customImageRenders: {
        networkSourceMatcher(domains: ["https://datacenter.taichung.gov.tw"]):
            (context, attributes, element) {
          return FlutterLogo(size: 36);
        },
        networkSourceMatcher(domains: ["https://datacenter.taichung.gov.tw"]):
            networkImageRender(
          headers: {"Custom-Header": "some-value"},
          altWidget: (alt) => Text(alt),
          loadingWidget: () => Text("Loading..."),
        ),
        // On relative paths starting with /wiki, prefix with a base url
        (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
            networkImageRender(
                mapUrl: (url) => "https://datacenter.taichung.gov.tw" + url),
        // // Custom placeholder image for broken links
        // networkSourceMatcher(): networkImageRender(altWidget: (_) => FlutterLogo()),
      },
      onLinkTap: (url) {
        print("Opening $url...");
      },
      onImageTap: (src) {
        print(src);
      },
      onImageError: (exception, stackTrace) {
        print(exception);
      },
    );
  }
}

class _MyMap extends StatefulWidget {
  final String eastLongitude;
  final northLatitude;

  _MyMap({this.northLatitude, this.eastLongitude});

  @override
  __MyMapState createState() => __MyMapState();
}

class __MyMapState extends State<_MyMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('myMarker'),
      draggable: false,
      onTap: () {
        print('marker Tapped');
      },
      position: LatLng(double.parse(widget.northLatitude),
          double.parse(widget.eastLongitude)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.center,
      //compassEnabled：旋轉地圖時右上角是否顯示指北針，預設為true
      // zoomGesturesEnabled：是否允許縮放手勢切換Camera Zoom Size，預設為true
      // rotateGesturesEnabled：是否允許旋轉手勢，預設為true
      // mapType：設定地圖樣式，共有四種normal、satellite(衛星)、hybrid(衛星+地形)、terrain(地形)
      child: GoogleMap(
        mapType: MapType.normal,
        compassEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(widget.northLatitude),
              double.parse(widget.eastLongitude)),
          zoom: 15.0, //Camera縮放尺寸，越近數值越大，越遠數值越小，預設為0
          bearing: 30, //Camera旋轉的角度，方向為逆時針轉動，預設為0
          // tilt: 120  //Camera侵斜角度
        ),
        zoomGesturesEnabled: false,
        markers: Set.from(allMarkers),
      ),
    );
  }
}
