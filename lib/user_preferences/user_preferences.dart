import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }
  //GET y SET del lugar seleccionado nombre y validacion
  get selected {
    return _prefs.getBool('selected') ?? '';
  }

  set selected( bool value ) {
    _prefs.setBool('selected', value);
  }

  get selectedSite {
    return _prefs.getString('selectedSite') ?? '';
  }

  set selectedSite( String value ) {
    _prefs.setString('selectedSite', value);
  }

  get selectedNumber {
    return _prefs.getString('selectedNumber') ?? '';
  }

  set selectedNumber( String value ) {
    _prefs.setString('selectedNumber', value);
  }

  get selectedLocation {
    return _prefs.getString('selectedLocation') ?? '';
  }

  set selectedLocation( String value ) {
    _prefs.setString('selectedLocation', value);
  }
  //Get y Set Cronometro 
  get cronometroTime {
    return _prefs.getString('cronometerTime') ?? '';
  }

  set cronometroTime( String value ) {
    _prefs.setString('cronometerTime', value);
  }

  get startCronometer {
    return _prefs.getBool('startCronometer') ?? '';
  }

  set startCronometer( bool value ) {
    _prefs.setBool('startCronometer', value);
  }
  //Get y Set parkingInfo
  get idParkingInfo {
    return _prefs.getString('idParkingInfo') ?? '';
  }

  set idParkingInfo( String value ) {
    _prefs.setString('idParkingInfo', value);
  }

  get fechaInfo {
    return _prefs.getString('fechaInfo') ?? '';
  }

  set fechaInfo( String value ) {
    _prefs.setString('fechaInfo', value);
  }
  get entradaInfo {
    return _prefs.getString('entradaInfo') ?? '';
  }

  set entradaInfo( String value ) {
    _prefs.setString('entradaInfo', value);
  }
  

  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

}