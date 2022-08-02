
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/vistas/widgets/menuNavegar.dart';
import 'package:controlmax/vistas/administracion/ruta/RutasEstado.dart';


class RutaAdminView extends StatefulWidget {
  RutaAdminView({this.usuario});
  final String usuario;
  @override
  _RutaAdminViewState createState() => _RutaAdminViewState();
}

class _RutaAdminViewState extends State<RutaAdminView> {
  int index=0;
  Navegar navegar;
 


  @override
  void initState() {
    navegar = Navegar(currentIndex: (i){
      setState(() {
        index=i;          
      });
    },lista:lista);
    super.initState();
  }

  List <BottomNavigationBarItem> lista=[
    BottomNavigationBarItem(icon:const Icon(Icons.two_wheeler_rounded,size:40, ),label:'Ruta día' ),
    BottomNavigationBarItem(icon:const Icon(Icons.point_of_sale,size:40, ),label:'Estado cierre' ),
    BottomNavigationBarItem(icon:const Icon(Icons.warning,size:40, ),label:'Bloqueados' )
  ];
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    var menu = new Menu();
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('Ruta'),actions: <Widget>[
          ],
        ),
        drawer: menu,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
            RutasEstado(index:index),
          ),
        ),
        bottomNavigationBar:navegar,
      )
    );
  }

}