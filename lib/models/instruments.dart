import 'dart:convert';

List<Instrument> instrumentFromJson(String str) =>
    List<Instrument>.from(json.decode(str).map((x) => Instrument.fromJson(x)));

String instrumentToJson(List<Instrument> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Instrument {
  Instrument({
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

  factory Instrument.fromJson(Map<String, dynamic> json) => Instrument(
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
