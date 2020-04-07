import 'dart:convert';

import 'package:flutter/services.dart';


class _MenuProvider{

  List<dynamic> opciones =[];

  _MenuProvider(){
    //cargarData();
  }
    
  Future<List<dynamic>>cargarData() async{
    
    final resp = await rootBundle.loadString('data/menu_opts.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];

    return opciones;
  }

  Future<List<dynamic>>cargarDataParking() async{
    
    final resp = await rootBundle.loadString('data/cards_parking.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['parkings'];

    return opciones;
  }

  Future<List<dynamic>>cargarDataMakers() async{
    
    final resp = await rootBundle.loadString('data/markers_parking.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['markers'];

    return opciones;
  }
}

final menuProvider = new _MenuProvider();