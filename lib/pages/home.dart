
import 'package:easyparking/pages/Parking.dart';
import 'package:easyparking/pages/Scanner_QR.dart';
import 'package:easyparking/pages/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easyparking/utils/session.dart';
import '../providers/me.dart';
//import '../models/user.dart';
import '../utils/dialogs.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Me _me;

  @override
  void initState() {
    super.initState();
  }
  int _selectedIndex = 0;
  String _counter, _value = "";
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    new ScannerQr(),
    new Parking(),
    new User(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _onExit() {
    Dialogs.confirm(context, title: "COFIRM", message: "Are you sure?",
        onCancel: () {
          Navigator.pop(context);
        }, onConfirm: () async {
          Navigator.pop(context);
          Session session = Session();
          await session.clear();
          Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
        });
  }

  @override
  Widget build(BuildContext context) {
    _me = Me.of(context);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyParking'),
        backgroundColor: Colors.blue,
        brightness: Brightness.light,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (String value) {
              if (value == "exit") {
                _onExit();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "share",
                child: Text("Share App"),
              ),
              PopupMenuItem(
                value: "exit",
                child: Text("Exit App"),
              )
            ],
          )
        ],
        elevation: 0,
      ),
      body: Center(
        //child: Text(_me.data.toJson().toString()),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.crop_free),
            title: Text('Scanner'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text('Parkings'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Person'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}