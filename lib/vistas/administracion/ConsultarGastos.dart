import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/modelos/ReporteGasto.dart';
import 'package:controlmax/modelos/ReporteDiario.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/administracion/ConsultarProduccion.dart';

class ConsultarGastos extends StatefulWidget {
  final String fecha;
  final String usuario;
  final String fechaInicial;
  final String fechaFinal;
  
  ConsultarGastos({Key key,this.fecha,this.usuario,this.fechaInicial,this.fechaFinal}) : super();
 
  final String title = "Gastos";
 
  @override
  ConsultarGastosState createState() => ConsultarGastosState();
}
 
class ConsultarGastosState extends State<ConsultarGastos> {
  bool sort;
  bool validar;
  Usuario consulta;
  bool borrar=false;
  String mensaje,texto;
  bool refrescar = false;
  List<Widget> lista =[];
  List<ReporteGasto> users=[];
  List<ReporteDiario> total=[];
  List<ReporteDiario> selectedUsers;
  String dropdownValue = 'Opciones';
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';
  
  
  Future <List<ReporteGasto>> listarPGastos()async{
    var usuario= Insertar();
    if(selectedUsers.length > 0){
        return users;
    }else if(borrar==true)
    {
      return users;
    }else if(users.length > 0)
    {
      return users;
    }
    else
    {
      await usuario.descargarGastos(widget.fecha,widget.usuario).then((_){
        var preUsuarios=usuario.obtenerGastosFecha();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      return users;
    }
  }

    
  @override
  void initState() {
    sort = false;
    //widget.data;
    selectedUsers = [];
    //_controller.text=widget.data.parametro;
    //users =widget.data.usuarios ;
    //listarUsuario();
    super.initState();
  }

  Widget  dataBody(texto) {
    return FutureBuilder <List<ReporteGasto>>(
      future:listarPGastos(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyleDataCell = TextStyle(fontSize:15,);
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView( 
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                MaterialStateColor.resolveWith((states) =>Theme.of(context).accentColor,),
                //Color.fromRGBO(136,139, 141, 1.0)
                sortAscending: sort,
                sortColumnIndex: 0,
                horizontalMargin:10,
                columnSpacing:10,
                columns: [
                  DataColumn(
                    label: Text("Fecha",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Fecha",
                  ),
                  DataColumn(
                    label: Text("Nombre",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Nombre",
                  ),
                  DataColumn(
                    label: Text("Valor",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Valor",
                  ),
                  DataColumn(
                    label: Text("Tipo",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Tipo",
                  ),
                  DataColumn(
                    label: Text("Observaciones",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Observaciones",
                  ),
                ],
                rows: users.map(
                  (user) => DataRow(
                    cells: [
                      DataCell(
                        Text(user.fecha,style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.nombre.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text(user.valor.toString(),style: textStyleDataCell)),
                      DataCell(
                        Text(user.tipo.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.observaciones.toString(),style: textStyleDataCell),
                      ),
                    ]
                  ),
                ).toList(),
              ),
            ),
          );
        }else{
          return
          Center(
            child:CircularProgressIndicator()
            //Splash1(),
          );
        }
      },
    );
  }

  _onPressedBuscar(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => ConsultarProduccion(fechaFinal:widget.fechaFinal,fechaInicial:widget.fechaInicial,parametro: widget.usuario ,),)); 
    });
  }
  @override
  Widget build(BuildContext context) {  
    var menu = new Menu();
    return WillPopScope(
    onWillPop: () async => false,
      child: SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text("Gastos",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
            //flexibleSpace:encabezado,
            //backgroundColor:Colors.blue
            // Colors.transparent,
          ),
          drawer: menu,
          body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                color:Colors.white,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:Container(
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:Boton(onPresed: _onPressedBuscar,texto:'Regresar',size: 15,), 
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:dataBody(texto),
              ),
            ],
          ),
        ),
      ), 
    );
  }
  
}
