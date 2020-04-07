import 'package:easyparking/pages/home.dart';
import 'package:easyparking/pages/login.dart';
import 'package:easyparking/providers/user_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../api/auth_api.dart';

class DefaultScreen extends StatefulWidget {
  @override
  _DefaultScreenState createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {

  @override
  Widget build(BuildContext context) {
    final Auth auth = Providers.of(context).auth;
    
    return Scaffold(
        body: StreamBuilder<String>(
          stream: auth.onAuthStateChanged,
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final bool loggedIn = snapshot.hasData;
              if (loggedIn == true) {
                return HomePage();
              } else {
                return LoginPage();
              }
            }
            return CircularProgressIndicator(strokeWidth: 0.4,);
          },
        ),
    );
  }
}