import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/modelos/RutaAdmin.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/modelos/HistorialVenta.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/administracion/EditarVenta.dart';
import 'package:controlmax/vistas/administracion/RutaAdministrador.dart';

class RecoleccionAdmin extends StatefulWidget {
  final RutaAdmin data;
  RecoleccionAdmin({this.data});
  @override
  _RecoleccionAdminState createState() => _RecoleccionAdminState();
}

class _RecoleccionAdminState extends State<RecoleccionAdmin> {
  bool otra=false;
  bool reportar=false;
  bool bloqueo=false;
  bool clave=false;
  bool editar=false;
  bool eliminar=false;
  Menu menu = new Menu();
  String claveNueva;
  String dropdown ="Reportar Novedad";
  final format = DateFormat("dd/MM/yyyy");
  String dropdownCuotas ="Cantidad de Cuotas";
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextStyle textStyleDataCell = TextStyle(fontSize:15,);
  TextEditingController  couta = new TextEditingController();
  TextEditingController  clavePago = new TextEditingController();
  double cuotarecolectada,cuotaRegistro,coutaIngresar,valorIngresar;
  List<String> novedad=["Reportar Novedad","No pago","No encontrado","Pasar mañana"];
  List<String> cantidadCuotas=["Cantidad de Cuotas","Novedad","Otra","Bloqueado","1","2","3","4","5","6","7","8","9","10"];
  
  @override
  void initState() {
    if(objetosUsuario.contains('ED001') || objetosUsuario.contains("SA000")){
      editar = true;
    }
    if(objetosUsuario.contains('EV001') || objetosUsuario.contains("SA000")){
      eliminar = true;
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
            title: Text('Cobro',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    height: 600,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:Center(child:formUI()),
                  ) 
                ),
              )
            )
          )
        ),
      ),
    );
  }

  _crearRecoleccion()async{  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RutaAdminView())
    );
  }

  _editarVenta()async{  
    //if(widget.data.numeroCuota==0){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditarVentaView(cliente: widget.data,))
      );
    // }else{
    //   warningDialog(
    //     context, 
    //     'La venta ya tiene cuotas recolectadas, no se puede editar',
    //     neutralAction: (){
    //     },
    //   );
    // }
  }

  _eliminarVenta()async{  
    if(widget.data.numeroCuota==0){
      warningDialog(
        context, 
        "Esta seguro que desea eliminar la venta",
        negativeText: "Si",
        negativeAction: (){
          var session= Insertar();
          session.eliminarVentaAdmin(id: widget.data.id).then((_) {
            _crearRecoleccion();
          });
        },
        neutralText: "No",
        neutralAction: (){
        },
      );
    }else{
      warningDialog(
        context, 
        'La venta ya tiene cuotas recolectadas, no se puede eliminar',
        neutralAction: (){
        },
      );
    }
  } 
  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
  }
  Future<List<HistorialVenta>> ventas(){
    var insertar = Insertar();
    return insertar.historialRecoleccion(widget.data.documento);
  }
  Widget formUI() {
    return Center(
      child:Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Nombre :"+" " +widget.data.nombre+' '+widget.data.primerApellido,style: textStyleDataCell,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Documento :"+" " +widget.data.documento,style: textStyleDataCell,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Dirección :"+" "+widget.data.direccion,style: textStyleDataCell,),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Frecuencia :"+" " +widget.data.frecuencia.toString(),style: textStyleDataCell,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Valor Solicitado:"+" " +widget.data.solicitado.toString(),style: textStyleDataCell,),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Valor Cuota :"+" " +widget.data.valorCuota.toString(),style: textStyleDataCell,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
                child: Text("Cuotas restantes :"+" "+(widget.data.cuotas-widget.data.numeroCuota).toStringAsFixed(1),style: textStyleDataCell,),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Fecha prestamo :"+" "+format.format((DateTime.fromMillisecondsSinceEpoch(widget.data.fecha,isUtc:false))).toString(),style: textStyleDataCell,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
                child: Text("Total cuotas :"+" "+widget.data.cuotas.toString(),style: textStyleDataCell,),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,6,20,6),
            child: Container(
              width: 300,
              child:Boton(onPresed: _crearRecoleccion,texto:'Regresar',)
            ),
          ) , 
          editar?Padding(
            padding: const EdgeInsets.fromLTRB(20,6,20,6),
            child: Container(
              width: 300,
              child:Boton(onPresed: _editarVenta,texto:'Editar',),
            ),
          ):Container(), 
          eliminar?Padding(
            padding: const EdgeInsets.fromLTRB(20,6,20,6),
            child: Container(
              width: 300,
              child:Boton(onPresed: _eliminarVenta,texto:'Eliminar',),
            ),
          ):Container(), 
        ],
      ), 
    );
  }
}