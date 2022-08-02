import 'package:controlmax/vistas/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class IngresoRetiroDinero extends StatefulWidget {
  final bool editar;
  IngresoRetiroDinero(this.editar);
  @override
  _IngresoRetiroDineroState createState() => _IngresoRetiroDineroState();
}

class _IngresoRetiroDineroState extends State<IngresoRetiroDinero> {
  TextEditingController  couta = new TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();
  String dropdownCuotas ="Seleccione el tipo";
  String dropdown ="Ingrese el gasto";
  bool mostrarTipoClave= false;
  List<String> cantidadCuotas=["Seleccione el tipo","Base general","Secretaria","Arrendo"];
  Menu menu = new Menu();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text(widget.editar?'Retiro Base General':'Ingreso Base General',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
  void _alCambiar(newValue){
    if(newValue!="Seleccione el tipo")
    { 
      setState(() {
        dropdownCuotas =newValue.toString();
        mostrarTipoClave= true;
      });
    }else{

    }
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
          Icons.check,
          DropdownSoatView(texto:dropdownCuotas ,documentosLista:cantidadCuotas,alCambiar: _alCambiar,dropdownValor: dropdownCuotas),
        ),
        mostrarTipoClave? formItemsDesign(
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
        ):Container(),
        Boton(onPresed: widget.editar?_retirarDinero:_ingresarDinero,texto:'Aceptar',),
         
      ]
    );
  }

  _ingresarDinero()async{
    double valorIngresar = double.parse(couta.text);
    if(couta.text!=""){
      var session= Insertar();
      session.ingresoBasePrincipal(valorIngresar,dropdownCuotas.toString())
      .then((_) {
        successDialog(
          context, 
          "Ingreso exitoso",
          neutralAction: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => IngresoRetiroDinero(widget.editar))
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

  _retirarDinero()async{
    double valorIngresar = double.parse(couta.text);
    if(couta.text!=""){
      var session= Insertar();
      session.retiroBasePrincipal(valorIngresar,dropdownCuotas.toString())
      .then((_) {
        successDialog(
          context, 
          "Retiro exitoso",
          neutralAction: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => IngresoRetiroDinero(widget.editar))
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