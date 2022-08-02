import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:flutter/material.dart';

class AsignarDinero extends StatefulWidget {

  @override
  _AsignarDineroState createState() => _AsignarDineroState();
}

class _AsignarDineroState extends State<AsignarDinero> {
  TextEditingController  couta = new TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();
  String dropdown ="Ingrese el gasto";
  Menu menu = new Menu();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Asignar Dinero',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
          ),
          drawer: menu,
          body:  new SingleChildScrollView(
            child:
            Container(
              color: Colors.white,
              child:new Center(
              //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                child: new Form(
                key: keyForm,
                  child:Container(
                    width: 600,
                    height: 400,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          )
        ),
      ),
    );
  }
  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
  }
  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[
        formItemsDesign(
          Icons.attach_money,
          TextFormField(
            controller: couta,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Cantidad',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el valor a asignar';
              }
            },
          ),
        ),
        Boton(onPresed: _asignarDinero,texto:'Aceptar',),
         
      ]
    );
  }

  _asignarDinero()async{
    double valorIngresar = double.parse(couta.text);
    if(couta.text!=""){
      var session= Insertar();
      session.asignarDinero(valorIngresar)
      .then((_) {
        successDialog(
          context, 
          "Asignacón exitosa",
          neutralAction: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AsignarDinero())
            );
          },
        );   
      });
    }else{
      warningDialog(
        context, 
        "Por favor ingrese un valor",
        neutralAction: (){
        },
      );
    }
  }
}