import 'dart:convert';

List<Data> dataFromJson(String str) =>
    List<Data>.from(json.decode(str).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
  Data({
    required this.barangay,
    required this.stationName,
    required this.datetime,
    required this.egg,
  });

  String barangay;
  String stationName;
  String datetime;
  int egg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        barangay: json["barangay"],
        stationName: json["station_name"],
        datetime: json["datetime"],
        egg: json["egg"],
      );

  Map<String, dynamic> toJson() => {
        "barangay": barangay,
        "station_name": stationName,
        "datetime": datetime,
        "egg": egg,
      };
}
