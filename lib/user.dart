import 'package:flutter/material.dart';
import 'package:easyparking/city.dart';

class User extends StatelessWidget {


  final List<City> _allCities = City.allCities();
  void suma() {
    int i = 1;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column( children:<Widget>[ Container(
        padding: 
          EdgeInsets.only(
            top: 20,
            bottom: 18,
            right: 5,
            left:5
          ),
        decoration: 
          BoxDecoration(
            image: 
              DecorationImage(
                image: AssetImage('images/top_users.png'),
                alignment: Alignment.topCenter
              )
          ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: 
                        new BoxDecoration(
                          shape: BoxShape.circle,
                          image: 
                            new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage(
                                "images/user_logo.png")
                            )
                        )
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("Victor Manuel",
                      textScaleFactor: 1.1,
                      style: TextStyle(
                      color: Colors.white,),
                    ),
                    new Text("Reyes Guijarro",
                      textScaleFactor: 1.1,
                      style: TextStyle(
                      color: Colors.white,),
                    ),
                    new Text("vmrg241096@gmail.com",
                      textScaleFactor: 1.1,
                      style: TextStyle(
                      color: Colors.white,),
                    ),
                    new Text("F342T45",
                      textScaleFactor: 1.1,
                      style: TextStyle(
                      color: Colors.white,),
                    ),
                    new Text("Cheroke",
                      textScaleFactor: 1.1,
                      style: TextStyle(
                      color: Colors.white,),
                    ),
                  ],
                ),
              ],
            ),
            Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: suma,
                      child: new Text("Actividades"),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.red,
                      onPressed: suma,
                      child: new Text("Metodos de pago"),
                      ),
                    ),
                  ],
                ),
  
          ],
        ),
      ),
    ]));
  }
  
  Widget _getItemUI(BuildContext context, int index) {
    return new Text(_allCities[index].name);
  }
}

 // First Attempt
  