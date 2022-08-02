import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/vistas/controlErrores/ClaseError.dart';
import 'package:controlmax/vistas/administracion/CierreRutaAdministracion.dart';
import 'package:controlmax/vistas/administracion/ConsultarFechaBloqueados.dart';
import 'package:controlmax/vistas/administracion/ruta/RutaDiaAdministrador.dart';
import 'package:flutter/material.dart';
class RutasEstado extends StatelessWidget {
  final  int index;
  const RutasEstado({ Key key,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myList=[
      objetosUsuario.contains('RA001') || objetosUsuario.contains("SA000")?RutaAdministradorView():ClaseError(),
      objetosUsuario.contains('RA001') || objetosUsuario.contains("SA000")?CerrarCajaAdministrador():ClaseError(),
      objetosUsuario.contains('AB001') || objetosUsuario.contains("SA000")?ConsultarFechaBloqueados():ClaseError(),
    ];
    return myList[index];
  }
}