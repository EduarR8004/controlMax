import 'package:flutter/material.dart';

class ClaseError extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child:Container(
        child:Text('No tiene permisos para ingresar a la funcionalidad.',
          style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20,),
          textAlign: TextAlign.justify,
        ),
      ) 
    );
  }
}