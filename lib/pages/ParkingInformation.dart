import 'package:easyparking/models/parking_info_model.dart';
import 'package:flutter/material.dart';

class ParkingInformation extends StatelessWidget {
 
 ParkingInfoModel parkingInfo = new ParkingInfoModel();

  @override
  Widget build(BuildContext context) {
    final ParkingInfoModel parkingData = ModalRoute.of(context).settings.arguments;
    if ( parkingData != null ) {
      parkingInfo = parkingData;
    }
    String estado;
    parkingInfo.estado ? estado = "En Curso" : estado = "Finalizado";
    return Scaffold(
        appBar: AppBar(
          title: Text('Información de estacionamiento'),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(5),
            color: Color.fromRGBO(240, 240, 252, 1),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  height: 180,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/loading_circle.gif',
                    image:parkingInfo.image,
                    fit: BoxFit.fill,
                    width: 350,
                    ),
                ),
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
                          ),
                          child: Row(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.only(right: 5),
                                child: new Icon(
                                  Icons.location_on, 
                                  color: Colors.white,
                                ),
                              ),
                              new Text(parkingInfo.lugar,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0
                              ))
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 5,
                          ),
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                new Text("Tiempo: "+ parkingInfo.tiempo,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
                                    )
                                ),
                                new Text("Numero de cajón: " + parkingInfo.cajon,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
                                    )
                                ),
                                new Text("Fecha: "+ parkingInfo.fecha,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
                                    )
                                ),
                                new Text("Costo: " + parkingInfo.costo.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
                                    )
                                ),
                                new Text("Estado: " + estado,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
                                    )
                                ),
                                new Text("Hora de Entrada: " + parkingInfo.hraentrada,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
                                    )
                                ),
                                new Text("Hora de Salida: " + parkingInfo.hrasalida,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
                                    )
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ],
            )
          ),
        ),
      );
  }
}