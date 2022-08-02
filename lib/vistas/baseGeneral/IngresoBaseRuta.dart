import 'package:controlmax/utiles/Globals.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/home.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/modelos/CuadresSemana.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class IngresoBaseRutaRetiroDinero extends StatefulWidget {
  final String usuario;
  final String nombre;
  final List<CuadreSemana> cuadre;
  IngresoBaseRutaRetiroDinero({this.cuadre, this.usuario, this.nombre});
  @override
  _IngresoBaseRutaRetiroDineroState createState() => _IngresoBaseRutaRetiroDineroState();
}

class _IngresoBaseRutaRetiroDineroState extends State<IngresoBaseRutaRetiroDinero> {
  dynamic usuario;
  String newValue;
  bool crear= false;
  String selectedRegion;
  List<Usuario> users=[];
  Menu menu = new Menu();
  List<Usuario>pasoParametro=[];
  String dropdown ="Ingrese el gasto";
  final format = DateFormat("yyyy-MM-dd");
  TextStyle estilo=TextStyle(fontSize:16,);
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextStyle estiloTitulo=TextStyle(fontWeight: FontWeight.bold,fontSize:16,);

  @override
  void initState() {
    if(objetosUsuario.contains('ACS001') || objetosUsuario.contains("SA000")){
      crear = true;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop:  () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Cuedre Base General',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    height:550,
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
      crossAxisAlignment:CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height:25,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              Text('Usuario : ',style:estiloTitulo,),
              Text(widget.usuario==null?'Por favor verificar fechas':widget.usuario,style:estilo),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Text('Nombre : ',style:estiloTitulo,),
              Text(widget.nombre==null?'por favor verificar fechas':widget.nombre,style:estilo),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Text('Dinero asignado : ',style:estiloTitulo,),
        //       Text(widget.cuadre[0].asignado==''?'por favor verificar fechas':widget.cuadre[0].asignado,style:estilo),
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Base Supervisor Semanal : ',style:estiloTitulo,),
              Text(widget.cuadre[1].asignado==''?'asignar caja a la ruta':widget.cuadre[1].asignado,style:estilo),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Ventas Semanal : ',style:estiloTitulo,),
              Text(widget.cuadre[0].ventas==''?'por favor verificar fechas':widget.cuadre[0].ventas,style:estilo),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Gasto Semanal: ',style:estiloTitulo,),
              Text(widget.cuadre[0].gasto==''?'por favor verificar fechas':widget.cuadre[0].gasto,style:estilo),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Cobro Semanal : ',style:estiloTitulo,),
              Text(widget.cuadre[0].recolectado==''?'por favor verificar fechas':widget.cuadre[0].recolectado,style:estilo),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Text('Entrega Semanal : ',style:estiloTitulo,),
        //       Text(widget.cuadre[0].entrega==''?'por favor verificar fechas':widget.cuadre[0].entrega,style:estilo),
        //     ],
        //   ),
        // ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Retiro Semanal: ',style:estiloTitulo,),
              Text(widget.cuadre[0].retiro==''?'por favor verificar fechas':widget.cuadre[0].retiro,style:estilo),
            ],
          ),
        ),
        widget.cuadre.length>2?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Última entrega : ',style:estiloTitulo,),
              Text(((double.parse(widget.cuadre[0].asignado)+double.parse(widget.cuadre[0].recolectado)+double.parse(widget.cuadre[2].ultimaEntrega))-(double.parse(widget.cuadre[0].gasto)+double.parse(widget.cuadre[0].ventas)+double.parse(widget.cuadre[0].retiro)+double.parse(widget.cuadre[0].entrega))).toString(),style:estilo),
            ],
          ),
        ):Container(),
        SizedBox(height:50,),
        crear?widget.cuadre.length>2?Boton(onPresed:_ingresarDinero,texto:'Aceptar',):Container(child: Text('Por favor revise las fechas ingresadas',style:TextStyle(fontWeight: FontWeight.bold,fontSize:20,)),):Container(),
         
      ]
    );
  }

  _ingresarDinero()async{
    double valorAsignado = double.parse(widget.cuadre[0].asignado);
    double cajaRuta = double.parse(widget.cuadre[1].asignado);
    double salida=double.parse(widget.cuadre[0].gasto)+double.parse(widget.cuadre[0].ventas)+double.parse(widget.cuadre[0].retiro)+double.parse(widget.cuadre[0].entrega);
    double entrada=double.parse(widget.cuadre[0].asignado)+double.parse(widget.cuadre[0].recolectado)+double.parse(widget.cuadre[2].ultimaEntrega)+double.parse(widget.cuadre[0].retiro)-salida;
    String usuario=widget.usuario;
    if(valorAsignado > 0){
      if(cajaRuta <= valorAsignado ){
        var session= Insertar();
        session.crearCuadreSemanal(usuario,entrada,cajaRuta)
        .then((_) {
          successDialog(
            context, 
            "Cuadre exitoso",
            neutralAction: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Home())
              );
            },
          );   
        });
      }else{
        warningDialog(
          context, 
          "Por favor revisar los valores del cuadre semanal",
          neutralAction: (){
          },
        );
      }
    }
  }
}

