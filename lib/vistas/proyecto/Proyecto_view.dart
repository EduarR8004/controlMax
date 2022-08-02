import 'package:controlmax/modelos/Proyecto.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Gasto.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/modelos/UsuarioAdministrador.dart';

class ProyectosView extends StatefulWidget {
  final Gasto objeto;
  final bool editar;

  ProyectosView({Key key,
  this.objeto,this.editar}) : super();

  @override
  _ProyectosViewState createState() => _ProyectosViewState();
}

class _ProyectosViewState extends State<ProyectosView> {
  dynamic usuario;
  bool porUsuario=false;
  String selectedRegion;
  List<UsuarioAdmin> users=[];
  List<UsuarioAdmin> _users=[];
  String dropdown ="Ingrese el gasto";
  List<UsuarioAdmin>pasoParametro=[];
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  nombreProyecto = new TextEditingController();
  Menu menu = new Menu();
  @override
  void initState() {
    super.initState();
    if(widget.editar == true){
      dropdown =widget.objeto.tipo; 
      widget.objeto==null?widget.objeto.idGasto='0':widget.objeto.idGasto.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Proyecto',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    height: 600,
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
      mainAxisAlignment:MainAxisAlignment.center,
      crossAxisAlignment:CrossAxisAlignment.center,
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
        formItemsDesign(
          Icons.account_tree_rounded,
          TextFormField(
            controller: nombreProyecto,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              labelText: 'Proyecto',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el valor del gasto';
              }
            },
          ),
        ),
        Boton(onPresed: _onPressed,texto:'Aceptar',),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Proyectos",style:TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold,fontSize:20,)),
        ),
        body(),
      ]
    );
  }

  Widget dataBody() {
    return FutureBuilder<List<UsuarioAdmin>>(
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
                      print(users[0].nombreCompleto.toString());
                    }
                  });
                },
                items: _users.map((UsuarioAdmin map) {
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
  Widget body(){
    return 
    Expanded(
      child:Container(
        width:355,
        child:listaProyectos()
      )
    );
  }
  FutureBuilder<List<Proyecto>> listaProyectos() {
    return FutureBuilder<List<Proyecto>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: listarProyectos(),
      builder: (BuildContext context, AsyncSnapshot<List<Proyecto>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              Proyecto item = snapshot.data[index];
              //delete one register for id
              return cardCuenta(item);
              // Dismissible(
              //   key: UniqueKey(),
              //   background: Container(color: Colors.red),
              //   onDismissed: (diretion) {
              //     //DatabaseProvider.db.eliminarId(item.id,"producto");
              //   },
              //   //Ahora pintamos la lista con todos los registros
              //   child:cardCuenta(item),
              // );
            },
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  Widget cardCuenta(Proyecto item){
    return 
    Card(
      child:
      ListTile(
        leading:Icon(Icons.account_tree_rounded,size:30),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Proyecto: "+item.proyecto,style: TextStyle(
              fontSize: 18,)
            ),
            Text("Admin: "+item.administrador,style: TextStyle(
              fontSize: 18,)
            ),
            Row(
              children: [
                Text("Fecha: "+item.fecha,style: TextStyle(
                  fontSize: 18,)
                ),
                // Text(" / "+item.valor,style: TextStyle(
                //   fontSize: 18,)
                // ),
              ],
            ),
          ],
        ), 
        onTap: () {

        },
      )
    );
  }
  Future <List<UsuarioAdmin>> listarUsuario()async{
    var usuario= Insertar();
    if(users.length > 0)
    {
      return users;
    }
    else
    {
      await usuario.descargarAdministrador().then((_){
        var preUsuarios=usuario.obtenerUsuarios();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      return users;
    }
  }
  crearProyecto(codParametro)async{
    Insertar usuario= Insertar();
    await usuario.crearProyecto(codParametro,nombreProyecto.text.trim()).then((data){
      if(data[0]=='1')
      {
        successDialog(
          context, 
          'Se creó el proyecto correctamente.',
          neutralText: "Aceptar",
          neutralAction: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProyectosView())
            );
          },
        );
      }else{
        infoDialog(
          context, 
          'Ya existe un proyecto con este nombre.',
          neutralText: "Aceptar",
          neutralAction: (){
          }
        );
      }
      
    });
  }
  _onPressed ()async{
    if(porUsuario==false ){
      if(nombreProyecto.text!=''){
        infoDialog(
          context, 
          'Desea crear un proyecto sin Administrador ?',
          negativeText: "Si",
          negativeAction: (){
            crearProyecto('');
          },
          neutralText: "No",
          neutralAction: (){
          }
        );
      }else{
        infoDialog(
          context, 
          'Ya existe un proyecto con este nombre.',
          neutralText: "Aceptar",
          neutralAction: (){
          }
        );
      }
    }else{
      if(nombreProyecto.text!=''){
        for ( var par in usuario)
        {
          pasoParametro.add(par);
        }
        String usuarioCuadre;
        pasoParametro.map((UsuarioAdmin map) {
          usuarioCuadre=map.usuario;
        }).toList();
        crearProyecto(usuarioCuadre);
      }else{
        infoDialog(
          context, 
          'Ya existe un proyecto con este nombre.',
          neutralText: "Aceptar",
          neutralAction: (){
          }
        );
      }
    }
  }
  Future<List<Proyecto>> listarProyectos(){
    var insertar = Insertar();
    return insertar.listarProyectos();
  }
  
  @override
  void dispose() {
    nombreProyecto.dispose();
    super.dispose();
  }
}