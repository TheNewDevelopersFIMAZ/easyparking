import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttie/fluttie.dart';

class Dialogs {
  static bool mainDialog(BuildContext context,
      {String title = '', String message: '', Color color = Colors.cyan}) {
    bool value = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Stack(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12))),
                          padding: EdgeInsets.all(10),
                          child: Center(
                              child: Text(
                            title,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Center(
                              child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        ),
                        Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/placa.png"))))
                      ],
                    ),
                    Positioned(
                      top: 170,
                      right: 40,
                      child: new Container(
                        decoration: BoxDecoration(),
                        child: Center(
                          child: new Container(
                              child: FutureBuilder<FluttieAnimation>(
                            builder: (context,
                                AsyncSnapshot<FluttieAnimation> snapshot) {
                              FluttieAnimation scanAnimation;
                              scanAnimation = snapshot.data;
                              return Container(
                                  width: 80, height: 80, child: scanAnimation);
                            },
                            future: _metod("arrow.json"),
                          )),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 60,
                      child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("images/cellphoneqr.png")))),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.black, width: 1)),
                        ),
                        child: Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.867,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12))),
                          child: FlatButton(
                            onPressed: () {
                              value = true;
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Aceptar',
                              style:
                                  TextStyle(color: Colors.cyan, fontSize: 20),
                            ),
                          ),
                        )),
                      ),
                    ),
                  ])),
            ),
          );
        });
    return value;
  }

  static bool alert(BuildContext context,
      {String title = '',
      String message: '',
      IconData icon = Icons.add_alert,
      double width = 300,
      double height = 200,
      Color color = Colors.cyan,
      VoidCallback onContinue,
      bool localMethod = true}) {
    bool value = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: height,
                width: width,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: width,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12))),
                        child: Column(
                          children: <Widget>[
                            Container(
                                child: Icon(
                              icon,
                              size: 50,
                            )),
                            Container(
                                child: Text(
                              title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26),
                            )),
                            Container(
                                child: Text(
                              message,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height * 0.2,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 1))),
                      child: Center(
                          child: Container(
                        width: width,
                        child: FlatButton(
                          onPressed: localMethod
                              ? () {
                                  value = true;
                                  Navigator.of(context).pop();
                                }
                              : onContinue,
                          child: Text(
                            'Aceptar',
                            style: TextStyle(
                                color: Colors.cyan, fontSize: height * 0.08),
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    return value;
  }

  static void confirm(BuildContext context,
      {String title = '',
      String message: '',
      IconData icon = Icons.warning,
      double width = 300,
      double height = 220,
      Color color = Colors.cyan,
      VoidCallback onCancel,
      VoidCallback onConfirm}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: Container(
              height: height,
              width: width,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: height * 0.2,
                      width: width,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(5))),
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                icon,
                                size: 32,
                                color: Colors.white,
                              )),
                          Container(
                              child: Text(
                            title,
                            style: TextStyle(color: Colors.white, fontSize: 26),
                          )),
                          Expanded(
                            child: Container(
                                child: Text(
                              message,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                              textAlign: TextAlign.center,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: FlatButton(
                            onPressed: onConfirm,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.cyan,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'SI',
                                  style: TextStyle(
                                      color: Colors.cyan, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: onCancel,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.cancel, color: Colors.cyan),
                                SizedBox(width: 10),
                                Text(
                                  'CANCELAR',
                                  style: TextStyle(
                                      color: Colors.cyan, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future<FluttieAnimation> _metod(String name) async {
    var instance = new Fluttie();
    var emojiComposition =
        await instance.loadAnimationFromAsset("assets/animations/${name}");
    FluttieAnimationController emojiAnimation = await instance.prepareAnimation(
        emojiComposition,
        duration: const Duration(seconds: 1),
        repeatCount: const RepeatCount.infinite(),
        repeatMode: RepeatMode.START_OVER);
    emojiAnimation.start();
    return new FluttieAnimation(emojiAnimation);
  }

  static bool alertToken(BuildContext context,
      {String title = '',
      String message: '',
      IconData icon = Icons.add_alert,
      double width = 300,
      double height = 200,
      Color color = Colors.cyan,
      VoidCallback onContinue,
      bool localMethod = true}) {
    bool value = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: height,
                width: width,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: width,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12))),
                        child: Column(
                          children: <Widget>[
                            Container(
                                child: Icon(
                              icon,
                              size: 50,
                            )),
                            Container(
                                child: Text(
                              title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26),
                            )),
                            Container(
                              child: TextFormField(
                                initialValue: message,
                                decoration: InputDecoration(
                                    labelText: "token",
                                    labelStyle: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height * 0.2,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 1))),
                      child: Center(
                          child: Container(
                        width: width,
                        child: FlatButton(
                          onPressed: localMethod
                              ? () {
                                  value = true;
                                  Navigator.of(context).pop();
                                }
                              : onContinue,
                          child: Text(
                            'Aceptar',
                            style: TextStyle(
                                color: Colors.cyan, fontSize: height * 0.08),
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    return value;
  }
}
