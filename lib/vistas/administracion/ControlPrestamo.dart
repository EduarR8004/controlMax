
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/modelos/ControlPrestamo.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class ControlPrestamo extends StatefulWidget {
  @override
  ControlPrestamoState createState() => ControlPrestamoState();
}
 
class ControlPrestamoState extends State<ControlPrestamo> {
  Color color;
  String mensaje,texto;
  List<Widget> lista =[];
  List<Control> users=[];
  bool refrescar = false;
  List<Control> selectedUsers;
  String dropdownValue = 'Opciones';
  final format = DateFormat("dd/MM/yyyy");
  TextEditingController  filtro = new TextEditingController();

  Future <List<Control>> listarUsuario(filtro)async{
    var usuario= Insertar();
    users=[];
    await usuario.listarControlPrestamo(filtro).then((_){
      var preUsuarios=usuario.obtenerControlPrestamo();
      for ( var usuario in preUsuarios)
      {
        if(!users.contains(usuario)){
          users.add(usuario);
        }
      }        
    });
    users.toSet().toList();
    return users;
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:4),
      child: Card(child: ListTile(
        leading:IconButton(
          icon: const Icon(Icons.search_rounded),
          tooltip: 'Búsqueda',
          onPressed: () {
            setState(() {
              print('consultando');
              ControlPrestamo();
              //listarUsuario(filtro.text);
            });
          },
        ), title: item)),
    );
  }
    
  @override
  void initState() {
    selectedUsers = [];
    super.initState();
  }

  Widget  dataBody(texto) {
    return FutureBuilder <List<Control>>(
      future:listarUsuario(filtro.text),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyleDataCell = TextStyle(fontSize:15,);
          return  
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView( 
                scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                    MaterialStateColor.resolveWith((states) =>Theme.of(context).accentColor, ),
                    horizontalMargin:9,
                    columnSpacing:9,
                    columns: [
                      DataColumn(
                        label: Text("Nombre",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Nombre",
                      ),
                      DataColumn(
                        label: Text("Apellido",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Apellido",
                      ),
                      DataColumn(
                        label: Text("Alias",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Alias",
                      ),
                       DataColumn(
                        label: Text("Documento",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Documento de identidad",
                      ),
                      DataColumn(
                        label: Text("F.U.Venta",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Fecha Última Venta",
                      ),
                      DataColumn(
                        label: Text("Días Mora",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Días Mora",
                      ),
                      DataColumn(
                        label: Text("Venta Actual",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Ventas",
                      ),
                      DataColumn(
                        label: Text("Cuotas",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Cuotas",
                      ),
                      DataColumn(
                        label: Text("Promedio",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Promedio",
                      ),
                      DataColumn(
                        label: Text("V.Maximo",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "V.Maximo",
                      ),
                      DataColumn(
                        label: Text("Ruta",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Ruta",
                      ),
                      DataColumn(
                        label: Text("Revisión",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Revisión",
                      ),
                    ],
                    rows: users.map(
                      (user) => DataRow(
                        cells: [
                          DataCell(
                            Text(user.nombre,style: textStyleDataCell),
                            onTap: () {
                              print('Selected ${user.nombre}');
                            },
                          ),
                          DataCell(Text(user.primerApellido,style: textStyleDataCell),),
                          DataCell(Text(user.alias,style: textStyleDataCell),),
                          DataCell(Text(user.documento,style: textStyleDataCell)),
                          DataCell(Text( user.fecha,style: textStyleDataCell),),
                          DataCell(Text(user.diasMora.toStringAsFixed(2),style:TextStyle(fontSize:15,color:user.diasMora > 0? Colors.red:color))),
                          DataCell(
                            Text(user.venta,style:TextStyle(fontSize:15,color:Colors.green),textAlign: TextAlign.center,),
                          ),
                          DataCell(
                            Text(user.cuotas,style:TextStyle(fontSize:15),textAlign: TextAlign.center,),
                          ),
                          DataCell(
                            Text(user.promedio.toStringAsFixed(2),style: textStyleDataCell,textAlign: TextAlign.center,),
                          ),
                          DataCell(
                            Text(user.maximo.toStringAsFixed(2),style:TextStyle(fontSize:15,color:user.maximo > user.promedio? Colors.red:color),textAlign: TextAlign.center,),
                          ),
                          DataCell(Text(user.nombreRuta,style: textStyleDataCell,textAlign: TextAlign.center,),),
                          DataCell(Text( user.revisar,style: textStyleDataCell,textAlign: TextAlign.center,),),
                          
                        ]
                      ),
                    ).toSet().toList()
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
  @override
  Widget build(BuildContext context) {  
    return Column( 
      mainAxisAlignment:MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 400,
          child:
          formItemsDesign(
            Icons.search,
            TextFormField(
              controller: filtro,
              decoration: new InputDecoration(
                labelText: 'Buscar',
              ),
              onChanged: (text){
                if(text==''){
                  ControlPrestamo();
                }
                setState(() {
                  print('consultando');
                  listarUsuario(text);
                });
              },
            )
          ),
        ),
        Expanded(
          child:dataBody(texto),
        )
      ],
    );
  }
}
