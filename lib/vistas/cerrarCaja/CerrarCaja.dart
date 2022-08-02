import 'package:controlmax/modelos/CajaInicial.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Gasto.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:controlmax/modelos/Asignar.dart';
import 'package:controlmax/modelos/ConteoDebe.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/login/login.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
class CerrarCaja extends StatefulWidget {

  @override
  _CerrarCajaState createState() => _CerrarCajaState();
}

class _CerrarCajaState extends State<CerrarCaja> {
  String dia;
  Gasto _gasto;
  double entrega;
  List partirDia;
  double retiro=retiroAlmacenado;
  ProgressDialog pr;
  Asignar _asignado;
  List<Gasto> gastos;
  FocusNode retiroNode;
  Menu menu = new Menu();
  ConteoDebe _nuevaVenta;
  ConteoDebe _recolectado;
  ConteoDebe _porRecolectar;
  List<Asignar> asignado=[];
  ConteoDebe _noPago;
  List<ConteoDebe> noPago=[];
  List<ConteoDebe> nuevaVenta;
  List<ConteoDebe> recolectado=[];
  ConteoDebe _recolectadoMismoDia;
  DateTime now = new DateTime.now();
  List<ConteoDebe> porRecolectar=[];
  List<CajaInicial> asignadoInicial=[];
  List<ConteoDebe> recolectadoMismoDia=[];
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextStyle textStyleDataCell = TextStyle(fontSize:15,);
  TextEditingController  couta = new TextEditingController();
  TextEditingController  base = new TextEditingController();
  TextEditingController  baseDia = new TextEditingController();
  
  @override
  void initState() {
    retiroNode = FocusNode();
    baseDia.text=0.0.toString();
    super.initState();
    dia=DateFormat('EEEE, d').format(now);
    partirDia=dia.split(",");
    dia=partirDia[0];
    valoresRecolectados();
    valoresPorRecolectar();
    dineroAsignadoInicial();
    retiroNode.addListener(() {
      if (retiroNode.hasFocus){
        print("tiene el foco");
      } else {
        setState(() {
          retiro=double.parse(baseDia.text); 
          retiroAlmacenado=retiro;
          tablaGastos(); 
        });
      }
    },);
  }
  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    if(hasInternet){
       _crearRecoleccion();
    }else{
      warningDialog(
        context, 
        "Error de conexión a internet, por favor intentelo de nuevo",
        neutralAction: (){
          
        },
      ); 
    }
  }
  void callbackDispatcher() {
    Workmanager.executeTask((task, inputData) async {
    if(task=='_actualizar'){
        _crearRecoleccion();
    }
    ///session_p ();
    return Future.value(true);
  });
  }
  Future<List<Asignar>>dineroAsignado()async{
    var session= Insertar();
    await session.consultarDineroAsignado().then((_){
      asignado=session.obtenerDineroAsignado();
    });
    base.text= 0.0.toString();
    return asignado;
  }
  Future<List<CajaInicial>>dineroAsignadoInicial()async{
    var session= Insertar();
    await session.consultarDineroAsignadoInicial().then((_){
      asignadoInicial=session.obtenerDineroAsignadoInicial();
    });
    base.text= 0.0.toString();
    return asignadoInicial;
  }
  Future <double>porEntregar()async{
    double resultado =(_asignado.valor+_recolectado.valorCuotas)-(_nuevaVenta.venta+_gasto.valor);
    entrega=resultado;
    return entrega;              
  }
  Future<List<ConteoDebe>>valoresRecolectados()async{
    var session= Insertar();
    await session.clientesVisitados().then((_){
      recolectado=session.obtenerClientesVisitados();
    });
    return recolectado;
  }

   Future<List<ConteoDebe>>valoresRecolectadosMismoDia()async{
    var session= Insertar();
    await session.recoleccionVentaMismoDia().then((_){
      recolectadoMismoDia=session.obtenerClientesVisitadosMismoDia();
    });
    return recolectadoMismoDia;
  }

  Future<List<Gasto>>gastosDia()async{
    var session= Insertar();
    await session.consultarGasto().then((_){
      gastos=session.obtenerGastos();
    });
    return gastos;
  }

  Future<List<ConteoDebe>> valoresPorRecolectar()async{
    var session= Insertar();
     await session.clientesVisitar().then((_){
       porRecolectar=session.obtenerclientesVisitar();
     });
     return porRecolectar;
  }

  Future<List<ConteoDebe>> valoresNoPago()async{
    var session= Insertar();
     await session.clientesNoPago().then((_){
       noPago=session.obtenerclientesVisitar();
     });
     return noPago;
  }

  Future<List<ConteoDebe>> nuevasVentas()async{
    var session= Insertar();
     await session.ventasNuevas().then((_){
       nuevaVenta=session.obtenerNuevasVentas();
     });
     return nuevaVenta;
  }

  Widget tablaGastos(){
    return FutureBuilder<List<Gasto>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: gastosDia(),
      builder: (BuildContext context, AsyncSnapshot<List<Gasto>> snapshot) {
        if (snapshot.hasData) {
          _gasto = gastos[0];
          double resultado;
          if(baseDia.text!=''){
            resultado =(_asignado.valor+_recolectado.valorCuotas)-(_nuevaVenta.venta+_gasto.valor)-retiro;
          }else{
            resultado =(_asignado.valor+_recolectado.valorCuotas)-(_nuevaVenta.venta+_gasto.valor);
          }
          Color color;
          if(resultado < 0){
            color =Colors.red;
          }else{
            color =Colors.green;
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gastos: "+_gasto.valor.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
                // const Divider(
                //   height: 20,
                //   thickness: 2,
                //   //indent: 20,
                //   //endIndent: 20,
                // ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,10,0),
                      child: Text("Entrega total : "+resultado.toStringAsFixed(1) ,style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color: color)),
                    ),
                    Text('|'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,0,0),
                      child: Text("Retiro : "+retiroAlmacenado.toString() ,style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color: color)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  
  Widget tablaAsignado(){
    return FutureBuilder<List<Asignar>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: dineroAsignado(),
      builder: (BuildContext context, AsyncSnapshot<List<Asignar>> snapshot) {
        if (snapshot.hasData) {
          _asignado = asignado[0];
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 2, 0),
            child: Column(
              mainAxisSize:MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_sharp ,size: 30,),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          _asignarDinero();
                        });
                      },
                    ),
                    Container(
                      width: 200,
                      child:
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: base,
                        decoration: new InputDecoration(
                          labelText: 'Base',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.do_disturb_on_outlined,size: 30,),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          _restarDinero();
                        });
                      },
                    )
                  ],
                ),
                //Text("Base: "+_asignado.valor.toString(),style: TextStyle(fontSize:18,)),
              ],
            ),
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  Widget bases(){
    double resultado;
    if(asignadoInicial[0].valor > _asignado.valor){
      resultado=asignadoInicial[0].valor-_asignado.valor;
    }else if(asignadoInicial[0].valor < _asignado.valor){
      resultado=_asignado.valor-asignadoInicial[0].valor;
    }else{
      resultado =0;
    }
     return Text("Día: "+resultado.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:17,));
  }
  Widget tablaBase(){
  return FutureBuilder<List<ConteoDebe>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresPorRecolectar(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebe>> snapshot) {
      if (snapshot.hasData) {
        _porRecolectar = porRecolectar[0];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisSize:MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Base",style: TextStyle(fontWeight:FontWeight.bold,fontSize:17)),
                  SizedBox(width: 10),
                  Text("Ini: "+asignadoInicial[0].valor.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:17,color: Colors.green)),
                  SizedBox(width: 10),
                  bases(),
                  SizedBox(width: 10),
                  Text("Act: "+_asignado.valor.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:17,)),
                ],
              ),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
  Widget tablaPorRecolectar(){
  return FutureBuilder<List<ConteoDebe>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresPorRecolectar(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebe>> snapshot) {
      if (snapshot.hasData) {
        _porRecolectar = porRecolectar[0];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Clientes ruta: "+_porRecolectar.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              SizedBox(width:10,),
              _porRecolectar.valorCuotas==null?Text("Por recaudar: "+"0",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Por recaudar: "+_porRecolectar.valorCuotas.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

 Widget tablaNuevaVenta(){
  return FutureBuilder<List<ConteoDebe>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: nuevasVentas(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebe>> snapshot) {
      if (snapshot.hasData) {
        _nuevaVenta = nuevaVenta[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nuevas Ventas: "+_nuevaVenta.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              SizedBox(width:10,),
              Text("Valor : "+_nuevaVenta.venta.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
Widget tablaNoPago(){
  return FutureBuilder<List<ConteoDebe>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresNoPago(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebe>> snapshot) {
      if (snapshot.hasData) {
        _noPago = noPago[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("No pagos: "+_noPago.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              SizedBox(width:10,),
              Text("No recaudado : "+_noPago.valorCuotas.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
Widget tablaRecolectado(){
  return FutureBuilder<List<ConteoDebe>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresRecolectados(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebe>> snapshot) {
      if (snapshot.hasData) {
        _recolectado = recolectado[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2,0, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _porRecolectar.documentos!=0?Text("Clientes visitados: "+_recolectado.documentos.toString()+" ("+((_recolectado.documentos/_porRecolectar.documentos)*100).toStringAsFixed(1)+"%)",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Clientes visitados: "+_recolectado.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              _porRecolectar.valorCuotas!=0?Text("Total recaudado: "+_recolectado.valorCuotas.toString()+" ("+((_recolectado.valorCuotas/_porRecolectar.valorCuotas)*100).toStringAsFixed(1)+"%)",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Total recaudado: "+_recolectado.valorCuotas.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

Widget tablaRecolectadoMismoDia(){
  return FutureBuilder<List<ConteoDebe>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresRecolectadosMismoDia(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebe>> snapshot) {
      if (snapshot.hasData) {
        _recolectadoMismoDia = recolectadoMismoDia[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2,0, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _recolectadoMismoDia.valorCuotas!=0?Text("Recaudo ventas nuevas: "+_recolectadoMismoDia.valorCuotas.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Recaudo ventas nuevas : 0",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
      message: 'Sincronizando la información',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      textAlign:TextAlign.center,
      progressTextStyle: TextStyle(
      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Cerrar Caja',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
          ),
          drawer: menu,
          body: new SingleChildScrollView(
            child:
            Container(
              color: Colors.white,
              child:new Center(
              //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                child: new Form(
                key: keyForm,
                  child:Container( 
                    width: 700,
                    height:570,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              _crearRecoleccion();
              // Workmanager.initialize(
              //   callbackDispatcher, // The top level function, aka callbackDispatcher
              //   isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
              // );
              // final result = await Connectivity().checkConnectivity();
              // showConnectivitySnackBar(result);
            },
            child:const Icon(Icons.check),
            //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
          ),
        ),
      ),
    );
  }
  Widget formUI() {
    return  
    Container( 
      child:
        Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height:60,
            child: SizedBox(
              child:tablaAsignado(),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 2,
            //indent: 20,
            //endIndent: 20,
          ),
          Container(
            height:35,
            child: SizedBox(
              child:tablaBase(),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 2,
            //indent: 20,
            //endIndent: 20,
          ),
          Container(
            height:60,
            child: SizedBox(
              child:tablaRecolectado(),
            ),
          ),
          const Divider(
            height: 8,
            thickness: 2,
            //indent: 20,
            //endIndent: 20,
          ),
          Container(
            height:25,
            child: SizedBox(
              height:10,
              child:tablaNuevaVenta(),
            ),
          ),
          Container(
            height:25,
            child: SizedBox(
              child:tablaRecolectadoMismoDia(),
            ),
          ),
          // const Divider(
          //   height: 8,
          //   thickness: 2,
          //   //indent: 20,
          //   //endIndent: 20,
          // ),
          const Divider(
            height: 8,
            thickness: 2,
            //indent: 20,
            //endIndent: 20,
          ),
          Container(
            height:35,
            child: SizedBox(
              child:tablaPorRecolectar(),
            ),
          ),
          const Divider(
            height: 5,
            thickness: 2,
            //indent: 20,
            //endIndent: 20,
          ),
          Container(
            height:35,
            child: SizedBox(
              child:tablaNoPago(),
            ),
          ),
          const Divider(
            height: 8,
            thickness: 2,
            //indent: 20,
            //endIndent: 20,
          ),
          Container(
            height:60,
            child: SizedBox(
              child:tablaGastos(),
            ),
          ),
          const Divider(
            height: 8,
            thickness: 2,
            //indent: 20,
            //endIndent: 20,
          ),
          formItemsDesign(
            Icons.money_off,
            TextFormField(
              controller: baseDia,
              focusNode: retiroNode,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                labelText: 'Retiro',
              ),
              validator:retornarValor,
              onChanged:(text){
                setState(() {
                  retiro=text==''?0.0:double.parse(text);  
                  retiroAlmacenado=retiro;
                  tablaGastos();        
                });
              },
            ),
          ),
          formItemsDesign(
            Icons.attach_money,
            TextFormField(
              controller: couta,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                labelText: 'Entrega Total',
              ),
              validator:cerrarCaja,
            ),
          ),  
        ]
      )
    );
  }

  String cerrarCaja(value){
    String texto='';
    if (value.isEmpty) {
      texto= 'Por favor Ingrese el valor recibido';
    }
    return texto;
  }

  String retornarValor(value){
    String texto='';
    if (value.isEmpty) {
      texto='Por favor Ingrese el valor a retirar';
    }
    return texto;
  }

   _crearRecoleccion()async{  
    if(couta.text!=""){
      //double valorBaseDia=double.parse(baseDia.text);
      double nuevoRetiro = double.parse(retiroAlmacenado.toStringAsFixed(0));
      double preCuadre = ((_recolectado.valorCuotas+_asignado.valor)-(_gasto.valor+_nuevaVenta.venta))-nuevoRetiro;
      double cuadre= double.parse(preCuadre.toStringAsFixed(0));
      double valorIngresar = double.parse(couta.text);
      if (_porRecolectar.documentos <=_recolectado.documentos && cuadre==valorIngresar){
        if(dia!='Saturday'){
          if(baseDia.text!=''){
            var session= Insertar();
            session.baseSiguiente(cuadre).then((_){
            }).catchError( (onError){
              pr.hide();
              warningDialog(
                context, 
                "Error de conexión, por favor inténtelo de nuevo",
                neutralAction: (){
                  
                },
              );                                     
            });
          }
        }
      }else{
        pr.hide();
        errorDialog(
          context, 
          "Por favor revice el valor ingresado y la cantidad de clientes visitados",
          neutralAction: (){
          },
        );
      }
      if (_porRecolectar.documentos <=_recolectado.documentos && cuadre==valorIngresar){
        var session= Insertar();
        await pr.show();
        session.enviarClientes(actualizar: true).then((data){
          if(data.length > 0)
          session.actualizarVentasCierre().then((_){
            session.enviarGastos().then((_){
              session.enviarHistorial().then((_){
                session.reporteDiario(_recolectado.valorCuotas.toString(),_gasto.valor.toString(),_nuevaVenta.venta.toString(),_asignado.valor.toString(),cuadre.toString(),nuevoRetiro.toString()).then((_){
                  pr.hide();
                  successDialog(
                    context, 
                    "Cuadre de caja exitoso",
                    neutralAction: (){
                      baseInicial=0.0;
                      tokenGlobal='';
                      usuarioGlobal='';
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(false),)); 
                      });
                    },
                  );
                }).catchError( (onError){
                  pr.hide();
                  warningDialog(
                    context, 
                    "Error de conexión, por favor inténtelo de nuevo",
                    neutralAction: (){
                      
                    },
                  );                                     
                });

              }).catchError( (onError){
                pr.hide();
                warningDialog(
                  context, 
                  "Error de conexión, por favor inténtelo de nuevo",
                  neutralAction: (){
                    
                  },
                );                                     
              });
            }).catchError( (onError){
              pr.hide();
              warningDialog(
                context, 
                "Error de conexión, por favor inténtelo de nuevo",
                neutralAction: (){
                  
                },
              );                                     
            });
          }).catchError( (onError){
            pr.hide();
            warningDialog(
              context, 
              "Error de conexión, por favor intentelo de nuevo",
              neutralAction: (){
                
              },
            );                                     
          });
        }).catchError( (onError){
          pr.hide();
          warningDialog(
            context, 
            "Error de conexión, por favor intentelo de nuevo",
            neutralAction: (){
              
            },
          );                                     
        });
      }else{
        pr.hide();
        errorDialog(
          context, 
          "Por favor revice el valor ingresado y la cantidad de clientes visitados",
          neutralAction: (){
          },
        );
      }
    }else{
      warningDialog(
        context, 
        "Por favor revice el valor ingresado y la cantidad de clientes visitados",
        neutralAction: (){
        },
      );
    }
  }
  formItemsDesignMoney(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:0),
      child: Card(
        child: ListTile(
          leading:IconButton(
            icon: const Icon(Icons.add,),
            color: Colors.black,
            onPressed: () {
              setState(() {
                _asignarDinero();
              });
            },
          ), title: item,
          subtitle: IconButton(
            icon: const Icon(Icons.add,),
            color: Colors.black,
            onPressed: () {
              setState(() {
                _restarDinero();
              });
            },
          ),
        )
      ),
    );
  }
  _asignarDinero()async{
    double valorIngresar = double.parse(base.text);
    if(valorIngresar!=0.0){
      var session= Insertar();
      warningDialog(
        context, 
        "Esta seguro que desea incrementar el valor",
        negativeText: "Si",
        negativeAction: (){
          session.editarAsignarDinero(valorIngresar)
          .then((_) {
            successDialog(
              context, 
              "Asignacón exitosa",
              neutralAction: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CerrarCaja())
                );
              },
            );   
          });
        },
        neutralText: "No",
        neutralAction: (){
        },
      );
    }else{
      warningDialog(
        context, 
        "Por favor ingrese un valor",
        neutralAction: (){
        },
      );
    }
  }

  _restarDinero()async{
    double valorIngresar = double.parse(base.text);
    if(valorIngresar!=0.0){
      var session= Insertar();
      warningDialog(
        context, 
        "Esta seguro que desea restar el valor",
        negativeText: "Si",
        negativeAction: (){
          session.restarAsignarDinero(valorIngresar)
          .then((_) {
            successDialog(
              context, 
              "Asignacón exitosa",
              neutralAction: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CerrarCaja())
                );
              },
            );   
          });
        },
        neutralText: "No",
        neutralAction: (){
        },
      );
    }else{
      warningDialog(
        context, 
        "Por favor ingrese un valor",
        neutralAction: (){
        },
      );
    }
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:0),
      child: Card(
        shadowColor:Colors.white,
        child: ListTile(leading: Icon(icon), title: item)
      ),
    );
  }

  @override
  void dispose() {
    couta.dispose();
    base.dispose();
    baseDia.dispose();
    super.dispose();
  }
}