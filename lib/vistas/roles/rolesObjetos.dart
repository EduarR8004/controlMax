import 'package:flutter/material.dart';
import 'package:controlmax/modelos/Rol.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:controlmax/vistas/roles/crearRol.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controlmax/vistas/roles/rolesCompletar.dart';
import 'package:controlmax/vistas/roles/objetosAsignados.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
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
    //var encabezado= new Encabezado(data:widget.data,titulo:'Roles y Objetos',);
    return WillPopScope(
    onWillPop: null,
      child: SafeArea(
        top: false,
        child:Scaffold(
          appBar: new AppBar(
            title: Text("Roles y Objetos",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
          ),
          drawer: menu,
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.red,
                  tabs: [
                    Tab(
                      text: 'Asignar Objetos',
                    ),
                    Tab(
                      text: 'Asignar Roles',
                    )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                Expanded(
                  child: TabBarView(
                    children: [AutoCompletar(), RolesCompletar(), ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AutoCompletar extends StatefulWidget {
  @override
  _AutoCompletarState createState() => _AutoCompletarState();
}

class _AutoCompletarState extends State<AutoCompletar> {
  
  List<Rol> roles=[];
  List<Rol> rolesTemp=[];
  bool asignados = false;
  String _token;
  String dropdownValue = 'Opciones';
  deleteSelected(rolesTemp) async {
    // if(rolesTemp.length>0){
    //   var session= Conexion();
    //   session.set_token(widget.data.token);
    //   var rol= Roles(session);
    //   await rol.eliminar_rol(rolesTemp[0].id).then((_){
    //     successDialog(
    //       context, 
    //       'Rol Eliminado Correctamente',
    //       neutralText: "Aceptar",
    //       neutralAction: (){
    //         Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => ProfilePage(data:widget.data))
    //         ); 
    //       },
    //     );
    //   });
    // }else
    // {
    //   warningDialog(
    //     context, 
    //     'Por favor seleccione un Rol',
    //       negativeAction: (){
    //     },
    //   );
    // }
  }
   Future getPreference()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //setState(() {
      _token=preferences.get('token')?? null;
    //});     
  }
  Future <List<Rol>> descargarRoles()async{
   List map;
    if(roles.length > 0){
       return roles;
    }else
    {
      var session= Insertar();
      //session.set_token(widget.data.token);
      //var rol= Roles(session);
      Map params={
      "lista":[]
    };
      map = await session.callMethodList('/listarRoles.php',params);
      for ( var rol in map)
      {
        roles.add(Rol.fromJson(rol));
      }
      return roles;
    }
  }
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<Rol>> key = new GlobalKey();
  AutoCompleteTextField textField;
  @override void initState() {
    getPreference();
    textField = new AutoCompleteTextField<Rol>(
      decoration: new InputDecoration(
        hintText:"Ingrese el Rol",
      ),
      key: key,
      submitOnSuggestionTap: true,
      clearOnSubmit: true,
      suggestions: roles,
      textInputAction: TextInputAction.go,
      textChanged: (item) {
        currentText = item;
      },
      itemSubmitted: (item) {
        setState(() {
          currentText = item.nombre;
          rolesTemp=[];
          asignados= true;
          rolesTemp.add(item);
          currentText = "";
        });
      },
      itemBuilder: (context, item) {
        return new Padding(
            padding: EdgeInsets.all(8.0), child: new Text(item.nombre));
      },
      itemSorter: (a, b) {
        return a.nombre.compareTo(b.nombre);
      },
      itemFilter: (item, query) {
        return item.nombre.toLowerCase().startsWith(query.toLowerCase());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        asignarObjetos(),
        Container(
          child: boton(),
        ),
        SizedBox(height:10),
        Container(padding: EdgeInsets.all(2),child:Column(children: [Text('Objetos Asignados')],)),
        asignados?
        ObjetosAsignados(_token,rolesTemp):Container(child:Column(children: [Text('')],)),
        // Container(padding: EdgeInsets.all(2),child:Column(children: [Text('Objetos No Asignados')],)),
        // asignados?
        // ObjetosNoAsignados(widget.data,rolesTemp):Container(child:Column(children: [Text('')],)),
        
      ]
    );
  }

  Widget asignarObjetos(){
    return FutureBuilder(
      future:descargarRoles(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          Column body = new Column(children: [
            new ListTile(
              title: textField,
              trailing: new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    if (currentText != "") {
                      rolesTemp.add(roles.firstWhere((i) => i.nombre.toLowerCase().contains(currentText)));
                    }
                  });
                }
              )
            ),
          ]);
          body.children.addAll(
            rolesTemp.map(
              (item) {
                return Container(
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Text(item.nombre,style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold,fontSize: 16,),), 
                      Text(item.descripcion),
                    ],
                  )
                );
              }
            )
          );
          return body;
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
        if(newValue=='Crear'){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CrearRol(false,rol:null))
          ); 
        }
        else if(newValue=='Eliminar')
        {
            deleteSelected(rolesTemp);
        }
        else if(newValue=='Editar')
        {
          if(rolesTemp.length>0){
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CrearRol(true,rol:rolesTemp[0]))); 
          }else{
            errorDialog(
            context, 
            "Por favor seleccione un Rol",
            negativeAction: (){
            },
          );
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
}