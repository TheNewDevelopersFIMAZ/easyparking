import 'package:easyparking/providers/sitesAvailableProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
 
class MapParkingsAreas extends StatefulWidget {
  
  @override
  _ParkingsState createState() => _ParkingsState();
}

class _ParkingsState extends State<MapParkingsAreas> {
  ImageProvider _image = new AssetImage("images/map.png");
  SitesAvailableProvider sitesProvider = new SitesAvailableProvider();
  String siteValue = "";

  var dropdownValue;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Lugares Disponibles"),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: new AspectRatio(
                          aspectRatio: 6/3,
                          child: ClipRect(
                            child: PhotoView(
                            imageProvider:_image,
                            minScale: PhotoViewComputedScale.contained * 1.8,
                            maxScale: 0.6,
                            backgroundDecoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            ),
                          )
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:10),
                      child:Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right:10),
                            child: Text("Estacionamientos: ",
                            style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 15,

                            )),
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: sitesProvider.cargarLocationAvailable(),
                              initialData: [],
                              builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                                if(snapshot.hasData){
                                  
                                  return listLocation(snapshot.data);
                                }else {
                                  return Center( child: CircularProgressIndicator(backgroundColor: Colors.transparent, valueColor:new AlwaysStoppedAnimation<Color>(Colors.cyan) ,));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.black12))
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: new RaisedButton(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            textColor: Colors.white,
                            color: siteValue != "" ? Colors.teal: Colors.grey,
                            onPressed: ()=> siteValue != "" ? screenLugares(context, siteValue):{},
                            child: new Text("Siguiente",
                            style: TextStyle(
                              fontSize: 18,
                            ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      );
  }

  void screenLugares(context, String data){

    Navigator.pushNamed(context, 'sitesAvailables', arguments: data);
  }

  Widget listLocation(List<dynamic> data){

    return DropdownButton(
        isExpanded: true,
        value: dropdownValue,
        underline: Container(
          height: 2,
          color: Colors.blueGrey[900],
        ),
        focusColor: Colors.teal,
        onChanged: (var newValue) {
          setState(() {
            dropdownValue = newValue;
             siteValue = newValue;
          });
        },
        items: data
          .map<DropdownMenuItem<String>>((dynamic value) {
           
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
            
          })
          .toList(),
        );
  }
}