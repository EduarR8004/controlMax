import 'package:flutter/material.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controlmax/vistas/roles/rolesAsignados.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class RolesCompletar extends StatefulWidget {

  @override
  _RolesCompletarState createState() => _RolesCompletarState();
}

class _RolesCompletarState extends State<RolesCompletar> {
  
  List<Usuario> usuariosTemp=[];
  List<Usuario> users=[];
  String _token;
  bool asignados = false;
  Future <List<Usuario>> listarUsuario(filtro)async{
    var usuario= Insertar();
    if(users.length > 0)
    {
      return users;
    }else{
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
  Future getPreference()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //setState(() {
      _token=preferences.get('token')?? null;
    //});     
  }
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<Usuario>> key = new GlobalKey();
  AutoCompleteTextField textField;

  @override void initState() {
    getPreference();
    textField = new AutoCompleteTextField<Usuario>(
      decoration: new InputDecoration(
        hintText:"Ingrese el Usuario",
      ),
      key: key,
      submitOnSuggestionTap: true,
      clearOnSubmit: true,
      suggestions: users,
      textInputAction: TextInputAction.go,
      textChanged: (item) {
        currentText = item;
      },
      itemSubmitted: (item) {
        setState(() {
          currentText = item.nombreCompleto;
          usuariosTemp=[];
          asignados= true;
          usuariosTemp.add(item);
          currentText = "";
        });
      },
      itemBuilder: (context, item) {
        return new Padding(
            padding: EdgeInsets.all(8.0), child: new Text(item.nombreCompleto));
      },
      itemSorter: (a, b) {
        return a.nombreCompleto.compareTo(b.nombreCompleto);
      },
      itemFilter: (item, query) {
        return item.nombreCompleto.toLowerCase().startsWith(query.toLowerCase());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          autocompletar(),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(2),
            child: Column(
              children: [Text('Roles Asignados')],
            )
          ),
          asignados
          ?RolesAsignados(_token, usuariosTemp)
          :Container(
            child: Column(
            children: [Text('')],
          )
          ),
          // Container(padding: EdgeInsets.all(2),child:Column(children: [Text('Roles No Asignados')],)),
          // asignados?
          // RolesNoAsignados(widget.data,usuariosTemp):Container(child:Column(children: [Text('')],)),
        ],
      ),
    );
  }

  Widget  autocompletar() {
    return FutureBuilder(
      future:listarUsuario(''),
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
                      usuariosTemp.add(users.firstWhere((i) => i.nombreCompleto.toLowerCase().contains(currentText)));
                      textField.clear();
                      currentText = "";
                    }
                  });
                }
              )
            )
          ]);
          body.children.addAll(
            usuariosTemp.map((item) {
              return Container(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                verticalDirection: VerticalDirection.down,
                children: [
                Text(item.nombreCompleto,style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold,fontSize: 16,)), 
                ],
              )
              );
            })
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
}