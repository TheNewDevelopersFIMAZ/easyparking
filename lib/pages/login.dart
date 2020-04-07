import 'package:easyparking/models/usuario_model.dart';
import 'package:easyparking/pages/home.dart';
import 'package:easyparking/pages/SignUp.dart';
import 'package:easyparking/providers/user_pro.dart';
import 'package:easyparking/providers/user_provider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:easyparking/utils/responsive.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UsuariosModel usuario = new UsuariosModel();
  final UserProvider usuarioProvider = new UserProvider();
  PreferenciasUsuario usuariopre = new PreferenciasUsuario();
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _isFetching = false; 

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit() async {
    final auth = Providers.of(context).auth;
    
    if (_formKey.currentState.validate()) {
      setState(() {
        _isFetching = true;
      });
      try {
        _formKey.currentState.save();
        String userId = await auth.signInWithEmailAndPassword(
              usuario.email,
              usuario.password
            );
        print('Signed in $userId');
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
        Dialogs.alert(context, title: "Error al iniciar sesión", message: "El correo o la contraseña son incorrectos");
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
    final responsive = Responsive(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.cyan
          ),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  padding: 
                    EdgeInsets.only(
                      right: 20,
                      left:20
                    ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: responsive.hp(6)),
                            Text(
                              "Estacionando-Ando",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: responsive.ip(3.5),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            )
                          ],
                        ),
                        Container(
                          //color: Colors.black,
                          margin: EdgeInsets.symmetric(vertical: size.width * 0.07),
                          padding: EdgeInsets.only(left: size.width * 0.07, right: size.width * 0.07, top: size.width * 0.09),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(
                              color: Colors.black12, 
                              blurRadius: 20
                            )],
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  width: size.width*0.5,
                                  height: size.height*0.2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("images/logo_inicio.png") 
                                    ),
                                  )
                                )
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 350,
                                  minWidth: 350,
                                ),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Correo Electronico",
                                            labelStyle: TextStyle(fontSize: responsive.hp(2))
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
                                            labelStyle: TextStyle(fontSize: responsive.hp(2))
                                          ),
                                          onSaved: (value) => usuario.password = value,
                                          obscureText: true,
                                          validator: (String text) {
                                            if (text.isNotEmpty) {
                                              _password = text;
                                              return null;
                                            }
                                            return "Contraseña no valida";
                                          },
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(height: responsive.hp(4)),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 350,
                                  minWidth: 350,
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsive.ip(2)),
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(4),
                                  onPressed: () => _submit(),
                                  child: Text("Iniciar Sesión",
                                      style: TextStyle(
                                          fontSize: responsive.ip(2.5))),
                                ),
                              ),/*
                              SizedBox(height: responsive.hp(1)),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 350,
                                  minWidth: 350,
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsive.ip(2)),
                                  color: Colors.redAccent[200],
                                  borderRadius: BorderRadius.circular(4),
                                  onPressed: () async {
                                    try {
                                      final _auth = Providers.of(context).auth;
                                      final id = await _auth.signInWithGoogle();
                                      print('signed in with google $id');
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Entypo.google_),
                                      SizedBox(width: responsive.hp(1)),
                                      Text("Iniciar con Google",
                                          style: TextStyle(
                                              fontSize: responsive.ip(2.5))),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: responsive.hp(1)),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 350,
                                  minWidth: 350,
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsive.ip(2)),
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                  onPressed: () async {
                                    try {
                                      final _auth = Providers.of(context).auth;
                                      final id = await _auth.signInWithFacebook();
                                      print('signed in with facebook $id');
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Entypo.facebook),
                                      SizedBox(width: responsive.hp(1)),
                                      Text("Iniciar con Facebook",
                                          style: TextStyle(
                                              fontSize: responsive.ip(2.5))),
                                    ],
                                  ),
                                ),
                              ),*/
                              SizedBox(height: responsive.hp(2)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("¿Quieres crear una nueva cuenta?",
                                      style: TextStyle(
                                          fontSize: responsive.ip(1.8),
                                          color: Colors.black54)),
                                  CupertinoButton(
                                    onPressed: () =>
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: ( context )=> SingUpPage())),
                                    child: Text("Crear Cuenta",
                                        style: TextStyle(
                                            fontSize: responsive.ip(1.5),
                                            color: Colors.cyan[500])),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: responsive.hp(5),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              _isFetching
                  ? Positioned.fill(
                  child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: CupertinoActivityIndicator(radius: 15),
                    ),
                  ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}