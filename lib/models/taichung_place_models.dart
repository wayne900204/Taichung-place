// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<TaichungPlaceModel> userFromJson(String str) => List<TaichungPlaceModel>.from(json.decode(str).map((x) => TaichungPlaceModel.fromJson(x)));

String userToJson(List<TaichungPlaceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaichungPlaceModel {
  TaichungPlaceModel({
    this.id,
    this.status,
    this.name,
    this.summary,
    this.introduction,
    this.township,
    this.address,
    this.eastLongitude,
    this.northLatitude,
    this.phoneNumber,
    this.publicTransportation,
    this.ticketInfo,
    this.drivingInfo,
    this.parkInfo,
    this.travelInfo,
  });

  String id;
  Empty status;
  String name;
  String summary;
  String introduction;
  Enum township;
  String address;
  String eastLongitude;
  String northLatitude;
  String phoneNumber;
  String publicTransportation;
  String ticketInfo;
  String drivingInfo;
  String parkInfo;
  String travelInfo;

  factory TaichungPlaceModel.fromJson(Map<String, dynamic> json) => TaichungPlaceModel(
    id: json["景點ID"],
    status: emptyValues.map[json["狀態"]],
    name: json["名稱"],
    summary: json["簡述"],
    introduction: json["介紹"],
    township: enumValues.map[json["鄉鎮市區"]],
    address: json["地址"],
    eastLongitude: json["東經"],
    northLatitude: json["北緯"],
    phoneNumber: json["電話"],
    publicTransportation: json["大眾運輸"],
    ticketInfo: json["門票資訊"],
    drivingInfo: json["行車資訊"],
    parkInfo: json["停車資訊"],
    travelInfo: json["旅遊叮嚀"],
  );

  Map<String, dynamic> toJson() => {
    "景點ID": id,
    "狀態": emptyValues.reverse[status],
    "名稱": name,
    "簡述": summary,
    "介紹": introduction,
    "鄉鎮市區": enumValues.reverse[township],
    "地址": address,
    "東經": eastLongitude,
    "北緯": northLatitude,
    "電話": phoneNumber,
    "大眾運輸": publicTransportation,
    "門票資訊": ticketInfo,
    "行車資訊": drivingInfo,
    "停車資訊": parkInfo,
    "旅遊叮嚀": travelInfo,
  };
}

enum Empty { EMPTY, PURPLE }

final emptyValues = EnumValues({
  "開啟": Empty.EMPTY,
  "關閉": Empty.PURPLE
});

enum Enum { EMPTY, PURPLE, FLUFFY, TENTACLED, STICKY, INDIGO, INDECENT, HILARIOUS, AMBITIOUS, CUNNING, MAGENTA, FRISKY, MISCHIEVOUS, BRAGGADOCIOUS, THE_1, THE_2, THE_3, THE_4, THE_5, THE_6, THE_7, THE_8, THE_9, THE_10, THE_11, THE_12, THE_13, THE_14, THE_15, THE_16 }

final enumValues = EnumValues({
  "后里區": Enum.AMBITIOUS,
  "北屯區": Enum.BRAGGADOCIOUS,
  "大甲區": Enum.CUNNING,
  "潭子區": Enum.EMPTY,
  "大雅區": Enum.FLUFFY,
  "南區": Enum.FRISKY,
  "大安區": Enum.HILARIOUS,
  "梧棲區": Enum.INDECENT,
  "外埔區": Enum.INDIGO,
  "霧峰區": Enum.MAGENTA,
  "東區": Enum.MISCHIEVOUS,
  "沙鹿區": Enum.PURPLE,
  "豐原區": Enum.STICKY,
  "大肚區": Enum.TENTACLED,
  "大里區": Enum.THE_1,
  "中區": Enum.THE_10,
  "和平區": Enum.THE_11,
  "新社區": Enum.THE_12,
  "神岡區": Enum.THE_13,
  "烏日區": Enum.THE_14,
  "芬園鄉": Enum.THE_15,
  "石岡區": Enum.THE_16,
  "南屯區": Enum.THE_2,
  "清水區": Enum.THE_3,
  "北區": Enum.THE_4,
  "西區": Enum.THE_5,
  "太平區": Enum.THE_6,
  "東勢區": Enum.THE_7,
  "西屯區": Enum.THE_8,
  "龍井區": Enum.THE_9
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
