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
                MyListTitle(leading: "名稱：", title: widget.item.name),
                MyListTitle(leading: '簡述：', title: widget.item.summary),
                MyListTitle(leading: '地址：', title: widget.item.address),
                MyListTitle(leading: '電話：', title: widget.item.phoneNumber ?? ""),
                MyListTitle(
                    leading: '大眾運輸：', title: widget.item.publicTransportation ?? ""),
                MyListTitle(leading: '行車資訊：', title: widget.item.drivingInfo ?? ""),
                MyListTitle(leading: '門票資訊：', title: widget.item.ticketInfo ?? ""),
                MyListTitle(leading: '旅遊叮嚀：', title: widget.item.travelInfo ?? ""),
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

class MyListTitle extends StatelessWidget {
  final String leading;
  final String title;

  MyListTitle({this.leading, this.title});

  @override
  Widget build(BuildContext context) {
    if (leading != null ||
        title != null ||
        title != "" ||
        leading != "" ||
        leading.toString() != "null" ||
        title.toString() != "null") {
      print("???");
      return ListTile(
        leading: Text(leading),
        title: Text(title),
      );
    } else {

      return Container();
    }
  }
}
