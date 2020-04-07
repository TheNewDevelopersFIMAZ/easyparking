import 'package:easyparking/models/parking_info_model.dart';
import 'package:easyparking/providers/parking_info_provider.dart';
import 'package:easyparking/providers/sitesAvailableProvider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/dialogs.dart';
import 'package:easyparking/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttie/fluttie.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class QrScanner extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<QrScanner> {
  
  String qr;
  bool camState = true;
  bool _isFlash = false, _isFoundQRcode = false;
  bool _mainScanner = false;
  bool _isFetching = false;
  SitesAvailableProvider sitesProvider = new SitesAvailableProvider();
  PreferenciasUsuario usuariopre = new PreferenciasUsuario();
  ParkingInfoModel parkingInfo = new ParkingInfoModel();
  final ParkingInfoProvider parkingInfoProvider = new ParkingInfoProvider();

  @override
  initState() {
    super.initState();
    //_metod();
  }

  Future<FluttieAnimation>_metod(String name) async{
    var instance = new Fluttie();
    var emojiComposition = await instance.loadAnimationFromAsset("assets/animations/${name}");
    FluttieAnimationController emojiAnimation = await instance.prepareAnimation(emojiComposition,
    duration: const Duration(seconds: 5),
    repeatCount: const RepeatCount.infinite(),
    repeatMode: RepeatMode.START_OVER);
    emojiAnimation.start();
    return new FluttieAnimation(emojiAnimation);
  }

  @override
  Widget build(BuildContext context) {
    final bool scannerResponse = ModalRoute.of(context).settings.arguments;
    if ( scannerResponse != null ) {
      _mainScanner = scannerResponse;
    }
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    BorderSide borderVertical = new BorderSide(width: _mainScanner ? responsive.wp(45):responsive.wp(28), color: Color.fromRGBO(37, 37, 38,0.3));
    BorderSide borderHorizontal = new BorderSide(width: responsive.wp(15), color: Color.fromRGBO(37, 37, 38,0.3));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: !_isFoundQRcode ? new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: camState
                    ? new Center(
                        child: new Container(
                          color:Colors.black87,
                          child: new QrCamera(
                            onError: (context, error) => Text(
                                  error.toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                            qrCodeCallback: (code) {
                              setState(() {
                                qr = code;
                                _isFoundQRcode = true;
                                !usuariopre.selected 
                                ? _mainScanner 
                                ? Navigator.pushNamed(context, 'singup', arguments: qr)
                                :scannSite()
                                :Dialogs.alert(
                                  context, 
                                  title: "Ha ocurrido un problema", 
                                  message: "Existe un proceso en curso", 
                                  color: Colors.red,
                                  localMethod: false, 
                                  onContinue: (){setState(() { 
                                    _isFoundQRcode = false;
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            },
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  width: size.width*0.7,
                                  left: responsive.wp(15),
                                  top: _mainScanner ? responsive.wp(25):responsive.wp(10),
                                  child: new Container(
                                        child: Center(
                                          child: Text("Escanear Código QR", style: TextStyle(color: Colors.white, fontSize: 25)),
                                        ),
                                      ),
                                ),
                                Positioned(
                                  width: size.width*0.7,
                                  left: responsive.wp(15),
                                  top: _mainScanner ? responsive.wp(130):responsive.wp(110),
                                  child: new Container(
                                        child: Center(
                                          child: Text("Coloque la cámara encima del código QR",textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, fontSize: 20)),
                                        ),
                                      ),
                                ),
                                Positioned(
                                  width: responsive.wp(100),
                                  top: responsive.wp(0),
                                  bottom: responsive.wp(0),
                                  child: new Container(
                                    decoration: BoxDecoration(
                                      border: Border(top: borderVertical, bottom: borderVertical, left: borderHorizontal, right: borderHorizontal)
                                      //style: BorderStyle.solid, width: responsive.wp(15), color: Color.fromRGBO(37, 37, 38,0.3)
                                    ),
                                    //padding: EdgeInsets.only(right: 50, left: 50, top: 90, bottom: 90),
                                    child: Center(
                                      child: new Container(
                                          child: FutureBuilder<FluttieAnimation>(
                                            builder: (context, AsyncSnapshot<FluttieAnimation> snapshot){
                                              FluttieAnimation scanAnimation;
                                              //if (snapshot.hasData) {
                                                scanAnimation = snapshot.data;
                                              //}
                                              return Container(
                                                width: size.width,
                                                height: size.height,
                                                child: scanAnimation
                                              );
                                            },
                                            future: _metod("barcode_scanner.json"),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  top: 15,
                                  child: SafeArea(
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(10),
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.black12,
                                      child: _isFlash ? Icon(
                                        Icons.flash_on,
                                        color: Colors.yellow,
                                        size: 30,
                                      )
                                      : Icon(
                                          Icons.flash_off,
                                          color: Colors.yellow,
                                          size: 30,
                                        ),
                                      onPressed: (){
                                        setState(() {
                                          _isFlash ? _isFlash = false : _isFlash = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                _mainScanner ? Positioned(
                                  left: 15,
                                  top: 5,
                                  child: SafeArea(
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(10),
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.black12,
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ):Container(),
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
                            notStartedBuilder: (context){ 
                              return new Center(
                                child:new Container(
                                  child: CircularProgressIndicator()
                                ),
                              );  
                            },
                          ),
                        ),
                      )
                    : new Center(child: new Text("Camera inactive"))),
            //new Text("QRCODE: $qr"),
          ],
        ),
      ):Container(
          color: Color.fromRGBO(51, 51, 51, 1),
        ),
    );
    
  }

  scannSite()async{
    try{
      setState(() {
        _isFetching = true;
      });
      List<String> locationInfo = qr.split("/").toList();
      dynamic respond = await sitesProvider.editarParkingAvailableQR(qr);
      if(respond == 1){
        Dialogs.alert(
          context, 
          title: "Ha ocurrido un error", 
          message: "El lugar ya esta ocupado", 
          localMethod: false,
          onContinue: (){setState(() { 
            _isFoundQRcode = false;
            Navigator.pop(context);
          });
        });
      }else{
        if(respond == 0){
          
          Dialogs.alert(
            context, 
            title: "Ha ocurrido un error", 
            message: "No se ha podido establecer conexión", 
            localMethod: false,
            onContinue: (){setState(() { 
            _isFoundQRcode = false;
            Navigator.pop(context);
          });
        });
        }else{
          usuariopre.selected = true;
          usuariopre.selected = true;
          usuariopre.startCronometer = true;
          usuariopre.selectedSite =  locationInfo[2];
          usuariopre.selectedNumber = respond.numero.toString();
          usuariopre.selectedLocation = locationInfo[1].toLowerCase();
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
          parkingInfo.cajon = respond.numero.toString();
          parkingInfo.estado = true;
          parkingInfo.lugar = locationInfo[1].toLowerCase();
          usuariopre.idParkingInfo = await parkingInfoProvider.crearParkingInfo(usuariopre.token, parkingInfo);
          Dialogs.alert(
            context, 
            title: "Registro correcto", 
            message: "Se a seleccionado el lugar de forma exitosa", 
            localMethod: true,
            onContinue: (){setState(() { 
            _isFoundQRcode = false;
            Navigator.pop(context);
          });
        });
        }
      }
    }catch(e){
      Dialogs.alert(
        context, 
        title: "Ha ocurrido un error", 
        message: "error", 
        localMethod: true,
        onContinue: (){setState(() { 
            _isFoundQRcode = false;
            Navigator.pop(context);
          });
        });
    }
    setState(() {
      _isFetching = false;
    });
  }

  dialog(){
  Dialogs.confirm(
            context,
            title: "Verifica si la informacion es correcta",
            message:qr,
            onCancel: () {
              setState(() { 
              _isFoundQRcode = false;
              Navigator.pop(context);
              });
            }, onConfirm: _mainScanner ? () {
              Navigator.pushNamed(context, 'singup', arguments: qr);
            }:()=> setState(() { 
              _isFoundQRcode = false;
              Navigator.pop(context);
              sitesProvider.editarParkingAvailableQR(qr);
              })
          );
    
  }
}