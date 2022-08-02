
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Gasto.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/gastos/Gastos.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

//import 'user.dart';
 
class DataTableGastos extends StatefulWidget {
  final String parametro;

  DataTableGastos({Key key,
  this.parametro}) : super();
 
  final String title = "Gestión de Gastos";
 
  @override
  DataTableGastosState createState() => DataTableGastosState();
}
 
class DataTableGastosState extends State<DataTableGastos> {
  List<Widget> lista =[];
  List<Gasto> users=[];
  Gasto consulta;
  List<Gasto> selectedUsers;
  bool refrescar = false;
  bool sort;
  String dropdownValue = 'Opciones';
  bool validar;
  bool borrar=false;
  String mensaje,texto;
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';

  Future <List<Gasto>> listarGasto()async{
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
      await usuario.listarGasto().then((_){
        var preUsuarios=usuario.obtenerGastos();
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
    selectedUsers = [];
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.tipo.compareTo(b.tipo));
      } else {
        users.sort((a, b) => b.tipo.compareTo(a.tipo));
      }
    }
  }
 
  onSelectedRow(bool selected, Gasto user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  activar(){
    var session= Insertar();
    borrar=true; 
    for (int i = 0;i<selectedUsers.length; i++){
    var parametro=selectedUsers[i].usuario;
      session.activarUsuario(parametro).then((_){     
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataTableGastos())
        );
      });
    }
  }
  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Gasto> temp = [];
        temp.addAll(selectedUsers);
        for (Gasto user in temp) {
          eliminar();
          users.remove(user);
          selectedUsers.remove(user);  
       }
        successDialog(
          context, 
          'Gasto Eliminado Correctamente',
          neutralText: "Aceptar",
          neutralAction: (){
            
          },
        );
      }else
      {
        warningDialog(
          context, 
          'Por favor seleccione un gasto',
            negativeAction: (){
          },
        );
      }
    });
  }

  eliminar(){
    var session= Insertar();
    borrar=true; 
    for (int i = 0;i<selectedUsers.length; i++){
    var parametro=selectedUsers[i].idGasto;
      session.eliminarGasto(parametro).then((_){     
      });
    }
  }
 
  Widget  dataBody(texto) {
    return FutureBuilder <List<Gasto>>(
      future:listarGasto(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyleDataCell = TextStyle(fontSize:15,);
          return  
            SingleChildScrollView(
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
                        label: Text("Tipo",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Tipo",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }
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
                        selected: selectedUsers.contains(user),
                        onSelectChanged: (b) {
                          print("Onselect");
                          onSelectedRow(b, user);
                        },
                        cells: [
                          DataCell(
                            Text(user.tipo,style: textStyleDataCell),
                            onTap: () {
                              print('Selected ${user.tipo}');
                            },
                          ),
                          DataCell(
                            Text(user.valor.toString(),style: textStyleDataCell)),
                          DataCell(
                            Text(user.observaciones,style: textStyleDataCell),
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
  
  @override
  Widget build(BuildContext context) {  
    var menu = new Menu();
    //texto=widget.parametro;
 
    return WillPopScope(
    onWillPop: null,
      child: SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text("Gestión de Gastos",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                color:Colors.white ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:boton(),
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

  Widget boton(){
    //var token=widget.data.token;
    return DropdownButton<String>(
      value: dropdownValue,
      // icon: Icon(Icons.arrow_circle_down_rounded),
      // iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black,fontSize: 16),
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      onChanged: (String newValue) {
        //final data = UsuarioEnvio(token:token);
        if(newValue=='Crear'){
          
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Gastos(editar: false,))
          ); 
        }else if(newValue=='Eliminar')
        {
          deleteSelected();
        }else if(newValue=='Editar')
        {
          if(selectedUsers.length < 1)
          {
            _showAlertDialog("Por favor seleccione un usuario","Operación invalida");
          }else if(selectedUsers.length > 1)
          {
            _showAlertDialog("Por favor seleccione solo un usuario","Operación invalida");
          }
          else{
            Gasto usuario = selectedUsers[0];
            Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>
              Gastos(objeto: usuario,editar: true,),
            )); 
          }
          
        }
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Opciones','Crear', 'Editar', 'Eliminar']
      .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _showAlertDialog(text,titulo) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(text),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.green),),
              onPressed: (){ Navigator.of(context).pop(); },
            ),
            ElevatedButton(
              child: Text("Cancelar", style: TextStyle(color: Colors.green),),
              onPressed: (){ Navigator.of(context).pop(); },
            )
          ],
        );
      }
    );
  }
}

class UsuarioEnvio {
  String token;
  UsuarioEnvio({this.token});
}
