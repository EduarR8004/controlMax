import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/modelos/Claves.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ClavesView extends StatefulWidget {
  @override
  _ClavesViewState createState() => _ClavesViewState();
}

class _ClavesViewState extends State<ClavesView> {
  TextEditingController  filtro = new TextEditingController();
  final format = DateFormat("dd/MM/yyyy");
  DateTime now = new DateTime.now();
  @override
  void didUpdateWidget(ClavesView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  Future<List<Clave>> claves(){
    var insertar = Insertar();
    return insertar.listarClavesAdmin();
  }

  Widget cardCuenta(Clave item){
    return 
    Card(
      child:
      ListTile(
        leading:Icon(Icons.lock_open_rounded,size:30),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Usuario: "+item.usuario,style: TextStyle(
              fontSize: 18,)
            ),
            Text(item.clave,style: TextStyle(
              fontSize: 18,)
            ),
            Text("Tipo: "+item.tipo,style: TextStyle(
              fontSize: 18,)
            ),
          ],
        ), 
        onTap: () {
        },
      )
    );
  }
  Widget build(BuildContext context) {
    var menu = new Menu();
    return WillPopScope(
    onWillPop: () async => false,
      child:
      SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('Claves Generadas'),actions: <Widget>[],
        ),
        drawer: menu,
        body: Center(child:body()),
      )
      ),
    );
  }
  Widget body(){
    return Column(
      children: [
        Expanded(
          child:Container(
            width:355,
            child:listaClaves()
          )
        )
      ],
    );
  }
  FutureBuilder<List<Clave>> listaClaves() {
    return FutureBuilder<List<Clave>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: claves(),
      builder: (BuildContext context, AsyncSnapshot<List<Clave>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              Clave item = snapshot.data[index];
              //delete one register for id
              return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (diretion) {
                  //DatabaseProvider.db.eliminarId(item.id,"producto");
                },
                //Ahora pintamos la lista con todos los registros
                child:cardCuenta(item),
              );
            },
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}