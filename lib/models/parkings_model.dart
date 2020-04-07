import 'dart:convert';

ParkingsModel parkingsModelFromJson(String str) => ParkingsModel.fromJson(json.decode(str));

String parkingsModelToJson(ParkingsModel data) => json.encode(data.toJson());

class ParkingsModel {
    String id;
    String lugar;
    int parking;
    String image;
    double latitud;
    double longitud;
    String icon;

    ParkingsModel({
        this.id,
        this.lugar,
        this.parking,
        this.image,
        this.latitud,
        this.longitud,
        this.icon
    });

    factory ParkingsModel.fromJson(Map<String, dynamic> json) => ParkingsModel(
        id: json["id"],
        lugar: json["lugar"],
        parking: json["parking"],
        image: json["image"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        icon: json["icon"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lugar": lugar,
        "parking": parking,
        "image": image,
        "latitud": latitud,
        "longitud": longitud,
        "icon": icon
    };
}
