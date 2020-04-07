import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyparking/models/usuario_model.dart';
import 'package:easyparking/providers/user_provider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/dialogs.dart';
import 'package:easyparking/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final UserProvider userProvider = new UserProvider();

  final PreferenciasUsuario userPreferences = PreferenciasUsuario();
  UsuariosModel userModel = UsuariosModel();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    return Scaffold(
        backgroundColor: Color.fromRGBO(240, 240, 252, 0.5),
        body: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: userProvider.cargarUsuario(userPreferences.token),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        final userModel = UsuariosModel.fromJson(snapshot.data);

                        return Card(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 5, right: 5, left: 5),
                                color: Colors.cyan,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        new Container(
                                          width: size.width * 0.29,
                                          height: size.width * 0.29,
                                          decoration: new BoxDecoration(
                                            color: Colors.cyan,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3.0,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 80,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            userModel.nombre,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                          new Text(
                                            "  ${userModel.apellido}",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                          new Text(
                                            "    ${userModel.email}",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                          new Text(
                                            "  ${userModel.placasCarro}",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                          new Text(
                                            userModel.marcaCarro,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 15,
                                top: 5,
                                child: SafeArea(
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(10),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.black12,
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Card(
                          child: Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.cyan,
                              child: _shimmer(size, responsive)),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Card(
                child: Container(
                    child: Column(children: <Widget>[
              buttonFlat(() {
                Navigator.pushNamed(context, "visitaspage");
              }, Icons.watch_later, "Ultimas Visitas"),
              buttonFlat(() {
                Navigator.pushNamed(context, "vehiculospage",
                    arguments: userModel);
              }, Icons.directions_car, "Vehículos"),
              buttonFlat(() {}, Icons.credit_card, "Metodos de Pago"),
              buttonFlat(() {
                Dialogs.confirm(context,
                    height: 300,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onConfirm: () =>
                        onSendMessage("Camioneta", "Roja", "RF3425"),
                    title: "Mandar Alerta",
                    message:
                        "Deceas mandar una alerta de robo con la siguiente información: \nVehículo: Ford\nPlacas:RF3425");
              }/*Navigator.pushNamed(context, "sendAlert");}*/, Icons.add_alert, "Enviar Alerta de Robo"),
            ]))),
          ],
        ));
  }

  FlatButton buttonFlat(VoidCallback onClick, IconData icon, String title) {
    return FlatButton(
      onPressed: onClick,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  child: Tab(
                      icon: Icon(
                    icon,
                    color: Colors.cyan,
                    size: 50,
                  )),
                ),
                Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(title,
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 20,
                        )),
                  )
                ])
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 5,
            child: Container(
              child: Tab(
                  icon: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.cyan,
                size: 20,
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget _shimmer(Size size, Responsive responsive) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            new Container(
                margin: EdgeInsets.all(5),
                width: size.width * 0.29,
                height: size.width * 0.29,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                )),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              width: 100.0,
              height: 12.0,
              color: Colors.white,
            ),
            SizedBox(height: responsive.hp(1.5)),
            new Container(
              width: 120.0,
              height: 12.0,
              margin: EdgeInsets.only(left: 5),
              color: Colors.white,
            ),
            SizedBox(height: responsive.hp(1.5)),
            new Container(
              width: 200.0,
              height: 12.0,
              margin: EdgeInsets.only(left: 10),
              color: Colors.white,
            ),
            SizedBox(height: responsive.hp(1.5)),
            new Container(
              width: 100.0,
              height: 12.0,
              margin: EdgeInsets.only(left: 5),
              color: Colors.white,
            ),
            SizedBox(height: responsive.hp(1.5)),
            new Container(
              width: 100.0,
              height: 12.0,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  onSendMessage(String content, String color, String placas) {
    Navigator.pop(context);
    if (content.trim() != '') {
      var documentReference = Firestore.instance
          .collection('alerta_de_robo')
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idUsuario': "46s7PpHIxlVcfri7x1uxODZKhNI2",
            'correo': userModel.email,
            'tipovehiculo': content,
            'color': color,
            'placas': placas,
          },
        );
        print("Correcto");
      });
      //listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Error");
      //Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }
}

// First Attempt
