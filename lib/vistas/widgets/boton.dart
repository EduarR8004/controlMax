import 'package:flutter/material.dart';

class Boton extends StatefulWidget {

  final void Function () onPresed;
  final String texto;
  //final _formKey = GlobalKey<FormState>();
  final double size;

  Boton({ this.onPresed,this.texto,this.size});

  @override
  _BotonState createState() => _BotonState();
}

class _BotonState extends State<Boton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child:
      ElevatedButton(
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.texto,style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:widget.size==null?20:widget.size,),)
          ],
        ),
        onPressed:widget.onPresed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}