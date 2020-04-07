import 'package:easyparking/models/parking_info_model.dart';
import 'package:easyparking/providers/parking_info_provider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
  
class VisitasPage extends StatefulWidget {
  @override
  _VisitasPageState createState() => _VisitasPageState();
}

class _VisitasPageState extends State<VisitasPage> {
  final ParkingInfoProvider parkingInfoProvider = new ParkingInfoProvider();
  final PreferenciasUsuario _userpreferences = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ultimas Visitas'),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Container(
            child: _lista()
          ),
        ),
      );
  }

  Widget _lista(){
    return FutureBuilder(
      future: parkingInfoProvider.cargarParkingInfo(_userpreferences.token),
      builder: (context, AsyncSnapshot<List<ParkingInfoModel>> snapshot){
        if(snapshot.hasData){
          final parking = snapshot.data;
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: parking.length,
              itemBuilder: (context, i) => _accionesRecientes(context, parking[i]),
            );
        }else {
          return Card(
            margin: EdgeInsets.all(20),
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.cyan,
              child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: _shimmerList()
              )
            ),
          );
        }
      }
    );
  }

  Widget _accionesRecientes(BuildContext context, ParkingInfoModel data) {

      final widgetTemp = Card(
        child:ListTile(
          title: Text(data.lugar, style: TextStyle(color: Colors.cyan, fontSize: 19),),
          subtitle: Text(data.fecha, style: TextStyle(color: Colors.teal)),
          leading: Icon( Icons.location_on, color: Colors.cyan, size: 40,),
          trailing: Icon( Icons.keyboard_arrow_right, color: Colors.cyan, size: 40,),
          onTap: (){ 
            Navigator.pushNamed(context, 'parkinginfo', arguments: data);
          },
        )
      );
    return widgetTemp;
  }

  List<Widget> _shimmerList(){

    List<Widget> listWidget = [];
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    for(int i=0; i<=2; i++){
      
      Widget tempWidget =  Row(
        children: <Widget>[

          Column(
                        children: <Widget>[
                          new Container(                            
                            margin: EdgeInsets.only(top: 10, left:10),
                            width: size.width*0.15,
                            height: size.width*0.15,
                            decoration: 
                              new BoxDecoration(
                                color: Colors.black,
                                //shape: BoxShape.circle,
                              )
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top: 10, left:5),
                            width: 100.0,
                            height: 10.0,
                            color: Colors.white,
                          ),
                          SizedBox(height: responsive.hp(1.5)),
                          new Container(
                            width: 120.0,
                            height: 10.0,
                            margin: EdgeInsets.only(left:5),
                            color: Colors.white,
                          ),
                        ],
                      ),

        ]
        
      );

      listWidget.add(tempWidget);
    }

    return listWidget;
  }
}