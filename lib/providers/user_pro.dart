  
import 'package:easyparking/api/auth_api.dart';
import 'package:flutter/material.dart';

class Providers extends InheritedWidget {
  final BaseAuth auth;

  Providers({ 
    Key key,
    Widget child,
    this.auth,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Providers of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Providers) as Providers);
}