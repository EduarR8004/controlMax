import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/modelos/ReporteDiario.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/baseGeneral/AsignarBaseRuta.dart';
import 'package:controlmax/vistas/administracion/ConsultarGastos.dart';
import 'package:controlmax/vistas/administracion/FechasProduccion.dart';

class ConsultarProduccion extends StatefulWidget {
  final String parametro;
  final String fechaInicial;
  final String fechaFinal;
  final bool todos;
  
  ConsultarProduccion({Key key,this.parametro,this.fechaFinal,this.fechaInicial,this.todos}) : super();
 
  final String title = "Gestión de Usuarios";
 
  @override
  ConsultarProduccionState createState() => ConsultarProduccionState();
}
 
class ConsultarProduccionState extends State<ConsultarProduccion> {
  bool sort;
  Color color;
  bool validar;
  Usuario consulta;
  bool borrar=false;
  String mensaje,texto;
  bool refrescar = false;
  List<Widget> lista =[];
  List<ReporteDiario> users=[];
  List<ReporteDiario> total=[];
  List<ReporteDiario> selectedUsers;
  String dropdownValue = 'Opciones';
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';
  //SELECT * from venta where DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= date(fechaTexto);
  //SELECT * from venta where DATE_SUB('2022-03-08', INTERVAL 7 DAY) <= date(fechaTexto);
  
  Future <List<ReporteDiario>> listarProduccion()async{
    var usuario= Insertar();
    users=[];
    if(widget.todos)
    {
      await usuario.descargarProduccionTodos(widget.fechaInicial,widget.fechaFinal).then((_){
        var preUsuarios=usuario.obtnerProduccion();
        for ( var usuario in preUsuarios)
        { 
          users.add(usuario);
        }        
      });

    }else{
      await usuario.descargarProduccion(widget.fechaInicial,widget.fechaFinal,widget.parametro).then((_){
        var preUsuarios=usuario.obtnerProduccion();
        for ( var usuario in preUsuarios)
        { 
          users.add(usuario);
        }        
      });
    }
    return users;
  }

  Future <List<ReporteDiario>> listarTotalProduccion()async{
    var usuario= Insertar();
    total=[];
    if(widget.todos)
    {
      await usuario.descargarTotalProduccionTodos(widget.fechaInicial,widget.fechaFinal).then((_){
        var preUsuarios=usuario.obtnerTotalProduccion();
        for ( var usuario in preUsuarios)
        {
          total.add(usuario);
        }        
      });
    }else{
      await usuario.descargarTotalProduccion(widget.fechaInicial,widget.fechaFinal,widget.parametro).then((_){
        var preUsuarios=usuario.obtnerTotalProduccion();
        for ( var usuario in preUsuarios)
        {
          total.add(usuario);
        }        
      });
    }
    return total;
  }
    
  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    super.initState();
  }

  void borrarTabla(){
    setState(() {
      users=[]; 
    });
  }
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.fecha.compareTo(b.fecha));
      } else {
        users.sort((a, b) => b.fecha.compareTo(a.fecha));
      }
    }
  }
 
  onSelectedRow(bool selected, ReporteDiario user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }
  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<ReporteDiario> temp = [];
        temp.addAll(selectedUsers);
        for (ReporteDiario user in temp) {
          //eliminar();
          users.remove(user);
          selectedUsers.remove(user);  
       }
        successDialog(
          context, 
          'Usuario Eliminado Correctamente',
          neutralText: "Aceptar",
          neutralAction: (){
          },
        );
      }else
      {
        warningDialog(
          context, 
          'Por favor seleccione un usuario',
            negativeAction: (){
          },
        );
      }
    });
  }
 
  Widget  dataBody(texto) {
    return FutureBuilder <List<ReporteDiario>>(
      future:listarProduccion(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView( 
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                MaterialStateColor.resolveWith((states) =>Theme.of(context).accentColor),
                //Color.fromRGBO(136,139, 141, 1.0)
                sortAscending: sort,
                sortColumnIndex: 0,
                horizontalMargin:10,
                columnSpacing:10,
                columns: [
                  DataColumn(
                    label: Text("Nombre",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Nombre",
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sort = !sort;
                      });
                      onSortColum(columnIndex, ascending);
                    }
                  ),
                  DataColumn(
                    label: Text(
                      "Fecha",style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Fecha",
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sort = !sort;
                      });
                      onSortColum(columnIndex, ascending);
                    }
                  ),
                  DataColumn(
                    label: Text(
                      "Hora Cierre",style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Hora",
                  ),
                  DataColumn(
                    label: Text("Base-S",
                      style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:15,
                      ),textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Base",
                  ),
                  DataColumn(
                    label: Text("Base-U",
                      style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:15,
                      ),textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Base",
                  ),
                  DataColumn(
                    label: Text("Cobro",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Cobro",
                  ),
                  DataColumn(
                    label: Text("Ventas",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Ventas",
                  ),
                  DataColumn(
                    label: Text("Gasto",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Gasto",
                  ),
                  DataColumn(
                    label: Text("Retiro",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Retiro",
                  ),
                  DataColumn(
                    label: Text("Caja",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Caja",
                  ),
                ],
                rows: users.map(
                  (user) => DataRow(
                    //selected: selectedUsers.contains(user),
                    // onSelectChanged: (b) {
                    //   print("Onselect");
                    //   onSelectedRow(b, user);
                    // },
                    cells: [
                      DataCell(
                        Text(user.nombre,style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,),
                        onTap: () {
                        },
                      ),
                      DataCell(
                        Text(user.fecha,style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,),
                      ),
                      DataCell(
                        Text( user.hora.toString(),style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,),
                      ),
                      DataCell(
                        Text( user.baseRuta.toString(),style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,),
                        onTap: (){
                          if(objetosUsuario.contains('ABA003') || objetosUsuario.contains("SA000")){
                            if(user.baseRuta!='0'){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>
                                  BaseRuta(true,valor:user.baseRuta,usuario:user.usuario,idBase:user.idBase,fecha:user.fecha,nombre: user.usuario,),
                                )); 
                              });
                            }else{
                              infoDialog(
                                context, 
                                'No tiene  base para editar en esa fecha.',
                                negativeAction: (){
                                },
                              );
                            }
                          }else{
                            infoDialog(
                              context, 
                              'No tiene  permisos para editar la base.',
                              negativeAction: (){
                              },
                            );
                          }
                        }
                      ),
                      DataCell(
                        Text( user.asignado.toString(),style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,),
                      ),
                      DataCell(
                        Text(  double.parse(user.recolectado).toStringAsFixed(1),style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,)),
                      DataCell(
                        Text(user.ventas.toString(),style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,),
                      ),
                      DataCell(
                        Text( user.gasto.toString(),style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red),textAlign: TextAlign.center,),
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>
                              ConsultarGastos(usuario:user.usuario,fecha: user.fecha,fechaFinal: widget.fechaFinal,fechaInicial: widget.fechaInicial,),
                            )); 
                          });
                        },
                      ),
                      DataCell(
                        Text( user.retiro.toString(),style:TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red)),
                      ),
                      DataCell(
                        Text( ((double.parse(user.asignado)+double.parse(user.recolectado))-(double.parse(user.ventas)+double.parse(user.retiro)+double.parse(user.gasto))).toStringAsFixed(1),style: TextStyle(fontSize:15,color:double.parse(user.asignado)>= double.parse(user.baseRuta)? color:Colors.red)),
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

  Widget  dataTotal(texto) {
    return FutureBuilder <List<ReporteDiario>>(
      future:listarTotalProduccion(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyleDataCell = TextStyle(fontSize:15,);
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView( 
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                MaterialStateColor.resolveWith((states) =>Theme.of(context).accentColor, ),
                //Color.fromRGBO(136,139, 141, 1.0)
                sortAscending: sort,
                sortColumnIndex: 0,
                horizontalMargin:10,
                columnSpacing:10,
                columns: [
                  DataColumn(
                    label: Text("Nombre",
                      style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:15,
                      ),textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Usuario",
                  ),
                  DataColumn(
                    label: Text("Base-S",
                      style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:15,
                      ),textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Base",
                  ),
                  // DataColumn(
                  //   label: Text("Base-U",
                  //     style: TextStyle(
                  //       color:Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize:15,
                  //     ),textAlign: TextAlign.center,
                  //   ),
                  //   numeric: false,
                  //   tooltip: "Base",
                  // ),
                  DataColumn(
                    label: Text("Cobro",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Cobro",
                  ),
                  DataColumn(
                    label: Text("Ventas",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Ventas",
                  ),
                  DataColumn(
                    label: Text("Gasto",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Gasto",
                  ),
                  DataColumn(
                    label: Text("Retiro",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Retiro",
                  ),
                  // DataColumn(
                  //   label: Text("Caja",style: TextStyle(
                  //     color:Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize:15,
                  //   )),
                  //   numeric: false,
                  //   tooltip: "Caja",
                  // ),
                  
                ],
                rows: total.map(
                  (user) => DataRow(
                    cells: [
                      DataCell(
                        Text( user.nombre.toString(),style: textStyleDataCell,textAlign: TextAlign.center,),
                      ),
                      DataCell(
                        Text( user.baseRuta.toString(),style: textStyleDataCell,textAlign: TextAlign.center,),
                      ),
                      // DataCell(
                      //   Text( user.asignado.toString(),style: textStyleDataCell,textAlign: TextAlign.center,),
                      // ),
                      DataCell(
                        Text(double.parse(user.recolectado).toStringAsFixed(1),style: textStyleDataCell)),
                      DataCell(
                        Text(user.ventas.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.gasto.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( double.parse(user.retiro).toStringAsFixed(1),style: textStyleDataCell),
                      ),
                      // DataCell(
                      //   Text( ((double.parse(user.asignado)+double.parse(user.recolectado))-(double.parse(user.ventas)+double.parse(user.retiro)+double.parse(user.gasto))).toStringAsFixed(1),style: textStyleDataCell),
                      // ),
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

  void confirm (dialog){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Faltan Permisos",
      desc: dialog,
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }
  _onPressedBuscar(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => FechasProduccion(),)); 
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
            title: Text("Producción",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                        child:Boton(onPresed: _onPressedBuscar,texto:'Nuevas fechas',size: 15,), 
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:dataBody(texto),
              ),
              Container(
                child:Text("Totales",style: TextStyle(
                  color:Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize:20,
                )), 
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0,0,12),
                child: Container(
                  //child:Expanded(
                    child:
                    dataTotal(texto),
                  //), 
                ),
              )
            ],
          ),
        ),
      ), 
    );
  }
  
}

class UsuarioEnvio {
  String token;
  UsuarioEnvio({this.token});
}
