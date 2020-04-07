import 'dart:convert';

import 'package:easyparking/models/parkings_model.dart';
import 'package:easyparking/models/sitesAvailablesModel.dart';
import "package:http/http.dart" as http;

class SitesAvailableProvider {

  final String _url = "https://easyparking-00001.firebaseio.com";

  Future<bool> crearParking(ParkingsModel parking) async{

    final String url = "$_url/Parkings.json";

    final resp = await http.post( url, body: parkingsModelToJson(parking));

    Map<String, dynamic> decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<bool> editarParkingAvailable( SitesAvailablesModel parking, String location ) async {
    
    final url = '$_url/ParkingsAvailables/uasuniversidad/$location/${ parking.id }.json';
    print(url);
    print(parking.id);
    final resp = await http.get( url );
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final prodTemp = SitesAvailablesModel.fromJson(decodedData);
    if(prodTemp != null){
      await http.put( url, body: sitesAvailablesModelToJson(parking) );
      return true;
    }
    print( decodedData );
    return false;
  }

  Future<dynamic> editarParkingAvailableQR( String location ) async {
    
    final url = '$_url/ParkingsAvailables/$location.json';
    print(url);
    final resp = await http.get( url );
    final Map<String, dynamic> decodedData = json.decode(resp.body);
     print( decodedData );
    final prodTemp = SitesAvailablesModel.fromJson(decodedData);
    if(prodTemp != null){
      if(prodTemp.disponibilidad){
        prodTemp.disponibilidad = !prodTemp.disponibilidad;
        await http.put( url, body: sitesAvailablesModelToJson(prodTemp) );
      }else{
        return 1;
      }
      
      return prodTemp;
    }
   
    return 0;
  }



  Future<List<SitesAvailablesModel>> cargarParkingAvailable(String location) async {

    List<SitesAvailablesModel> parkingData = new List();

    try{
      final url  = '$_url/ParkingsAvailables/uasuniversidad/$location.json';
      final resp = await http.get(url);

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      print(decodedData);
    
      if ( decodedData == null ) return [];

      decodedData.forEach( ( id, park ){

        final prodTemp = SitesAvailablesModel.fromJson(park);
        prodTemp.id = id;
        parkingData.add( prodTemp );

      });
    }catch(e){
      return parkingData = null;
    }

    return parkingData;

  }

  Future<int> parkingAvailable(String location) async {
    int lugares = 0;
    try{
      final url  = '$_url/ParkingsAvailables/uasuniversidad/$location.json';
      final resp = await http.get(url);

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      print(decodedData);
    
      if ( decodedData == null ) return 0;

      decodedData.forEach( ( id, park ){

        final prodTemp = SitesAvailablesModel.fromJson(park);
        prodTemp.id = id;
        if(prodTemp.disponibilidad){
          lugares++;
        }

      });
    }catch(e){
      return 0;
    }

    return lugares;

  }

  Future<List<dynamic>> cargarLocationAvailable() async {

    List<String> parkingData = new List();

    try{
      final url  = '$_url/ParkingsAvailables/uasuniversidad.json';
      final resp = await http.get(url);

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      //print(decodedData);
    
      if ( decodedData == null ) return [""];

      decodedData.forEach( ( id, park ){

        parkingData.add( id.toUpperCase() );
        print(id);

      });
    }catch(e){
      return parkingData = null;
    }

    return parkingData;

  }

  Future<List<dynamic>> cargarSiteAvailable() async {

    List<String> parkingData = new List();

    try{
      final url  = '$_url/ParkingsAvailables.json';
      final resp = await http.get(url);

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      //print(decodedData);
    
      if ( decodedData == null ) return [""];

      decodedData.forEach( ( id, park ){

        parkingData.add( id.toUpperCase() );
        print(id);

      });
    }catch(e){
      return parkingData = null;
    }

    return parkingData;

  }


  Future<int> borrarParking( String id ) async { 

    final url  = '$_url/Parkings/$id.json';
    final resp = await http.delete(url);

    print( resp.body );

    return 1;
  }
  
}