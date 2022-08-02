import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/home.dart';
import 'package:controlmax/vistas/login/login.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:flutter/material.dart';

class Portada extends StatefulWidget {
  final bool editar;
  const Portada({Key key, this.editar}) : super(key: key);
  @override
  State<Portada> createState() => _PortadaState();
}

class _PortadaState extends State<Portada> {
  _onPressed(){
    warningDialog(
      context, 
      "Recargue su saldo para seguir apostando",
      neutralAction: (){
        
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          body:  new SingleChildScrollView(
            child:
            Container(
              color: Colors.blueGrey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,50,10,0),
                        child: 
                        Text('Salir',style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        ),
                      ),
                        onTap:(){
                          if(widget.editar){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Home())
                            );
                          }else{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login(false)));
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height:50,
                  ),
                  Container(
                    height: 380,
                    width: 300,
                    child: Image.asset("assets/img/balon.png"),
                  ),
                  SizedBox(
                    height:50,
                  ),
                  Boton(onPresed: _onPressed,texto:'Aceptar',),
                  SizedBox(
                    height:50,
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}