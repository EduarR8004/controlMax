import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Ventas.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class HistorialCreditoView extends StatefulWidget {
  
  @override
  _HistorialCreditoViewState createState() => _HistorialCreditoViewState();
}

class _HistorialCreditoViewState extends State<HistorialCreditoView> {
  bool boton= true;
  DateTime now = new DateTime.now();
  final format = DateFormat("dd/MM/yyyy");
  TextEditingController  filtro = new TextEditingController();

  @override
  void didUpdateWidget(HistorialCreditoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      //widget.boton==true?boton=true:boton=false;
    });
  }
  @override
  void initState() {
    super.initState();
  }

  Future<List<Ventas>> ventas(filtro){
    var insertar = Insertar();
    return insertar.historicoVentas(filtro:filtro);
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
              ventas(filtro.text);
            });
          },
        ), title: item)),
    );
  }

  Widget cardCuenta(Ventas item){
    return 
    Card(
      child:
      ListTile(
        leading:Icon(Icons.person,size:50),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.nombre+" "+item.primerApellido,style: TextStyle(
              fontSize: 18,)
            ),
            
            Row(
              children: [
                Text("D:"+item.idCliente+" "+item.alias,style: TextStyle(
                  fontSize: 18,)
                ),
              ],
            )
          ],
        ),
        subtitle:Row(
          children: [
            Text((item.solicitado).toStringAsFixed(1),style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:18,)),
            Text(" / ",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:18,)),
            Text(item.cuotas.toStringAsFixed(1),style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:18,)),
            Text(" / ",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:18,)),
            Text(item.valorCuota.toStringAsFixed(1),style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:18,)),
            SizedBox(width: 12.0),
          ],
        ), 
        onTap: () {
          //WidgetsBinding.instance.addPostFrameCallback((_) {
          //   Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Recoleccion(data: item,),)); }
          // );
        },
      )
    );
  }
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    var menu = new Menu();
    return WillPopScope(
      onWillPop: () async => false,
      child:
      SafeArea(
        top: false,
        child: Scaffold(
          appBar: new AppBar(title: new Text('Historial de pago'),actions: <Widget>[
          ],
          ),
          drawer: menu,
          body: body(),
        )
      ),
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
            onChanged: (text){
              setState(() {
                ventas(text);
              });
            },
          )
        ),
        Expanded(
          child: listaVentas()
        )
      ],
    );
  }
  FutureBuilder<List<Ventas>> listaVentas() {
    return FutureBuilder<List<Ventas>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: ventas(filtro.text),
      builder: (BuildContext context, AsyncSnapshot<List<Ventas>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              Ventas item = snapshot.data[index];
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

  @override
  void dispose() {
    filtro.dispose();
    super.dispose();
  }
}