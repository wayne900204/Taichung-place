import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';
import 'package:taichung_place/models/taichung_place_models.dart';

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
            'AI 植物辨識',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.item.name!=null?ListTile(
                  leading: Text( "名稱："),
                  title: Text( widget.item.name),
                ):Container(),
                widget.item.phoneNumber==null||widget.item.phoneNumber==""?Container():ListTile(
                  leading: Text( '電話號碼：'),
                  title: Text( widget.item.phoneNumber??""),
                ),
                widget.item.address==''||widget.item.address==null?Container():ListTile(
                  leading: Text( '地址'),
                  title: Text( widget.item.address??""),
                ),
                widget.item.drivingInfo==null||widget.item.drivingInfo==""?Container():ListTile(
                  leading: Text('行車資訊：'),
                  title: Text( widget.item.drivingInfo??""),
                ),
                widget.item.travelInfo==''||widget.item.drivingInfo==null?Container():ListTile(
                  leading: Text('旅遊資訊：'),
                  title: Text( widget.item.travelInfo??""),
                ),
                makeHtml(),
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

