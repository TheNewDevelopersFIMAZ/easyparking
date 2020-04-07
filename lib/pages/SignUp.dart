import 'package:easyparking/models/usuario_model.dart';
import 'package:easyparking/pages/home.dart';
import 'package:easyparking/pages/login.dart';
import 'package:easyparking/providers/user_pro.dart';
import 'package:easyparking/providers/user_provider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:easyparking/utils/responsive.dart';

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final UsuariosModel usuario = new UsuariosModel();
  final UserProvider usuarioProvider = new UserProvider();
  PreferenciasUsuario usuariopre = new PreferenciasUsuario();
  final _formKey = GlobalKey<FormState>();
  //final _authAPI = AuthAPI();
  var _username = '', _email = '', _password = '';
  var _isFetching = false;
  List <String> qrDate;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit() async{
    final auth = Providers.of(context).auth;
    if (_formKey.currentState.validate()) {
      setState(() {
        _isFetching = true;
      });
      try {
        _formKey.currentState.save();
        String userId = await auth.createUserWithEmailAndPassword(
              usuario.email,
              usuario.password
            );
        print('Signed in $userId');
        await usuarioProvider.crearUsuario(usuario, userId);
        usuariopre.token = userId;
        usuariopre.selected = false;
        usuariopre.startCronometer = true;
        usuariopre.cronometroTime = "00:00:00";
        usuariopre.selectedLocation = "";
        usuariopre.selectedNumber = "";
        usuariopre.selectedSite = "";
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute( builder: (context) => HomePage() ), ModalRoute.withName("/home"));
      
      } catch (e) {
        print(e);
        Dialogs.alert(context, title: "No se pudo realizar el registo", message: "El correo ingresado ya existe");
      }
      
      print(usuariopre.token);
      setState(() {
        _isFetching = false;
      });
      
    }   
    
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String message = "El código QR se encuentra en las placas de tu automóvil puedes encontrarlo en la esquina superior derecha como se muestra en la imagen";
    final responsive = Responsive(context);
    final dynamic qrData = ModalRoute.of(context).settings.arguments;
    if ( qrData != null ) {
      qrDate = qrData.split(' ').toList();
      print(qrData.split(" ").toList());
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          //color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.cyan
          ),
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  //width: size.width,
                  //height: size.height,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: responsive.hp(6)),
                            Text(
                              "Crear cuenta",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: responsive.ip(3.5), 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            SizedBox(height: responsive.hp(3)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.width * 0.02),
                          padding: EdgeInsets.all(size.width * 0.07),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //border: Border.all(color: Colors.white, width: 30)
                          ),
                          child: Column(
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 340,
                                  minWidth: 340,
                                ),
                                child: Container(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: responsive.hp(3)),
                                        RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0),
                                            side: BorderSide(color: Colors.cyan)),
                                          splashColor: Colors.cyan,
                                          color: Colors.cyan,
                                          onPressed: (){
                                            Navigator.pushNamed(context, 'qrscanner', arguments: true);
                                            Dialogs.mainDialog(context, title: "Instrucciones", message: message ); 
                                            },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  child: Tab(
                                                    icon: new Image.asset("images/qr_icon.png", 
                                                    color: Colors.white,
                                                    ),
                                                  )
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                                      child: Text(
                                                        "Escanea aquí el codigo QR de las placas en tu vehículo para registrarte \n (campo obligatorio)",
                                                        style: TextStyle(
                                                          color: Colors.white
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: responsive.hp(0.8)),
                                        TextFormField(
                                          initialValue: qrDate != null ? qrDate.length > 5 ? qrDate[0].toString() : "" : "",
                                          enabled: false,
                                          decoration: InputDecoration(
                                            labelText: "Placas",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.placasCarro = value,
                                          validator: (String text) {
                                            if (text.isNotEmpty ) {
                                              _password = text;
                                              return null;
                                            }
                                            return "Los datos no son correctos";
                                          },
                                        ),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Tipo de vehículo",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.tipoCarro = value,
                                          validator: (String text) {
                                            if (RegExp(r'^[a-zA-Z]+$')
                                                  .hasMatch(text)) {
                                              _password = text;
                                              return null;
                                            }
                                            return "Los datos no son correctos";
                                          },
                                        ),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            focusColor: Colors.brown,
                                            labelText: "Marca del vehículo",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.marcaCarro = value,
                                          validator: (String text) {
                                            if (RegExp(r'^[a-zA-Z]+$')
                                                  .hasMatch(text)) {
                                              _password = text;
                                              return null;
                                            }
                                            return "Los datos no son correctos";
                                          },
                                        ),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Color del vehículo",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.colorCarro = value,
                                          validator: (String text) {
                                            if (RegExp(r'^[a-zA-Z]')
                                                  .hasMatch(text))  {
                                              _password = text;
                                              return null;
                                            }
                                            return "Los datos no son correctos";
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Usuario",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.nombreUsuario = value,
                                            validator: (String text) {
                                              if (RegExp(r'^(?=.*?[a-zA-Z0-9])([a-zA-Z0-9 ])+$')
                                                  .hasMatch(text)) {
                                                _username = text;
                                                return null;
                                              }
                                              return "Nombre de usuario no valido";
                                            }),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Nombre",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.nombre = value,
                                            validator: (String text) {
                                              if (RegExp(r'^(?=.*?[a-zA-Z])([a-zA-Z ])+$')
                                                  .hasMatch(text)) {
                                                _username = text;
                                                return null;
                                              }
                                              return "Nombre no valido";
                                            }),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Apellido",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.apellido = value,
                                            validator: (String text) {
                                              if (RegExp(r'^(?=.*?[a-zA-Z])([a-zA-Z ])+$')
                                                  .hasMatch(text)) {
                                                _username = text;
                                                return null;
                                              }
                                              return "Apellido no valido";
                                            }),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Correo Electronico",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.email = value,
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (String text) {
                                              if (RegExp('^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})').hasMatch(text)) {
                                                _email = text;
                                                return null;
                                              }
                                              return "Correo no valido";
                                            }),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Contraseña",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          obscureText: true,
                                          onSaved: (value) => usuario.password = value,
                                          keyboardType: TextInputType.visiblePassword,
                                          validator: (String text) {
                                            if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(text)) {
                                              _password = text;
                                              return null;
                                            }
                                            return "Incluya 8 caracteres, mayuscula, minúscula, número y caracter especial";
                                          },
                                        ),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                                          decoration: InputDecoration(
                                            labelText: "Numero de Telefono",
                                            labelStyle: TextStyle(fontSize: responsive.ip(1.8))
                                          ),
                                          onSaved: (value) => usuario.numeroTelefono = int.parse(value),
                                          validator: (String text) {
                                            if (RegExp(r'(^(?:[+0]9)?[0-9]{9,14}$)').hasMatch(text)) {
                                              _password = text;
                                              return null;
                                            }
                                            return "Telefono no valido";
                                          },
                                        ),
                                        
                                      ],
                                    )
                                  ),
                                )
                              ),
                              SizedBox(height: responsive.ip(5)),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 300,
                                  minWidth: 300,
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.symmetric(vertical: responsive.ip(1.9)),
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(4),
                                  onPressed: () => _submit(),
                                  child: Text("Crear Cuenta",
                                      style: TextStyle(fontSize: responsive.ip(1.9))),
                                ),
                              ),
                              SizedBox(height: responsive.hp(2)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Ya tienes una cuenta?",
                                      style: TextStyle(
                                          fontSize: responsive.ip(1.7), color: Colors.black54)),
                                  CupertinoButton(
                                    onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                                    child: Text("Iniciar Sesión",
                                        style: TextStyle(
                                            fontSize: responsive.ip(1.7),
                                            color: Colors.cyan[900])),
                                  )
                                ],
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 5,
                child: SafeArea(
                  child: CupertinoButton(
                    padding: EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black12,
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: ( context )=> LoginPage())),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // START FETCHING DIALOG
              _isFetching
                  ? Positioned.fill(
                  child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: CupertinoActivityIndicator(radius: 15),
                    ),
                  ))
                  : Container()
              // END FETCHING DIALOG

            ],
          ),
        ),
      ),
    );
  }
}