import 'dart:convert';

import 'package:easyparking/models/parkings_model.dart';
import "package:http/http.dart" as http;

class ParkingProvider {

  final String _url = "https://easyparking-00001.firebaseio.com";

  Future<bool> crearParking(ParkingsModel parking) async{

    final String url = "$_url/Parkings.json";

    final resp = await http.post( url, body: parkingsModelToJson(parking));

    Map<String, dynamic> decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<bool> editarParking( ParkingsModel parking ) async {
    
    final url = '$_url/Parkings/${ parking.id }.json';

    final resp = await http.put( url, body: parkingsModelToJson(parking) );

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }



  Future<List<ParkingsModel>> cargarParking() async {

    List<ParkingsModel> parkingData = new List();

    try{
      final url  = '$_url/Parkings.json';
      final resp = await http.get(url);

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      //print(decodedData);
    
      if ( decodedData == null ) return [];

      decodedData.forEach( ( id, park ){

        final prodTemp = ParkingsModel.fromJson(park);
        parkingData.add( prodTemp );

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