import 'dart:convert';

List<Data> dataFromJson(String str) =>
    List<Data>.from(json.decode(str).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
  Data({
    required this.id,
    required this.deviceId,
    required this.stationName,
    required this.barangay,
    required this.status,
  });

  int id;
  String deviceId;
  String stationName;
  String barangay;
  int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        deviceId: json["device_id"],
        stationName: json["station_name"],
        barangay: json["barangay"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "station_name": stationName,
        "barangay": barangay,
        "status": status,
      };
}
