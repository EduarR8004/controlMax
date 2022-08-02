import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/vistas/ventas.dart';
import 'package:controlmax/modelos/Cliente.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/agenda/crearAgenda.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

// class Historial extends StatefulWidget {
//   Historial({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _HistorialState createState() => new _HistorialState();
// }

// class _HistorialState extends State<Historial> {
//   //List <Cliente> duplicateItems;
//   TextEditingController editingController = TextEditingController();
//   Future<List<Cliente>> clientes(){
//     var insertar = Insertar();
//     insertar.consultarClientes();
//   }
//     final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
//     var items = [];

//   @override
//   void initState() {
//     items.addAll(duplicateItems);
//     super.initState();
//   }

//   void filterSearchResults(String query) {
//     List<String> dummySearchList = [];
//     dummySearchList.addAll(duplicateItems);
//     if(query.isNotEmpty) {
//       List<String> dummyListData = [];
//       dummySearchList.forEach((item) {
//         if(item.contains(query)) {
//           dummyListData.add(item);
//         }
//       });
//       setState(() {
//         items.clear();
//         items.addAll(dummyListData);
//       });
//       return;
//     } else {
//       setState(() {
//         items.clear();
//         items.addAll(duplicateItems);
//       });
//     }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 onChanged: (value) {
//                   filterSearchResults(value);
//                 },
//                 controller: editingController,
//                 decoration: InputDecoration(
//                     labelText: "Search",
//                     hintText: "Search",
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(25.0)))),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text('${items[index]}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Historial extends StatefulWidget {
  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  TextEditingController  filtro = new TextEditingController();
  Future<List<Cliente>> clientes(filtro){
    var insertar = Insertar();
    return insertar.consultarClientes(filtro: filtro);
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
  
   Widget cardCuenta(Cliente item){
    // DateTime fecha= DateTime.fromMillisecondsSinceEpoch(item.fecha);
    // int diffDays = now.difference(fecha).inDays;
    // double diferencia = diffDays-item.numeroCuota;
    // Icon icono;
    // if(diferencia <=3 )
    // {
    //   icono=Icon(Icons.thumb_up, size:30,color:Colors.green);
    // }else if(diferencia > 3 && diferencia < 6)
    // {
    //   icono=Icon(Icons.thumbs_up_down , size:30,color:Colors.yellow);
    // }else{
    //   icono=Icon(Icons.thumb_down_sharp, size:30,color:Colors.red);
    // }
    // print(diffDays);
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
            Text("Documento : "+item.documento,style: TextStyle(fontSize:16,)),
            Text("Dirección : "+item.direccion,style: TextStyle(fontSize:16,)),
            Text("Ciudad : "+item.ciudad,style: TextStyle(fontSize:16,)),
            Text("Alias : "+item.alias,style: TextStyle(fontSize:16,)),
            Text("Telefóno : "+item.telefono,style: TextStyle(fontSize:16,)),
          ],
        ), 
        onTap: () {
          infoDialog(
            context, 
            "Por favor haga clic en la funcionalidad requerida",
            neutralText:'Agendamiento',
            neutralAction: (){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => CrearAgenda(true,cliente:item))); }
              );
            },
            positiveText:'Ventas',
            positiveAction:(){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => NuevaVentaView(true,true,true,cliente:item,))); }
              );
            } 
          ); 
        },
      )
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
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    var menu = new Menu();
    return WillPopScope(
      onWillPop: null,
      child:
      SafeArea(
        top: false,
        child: Scaffold(
          appBar: new AppBar(title: new Text('Historial Cliente'),actions: <Widget>[
          ],
          ),
          drawer: menu,
          body: body(),
        )
      )
    );
  }

  FutureBuilder<List<Cliente>> listarClientes() {
    return FutureBuilder<List<Cliente>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: clientes(filtro.text),
      builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              Cliente item = snapshot.data[index];
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
}