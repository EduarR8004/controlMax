
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/usuarios/crearUsuarios.dart';

//import 'user.dart';
 
class DataTableUsuarios extends StatefulWidget {
  final String parametro;

  DataTableUsuarios({Key key,
  this.parametro}) : super();
 
  final String title = "Gestión de Usuarios";
 
  @override
  DataTableUsuariosState createState() => DataTableUsuariosState();
}
 
class DataTableUsuariosState extends State<DataTableUsuarios> {
  bool sort;
  bool validar;
  bool editar=false;
  bool eliminar=false;
  bool crear= false;
  Usuario consulta;
  bool borrar=false;
  String mensaje,texto;
  List<Widget> lista =[];
  List<Usuario> users=[];
  bool refrescar = false;
  List<Usuario> selectedUsers;
  String dropdownValue = 'Opciones';
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';
  
  Future <List<Usuario>> listarUsuario()async{
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
      await usuario.descargarUsuarios().then((_){
        var preUsuarios=usuario.obtenerUsuarios();
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
    if(objetosUsuario.contains('EU004') || objetosUsuario.contains("SA000")){
      editar = true;
    }
    if(objetosUsuario.contains('EU003') || objetosUsuario.contains("SA000")){
      eliminar = true;
    }
    if(objetosUsuario.contains('CCU002') || objetosUsuario.contains("SA000")){
      crear = true;
    }
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
        users.sort((a, b) => a.nombreCompleto.compareTo(b.nombreCompleto));
      } else {
        users.sort((a, b) => b.nombreCompleto.compareTo(a.nombreCompleto));
      }
    }
  }
 
  onSelectedRow(bool selected, Usuario user) async {
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataTableUsuarios())
        );
      });
    }
  }

  inActivar(){
    var session= Insertar();
    borrar=true; 
    for (int i = 0;i<selectedUsers.length; i++){
    var parametro=selectedUsers[i].usuario;
      session.inActivarUsuario(parametro).then((_){     
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataTableUsuarios())
        );
      });
    }
  }
  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Usuario> temp = [];
        temp.addAll(selectedUsers);
        for (Usuario user in temp) {
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

  activarUsuarios() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Usuario> temp = [];
        temp.addAll(selectedUsers);
        for (Usuario user in temp) {
          activar();
          users.remove(user);
          selectedUsers.remove(user);  
        }
        successDialog(
          context, 
          'Usuario Activado Correctamente',
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

  inActivarUsuarios() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Usuario> temp = [];
        temp.addAll(selectedUsers);
        for (Usuario user in temp) {
          inActivar();
          users.remove(user);
          selectedUsers.remove(user);  
        }
        successDialog(
          context, 
          'Usuario Inactivado Correctamente',
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
    return FutureBuilder <List<Usuario>>(
      future:listarUsuario(),
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
                        label: Text("Nombre",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Nombre Completo",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }
                      ),
                      DataColumn(
                        label: Text("Usuario",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Usuario",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }
                      ),
                      DataColumn(
                        label: Text("Estado",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Estado",
                      ),
                      DataColumn(
                        label: Text("Proyecto",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Proyecto",
                      ),
                      DataColumn(
                        label: Text("Documento",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Documento de identidad",
                      ),
                      DataColumn(
                        label: Text("Teléfono",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Teléfono",
                      ),
                      DataColumn(
                        label: Text("Fecha",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Fecha",
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
                            Text(user.nombreCompleto,style: textStyleDataCell),
                            onTap: () {
                              print('Selected ${user.nombreCompleto}');
                            },
                          ),
                          DataCell(
                            Text(user.usuario,style: textStyleDataCell),
                          ),
                          DataCell(
                            Text(user.estado,style: textStyleDataCell),
                          ),
                          DataCell(
                            Text(user.proyecto,style: textStyleDataCell),
                          ),
                          DataCell(
                            Text(user.direccion,style: textStyleDataCell)),
                          DataCell(
                            Text(user.telefono,style: textStyleDataCell),
                          ),
                          DataCell(
                            Text( user.fecha,style: textStyleDataCell),
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
  // _onPressedBuscar(){

  //   if(_controller.text==null || _controller.text=="")
  //   {
  //     infoDialog(context,'Por favor ingrese un parámetro para realizar la búsqueda',
  //     negativeAction: (){}, 
  //     );
  //   }else
  //   {
  //     // texto=_controller.text==null?'':_controller.text;
  //     // Navigator.of(context).push(
  //     // MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:texto)));
  //   }
  // }

  _onPressedCrear(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage(false,usuario:null)));
  }
  _onPreseedEditar(){
    if(selectedUsers.length < 1)
    {
      _showAlertDialog("Por favor seleccione un usuario","Operación invalida");
    }else if(selectedUsers.length > 1)
    {
      _showAlertDialog("Por favor seleccione solo un usuario","Operación invalida");
    }
    else{
      Usuario usuario = selectedUsers[0];
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage(true,usuario:usuario))
      ); 
    }
  }

  // _limpiarFiltro(){
  //   texto='';
  //   Navigator.of(context).push(
  //   MaterialPageRoute(builder: (context) => DataTableUsuarios(parametro:texto)));
  // }
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
            title: Text("Gestión de Usuario",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
              // Container(
              //   color:Colors.white ,
              //   padding: EdgeInsets.all(10),
              //   child: TextField(
              //     controller: _controller,
              //     autofocus: false,
              //     autocorrect: true,
              //     decoration: InputDecoration(
              //       enabledBorder: UnderlineInputBorder(      
              //         borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
              //       ),  
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
              //       ),
              //       border: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
              //       ),
              //       //border: OutlineInputBorder(),
              //       labelText: 'Buscar',
              //       prefixIcon: Icon(Icons.search)
              //     ),
              //   ), 
              // ), 
              Container(
                color:Colors.white,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    crear?Boton(onPresed: _onPressedCrear,texto:'Crear',size: 15,):Container(),
                    editar?Boton(onPresed: _onPreseedEditar,texto:'Editar',size: 15,):Container(),
                    eliminar?Boton(onPresed: deleteSelected,texto:'Eliminar',size: 15,):Container(),
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
          
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage(false,usuario:null))
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
            Usuario usuario = selectedUsers[0];
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage(true,usuario:usuario))
            ); 
          }
          
        }else if(newValue=='Activar')
        {
           activarUsuarios();
        }else if(newValue=='Inactivar')
        {
           inActivarUsuarios();
        }
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Opciones','Activar','Inactivar']
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
