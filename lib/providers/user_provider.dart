import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import "package:http/http.dart" as http;
import 'package:easyparking/models/usuario_model.dart';

class UserProvider {

  final String _url = "https://easyparking-00001.firebaseio.com";
  //final String _apiFirebase = "AIzaSyDLYMLKM2u9mS3onoV1RLvqV2a4toIKAUw";
  //final PreferenciasUsuario _prefs = new PreferenciasUsuario(); 

  Future<bool> crearUsuario(UsuariosModel usuario, String id) async{

    //final String url = "$_url";
    
    DatabaseReference mDatabase;
    mDatabase = FirebaseDatabase.instance.reference();
    

    await mDatabase.child("Usuarios").child(id).set(usuario.toJson());

    //Map<String, dynamic> decodeData = json.decode(resp.body);

    //print(resp);

    return true;
  }

  Future<bool> editarUsuario( UsuariosModel usuario ) async {
    
    final url = '$_url/Usuarios/${ usuario.id }.json';

    final resp = await http.put( url, body: usuariosModelToJson(usuario) );

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }



  Future<Map<String, dynamic>> cargarUsuario(String id) async {

    final url  = '$_url/Usuarios/${ id }.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if ( decodedData == null ) return null;

    return decodedData;

  }


  Future<int> borrarUsuario( String id ) async { 

    final url  = '$_url/Usuarios/$id.json';
    final resp = await http.delete(url);

    print( resp.body );

    return 1;
  }

  /*
  Future<String> subirImagen( File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dc0tufkzf/image/upload?upload_preset=cwye3brj');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add(file);


    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body );
      return null;
    }

    final respData = json.decode(resp.body);
    print( respData);

    return respData['secure_url'];


  }*/
  
}