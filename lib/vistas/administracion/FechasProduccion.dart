import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:controlmax/vistas/administracion/ConsultarProduccion.dart';

class FechasProduccion extends StatefulWidget {
  

  @override
  _FechasProduccionState createState() => _FechasProduccionState();
}

class _FechasProduccionState extends State<FechasProduccion> {
  Menu menu = new Menu();
  dynamic usuario;
  String selectedRegion;
  bool todos=true;
  List<Usuario> users=[];
  List<Usuario>pasoParametro=[];
  List<Usuario> _users=[];
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  final format = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop:  () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Consultar Producción',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
          ),
          drawer: menu,
          body:  new SingleChildScrollView(
            child:
            Container(
              color: Colors.white,
              child: 
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      child:new Center(
                      //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                        child:dataBody(),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      child:new Center(
                      //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                        child:fechaInicial(context),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      child:new Center(
                      //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                        child:fechaFinal(context),
                      )
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 30,
                  ),
                  Container(
                    color: Colors.white,
                    height: 60,
                    width: 200,
                    child:Boton(onPresed: _onPressed,texto:'Aceptar',), 
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   _onPressed ()async{
    List<String>fechaicambio=_startTimeController.text.split('/');
    List<String> fechafcambio=_endTimeController.text.split('/');
    String  fini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
    String ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
    DateTime parseInicial = DateTime.parse(fini);
    DateTime parseFinal = DateTime.parse(ffinal);
    int diffDays = parseFinal.difference(parseInicial).inDays;
    if(objetosUsuario.contains('APA001') || objetosUsuario.contains("SA000")){
      if(todos){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ConsultarProduccion(fechaFinal:ffinal,fechaInicial:fini ,todos:todos,))
        );
      }else{
        for ( var par in usuario)
        {
          pasoParametro.add(par);
        }
        var codParametro;
        pasoParametro.map((Usuario map) {
          codParametro=map.usuario;
        }).toList();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ConsultarProduccion(fechaFinal:ffinal,fechaInicial:fini ,parametro: codParametro,todos:false,))
        );
      }
      
    }else{
      if(diffDays > 15)
      {
        infoDialog(
          context, 
          'La consulta no puede ser superior a 15 días',
          negativeAction: (){
          },
        );
      }else{
        if(todos){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ConsultarProduccion(fechaFinal:ffinal,fechaInicial:fini ,todos:todos,))
          );
        }else{
          for ( var par in usuario)
          {
            pasoParametro.add(par);
          }
          var codParametro;
          pasoParametro.map((Usuario map) {
            codParametro=map.usuario;
          }).toList();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ConsultarProduccion(fechaFinal:ffinal,fechaInicial:fini ,parametro: codParametro,))
          );
        }
      }
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
                      todos=false;
                      usuario=users.where((a) => a.usuario==newValue);
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