import 'package:easyparking/api/auth_api.dart';
import 'package:easyparking/pages/DefaultScreen.dart';
import 'package:easyparking/pages/QrScanner.dart';
import 'package:easyparking/pages/SitesAvailables.dart';
import 'package:easyparking/pages/alertSend.dart';
import 'package:easyparking/pages/ParkingInformation.dart';
import 'package:easyparking/pages/SignUp.dart';
import 'package:easyparking/pages/ListVehiculosPage.dart';
import 'package:easyparking/pages/ListVisitasPage.dart';
import 'package:easyparking/providers/push_notifications.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easyparking/providers/user_pro.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


  @override
  void initState() {
    super.initState();

    final pushProvider = new PushNotification();
    pushProvider.initNotifications();

    pushProvider.mensajes.listen( (data) {

      // Navigator.pushNamed(context, 'mensaje');
      print('Argumento del Push');
      print(data);

      navigatorKey.currentState.pushNamed('sendAlert', arguments: data );

    });

  }

  @override
  Widget build(BuildContext context) {
    return Providers(
      auth: Auth(), 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'home',
        routes: {
          'parkinginfo'     : ( BuildContext context ) => ParkingInformation(),
          'home'            : ( BuildContext context ) => DefaultScreen(),
          'sitesAvailables' : (BuildContext context ) => SitesAvailables(),
          'qrscanner'       : (BuildContext context ) => QrScanner(),
          'singup'          : (BuildContext context ) => SingUpPage(),
          'visitaspage'     : (BuildContext context ) => VisitasPage(),
          'vehiculospage'     : (BuildContext context ) => VehiculosPage(),
          'sendAlert'         : (BuildContext context ) => AlertSend(),
          
        },
      ),
    );
  }
}

