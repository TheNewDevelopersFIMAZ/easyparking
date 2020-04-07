import 'dart:convert';

ParkingInfoModel parkingInfoModelFromJson(String str) => ParkingInfoModel.fromJson(json.decode(str));

String parkingInfoModelToJson(ParkingInfoModel data) => json.encode(data.toJson());

class ParkingInfoModel {
    String id;
    String fecha;
    String tiempo;
    String lugar;
    String cajon;
    double costo;
    bool estado;
    String image;
    String hraentrada;
    String hrasalida;

    ParkingInfoModel({
        this.id,
        this.fecha,
        this.tiempo,
        this.lugar,
        this.cajon,
        this.costo,
        this.estado,
        this.image,
        this.hrasalida,
        this.hraentrada
    });

    factory ParkingInfoModel.fromJson(Map<String, dynamic> json) => ParkingInfoModel(
        id: json["id"],
        fecha: json["fecha"],
        tiempo: json["tiempo"],
        lugar: json["lugar"],
        cajon: json["cajon"],
        costo: json["costo"],
        estado: json["estado"],
        image: json["image"],
        hraentrada: json["hraentrada"],
        hrasalida: json["hrasalida"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "tiempo": tiempo,
        "lugar": lugar,
        "cajon": cajon,
        "costo": costo,
        "estado": estado,
        "image": image,
        "hraentrada": hraentrada,
        "hrasalida": hrasalida
    };
}