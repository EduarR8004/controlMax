import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Agendamiento.dart';
import 'package:controlmax/vistas/agenda/crearAgenda.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class ListarAgenda extends StatefulWidget {

  @override
  _ListarAgendaState createState() => _ListarAgendaState();
}

class _ListarAgendaState extends State<ListarAgenda> {
  TextEditingController  filtro = new TextEditingController();
  Agendamiento _porAgendar;
  List<Agendamiento> agendado=[];
  Future<List<Agendamiento>> clientes(filtro){
    var insertar = Insertar();
    return insertar.consultarAgendamiento(filtro: filtro);
  }
  Future <List<Agendamiento>>consultaAgendado()async{
    var session= Insertar();
    await session.consultarAgendado().then((_){
      agendado=session.obtenerAgendado();
    });
    return agendado;            
  }
  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:4),
      child: Card(child: ListTile(
        leading:IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Búsqueda',
          onPressed: () {
            setState(() {
              clientes(filtro.text);
            });
          },
        ), title: item)),
    );
  }
  
   Widget cardCuenta(Agendamiento item){
    return 
    Card(
      child:
      ListTile(
        leading:Icon(Icons.person,size:50),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre : "+item.nombre+' '+item.primerApellido,style: TextStyle(fontSize:18,)),
          ],
        ),
        subtitle:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha : "+item.fechaTexto,style: TextStyle(fontSize:16,)),
            Text("Valor : "+item.solicitado.toString(),style: TextStyle(fontSize:16,)),
            Text("Documento : "+item.documento,style: TextStyle(fontSize:16,)),
            Text("Telefóno : "+item.telefono,style: TextStyle(fontSize:16,)),
          ],
        ), 
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => CrearAgenda(true,agendamiento: item,))); }
          );
        },
      )
    );
  }
  Widget tablaAgendado(){
    return FutureBuilder<List<Agendamiento>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: consultaAgendado(),
      builder: (BuildContext context, AsyncSnapshot<List<Agendamiento>> snapshot) {
        if (snapshot.hasData) {
          _porAgendar = agendado[0];
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _porAgendar.solicitado==null?Text("Valor agenda: "+"0",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Colors.blueGrey)):Text("Valor agenda: "+_porAgendar.solicitado.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Colors.blueGrey)),
                  ],
                ),
              ],
            ),
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
   Widget body(){
    return Column(
      children: [
        formItemsDesign(
          Icons.search,
          TextFormField(
            controller: filtro,
            decoration: new InputDecoration(
              labelText: 'Buscar',
            ),
          )
        ),
        Expanded(
          child: listarClientes()
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: 
            // Expanded(
            //   child: 
              SizedBox(
                child:tablaAgendado(),
              ),
            //),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    var menu = new Menu();
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(title: new Text('Agendamiento'),actions: <Widget>[
        ],
        ),
        drawer: menu,
        body: body(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => CrearAgenda(false))); }
              );
            },
            child:const Icon(Icons.person),
            //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
          ),
      )
    );
  }

  FutureBuilder<List<Agendamiento>> listarClientes() {
    return FutureBuilder<List<Agendamiento>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: clientes(filtro.text),
      builder: (BuildContext context, AsyncSnapshot<List<Agendamiento>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              Agendamiento item = snapshot.data[index];
              //delete one register for id
              return cardCuenta(item);
              // return Dismissible(
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
}