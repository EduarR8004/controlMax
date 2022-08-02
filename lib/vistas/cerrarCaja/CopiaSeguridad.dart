import 'package:controlmax/modelos/Claves.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
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
class CopiaSeguridad extends StatefulWidget {

  @override
  _CopiaSeguridadState createState() => _CopiaSeguridadState();
}

class _CopiaSeguridadState extends State<CopiaSeguridad> {
  String dia;
  double entrega;
  List partirDia;
  double retiro=0;
  ProgressDialog pr;
  FocusNode retiroNode;
  List<Gasto> gastos;
  Menu menu = new Menu();
  FocusNode claveVerificar;
  List<Asignar> asignado=[];
  List<ConteoDebe> nuevaVenta;
  List<ConteoDebe> recolectado=[];
  DateTime now = new DateTime.now();
  List<ConteoDebe> porRecolectar=[];
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextStyle textStyleDataCell = TextStyle(fontSize:15,);
  String claveVenta='Por favor ingrese la clave de autorización';
  TextEditingController  clavePago = new TextEditingController();
  
  @override
  void initState() {
    retiroNode = FocusNode();
    super.initState();
    dia=DateFormat('EEEE, d').format(now);
    partirDia=dia.split(",");
    dia=partirDia[0];
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

  Future<List<Clave>> claves(){
    var insertar = Insertar();
    return insertar.consultarListaClaves();
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
            title: Text('Copia de Seguridad',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    width: 700,
                    height:535,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async{
          //     Workmanager.initialize(
          //       callbackDispatcher, // The top level function, aka callbackDispatcher
          //       isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
          //     );
          //     final result = await Connectivity().checkConnectivity();
          //     showConnectivitySnackBar(result);
          //   },
          //   child:const Icon(Icons.check),
          //   //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
          // ),
        ),
      ),
    );
  }
  onPressed() async{
    Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
    final result = await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result);
  }
  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Esta funcionalidad permite enviar al servidor la informacion del ultimo cierre realizado,solo debe dar clic en el boton aceptar',style:TextStyle(fontWeight: FontWeight.bold,fontSize:20,)),
        ),
        formItemsDesign(
          Icons.lock_open_rounded,
          TextFormField(
            controller: clavePago,
            focusNode: claveVerificar,
            decoration: new InputDecoration(
              labelText: 'Clave',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor la clave';
              }
            },
          ),
        ),
        Boton(onPresed:onPressed,texto:'Aceptar',),
      ]
    );
  }
  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
 }
  _crearRecoleccion()async{  
    var session= Insertar();
    if(clavePago.text==''){
      warningDialog(
        context, 
        claveVenta,
        neutralAction: (){
          claveVerificar.requestFocus();
        },
      );
      return;
    }else{
      await pr.show();
      session.verificarClave(clavePago.text).then((data) {
        if(data['respuesta']==true){
          session.enviarClientesCopia(actualizar: true).then((_){
            session.actualizarVentasCierreCopia().then((_){
              session.enviarGastosCopia().then((_){
                session.enviarHistorialCopia().then((_){
                  session.copiaReporteDiario().then((_){
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
          warningDialog(
            context, 
            data['motivo'].toString(),
            neutralAction: (){
            },
          );
        } 
      });
    }
  }
}

