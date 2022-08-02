import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:controlmax/vistas/baseGeneral/ConsultaBaseGeneralUsuario.dart';


class FechasBase extends StatefulWidget {
  
  @override
  _FechasBaseState createState() => _FechasBaseState();
}

class _FechasBaseState extends State<FechasBase> {
  bool porUsuario=false;
  dynamic usuario;
  Menu menu = new Menu();
  String selectedRegion;
  List<Usuario> users=[];
  List<Usuario> _users=[];
  List<Usuario>pasoParametro=[];
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop:  () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Consultar Total Caja',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(
                  //     color: Colors.white,
                  //     child:new Center(
                  //     //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                  //       child:dataBody(),
                  //     )
                  //   ),
                  // ),
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
    if(porUsuario==false){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ConsultarBaseGeneralUsuario(fechaFinal:_endTimeController.text,fechaInicial:_startTimeController.text,))
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
        MaterialPageRoute(builder: (context) => ConsultarBaseGeneralUsuario(fechaFinal:_endTimeController.text,fechaInicial:_startTimeController.text,usuario: codParametro,))
      );
    }
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
                onChanged: (newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    if(newValue !='Seleccione un usuario'){
                      porUsuario=true;
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
}