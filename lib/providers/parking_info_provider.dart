import 'dart:convert';

import 'package:easyparking/models/parking_info_model.dart';
import "package:http/http.dart" as http;

class ParkingInfoProvider {

  final String _url = "https://easyparking-00001.firebaseio.com";
  //final String _apiFirebase = "AIzaSyDLYMLKM2u9mS3onoV1RLvqV2a4toIKAUw";
  //final PreferenciasUsuario _prefs = new PreferenciasUsuario(); 

  Future<String> crearParkingInfo(String usuario, ParkingInfoModel parkingInfo) async{

    final String url = "$_url/Parking_info/$usuario.json";

    final resp = await http.post( url, body: parkingInfoModelToJson(parkingInfo));

    if(resp==null)return"";

    Map<String, dynamic> decodeData = json.decode(resp.body);

    final List<String> parkingData = new List();

    decodeData.forEach( ( id, park ){

      final prodTemp = park;
      parkingData.add( prodTemp );

    });

    return parkingData[0];
  }

  Future<dynamic> editarParkingInfo( String usuario, String idInfo, ParkingInfoModel parkingInfo ) async {
    
    final url = '$_url/Parking_info/$usuario/$idInfo.json';

    final resp = await http.put( url, body: parkingInfoModelToJson(parkingInfo) );

    final decodedData = json.decode(resp.body);


    return true;

  }

  Future<List<ParkingInfoModel>> cargarParkingInfo(String usuario) async {

    final url  = '$_url/Parking_info/$usuario.json'; 
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    //print(decodedData);

    final List<ParkingInfoModel> parkingData = new List();

    if ( decodedData == null ) return [];

    decodedData.forEach( ( id, park ){

      final prodTemp = ParkingInfoModel.fromJson(park);
      parkingData.add( prodTemp );

    });

    return parkingData;

  }


  Future<int> borrarParkingInfo( String id ) async { 

    final url  = '$_url/Usuarios/$id.json';
    final resp = await http.delete(url);

    print( resp.body );

    return 1;
  }
  
}