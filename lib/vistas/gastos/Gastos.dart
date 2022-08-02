import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Gasto.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/vistas/widgets/dropdown.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/gastos/ListarGastos.dart';

class Gastos extends StatefulWidget {
  final Gasto objeto;
  final bool editar;

  Gastos({Key key,
  this.objeto,this.editar}) : super();

  @override
  _GastosState createState() => _GastosState();
}

class _GastosState extends State<Gastos> {
  TextEditingController  valorGasto = new TextEditingController();
  TextEditingController  observaciones = new TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();
  String dropdown ="Ingrese el gasto";
  List<String> listaGasto=["Ingrese el gasto","Alimentación","Comisión","Gasolina","Moto","Plan celular","Programa","Sueldo supervisor","Otros"];
  Menu menu = new Menu();
  @override
  void initState() {
    super.initState();
    if(widget.editar == true){
      valorGasto.text =widget.objeto.valor.toString(); 
      observaciones.text =widget.objeto.observaciones; 
      dropdown =widget.objeto.tipo; 
      widget.objeto==null?widget.objeto.idGasto='0':widget.objeto.idGasto.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Gastos',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
          Icons.check,
          DropdownSoatView(texto:dropdown ,documentosLista:listaGasto,alCambiar: _alCambiar,dropdownValor: dropdown),
        ),
        formItemsDesign(
          Icons.attach_money,
          TextFormField(
            controller: valorGasto,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Gasto',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el valor del gasto';
              }
            },
          ),
        ),
        formItemsDesign(
          Icons.add_comment,
          TextFormField(
            controller: observaciones,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              labelText: 'Observaciones',
            ),
          ),
        ),
        Boton(onPresed: _crearRecoleccion,texto:'Aceptar',),
      ]
    );
  }

  void _alCambiar(newValue){
    if(newValue!="Ingrese el gasto")
    {
      setState(() {
        dropdown =newValue.toString();
      });
    }else{
      setState(() {
        dropdown =newValue.toString();
      });
    }
  }
  _crearRecoleccion()async{
    double valorIngresar = double.parse(valorGasto.text);
    if(valorGasto.text!="" && dropdown!="Ingrese el gasto"){
      String idGasto;
      var session= Insertar();
      if(widget.objeto==null){
        idGasto='0';
      }else{
        idGasto=widget.objeto.idGasto.toString();
      }
      session.crearGasto(valorIngresar,dropdown,observaciones.text,idGasto,widget.editar)
      .then((_) {
        successDialog(
          context, 
          "Proceso exitoso",
          neutralAction: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DataTableGastos())
            );
          },
        );   
      });
    }else{
      warningDialog(
        context, 
        "Por favor ingrese un valor y un tipo de gasto",
        neutralAction: (){
        },
      );
    }
  }

  @override
  void dispose() {
    valorGasto.dispose();
    observaciones.dispose();
    super.dispose();
  }
}