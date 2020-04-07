import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertSend extends StatefulWidget {
  @override
  _AlertSendState createState() => _AlertSendState();
}

class _AlertSendState extends State<AlertSend> {
  final _formKey = GlobalKey<FormState>();
  PreferenciasUsuario usuario = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    String argument = ModalRoute.of(context).settings.arguments;
    Map argumentMap = json.decode('{"tipovehiculo": "Camioneta", "color": "Roja", "placas": "RF3425"}');
    final responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerta de Robo'),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 350,
            minWidth: 350,
          ),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Container(
                        child: Text(
                      "Información del vehículo",
                      style: TextStyle(color: Colors.black, fontSize: 26),
                    )),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: responsive.hp(1.5)),
                        Container(
                            child: Text(
                          "Vehiculo: ${argumentMap['tipovehiculo']}",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        )),
                        SizedBox(height: responsive.hp(1.5)),
                        Container(
                            child: Text(
                          "Color: ${argumentMap['color']}",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        )),
                        SizedBox(height: responsive.hp(1.5)),
                        Container(
                            child: Text(
                          "Placas: ${argumentMap['placas']}",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        )),
                        SizedBox(height: responsive.hp(1.5)),
                        Container(
                            child: Text(
                          "Correo:  ${argumentMap['correo']}",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        )),
                      ]),
                  SizedBox(height: responsive.hp(1.5)),
                  Container(
                      child: Text(
                    "Cualquier informacion sobre el paradero del vehículo favor de comunicarse al correo del usuario, si has visto el vehículo serca de tu ubicación selecciona el boton enviar alerta. *Maria Fernanda* espera tu apoyo de antemano ¡Gracias!",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  )),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 350,
                      minWidth: 350,
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: responsive.ip(2)),
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(4),
                      onPressed: () {},
                      child: Text("Enviar Alerta",
                          style: TextStyle(fontSize: responsive.ip(2.5))),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
