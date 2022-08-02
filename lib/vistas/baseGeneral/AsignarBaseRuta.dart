import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:intl/intl.dart';

class BaseRuta extends StatefulWidget {
  final bool editar;
  final String valor;
  final String usuario;
  final String nombre;
  final String fecha;
  final idBase;
  BaseRuta(this.editar,{ this.valor,this.usuario,this.fecha,this.idBase,this.nombre});
  @override
  _BaseRutaState createState() => _BaseRutaState();
}

class _BaseRutaState extends State<BaseRuta> {
  dynamic usuario;
  String newValue;
  String selectedRegion;
  List<Usuario> users=[];
  Menu menu = new Menu();
  List<Usuario> _users=[];
  List<Usuario>pasoParametro=[];
  final format = DateFormat("yyyy-MM-dd");
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  couta = new TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  @override
    void initState() {
      if(widget.editar == true){
        couta.text=widget.valor;
        newValue=widget.nombre;
        _startTimeController.text=widget.fecha;
      }
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Asignar Base a Ruta',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    height: 400,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          )
        ),
      ),
    );
  }
  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
  }
  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20,40,15,5),
              child: Container(
                child:Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ), 
              ),
            ),
            fechaInicial(context),
          ],
        ),
        formItemsDesign(
          Icons.attach_money,
          TextFormField(
            controller: couta,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Cantidad',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el valor a asignar';
              }
            },
          ),
        ),
        Boton(onPresed: _onPressed,texto:'Aceptar',),
         
      ]
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
                hint:Text(widget.editar?widget.usuario:'Seleccione la ruta', textAlign: TextAlign.center,style: TextStyle(
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
      width:325,
      padding: EdgeInsets.fromLTRB(16, 10, 15, 10),
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
          // prefixIcon: IconButton(
          //   onPressed: (){
          //     },
          // ),
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
        labelText: 'Fecha',
        ),
      ),
    );
  }

  _onPressed ()async{
    String fecha ='';
    String idBase='';
    if(widget.editar == true){
      usuario=users.where((a) => a.usuario==selectedRegion);
      fecha=widget.fecha;
      idBase=widget.idBase;
    }
    for ( var par in usuario)
    {
      pasoParametro.add(par);
    }
    var codParametro;
    pasoParametro.map((Usuario map) {
      codParametro=map.usuario;
    }).toList();
    double valorIngresar = double.parse(couta.text);
    if(couta.text!=""){
      var session= Insertar();
      session.enviarBaseRuta(codParametro==null?widget.usuario:codParametro,valorIngresar,widget.editar,fechaEditar:fecha,idBase:idBase,fecha: _startTimeController.text )
      .then((_) {
        successDialog(
          context, 
          "Asignacón exitosa",
          neutralAction: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BaseRuta(false))
            );
          },
        );   
      });
    }else{
      warningDialog(
        context, 
        "Por favor ingrese un valor",
        neutralAction: (){
        },
      );
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
  
}