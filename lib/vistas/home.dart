import 'package:controlmax/main.dart';
import 'package:controlmax/modelos/Proyecto.dart';
import 'package:controlmax/vistas/portada.dart';
import 'package:controlmax/vistas/widgets/listaProyectos.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/vistas/ventas.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/vistas/ventas/ruta.dart';
import 'package:controlmax/vistas/login/login.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/agenda/listarAgenda.dart';
import 'package:controlmax/vistas/gastos/ListarGastos.dart';
import 'package:controlmax/vistas/historial/Historial.dart';
import 'package:controlmax/vistas/cerrarCaja/CerrarCaja.dart';

class Home extends StatefulWidget {
  final List objetos;
  Home({this.objetos});
  //const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  double tamano=120;
  double espacio=30;
  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  String selectedRegion;
  String dropdownInicial;
  List<String> objMenu=[];
  List<Proyecto> users=[];
  dynamic usuarioSeleccionado;
  List<Proyecto>pasoParametro=[];
  var codParametro;
   @override
  void initState() {
    if(objetosUsuario.contains('VCVN001')){
      tamano=150;
    }else{
      espacio=90;
      tamano=350;
    }
    super.initState();
    // if(Platform.isAndroid){
    //   _asignarDineroInicial();
    // }
  }
  Future <List<String>>objetosMenu()async{
    objMenu=objetosUsuario;
    return objMenu;              
  }
  // _asignarDineroInicial()async{
  //   var session= Insertar();
  //   session.asignarDineroInicial()
  //   .then((_) {
  //   });
  // }
  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    // final message = hasInternet
    //     ? 'You have again ${result.toString()}'
    //     : 'You have no internet';
    //final color = hasInternet ? Colors.green : Colors.red;
    if(hasInternet){
      _actualizar();
    }
    
    //Utils.showTopSnackBar(context, message, color);
  }
    _actualizar(){  
    var session= Insertar();
    session.enviarClientes(actualizar: false).then((_){
      session.actualizarVentas().then((_){
        session.enviarHistorial().then((_){
          session.enviarGastos().then((_){
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var menu = new Menu();
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
      message: 'Estamos actualizando la información',
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
        key: _scaffoldKey,
        child: Scaffold(
          appBar: new AppBar(
            shadowColor: Theme.of(context).accentColor,
            foregroundColor: Theme.of(context).accentColor,
            flexibleSpace: Container(
            //height: 60,
            //width: 700,
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text("ControlMax",style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                  )),
                  Padding(
                  padding: EdgeInsets.fromLTRB(0,15,2,0),
                    child:Container(
                      width:250,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:<Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.exit_to_app_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () { 
                            },
                          ),
                          InkWell(
                            onTap: ()async {
                              if(Platform.isAndroid){
                                onPressedInformacion();
                                // var session= Insertar();
                                // session.copiaVentas().then((_) {
                                //   session.copiaCliente().then((_) {
                                //     session.copiaGasto().then((_) {
                                //       session.copiaHistorialMovimiento().then((_) {
                                //         session.borrarTablas().then((_) {
                                //           pr.hide();
                                //           WidgetsBinding.instance.addPostFrameCallback((_) {
                                //           Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Portada(editar: false,),));});
                                //         });
                                //       });
                                //     });
                                //   });
                                // });   
                              }else{
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(true),));}
                                );
                              }
                            },
                            child:Text("Cerrar Sesión",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body:Container(
            color: Colors.white,
            child:Column(children: [
              body(),
              objetosUsuario.contains('ACP001')?Listarproyectos():Container(),
            ],)  
            //dataBody(),
          )
        ),
      ),
    );
  }

  body(){
    return FutureBuilder <List<String>>(
      future:objetosMenu(),
      builder:(context,snapshot){
        if(snapshot.hasData){
        return  
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
              child:Center(
                child: Container(
                  width: 600,
                  height: 650,
                  color:Colors.white,
                  child:Column(
                    children: [
                      SizedBox(height: espacio),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ControlMax",style: TextStyle(
                          color: Color.fromRGBO(83, 86, 90, 1.0),
                          fontSize: 45,
                          fontWeight: FontWeight.bold
                          )),
                          //Icon(Icons.add_circle, size:60,color:Colors.blueGrey),
                        ],
                      ),
                      SizedBox(height:15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(Icons.bar_chart_sharp, size:tamano,color:Theme.of(context).accentColor),
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(horizontal:10),                             
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          objMenu.contains("AD001") || objMenu.contains("SA000")?
                          miCardAsignarDinero():Container(),
                          objMenu.contains("VCVN001") || objMenu.contains("SA000")?
                          miCardVenta():Container(),
                          objMenu.contains("VRC001") || objMenu.contains("SA000")?
                          miCardRuta():Container(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          objMenu.contains("HU001") || objMenu.contains("SA000")?
                          miCardHistorial():Container(),
                          objMenu.contains("VRC001") || objMenu.contains("SA000")?
                          miCardGastos():Container(),
                          objMenu.contains("VRC001") || objMenu.contains("SA000")?
                          miCardCerrarCaja():Container(),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Rojo'),
                              ),
                              Checkbox(
                                checkColor: Colors.red,
                                //fillColor: Colors.blueGrey,
                                value: isChecked,
                                onChanged: (bool value) {
                                  CambiarTema.of(context).onTap('Rojo');
                                  setState(() {
                                    isChecked = value;
                                    isChecked1=false;
                                    isChecked2=false;
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Azul'),
                              ),
                              Checkbox(
                                checkColor: Colors.blue,
                                activeColor: Colors.blue,
                                value: isChecked1,
                                onChanged: (bool value) {
                                  CambiarTema.of(context).onTap('Azul');
                                  setState(() {
                                    isChecked = false;
                                    isChecked1=value;
                                    isChecked2=false;
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Gris'),
                              ),
                              Checkbox(
                                checkColor: Colors.blueGrey,
                                //fillColor: Colors.blueGrey,
                                value: isChecked2,
                                onChanged: (bool value) {
                                  CambiarTema.of(context).onTap('');
                                  setState(() {
                                    isChecked = false;
                                    isChecked1= false;
                                    isChecked2=value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                )
              ),
          );
        }else{
          return
          Center(
            child:CircularProgressIndicator()
            //Splash1(),
          );
        }
      },
    );
  }

  onPressedVenta(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NuevaVentaView(false,false,false))
    );
  }
  onPressedRuta(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RecoleccionView(boton: true,))
    );
  }
  onPressedCierreCaja(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CerrarCaja())
    );
  }
  onPressedGastos(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DataTableGastos())
    );
  }
  onPressedInformacion() async{
    var session= Insertar();
    await pr.show();
    session.enviarClientes(actualizar: true).then((data){
      if(data.length > 0)
      session.actualizarVentas().then((_){
        session.enviarHistorial().then((_){
          session.enviarGastos().then((_){
            session.copiaVentas().then((_) {
              session.copiaCliente().then((_) {
                session.copiaGasto().then((_) {
                  session.copiaHistorialMovimiento().then((_) {
                    session.borrarTablas().then((_) {
                      pr.hide();
                      baseInicial=0.0;
                      tokenGlobal='';
                      usuarioGlobal='';
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Portada(editar: false,),));});
                    });
                  });
                });
              });
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
  }

  onPressedListarAgenda(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ListarAgenda())
    );
  }
  onPressedHistorial(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Historial())
    );
  }
  
  Card miCardVenta() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[ 
            InkWell(
              onTap: ()async{
                if(Platform.isAndroid){
                  onPressedVenta();
                  final result = await Connectivity().checkConnectivity();
                  showConnectivitySnackBar(result);
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child:Icon(Icons.person_add_alt_1  , size:80,color:Theme.of(context).accentColor),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Ventas'),
            ),
          ],
        ),
      )
    );
  }
  Card miCardRuta() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: ()async{
                if(Platform.isAndroid){
                  onPressedRuta();
                  final result = await Connectivity().checkConnectivity();
                  showConnectivitySnackBar(result);
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.two_wheeler_rounded  , size:80,color:Theme.of(context).accentColor),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Ruta'),
            ),
          ],
        ),
      )
    );
  }
  Card miCardHistorial() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedHistorial();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child:
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.auto_stories  , size:80,color:Theme.of(context).accentColor),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Historial'),
            ),
          ],
        ),
      )
    );
  }

  Card  miCardAsignarDinero() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedListarAgenda();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: 
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.point_of_sale, size:80,color:Theme.of(context).accentColor),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Agenda'),
            ),
          ],
        ),
      )
    );
  }

  Card miCardCerrarCaja() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedCierreCaja();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: 
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.bar_chart_sharp,size:80,color:Theme.of(context).accentColor),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Cerrar'),
            ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: Text('Caja'),
            // ),
          ],
        ),
      )
    );
  }

  Card miCardGastos() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedGastos();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: 
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.money_off,size:80,color:Theme.of(context).accentColor),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Gastos'),
            ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: Text('Caja'),
            // ),
          ],
        ),
      )
    );
  }

  Card miCardInformacion() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: ()async{
                if(Platform.isAndroid){
                  onPressedInformacion();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: 
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.upload_rounded,size:80,color:Theme.of(context).accentColor),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Actualizar'),
            ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: Text('Caja'),
            // ),
          ],
        ),
      )
    );
  }

}