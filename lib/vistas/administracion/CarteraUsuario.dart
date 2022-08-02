import 'package:controlmax/modelos/Cartera.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/RutaAdmin.dart';
import 'package:controlmax/modelos/Gasto.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:controlmax/modelos/Asignar.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/modelos/ConteoDebeAdmin.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
class CarteraUsuario extends StatefulWidget {

  @override
  _CarteraUsuarioState createState() => _CarteraUsuarioState();
}

class _CarteraUsuarioState extends State<CarteraUsuario> {
  String dia;
  String ini;
  String ffinal;
  double entrega;
  List partirDia;
  String usuario;
  double retiro=0;
  ProgressDialog pr;
  List<Gasto> gastos;
  bool mostrar= false;
  DateTime parseFinal;
  int paginaActual=0;
  String fechaConsulta;
  FocusNode retiroNode;
  String selectedRegion;
  Menu menu = new Menu();
  DateTime parseInicial;
  List<Usuario> users=[];
  List<Usuario> _users=[];
  bool carteraFechas=false;
  List<Asignar> asignado=[];
  ConteoDebeAdmin _nuevaVenta;
  Cartera _recolectado;
  Cartera _porRecolectar;
  List<ConteoDebeAdmin> nuevaVenta;
  ConteoDebeAdmin _totalNuevaVenta;
  List<ConteoDebeAdmin> totalNuevaVenta;
  DateTime now = new DateTime.now();
  List<Cartera> recolectado=[];
  List<Cartera> porRecolectar=[];
  List<ConteoDebeAdmin> totalRecolectado=[];
  final formatSumar = DateFormat("yyyy-MM-dd");
  final format = DateFormat("dd/MM/yyyy hh:mm");
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextStyle textStyleDataCell = TextStyle(fontSize:15,);
  TextEditingController  couta = new TextEditingController();
  TextEditingController  base = new TextEditingController();
  TextEditingController  baseDia = new TextEditingController();
  
  @override
  void initState() {
    ini=formatSumar.format(now);
    ffinal=formatSumar.format(now);
    String fechaInicial=ini+' 00:00:00';
    String fechaFinal=ffinal+' 23:59:59';
    fechaConsulta = formatSumar.format(now);
    parseFinal = DateTime.parse(fechaFinal);
    parseInicial = DateTime.parse(fechaInicial);
    dia=DateFormat('EEEE, d').format(now);
    if(objetosUsuario.contains('CAF001') || objetosUsuario.contains("SA000")){
      carteraFechas = true;
    }
    super.initState();
  }
  Future<List<Cartera>>listarNoPago(usuario)async{
    var session= Insertar();
    await session.listarNoPago(usuario).then((_){
      recolectado=session.obtenerCartera();
    });
    return recolectado;
  }

  Future<List<ConteoDebeAdmin>>valoresVentasNuevas(usuario)async{
    var session= Insertar();
    await session.valoresVentasHoyUsuarioAdmin(usuario).then((_){
      nuevaVenta=session.obtenervaloresVentasHoyAdmin();
    });
    return nuevaVenta;
  }

  Future<List<RutaAdmin>> ventas(String usuario){
    var insertar = Insertar();
    return insertar.descargarRutaNoPago(usuario);
  }

  Future<List<ConteoDebeAdmin>>valoresVentasNuevasGeneral()async{
    var session= Insertar();
    await session.totalValoresVentasAdmin().then((_){
      totalNuevaVenta=session.obtenerTotalValoresVentasHoyAdmin();
    });
    return totalNuevaVenta;
  }
  Future<List<Cartera>> listarCartera(usuario)async{
    var session= Insertar();
     await session.listarCartera(usuario).then((_){
       porRecolectar=session.obtenerCartera();
     });
     return porRecolectar;
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
                value:selectedRegion,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    if(newValue !='Seleccione un usuario'){
                      usuario=selectedRegion;
                      mostrar=true;
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
          );
        }
      },
    );
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Valor ventas: "+_porRecolectar.venta.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              Text("Valor cartera: "+_porRecolectar.saldo.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
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

 Widget tablaNuevaVenta(){
  return FutureBuilder<List<ConteoDebeAdmin>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresVentasNuevas(usuario),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebeAdmin>> snapshot) {
      if (snapshot.hasData) {
        _nuevaVenta = nuevaVenta[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nuevas Ventas: "+_nuevaVenta.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              Text("Valor : "+_nuevaVenta.venta.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
Widget tablaNuevaVentaGeneral(){
  return FutureBuilder<List<ConteoDebeAdmin>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresVentasNuevasGeneral(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebeAdmin>> snapshot) {
      if (snapshot.hasData) {
        _totalNuevaVenta = totalNuevaVenta[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nuevas Ventas: "+_totalNuevaVenta.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              Text("Valor : "+_totalNuevaVenta.venta.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

Widget tablaNoRecolectado(){
  return FutureBuilder<List<Cartera>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: listarNoPago(usuario),
    builder: (BuildContext context, AsyncSnapshot<List<Cartera>> snapshot) {
      if (snapshot.hasData) {
        _recolectado = recolectado[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2,0, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("No pagos: "+_recolectado.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              Text("No recaudado: "+_recolectado.valorCuota.toStringAsFixed(1),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

 @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child:Container(
      color: Colors.white,
        child:new Center(
        //margin: new EdgeInsets.fromLTRB(100,0,100,0),
          child: Center( 
            child:new Form(
              key: keyForm,
              child:Container(
                width: 600,
                height: 610,
                margin: new EdgeInsets.fromLTRB(0,20,0,0),
                color:Colors.white,
                child:formUI(),
              ) 
            )
          ),
        )
      ),
      );
          // floatingActionButton:carteraFechas?FloatingActionButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => CarteraFechas()));
          //   },
          //   child:const Icon(Icons.calendar_today_rounded),
          //   //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
          // ):FloatingActionButton(
          //   onPressed:(){
          //     infoDialog(
          //       context, 
          //       'No tiene permisos para la funcionalidad',
          //       negativeAction: (){
          //       },
          //     );
          //   },
          // ),

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
  
  Widget cardCuenta(RutaAdmin item){
    DateTime fecha= DateTime.fromMillisecondsSinceEpoch(item.fecha);
    int diffDays = now.difference(fecha).inDays;
    double diferencia = diffDays-item.numeroCuota;
    String motivo=item.motivo;
    Icon iconoEstado;
    Color color;
    Icon icono;
    if(diferencia <=3 )
    {
      icono=Icon(Icons.thumb_up, size:30,color:Colors.green);
    }else if(diferencia > 3 && diferencia < 6)
    {
      icono=Icon(Icons.thumbs_up_down , size:30,color:Colors.yellow);
    }else if(diferencia == 0)
    {
      icono=Icon(Icons.person, size:30,);
    }else{
      icono=Icon(Icons.thumb_down_sharp, size:30,color:Colors.red);
    }

    if(motivo=="abono" || motivo=="pago"|| motivo=="Prestamo"){
      iconoEstado=Icon(Icons.check, size:20,color:Colors.green);
      color=Colors.green;
    }else if(motivo!="abono" && motivo!="pago"){
      iconoEstado=Icon(Icons.clear, size:20,color:Colors.red);
    }
    print(diffDays);
    return 
    Card(
      child:
      ListTile(
        leading:icono,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("D:"+item.idCliente.toString()+" "+item.alias,style: TextStyle(
              fontSize: 18,)
            ),
            Text(item.nombre+" "+item.primerApellido,style: TextStyle(
              fontSize: 18,)
            ),
          ],
        ),
        subtitle:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text((item.cuotas-item.numeroCuota).toStringAsFixed(1),style: TextStyle(fontSize:15,)),
                Text(" / ",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:15,)),
                Text(item.saldo.toStringAsFixed(1),style: TextStyle(fontSize:15,)),
                Text(" / ",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:15,)),
                Text(item.valorCuota.toStringAsFixed(1),style: TextStyle(fontSize:15,)),
                iconoEstado,
                SizedBox(width: 5.0),
                //Text(item.valorDia.toStringAsFixed(1),style: TextStyle(fontSize:15,color: color)),
                SizedBox(width: 5.0),
              ],
            ),
            Text(format.format((DateTime.fromMillisecondsSinceEpoch(item.orden,isUtc:false))).toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:15)), 
          ],
        ),
        // onTap: () {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => RecoleccionAdmin(data: item,),)); }
        //   );
        // },
      )
    );
  }
  FutureBuilder<List<RutaAdmin>> listaVentas(String usuario) {
    return FutureBuilder<List<RutaAdmin>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: ventas(usuario),
      builder: (BuildContext context, AsyncSnapshot<List<RutaAdmin>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              RutaAdmin item = snapshot.data[index];
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

  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.center,
      children: <Widget>[
        dataBody(),
        Container(height:20,),
        mostrar?
        Container(
          child: SizedBox(
            child:tablaCartera(),
          ),
        )
        :Container(),
        separador(),
        Container(height:10,),
        mostrar?
        Container(
          child:
           SizedBox(
            child:tablaNoRecolectado(),
          ),
        )
        :Container(),  
        separador(),
        Container(height:40,),
        mostrar?
        Expanded(
          child: Container(
            width:360,
            child:listaVentas(usuario)
          )   
        ):Container(),    
      ]
    );
  }

  @override
  void dispose() {
    couta.dispose();
    base.dispose();
    baseDia.dispose();
    super.dispose();
  }
}