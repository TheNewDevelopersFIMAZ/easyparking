import 'package:easyparking/models/usuario_model.dart';
import 'package:easyparking/providers/user_provider.dart';
import 'package:easyparking/user_preferences/user_preferences.dart';
import 'package:easyparking/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VehiculosPage extends StatefulWidget {
  @override
  _VehiculosPageState createState() => _VehiculosPageState();
}

class _VehiculosPageState extends State<VehiculosPage> {
  final UserProvider userProvider = new UserProvider();
  final PreferenciasUsuario userPreferences = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Container(child: _lista()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add),),
    );
  }

  Widget _lista() {
    return FutureBuilder(
        future: userProvider.cargarUsuario(userPreferences.token),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            final userModel = UsuariosModel.fromJson(snapshot.data);
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: 1,
              itemBuilder: (context, i) =>
                  _accionesRecientes(context, userModel),
            );
          } else {
            return Card(
              margin: EdgeInsets.all(20),
              child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.cyan,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: _shimmerList())),
            );
          }
        });
  }

  Widget _accionesRecientes(BuildContext context, UsuariosModel data) {
    final widgetTemp = Card(
        child: ListTile(
      title: Text(
        data.marcaCarro,
        style: TextStyle(color: Colors.cyan, fontSize: 19),
      ),
      subtitle: Text(data.placasCarro, style: TextStyle(color: Colors.teal)),
      leading: Icon(
        Icons.directions_car,
        color: Colors.cyan,
        size: 40,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.cyan,
        size: 40,
      ),
      onTap: () {
        //Navigator.pushNamed(context, 'parkinginfo', arguments: data);
      },
    ));
    return widgetTemp;
  }

  List<Widget> _shimmerList() {
    List<Widget> listWidget = [];
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    for (int i = 0; i <= 2; i++) {
      Widget tempWidget = Row(children: <Widget>[
        Column(
          children: <Widget>[
            new Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                width: size.width * 0.15,
                height: size.width * 0.15,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  //shape: BoxShape.circle,
                )),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 10, left: 5),
              width: 100.0,
              height: 10.0,
              color: Colors.white,
            ),
            SizedBox(height: responsive.hp(1.5)),
            new Container(
              width: 120.0,
              height: 10.0,
              margin: EdgeInsets.only(left: 5),
              color: Colors.white,
            ),
          ],
        ),
      ]);

      listWidget.add(tempWidget);
    }

    return listWidget;
  }
}
