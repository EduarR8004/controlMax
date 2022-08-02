import 'package:controlmax/vistas/administracion/RutasAdmin.dart';
import 'package:controlmax/vistas/widgets/menuNavegar.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
class ReporteCarteraAdministrador extends StatefulWidget {

  @override
  _ReporteCarteraAdministradorState createState() => _ReporteCarteraAdministradorState();
}

class _ReporteCarteraAdministradorState extends State<ReporteCarteraAdministrador> {
  int index=0;
  Navegar navegar;
  Menu menu = new Menu();
  List <BottomNavigationBarItem> lista=[
    BottomNavigationBarItem(icon:const Icon(Icons.two_wheeler_rounded,size:35, ),label:'Cartera usuario' ),
    BottomNavigationBarItem(icon:const Icon(Icons.calendar_today,size:35, ),label:'Cartera fechas' ),
    BottomNavigationBarItem(icon:const Icon(Icons.zoom_out,size:35, ),label:'Control' ),
    BottomNavigationBarItem(icon:const Icon(Icons.zoom_out,size:35, ),label:'Control' ),
  ];
  
  @override
  void initState() {
    navegar = Navegar(currentIndex: (i){
      setState(() {
        index=i;          
      });
    },lista:lista);
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Cartera',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
          ),
          drawer: menu,
          body:Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              RutasAdmin(index:index),
                
            ),
          ),
          // floatingActionButton:carteraFechas?FloatingActionButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => CarteraFechas()));
          //   },
          //   child:const Icon(Icons.calendar_today_rounded),
          //   //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
          // ):FloatingActionButton(
          //   onPressed:(){
          //     infoDialog(
          //       context, 
          //       'No tiene permisos para la funcionalidad',
          //       negativeAction: (){
          //       },
          //     );
          //   },
          // ),
          bottomNavigationBar:navegar,
        ),
      ),
    );
  }
 
}

