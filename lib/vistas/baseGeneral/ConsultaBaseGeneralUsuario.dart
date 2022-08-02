import 'dart:async';
//import 'package:controlmax/vistas/baseGeneral/FechasBase.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/modelos/ListarCaja.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/baseGeneral/FechasBase.dart';

class ConsultarBaseGeneralUsuario extends StatefulWidget {
  final String fechaInicial;
  final String fechaFinal;
  final String usuario;
  
  ConsultarBaseGeneralUsuario({Key key,this.fechaFinal,this.fechaInicial, this.usuario}) : super();
 
  final String title = "Gestión de Usuarios";
 
  @override
  ConsultarBaseGeneralUsuarioState createState() => ConsultarBaseGeneralUsuarioState();
}
 
class ConsultarBaseGeneralUsuarioState extends State<ConsultarBaseGeneralUsuario> {
  bool sort;
  bool validar;
  Usuario consulta;
  bool borrar=false;
  String mensaje,texto;
  bool refrescar = false;
  List<Widget> lista =[];
  List<ListarCaja> users=[];
  List<ListarCaja> total=[];
  List<ListarCaja> selectedUsers;
  String dropdownValue = 'Opciones';
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';
  
  
  Future <List<ListarCaja>> listarProduccion()async{
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
      if(widget.usuario==null){
        await usuario.listarCajaGeneralRuta(widget.fechaInicial,widget.fechaFinal).then((_){
          var preUsuarios=usuario.obtnerListarCaja();
          for ( ListarCaja usuario in preUsuarios)
          {
            if(usuario.retiro!=0 || usuario.ingreso!=0){
              users.add(usuario);
            }
          }        
        });
      }else{
        await usuario.listarCajaUsuario(widget.fechaInicial,widget.fechaFinal,widget.usuario).then((_){
          var preUsuarios=usuario.obtnerListarCaja();
          for ( var usuario in preUsuarios)
          {
            users.add(usuario);
          }        
        });
      }
      return users;
    }
  }

  Future <List<ListarCaja>> listarTotalProduccion()async{
    var usuario= Insertar();
    if(total.length > 0)
    {
      return total;
    }
    else
    {
      if(widget.usuario==null){
        await usuario.totalCajaGeneral().then((_){
          var preUsuarios=usuario.obtnerListarCaja();
          for ( var usuario in preUsuarios)
          {
            total.add(usuario);
          }        
        });
      }else{
        await usuario.listarTotalCajaUsuario(widget.fechaInicial,widget.fechaFinal,widget.usuario).then((_){
          var preUsuarios=usuario.obtnerTotalCaja();
          for ( var usuario in preUsuarios)
          {
            total.add(usuario);
          }        
        });
      }
      return total;
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

  void borrarTabla(){
    setState(() {
      users=[]; 
    });
  }
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.usuario.compareTo(b.usuario));
      } else {
        users.sort((a, b) => b.usuario.compareTo(a.usuario));
      }
    }
  }
 
  onSelectedRow(bool selected, ListarCaja user) async {
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
        List<ListarCaja> temp = [];
        temp.addAll(selectedUsers);
        for (ListarCaja user in temp) {
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
    return FutureBuilder <List<ListarCaja>>(
      future:listarProduccion(),
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
                horizontalMargin:12,
                columnSpacing:12,
                columns: [
                  DataColumn(
                    label: Text("Fecha",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Fecha",
                    // onSort: (columnIndex, ascending) {
                    //   setState(() {
                    //     sort = !sort;
                    //   });
                    //   onSortColum(columnIndex, ascending);
                    // }
                  ),
                  DataColumn(
                    label: Text("Supervisor",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Supervisor",
                  ),
                  DataColumn(
                    label: Text("Entrada",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Entrega",
                  ),
                  DataColumn(
                    label: Text("Salida",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Base",
                  ),
                  // DataColumn(
                  //   label: Text("Ruta",style: TextStyle(
                  //     color:Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize:15,
                  //   )),
                  //   numeric: false,
                  //   tooltip: "Ruta",
                  // ),
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
                         Text(user.fecha,style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.administrador.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        user.ingreso==0?Container():Text( user.entrada.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        user.retiro==0?Container():Text(user.salida.toString(),style: textStyleDataCell)),
                      // DataCell(
                      //   Text( user.ruta.toString(),style: textStyleDataCell),
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
  Widget  dataTotal(texto) {
    return FutureBuilder <List<ListarCaja>>(
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
                horizontalMargin:12,
                columnSpacing:12,
                columns: [
                  DataColumn(
                    label: Text("Entrada",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Entrada",
                  ),
                  DataColumn(
                    label: Text("Salida",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Salida",
                  ),
                  DataColumn(
                    label: Text("Total",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Total",
                  ),
                ],
                rows: total.map(
                  (user) => DataRow(
                    //selected: selectedUsers.contains(user),
                    // onSelectChanged: (b) {
                    //   print("Onselect");
                    //   onSelectedRow(b, user);
                    // },
                    cells: [
                      DataCell(
                        Text( (double.parse(user.entrada)+user.ingreso).toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text((double.parse(user.salida)+ user.retiro).toString(),style: textStyleDataCell)
                      ),
                      DataCell(
                        Text(((double.parse(user.entrada)+user.ingreso)-(double.parse(user.salida)+ user.retiro)).toString(),style: textStyleDataCell)
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
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => FechasBase(),)); 
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
            title: Text("Control Caja General Usuario",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
              Container(
                //child:Expanded(
                  child:
                  dataTotal(texto),
                //), 
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

// SELECT * FROM((SELECT a.id,a.`usuario` as administrador,a.`fecha`,a.`ingreso`, concat('Ingreso ',b.nombre,' : ',a.`ingreso`) as entrada , a.`retiro`,Concat('Retiro ',b.nombre,' : ',a.`retiro`) as salida
// FROM `base_general` as a
// INNER JOIN usuarios_control as b on a.usuario=b.usuario
// WHERE a.fecha BETWEEN '2022-04-20' AND '2022-04-23' ORDER BY a.fecha DESC)
// UNION ALL
// (SELECT c.id,c.`usuario`as administrador,c.`fecha`,c.`entrada`,concat('Entrada ',d.`nombre`,' : ',c.`entrada`) as entrada1, c.`salida`,concat('Salida ',d.`nombre`,' : ',c.`salida`) as salida1
// FROM `base_general` as c
// INNER JOIN usuarios_control as d on c.usuario_ruta=d.usuario
// WHERE c.fecha BETWEEN '2022-04-20' AND '2022-04-23')) consulta ORDER BY consulta.fecha