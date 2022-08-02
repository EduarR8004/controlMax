import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Cartera.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CarteraFechas extends StatefulWidget {

  @override
  _CarteraFechasState createState() => _CarteraFechasState();
}

class _CarteraFechasState extends State<CarteraFechas> {
  dynamic usuario;
  bool todos=true;
  bool mostrar= false;
  String selectedRegion;
  String  fini;
  String ffinal;
  Menu menu = new Menu();
  List<Usuario> users=[];
  List<Usuario> _users=[];
  Cartera _porRecolectar;
  List<Usuario>pasoParametro=[];
  List<Cartera> porRecolectar=[];
  final format = DateFormat("dd/MM/yyyy");
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: 
      Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child:new Center(
                child:dataBody(),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child:new Center(
                child:fechaInicial(context),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child:new Center(
                child:fechaFinal(context),
              )
            ),
          ),
          Container(
            color: Colors.white,
            height: 10,
          ),
          Container(
            color: Colors.white,
            height: 60,
            width: 200,
            child:Boton(onPresed: _onPressed,texto:'Aceptar',), 
          ),
          Container(height:10,),
          Container(height:10,),
          mostrar?
          Container(
            child: SizedBox(
              child:tablaCartera(),
            ),
          )
          :Container(),
        ],
      ),
    );
    //       ),
    //       floatingActionButton: FloatingActionButton(
    //         onPressed: () {
    //           Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => ReporteCarteraAdministrador()));
    //         },
    //         child:const Icon(Icons.business_center_rounded,),
    //         //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
    //       ),
    //     ),
    //   ),
    // );
  }

   _onPressed ()async{
    
    if(_startTimeController.text=='' && _endTimeController.text==''||_startTimeController.text=='Fecha Inicial' || _endTimeController.text=='Fecha Final')
    {
      infoDialog(
        context, 
        'Por favor verificar las fechas',
        negativeAction: (){
        },
      );
    }else if(selectedRegion=='Seleccione un usuario' || selectedRegion==null){
      infoDialog(
        context, 
        'Por favor seleccione un usuario.',
        negativeAction: (){
        },
      );
    }else{
      List<String>fechaicambio=_startTimeController.text.split('/');
      List<String> fechafcambio=_endTimeController.text.split('/');
      fini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
      ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
      setState(() {
        fini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
        ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
        mostrar=true;
      });
    }
  }
  Future <List<Usuario>> listarUsuario()async{
    var usuario= Insertar();
    if(users.length > 0)
    {
      return users;
    }
    else
    {
      await usuario.descargarUsuarios().then((_){
        var preUsuarios=usuario.obtenerUsuarios();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      return users;
    }
  }
  Future<List<Cartera>> listarCartera(usuario)async{
    var session= Insertar();
     await session.listarCarteraFechas(fini,ffinal,usuario).then((_){
       porRecolectar=session.obtenerCartera();
     });
     return porRecolectar;
  }
  Widget separador(){
    return 
    mostrar?Padding(
      padding: const EdgeInsets.fromLTRB(10,0,10,0),
      child: const Divider(
        height: 5,
        thickness: 2,
        //indent: 20,
        //endIndent: 20,
      ),
    ):Container();
  }
  Widget tablaCartera(){
    return FutureBuilder<List<Cartera>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: listarCartera(usuario),
      builder: (BuildContext context, AsyncSnapshot<List<Cartera>> snapshot) {
        if (snapshot.hasData) {
          _porRecolectar = porRecolectar[0];
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Valor cartera: "+_porRecolectar.saldo.toStringAsFixed(2),style: TextStyle(fontWeight:FontWeight.bold,fontSize:22,)),
                Container(height:10,),
                Text("Total clientes: "+_porRecolectar.documentos.toStringAsFixed(0),style: TextStyle(fontWeight:FontWeight.bold,fontSize:22,)),
                //_porRecolectar.valorCuota==null?Text(" día: "+"0",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Total a recaudar: "+_porRecolectar.valorCuota.toStringAsFixed(1),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              ],
            ),
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  Widget dataBody() {
    return FutureBuilder<List<Usuario>>(
      future:listarUsuario(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          _users = (users).toList();
          return  Container(
            height: 50,
            width: 300,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(10, 5, 10,10),
            decoration: BoxDecoration(
              border: Border(bottom:BorderSide(width: 1,
                color: Color.fromRGBO(83, 86, 90, 1.0),
              ),),
            ),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                hint:Text('Seleccione un usuario', textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Karla',
                  ),), 
                // Padding(
                //   padding: EdgeInsets.fromLTRB(5, 2, 5,2),
                //   //child: Center(
                //       child:Text('Seleccione un usuario', textAlign: TextAlign.center,style: TextStyle(
                //   fontSize: 15.0,
                //   fontFamily: 'Karla',
                //   ),),
                // ),
                //),
                value:selectedRegion,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    if(newValue !='Seleccione un usuario'){
                      usuario=selectedRegion;
                      //mostrar=true;
                    }
                  });
                },
                items: _users.map((Usuario map) {
                  return new DropdownMenuItem<String>(
                    value: map.usuario,
                    //child: Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0,2),
                      child:
                      new Text(map.nombreCompleto,textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black)
                      ),
                    ),
                  //),
                  );
                }).toList(),
              ),
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
  Container fechaInicial(BuildContext context) {
    return 
    Container(
      width: 330,
      padding: EdgeInsets.fromLTRB(50, 10, 40, 10),
      child: DateTimeField(
        controller: _startTimeController,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100)
          );
        },
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){
              },
            icon: Icon(
            Icons.calendar_today,
            color: Colors.grey,
            ),
          ),
          enabledBorder:
          UnderlineInputBorder(      
            borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
          ),  
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
          ),
        labelText: 'Fecha Inicial',
        ),
      ),
    );
  }

  Container fechaFinal(BuildContext context) {
    return 
    Container(
      width: 330,
      padding: EdgeInsets.fromLTRB(50, 10, 40, 10),
      child: DateTimeField(
        controller: _endTimeController,
        onChanged: (text) {
          if(_endTimeController.text!='')
          {  
            
          }else{
            infoDialog(
              context, 
              'Por favor ingrese la fecha inicial',
              negativeAction: (){
              },
            );
          }
        },
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100)
          );
        },
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){
              },
            icon: Icon(
            Icons.calendar_today,
            color: Colors.grey,
            ),
          ),
          enabledBorder:
          UnderlineInputBorder(      
            borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
          ),  
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
          ),
        labelText: 'Fecha Final',
        ),
      ),
    );
  }
}

