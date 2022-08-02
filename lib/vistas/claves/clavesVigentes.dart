import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Claves.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
class ClavesVigentes extends StatefulWidget {

  @override
  _ClavesVigentesState createState() => _ClavesVigentesState();
}

class _ClavesVigentesState extends State<ClavesVigentes> {
  ProgressDialog pr;
  Menu menu = new Menu();
  GlobalKey<FormState> keyForm = new GlobalKey();
  
  @override
  void initState() {
    super.initState();
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
            title: Text('Claves vigentes',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
  
  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Claves vigentes para el usuario, sí requiere actualizar la información, clic en el botón aceptar',style:TextStyle(fontWeight: FontWeight.bold,fontSize:20,)),
        ),
        Boton(onPresed:onPressed,texto:'Aceptar',),
        Expanded(
          child: SizedBox(
            //height: 200.0,
            child:listaClaves(),
          ),
        ) 
      ]
    );
  }

  onPressed()async{  
    Insertar session= Insertar();
    await pr.show();
    session.listarClavesUsuario().then((_){
      pr.hide();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => ClavesVigentes(),)); 
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
  Widget cardCuenta(Clave item){
    return 
    Card(
      child:
      ListTile(
        leading:Icon(Icons.lock_open_rounded,size:30),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.clave,style:TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:18,)
            ),
            Row(
              children: [
                Text("Tipo: "+item.tipo,style: TextStyle(
                  fontSize: 18,)
                ),
                Text(" / "+item.valor,style: TextStyle(
                  fontSize: 18,)
                ),
              ],
            ),
          ],
        ), 
        onTap: () {
        },
      )
    );
  }

  FutureBuilder<List<Clave>> listaClaves() {
    return FutureBuilder<List<Clave>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: claves(),
      builder: (BuildContext context, AsyncSnapshot<List<Clave>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              Clave item = snapshot.data[index];
              //delete one register for id
              return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (diretion) {
                  //DatabaseProvider.db.eliminarId(item.id,"producto");
                },
                //Ahora pintamos la lista con todos los registros
                child:cardCuenta(item),
              );
            },
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
 }
}