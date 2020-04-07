import 'package:easyparking/api/auth_api.dart';
import 'package:easyparking/pages/MapLocationsParkings.dart';
import 'package:easyparking/pages/QrScanner.dart';
import 'package:easyparking/pages/login.dart';
import 'package:easyparking/pages/UserInformation.dart';
import 'package:easyparking/providers/push_notifications.dart';
import 'package:easyparking/providers/user_pro.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PreferenciasUsuario usuariopre = new PreferenciasUsuario();
  String token = ""; //no relevante
  final pushProvider = new PushNotification();

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 1;
  String _counter, _value = "";
  bool _isFetching = false;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    new QrScanner(),
    new MapLocationsParkings(),
    new UserInfo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _onExit() {
    Dialogs.confirm(
      context,
      title: "Salir",
      message: "¿Estas Seguro que deceas salir de la aplicacion?",
      icon: Icons.exit_to_app,
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () async {
        setState(() {
          _isFetching = true;
        });
        try {
          Auth auth = Providers.of(context).auth;
          await auth.signOut();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              ModalRoute.withName("/home"));
        } catch (e) {
          print(e);
        }
        setState(() {
          _isFetching = false;
        });
      },
    );
  }

  re() async {
    token = await pushProvider.getToken();
    Dialogs.alertToken(context,
        title: "Token", message: token, color: Colors.white, height: 200);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estacionando-Ando'),
        backgroundColor: Colors.cyan,
        brightness: Brightness.light,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (String value) {
              if (value == "exit") {
                !usuariopre.selected
                    ? _onExit()
                    : Dialogs.alert(context,
                        title: "Ha ocurrido un problema",
                        message: "Existe un proceso en curso",
                        color: Colors.red,
                        height: 200);
              } else {
                //no relevante
                re();
              } //
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "token",
                child: Text("Obtener token"),
              ),
              PopupMenuItem(
                value: "exit",
                child: Text("Salir"),
              )
            ],
          )
        ],
        elevation: 0,
      ),
      body: Center(
          child: Stack(children: <Widget>[
        _widgetOptions.elementAt(_selectedIndex),
        _isFetching
            ? Positioned.fill(
                child: Container(
                color: Colors.black38,
                child: Center(
                  child: CupertinoActivityIndicator(radius: 15),
                ),
              ))
            : Container()
      ])),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.crop_free,
              color: Colors.cyan,
            ),
            title: Text('Scanner', style: TextStyle(color: Colors.cyan)),
            //activeColor: Colors.black
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.cyan),
            title: Text('Parkings', style: TextStyle(color: Colors.cyan)),
            //activeColor: Colors.black
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.cyan),
            title: Text(
              'Perfil',
              style: TextStyle(color: Colors.cyan),
            ),
            //activeColor: Colors.black
          ),
        ],
        type: BottomNavigationBarType.shifting,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        //showElevation: true,
        //onItemSelected: _onItemTapped,
      ),
      //body: Container(color: Colors.blueAccent),
    );
  }
}
