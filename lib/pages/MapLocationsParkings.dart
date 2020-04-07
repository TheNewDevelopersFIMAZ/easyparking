import 'dart:async';

import 'package:easyparking/models/parking_info_model.dart';
import 'package:easyparking/models/parkings_model.dart';
import 'package:easyparking/models/sitesAvailablesModel.dart';
import 'package:easyparking/pages/MapParkingsAreas.dart';
import 'package:easyparking/providers/parking_info_provider.dart';
import 'package:easyparking/providers/parking_provider.dart';
import 'package:easyparking/providers/sitesAvailableProvider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationsParkings extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapLocationsParkings> {
  PreferenciasUsuario usuariopre = new PreferenciasUsuario();
  bool _isFetching = false;
  //cronometro
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);
  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    if (!mounted) return;
    setState(() {
      _setStopwatchText();
    });
  }

  _startStopButtonPressed() {
    if (!mounted) return;
    setState(() {
      _stopWatch.start();
      _startTimeout();
    });
  }

  void _setStopwatchText() {
    usuariopre.cronometroTime =
        _stopWatch.elapsed.inHours.toString().padLeft(2, '0') +
            ':' +
            (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
            ':' +
            (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
  }
  ///////

  ParkingProvider parkingProvider = new ParkingProvider();
  SitesAvailableProvider sitesProvider = new SitesAvailableProvider();
  SitesAvailablesModel siteModel = new SitesAvailablesModel();
  final ParkingInfoProvider parkingInfoProvider = new ParkingInfoProvider();
  ParkingInfoModel parkingInfo = new ParkingInfoModel();
  BitmapDescriptor pinLocationIcon;
  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.5), 'assets/logo_apk.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    if (usuariopre.selected && usuariopre.startCronometer) {
      _startStopButtonPressed();
      usuariopre.startCronometer = false;
    }
    print(usuariopre.selected);
    print(usuariopre.startCronometer);
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.2267, -106.408),
    zoom: 12.4746,
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _buildTimer(),
          _buildContainer(),
          _isFetching
              ? Positioned.fill(
                  child: Container(
                  color: Colors.black38,
                  child: Center(
                    child: CupertinoActivityIndicator(radius: 15),
                  ),
                ))
              : Container()
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
          ),
        ]),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            Container(
              //width: MediaQuery.of(context).size.width*0.4,
              margin: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Lugar: ${usuariopre.selectedLocation}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      child: Text("Sitio: ${usuariopre.selectedNumber}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16)),
                    )
                  ]),
            ),
            Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  "Tiempo: ${usuariopre.cronometroTime}",
                  style: TextStyle(fontSize: 18),
                )),
            Container(
              //width: MediaQuery.of(context).size.width*0.1,
              margin: EdgeInsets.all(5),
              child: RaisedButton.icon(
                splashColor: usuariopre.selected ? Colors.cyan : Colors.grey,
                colorBrightness: Brightness.dark,
                onPressed: () => usuariopre.selected ? stopTime() : {},
                color: Colors.white,
                icon: Icon(Icons.stop,
                    color: usuariopre.selected ? Colors.red : Colors.grey),
                label: Text(
                  "Detener",
                  style: TextStyle(
                      color: usuariopre.selected ? Colors.red : Colors.grey),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _maps());
  }

  Widget _maps() {
    return FutureBuilder(
        future: parkingProvider.cargarParking(),
        builder: (context, AsyncSnapshot<List<ParkingsModel>> snapshot) {
          if (snapshot.hasData) {
            final markers = snapshot.data;

            if (markers != null) {
              return GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.terrain,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: _onMapCreated,
                markers: _markers(markers),
              );
            } else {
              return Center(
                  child: Container(
                      child: Column(
                children: <Widget>[
                  Text("No se ha podido establecer conexión",
                      style: TextStyle(fontSize: 30)),
                  Text("Intentelo de nuevo", style: TextStyle(fontSize: 15)),
                ],
              )));
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyan),
            ));
          }
        });
  }

  Set<Marker> _markers(List<ParkingsModel> data) {
    final Set<Marker> marker = {};
    data.forEach((opt) {
      final Marker markerTemp = Marker(
          markerId: MarkerId(opt.id),
          position: LatLng(opt.latitud, opt.longitud),
          infoWindow: InfoWindow(title: opt.lugar),
          icon: pinLocationIcon);
      marker.add(markerTemp);
    });
    return marker;
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: _lista()),
    );
  }

  Widget _lista() {
    return FutureBuilder(
        future: parkingProvider.cargarParking(),
        builder: (context, AsyncSnapshot<List<ParkingsModel>> snapshot) {
          if (snapshot.hasData) {
            final parking = snapshot.data;
            return ListView(
              scrollDirection: Axis.horizontal,
              children: _accionesRecientes(context, parking),
            );
          } else {
            return Center(child: Container());
          }
        });
  }

  List<Widget> _accionesRecientes(
      BuildContext context, List<ParkingsModel> data) {
    final List<Widget> opciones = [];
    data.forEach((opt) {
      final widgetTemp = Padding(
        padding: const EdgeInsets.all(8.0),
        child: _boxes(opt.image, opt.lugar, opt.parking, opt.icon),
      );
      opciones.add(SizedBox(width: 10.0));
      opciones.add(widgetTemp);
    });
    return opciones;
  }

  Widget _boxes(String image, String lugar, int parking, String icon) {
    return GestureDetector(
      onTap: () {
        //_gotoLocation(lat,long);
        final route =
            MaterialPageRoute(builder: (context) => MapParkingsAreas());
        Navigator.push(context, route);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: FadeInImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(image),
                        placeholder: AssetImage("images/loading_79.gif"),
                        fadeInDuration: Duration(milliseconds: 10),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer(lugar, icon),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer(String lugar, String icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            lugar,
            style: TextStyle(
                color: Colors.cyan,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 10.0),
        Container(
            width: 60,
            height: 60,
            child: Tab(
              icon: new Image.asset(
                "images/" + icon,
                color: Colors.cyan,
              ),
            )),
      ],
    );
  }

  /*Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }*/

  stopTime() async {
    Dialogs.confirm(context,
        title: "Finalizar",
        message: "¿Seguro que deceas teminar tu tiempo de estacionamiento?",
        onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () async {
      setState(() {
        _isFetching = true;
      });
      Navigator.pop(context);
      try {
        siteModel.id = usuariopre.selectedSite;
        siteModel.numero = usuariopre.selectedNumber;
        siteModel.disponibilidad = true;
        final verify = await sitesProvider.editarParkingAvailable(
            siteModel, usuariopre.selectedLocation);
        if (verify) {
          Dialogs.alert(context, title: "Exitoso", message: "Se ha finalizado");
          usuariopre.selected = false;
          var dDay = new DateTime.now();
          List<String> list = dDay.toString().split(" ");
          List<String> listhora = list[1].split(".");
          parkingInfo.image =
              "https://miuniversidadmazatlan.com/wp-content/uploads/2019/02/uas-mazatlan.jpg";
          parkingInfo.fecha = usuariopre.fechaInfo;
          parkingInfo.hraentrada = usuariopre.entradaInfo;
          parkingInfo.hrasalida = listhora[0];
          parkingInfo.tiempo = "";
          parkingInfo.costo = 0.0;
          parkingInfo.estado = false;
          parkingInfo.lugar = usuariopre.selectedLocation;
          parkingInfo.cajon = usuariopre.selectedNumber;
          usuariopre.cronometroTime = "00:00:00";
          usuariopre.selectedLocation = "";
          usuariopre.selectedNumber = "";
          usuariopre.selectedSite = "";
          await parkingInfoProvider.editarParkingInfo(
              usuariopre.token, usuariopre.idParkingInfo, parkingInfo);
          setState(() {
            _stopWatch.stop();
          });
        } else {
          Dialogs.alert(context,
              title: "Error",
              message: "Ha ocurrido un problema al realizar la consulta");
        }
      } catch (e) {
        Dialogs.alert(context,
            title: "Error", message: "No se ha podido establecer conexion");
      }
      setState(() {
        _isFetching = false;
      });
    });
  }
}
