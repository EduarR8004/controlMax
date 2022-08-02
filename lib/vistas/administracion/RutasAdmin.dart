import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/vistas/administracion/CarteraFechas.dart';
import 'package:controlmax/vistas/administracion/CarteraUsuario.dart';
import 'package:controlmax/vistas/administracion/ControlPrestamo.dart';
import 'package:controlmax/vistas/controlErrores/ClaseError.dart';
import 'package:flutter/material.dart';
class RutasAdmin extends StatelessWidget {
  final  int index;
  const RutasAdmin({ Key key,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myList=[
      objetosUsuario.contains('CAR001') || objetosUsuario.contains("SA000")?CarteraUsuario():ClaseError(),
      objetosUsuario.contains('CAF001') || objetosUsuario.contains("SA000")?CarteraFechas():ClaseError(),
      objetosUsuario.contains('ACV001') || objetosUsuario.contains("SA000")?ControlPrestamo():ClaseError(),
    ];
    return myList[index];
  }
}

