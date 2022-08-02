import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:controlmax/vistas/home.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class Login extends StatefulWidget {
  final bool clear;
  final String title;
  
  Login(this.clear,{Key key, this.title}) : super(key: key);
  @override
  _State createState() => _State();
}
 
class _State extends State<Login> {
  String token;
  List obj;
  bool isLoggedIn = true;
  ProgressDialog pr;
  String name = '';
  Map usuarioActual;
  String storedUser;
  String storedPass;
  String storedSession;
  List<String> objetos=[];
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
  super.dispose();
  }
  void confirm (dialog){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error de Validación",
      desc: dialog,
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  Widget build(BuildContext context) {
  pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
  pr.style(
    message: 'Validando la información del Usuario '+nameController.text+' y actualizando la información',
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
  Future setPreference()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', storedSession);
  }
  var _onPressed =()async{
    print('object');
    if (!_formKey.currentState.validate()){
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data'))
      );
    }else{
      var session= Insertar();
      await pr.show();
      session.login(nameController.text,passwordController.text).then((data) {
        print('paso1');
        if(data.length > 0){
          var token=data[0];
          session.objetosUsuario(token['token'], nameController.text).then((data) {
            print('paso2');
            objetosUsuario=session.obtnerObjetos();
            tokenGlobal=token['token'];
            proyectoGlobal=token['proyecto'];
            usuarioGlobal=nameController.text.trim();
            storedSession=token['token'];
            setPreference();
            if(Platform.isAndroid){
              session.listarVentas().then((_){
                print('paso3');
                session.listarClaves().then((_){
                  print('paso4');
                  session.listarClientes().then((_) {
                    print('paso5');
                    session.listarCiudad().then((_) {
                      print('paso6');
                      session.listarDepartamento().then((_) {
                        session.listarHistorial().then((_) {
                          session.listarHistoricoVentas().then((_) {
                            print('paso7');
                            session.listarBase().then((_) {
                              print('paso8');
                              pr.hide();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
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
            }else{
              pr.hide();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
            }
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
          confirm ('Error en Usuario o Contraseña');  
        }
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
  };

  return WillPopScope(
    onWillPop:  () async => false,
    child:new Scaffold(
      body: Padding(
        padding: EdgeInsets.all(1),
          child: new Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  color:Colors.white,
                  height:600,
                  //MediaQuery.of(context).size.height,
                  //width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal:10,vertical:0),
                          height: 600,//MediaQuery.of(context).size.height * 0.70,
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomRight,
                            //   colors: [Color.fromRGBO(56, 124, 43, 1.0), Color.fromRGBO(176, 188, 34, 1.0)],
                            //   tileMode: TileMode.repeated,
                            // ),         
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1),
                              topRight: Radius.circular(1)
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            SizedBox(height: 50),
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
                              SizedBox(height: 10),
                              Icon(Icons.bar_chart_sharp, size:150,color:Theme.of(context).accentColor),
                              SizedBox(height: 10),
                              usuarioContrasena(_onPressed),
                            ],
                          ),
                        )
                      ],
                    ),
                ),
              ],
            ),
          ),
      ),
    ),   
  );
  }

  Container usuarioContrasena(Future<dynamic> _onPressed()) {
    return Container(
      width: 400,
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller:nameController ,
            validator: (value){
            if (value.isEmpty) {
                  return 'Por favor Ingrese su Usuario';
            }
            },
            style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold), 
            //TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            obscureText:false,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(      
                borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
              ),  
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color:Color.fromRGBO(83, 86, 90, 1.0),width: 1.0)
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white, width: 1.0)
              // ),
              labelText:"Usuario",
              labelStyle: TextStyle(color:Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold),
              suffixIcon: Icon(Icons.people_alt_rounded, size: 27,color: Color.fromRGBO(83, 86, 90, 1.0),),
            ),
            
          ),
          SizedBox(height: 10),
          TextFormField(
            controller:passwordController ,
            validator: (value){
            if (value.isEmpty) {
                  return 'Por favor Ingrese su Contraseña';
            }
            },
            style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold), 
            //style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            obscureText:true,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(      
                borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
              ),  
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white,width: 1.0)
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white, width: 1.0)
              // ),
              labelText:"Contraseña",
              labelStyle: TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold),
              suffixIcon: Icon(Icons.https, size: 27,color: Color.fromRGBO(83, 86, 90, 1.0),),
            ),
          
          ),
          SizedBox(height:30),
          Boton(onPresed: _onPressed,texto:'Aceptar',),
        
        ],
      ),
    );
  }
}
 
  