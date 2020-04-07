// To parse this JSON data, do
//
//     final sitesAvailablesModel = sitesAvailablesModelFromJson(jsonString);

import 'dart:convert';

SitesAvailablesModel sitesAvailablesModelFromJson(String str) => SitesAvailablesModel.fromJson(json.decode(str));

String sitesAvailablesModelToJson(SitesAvailablesModel data) => json.encode(data.toJson());

class SitesAvailablesModel {
    String id;
    bool disponibilidad;
    String numero;

    SitesAvailablesModel({
        this.id,
        this.disponibilidad,
        this.numero,
    });

    factory SitesAvailablesModel.fromJson(Map<String, dynamic> json) => SitesAvailablesModel(
        id: json["id"],
        disponibilidad: json["disponibilidad"],
        numero: json["numero"],
    );

    Map<String, dynamic> toJson() => {
        //"id": id,
        "disponibilidad": disponibilidad,
        "numero": numero,
    };
}