import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:easyparking/api/auth_api.dart';
import 'package:easyparking/utils/responsive.dart';
import '../widgets/circle.dart';
import '../widgets/input_text.dart';

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _authAPI = AuthAPI();

  var _username = '', _email = '', _password = '';
  var _isFetching = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit() async {
    if (_isFetching) return;
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      setState(() {
        _isFetching = true;
      });
      final isOk = await _authAPI.register(context,
          username: _username, email: _email, password: _password);

      setState(() {
        _isFetching = false;
      });

      if (isOk) {
        print("REGISTER");
        Navigator.pushNamedAndRemoveUntil(context, 'splash', (_) => false);
      }
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
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -size.width * 0.22,
                top: -size.width * 0.36,
                child: Circle(
                  radius: size.width * 0.45,
                  colors: [Colors.lightBlue[400], Colors.lightBlue],
                ),
              ),
              Positioned(
                left: -size.width * 0.15,
                top: -size.width * 0.34,
                child: Circle(
                  radius: size.width * 0.35,
                  colors: [Colors.tealAccent, Colors.cyan],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              width: responsive.wp(20),
                              height: responsive.wp(20),
                              margin: EdgeInsets.only(top: size.width * 0.3),
                              decoration: BoxDecoration(
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage("images/user.png")
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26, blurRadius: 25)
                                  ]),
                            ),
                            SizedBox(height: responsive.hp(3)),
                            Text(
                              "Crea una\nNueva cuenta",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 300,
                                minWidth: 300,
                              ),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      InputText(
                                          label: "Nombre de Usuario",
                                          fontSize: responsive.ip(1.8),
                                          validator: (String text) {
                                            if (RegExp(r'^[a-zA-Z0-9]+$')
                                                .hasMatch(text)) {
                                              _username = text;
                                              return null;
                                            }
                                            return "Invalid Username";
                                          }),
                                      SizedBox(height: responsive.hp(1.5)),
                                      InputText(
                                          label: "Correo Electronico",
                                          fontSize: responsive.ip(1.8),
                                          inputType: TextInputType.emailAddress,
                                          validator: (String text) {
                                            if (text.contains("@")) {
                                              _email = text;
                                              return null;
                                            }
                                            return "Invalid Email";
                                          }),
                                      SizedBox(height: responsive.hp(1.5)),
                                      InputText(
                                        label: "Contraseña",
                                        fontSize: responsive.ip(1.8),
                                        isSecure: true,
                                        validator: (String text) {
                                          if (text.isNotEmpty &&
                                              text.length > 5) {
                                            _password = text;
                                            return null;
                                          }
                                          return "Invalid password";
                                        },
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(height: responsive.ip(5)),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 300,
                                minWidth: 300,
                              ),
                              child: CupertinoButton(
                                padding: EdgeInsets.symmetric(vertical: responsive.ip(1.9)),
                                color: Colors.lightBlue,
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
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Iniciar Sesión",
                                      style: TextStyle(
                                          fontSize: responsive.ip(1.7),
                                          color: Colors.lightBlue[900])),
                                )
                              ],
                            ),

                          ],
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
                    onPressed: () => Navigator.pop(context),
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