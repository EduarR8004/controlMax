import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/administracion/ConsultarBloqueados.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ConsultarFechaBloqueados extends StatefulWidget {
  @override
  _ConsultarFechaBloqueadosState createState() => _ConsultarFechaBloqueadosState();
}

class _ConsultarFechaBloqueadosState extends State<ConsultarFechaBloqueados> {
  String fini;
  String ffinal;
  dynamic usuario;
  bool mostrar=false;
  String selectedRegion;
  dynamic codParametro;
  List<Usuario> users=[];
  List<Usuario> _users=[];
  List<Usuario>pasoParametro=[];
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  final format = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: 
      Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mostrar?Container():Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child:new Center(
              //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                child:dataBody(),
              )
            ),
          ),
          mostrar?Container():Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child:new Center(
              //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                child:fechaInicial(context),
              )
            ),
          ),
          mostrar?Container():Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child:new Center(
              //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                child:fechaFinal(context),
              )
            ),
          ),
          mostrar?Container():Container(
            color: Colors.white,
            height: 30,
          ),
          mostrar?Container():Container(
            color: Colors.white,
            height: 60,
            width: 200,
            child:Boton(onPresed: _onPressed,texto:'Aceptar',), 
          ),
          Expanded(
            child:mostrar?ConsultarBloqueados(fechaFinal:ffinal,fechaInicial:fini,parametro: codParametro,):Container(),
          ), 
        ],
      ),
    );
  }

   _onPressed ()async{
    List<String>fechaicambio=_startTimeController.text.split('/');
    List<String> fechafcambio=_endTimeController.text.split('/');
    fini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
    ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
    for ( var par in usuario)
    {
      pasoParametro.add(par);
    }
    pasoParametro.map((Usuario map) {
      codParametro=map.usuario;
    }).toList();
    setState(() {
      mostrar=true;
    }); 
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
}