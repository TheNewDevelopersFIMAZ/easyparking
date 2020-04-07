
import 'package:easyparking/models/parking_info_model.dart';
import 'package:easyparking/models/sitesAvailablesModel.dart';
import 'package:easyparking/pages/home.dart';
import 'package:easyparking/providers/parking_info_provider.dart';
import 'package:easyparking/providers/sitesAvailableProvider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 
class SitesAvailables extends StatefulWidget {
  @override
  _SitesAvailablesState createState() => _SitesAvailablesState();
}

class _SitesAvailablesState extends State<SitesAvailables> {
  SitesAvailableProvider sitesProvider = new SitesAvailableProvider();
  PreferenciasUsuario usuariopre = new PreferenciasUsuario();
  final ParkingInfoProvider parkingInfoProvider = new ParkingInfoProvider();
  ParkingInfoModel parkingInfo = new ParkingInfoModel();
  Color color = Colors.grey;
  bool isSelected = false;
  SitesAvailablesModel siteModel;
  final List<bool> listaSelected = [];
  final List<bool> disabled = [];
  final List<Widget> listaWidget = [];
  String valor = "";
  List<Color> colors = [];
  bool iterate = false;
  bool _isFetching = false; 
  String locationInfo = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sitesProvider.cargarLocationAvailable();
  }


  @override
  Widget build(BuildContext context) {

    final String siteLocation = ModalRoute.of(context).settings.arguments;
    if ( siteLocation != "" ) {
      locationInfo = siteLocation;
    }
    
    return Scaffold(
        appBar: AppBar(
          title: Text(locationInfo),
          backgroundColor: Colors.cyan
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Container ( 
                      margin: EdgeInsets.only( left:10, right: 10, top: 10),
                      decoration:BoxDecoration(color: Colors.cyan, border: Border.all(color: Colors.cyan, width: 3), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(right: 5),
                            child: new Icon(
                              Icons.directions_car, 
                                color: Colors.white,
                              ),
                            ),
                          new Text("Estacionamientos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                          ))
                      ],
                    )),
                  Expanded(
                      child: Container(
                      decoration:BoxDecoration(color: Colors.white, border: Border.all(color: Colors.cyan, width: 3), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                      margin: EdgeInsets.only(left:10, right: 10),
                        //height: 10.0,
                        child: FutureBuilder(
                          future: sitesProvider.cargarParkingAvailable(siteLocation.toLowerCase()),
                          builder:  (context, AsyncSnapshot<List<SitesAvailablesModel>> snapshot){
                            if(snapshot.hasData){
                              
                              return estacionamientos(snapshot.data);
                            }else {
                              return Center( child: CircularProgressIndicator(backgroundColor: Colors.transparent, valueColor:new AlwaysStoppedAnimation<Color>(Colors.cyan) ,));
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical:10, horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          estado(Colors.grey, "No disponible"),
                          estado(Color.fromRGBO(30, 30, 30, 1), "Disponible"),
                          estado(Colors.teal, "Seleccionado"),
                        ],
                      )
                    ),
                    new Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.black12))
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: new RaisedButton(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            textColor: Colors.white,
                            color: color,
                            onPressed: () => isSelected ? _onSelectedSite() : {},
                            child: new Text("Siguiente",
                            style: TextStyle(
                              fontSize: 18,
                            ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                ],
              )
            ),
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
        )
    );
  }

  Widget estado(Color color, String estado){

    return new Expanded(
      //margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: 10),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(5))
            ),
          ),
          new Expanded(
            child: new Text(estado,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            )
          )
        ],
      ),
    );
  }

  Widget estacionamientos(List<SitesAvailablesModel> sites){
    
    int j = 0;

    if(!iterate){

      for( j = 0 ; j < sites.length ; j++ ){
        
        if(sites[j].disponibilidad){
          colors.add(Color.fromRGBO(31, 31, 31, 1));
          disabled.add(true);
        }else{
          disabled.add(false);
          colors.add(Colors.grey);          
        }
          final selected = false;
          final widgetRow = Container(
                        child: Text("# ${sites[j].numero}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white
                          ),
                          ),
                        
                      );
          listaWidget.add(widgetRow);
          listaSelected.add(selected);
      }
      iterate = true;
    }
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(listaWidget.length, (index) {
        return Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colors.elementAt(index),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.white)
            ),
            child: RaisedButton(
              color: Colors.transparent,
              onPressed: () => disabled.elementAt(index)||!usuariopre.selected ? _onClick(index, sites[index].numero, sites[index]) : {},
              child: listaWidget.elementAt(index),
            ),
          )
        );
      }),
    );
  }

  _onClick(int index, String value, SitesAvailablesModel model){
    setState((){
        listaSelected[index] = !listaSelected[index];
        if(listaSelected[index] && !isSelected){
          colors[index] = Colors.teal;
          color = Colors.teal;
          isSelected = true;
          valor = value;
          siteModel = model;
        }else{
          if(isSelected && valor == value){
            colors[index] = Color.fromRGBO(31, 31, 31, 1);
            isSelected = false;
            color = Colors.grey;
          }
          
        }
    });
  }

  _onSelectedSite() {
    Dialogs.confirm(context, title: "Continuar", message: "¿Seguro que quieres estacionarte en el sitio ${valor}?",
        onCancel: () {
          Navigator.pop(context);
        }, onConfirm: () async {
          setState(() {
            _isFetching = true;
          });
          Navigator.pop(context);
          try {
            
            if(!usuariopre.selected){
              siteModel.disponibilidad = false;
              final verify = await sitesProvider.editarParkingAvailable(siteModel, locationInfo.toLowerCase());
              if(verify){
                usuariopre.selected = true;
                usuariopre.startCronometer = true;
                usuariopre.selectedSite = siteModel.id;
                usuariopre.selectedNumber = siteModel.numero.toString();
                usuariopre.selectedLocation = locationInfo.toLowerCase();
                var dDay = new DateTime.now();
                List<String> list = dDay.toString().split(" ");
                List<String> listhora = list[1].split(".");
                parkingInfo.image = "https://miuniversidadmazatlan.com/wp-content/uploads/2019/02/uas-mazatlan.jpg";
                parkingInfo.fecha = list[0];
                parkingInfo.hraentrada = listhora[0];
                usuariopre.fechaInfo = list[0];
                usuariopre.entradaInfo = listhora[0];
                parkingInfo.hrasalida = "";
                parkingInfo.tiempo = "";
                parkingInfo.costo = 0.0;
                parkingInfo.cajon = siteModel.numero.toString();
                parkingInfo.estado = true;
                parkingInfo.lugar = locationInfo.toLowerCase();
                usuariopre.idParkingInfo = await parkingInfoProvider.crearParkingInfo(usuariopre.token, parkingInfo);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute( builder: (context) => HomePage() ), ModalRoute.withName("/home"));
              }else{
                
                Dialogs.alert(context, title: "Ha ocurriodo un problema", message: "El sitio ya ha sido seleccionado");
              }
              
            }else{
              Dialogs.alert(context, title: "Actividad en proceso", message: "Ya se ha seleccionado un lugar de estacionamiento por favor finaliza para poder solicitar uno nuevo");
            }
            
          } catch (e) {
            print(e);
            Dialogs.alert(context, title: "Error de conexión", message: "No se ha podido realizar la petición");
          }
          setState(() {
            _isFetching = false;
          });
        });
  }
}