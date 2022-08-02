import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/modelos/Proyecto.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:flutter/material.dart';

class Listarproyectos extends StatefulWidget {
  @override
  State<Listarproyectos> createState() => _ListarproyectosState();
}

class _ListarproyectosState extends State<Listarproyectos> {
  List<Proyecto> users=[];
  List<Proyecto> _users=[];
  String selectedRegion;
  dynamic usuarioSeleccionado;
  List<Proyecto>pasoParametro=[];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Proyecto>>(
      future:listarProyectos(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          _users=[];
          _users = (users).toSet().toList();
          return  Container(
            height: 50,
            width:200,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(10, 5, 10,10),
            decoration: BoxDecoration(
              border: Border(bottom:BorderSide(width: 1,
                color: Color.fromRGBO(83, 86, 90, 1.0),
              ),),
            ),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                hint:Text('Seleccione un Proyecto', textAlign: TextAlign.left,style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Karla',
                  ),
                ), 
                // Padding(
                //   padding: EdgeInsets.fromLTRB(5, 2, 5,2),
                //   //child: Center(
                //       child:Text('Seleccione un usuario', textAlign: TextAlign.center,style: TextStyle(
                //   fontSize: 15.0,
                //   fontFamily: 'Karla',
                //   ),),
                // ),
                //),
                value:selectedRegion,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    if(newValue !='Seleccione un Proyecto'){
                      setState(() {
                         proyectoGlobal=selectedRegion;                     
                      });
                      users.toSet();
                      //usuarioSeleccionado=users.where((a) => a.proyecto==newValue);
                    }
                  });
                },
                items: _users.map((Proyecto map) {
                  return new DropdownMenuItem<String>(
                    value: map.proyecto,
                    //child: Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0,2),
                      child:
                      new Text(map.proyecto,textAlign: TextAlign.left,
                        style: new TextStyle(color: Colors.black)
                      ),
                    ),
                  //),
                  );
                }).toList(),
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

  Future <List<Proyecto>> listarProyectos()async{
    var insertar = Insertar();
    users=[];
    if(users.length > 0)
    {
      return users;
    }
    else
    {
      await insertar.listarProyectos().then((_){
        var preUsuarios=insertar.obtenerProyectos();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      users.toSet().toList();
      return users;
    }
  }
}