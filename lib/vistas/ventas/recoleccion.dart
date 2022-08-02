import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Ventas.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/ventas/ruta.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/modelos/HistorialVenta.dart';
import 'package:controlmax/vistas/widgets/dropdown.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/ventas/editarVenta.dart';

class Recoleccion extends StatefulWidget {
  final Ventas data;
  Recoleccion({this.data});
  @override
  _RecoleccionState createState() => _RecoleccionState();
}

class _RecoleccionState extends State<Recoleccion> {
  String url;
  String dia;
  int diffDays;
  int diffHours;
  List partirDia;
  DateTime fecha;
  bool otra=false;
  bool clave=false;
  String claveNueva;
  double diferencia;
  bool bloqueo=false;
  bool reportar=false;
  bool eliminar=false;
  Menu menu = new Menu();
  DateTime now = new DateTime.now();
  String dropdown ="Reportar Novedad";
  final format = DateFormat("yyyy-MM-dd");
  //final format = DateFormat("dd/MM/yyyy");
  String dropdownCuotas ="Cantidad de Cuotas";
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  couta = new TextEditingController();
  TextEditingController  clavePago = new TextEditingController();
  TextEditingController  claveEliminar = new TextEditingController();
  double cuotarecolectada,cuotaRegistro,coutaIngresar,valorIngresar;
  TextStyle textStyleDataCell = TextStyle(fontSize:15,fontWeight:FontWeight.bold);
  List<String> novedad=["Reportar Novedad","No pago","No encontrado","Pasar mañana"];
  List<String> cantidadCuotas=["Cantidad de Cuotas","Otra","No pago","Bloqueado","Eliminar","1","2","3","4","5","6","7","8","9","10"];
  
  @override
  void initState() {
    super.initState();
    fecha= DateTime.fromMillisecondsSinceEpoch(widget.data.fecha);
    diffDays = now.difference(fecha).inDays;
    diffHours = now.difference(fecha).inHours;
    dia=DateFormat('EEEE, d').format(now);
    partirDia=dia.split(",");
    dia=partirDia[0];
    diferencia = dia=='Monday'?(diffDays-widget.data.numeroCuota)-1:diffDays-widget.data.numeroCuota;
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Cobro',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    height: 650,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          ),
          floatingActionButton: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25,0,0,0),
                child: FloatingActionButton(
                  onPressed: () {
                    if(widget.data.numeroCuota >0 || diffHours >14){
                      warningDialog(
                        context, 
                        'La venta ya tiene cuotas recolectadas o fue creada en un fecha diferente a la actual, no se puede editar',
                        negativeAction: (){
                          
                        },
                      );
                      return;
                    }else{
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditarVentaRutaView(cliente: widget.data,))
                      );
                    }
                  },
                  child:const Icon(Icons.table_view_outlined),
                //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(250,0,0,0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RecoleccionView())
                    );
                  },
                  child:const Icon(Icons.two_wheeler_rounded),
                  //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  _eliminarVenta(){
    if(widget.data.numeroCuota==0){
      // if(claveEliminar.text.length==5){
        warningDialog(
          context, 
          "Esta seguro que desea eliminar la venta",
          negativeText: "Si",
          negativeAction: (){
            var session= Insertar();
            //session.eliminarVenta(widget.data,claveEliminar.text)
            session.eliminarVenta(widget.data)
            .then((data) {
              if(data['respuesta']==true){
                  successDialog(
                    context, 
                    data['motivo'].toString(),
                    neutralAction: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RecoleccionView())
                      );
                    },
                  );
              }else{
                warningDialog(
                  context, 
                  data['mensaje'].toString(),
                  neutralAction: (){
                  },
                );
              }
            });
          },
          neutralText: "No",
          neutralAction: (){
          },
        );
      // }else{
      //   warningDialog(
      //     context, 
      //     "Por favor verificar la clave ingresada",
      //     neutralAction: (){
      //     },
      //   );
      // }
    }else{
      warningDialog(
        context, 
        'La venta ya tiene cuotas recolectadas, no se puede eliminar',
        neutralAction: (){
        },
      );
    }
  }

  _launchURL(String telefono) async {
   url = 'tel:'+telefono;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  pagoSinClave(){
    Insertar session= Insertar();
    session.insertarVenta(widget.data,coutaIngresar,cuotarecolectada,bloqueo,clave:'Continuar' )
    .then((data) {
      if(data['respuesta']==true){
        successDialog(
          context, 
          "Recolección exitosa",
          neutralAction: (){
            // session.obtenerCliente(widget.data.documento).then((data) {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => Recoleccion(data:data))
            //   );
            // });
            
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RecoleccionView(boton:false,))
            );
          },
        );
      }else{
        warningDialog(
          context, 
          data['mensaje'].toString(),
          neutralAction: (){
          },
        );
      } 
    }).catchError( (onError){
      warningDialog(
        context, 
        "Por favor verificar la información ingresada",
        neutralAction: (){
          
        },
      );                                     
    });
  }

  pagoConClave(){
    Insertar session= Insertar();
    session.insertarVenta(widget.data,coutaIngresar,cuotarecolectada,bloqueo,clave: clavePago.text)
    .then((data) {
      if(data['respuesta']==true){
        successDialog(
          context, 
          "Recolección exitosa",
          neutralAction: (){ 
            // session.obtenerCliente(widget.data.documento).then((data) {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => Recoleccion(data:data))
            //   );
            // });
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RecoleccionView(boton:false,))
            );
          },
        );
      }else{
        warningDialog(
          context, 
          data['mensaje'].toString(),
          neutralAction: (){
          },
        );
      } 
    }).catchError( (onError){
      warningDialog(
        context, 
        "Por favor verificar la información ingresada",
        neutralAction: (){
          
        },
      );                                     
    });
  }
  _crearRecoleccion()async{  
    if(reportar){
      if(dropdownCuotas=='No pago'){
        var session= Insertar();
        session.reportarMotivo(widget.data,dropdownCuotas)
        .then((_) {
          successDialog(
            context, 
            "Ingreso de novedad exitosa",
            neutralAction: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RecoleccionView(boton:false,))
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => Recoleccion(data:widget.data))
              // );
            },
          );    
        });
      }else{
        warningDialog(
          context, 
          "Por favor seleccione una novedad",
          neutralAction: (){
          },
        ); 
      }
    }else{
      if(otra){
        coutaIngresar=double.parse(couta.text);
        cuotaRegistro = double.parse(widget.data.valorCuota.toString());
        cuotarecolectada=coutaIngresar/cuotaRegistro;
        if(coutaIngresar > widget.data.saldo)
        {
          warningDialog(
            context, 
            'El valor '+coutaIngresar.toString()+' es superior al saldo',
            neutralAction: (){
            },
          );
        }else{
          // if(cuotarecolectada >= 5){
          //   setState(() {
          //     clave= true;            
          //   });
          //   if(clavePago.text.length==4)
          //   {
          //     session.insertarVenta(widget.data,coutaIngresar,cuotarecolectada,bloqueo,clave:clavePago.text )
          //     .then((data) {
          //       if(data['respuesta']==true){
          //         successDialog(
          //           context, 
          //           "Recolección exitosa",
          //           neutralAction: (){
          //             Navigator.of(context).push(
          //               MaterialPageRoute(builder: (context) => RecoleccionView())
          //             );
          //           },
          //         );
          //       }else{
          //         warningDialog(
          //           context, 
          //           data['mensaje'].toString(),
          //           neutralAction: (){
          //           },
          //         );
          //       } 
          //     }).catchError( (onError){
          //       warningDialog(
          //         context, 
          //         "Por favor verificar la información ingresada",
          //         neutralAction: (){
          //           // Navigator.of(context).push(
          //           //   MaterialPageRoute(builder: (context) => RecoleccionView())
          //           // );
          //         },
          //       );                                     
          //     });
          //   }else{
          //     warningDialog(
          //       context, 
          //       'Por favor verificar la clave',
          //       neutralAction: (){
          //       },
          //     );
          //   }
          // }else{
          if(coutaIngresar  == widget.data.saldo && clave== false )
          {
            warningDialog(
              context, 
              'Esta cancelando el total del credito, ya no podra modificar la venta. Desea continuar?',
              negativeText: "No",
              negativeAction: (){
              },
              neutralText: "Si",
              neutralAction: (){
                pagoSinClave();
              },
            );
          }else if(coutaIngresar < widget.data.saldo && clave== false){
            pagoSinClave();
          }else{
            pagoConClave();
          }
          //}
        }
      }else{  
        if(bloqueo){
          coutaIngresar=0;
          cuotarecolectada=0;
        }
        // if(cuotarecolectada >= 5){
        //   claveNueva=clavePago.text;
        // }else{
          //claveNueva='Continuar';
        //}
        if(cuotarecolectada > widget.data.saldo)
        {
          warningDialog(
            context, 
            'El valor al que corresponde la cuota '+cuotarecolectada.toString()+' es superior al saldo',
            neutralAction: (){
            },
          );
        }else{
          if(coutaIngresar  == widget.data.saldo && clave== false )
          {
            warningDialog(
              context, 
              'Esta cancelando el total del credito, ya no podra modificar la venta. Desea continuar?',
              negativeText: "No",
              negativeAction: (){
              },
              neutralText: "Si",
              neutralAction: (){
                pagoSinClave();
              },
            );
          }else if(coutaIngresar < widget.data.saldo && clave== false){
            pagoSinClave();
          }else{
            pagoConClave();
          }
        }
      }
    }
  }

  void _alCambiar(newValue){
    if(newValue!="Cantidad de Cuotas" && newValue!="Otra"&& newValue!="No pago" && newValue!="Bloqueado" && newValue!="Eliminar")
    { 
      setState(() {
        dropdownCuotas =newValue.toString();
        cuotarecolectada = double.parse(dropdownCuotas);
        cuotaRegistro = double.parse(widget.data.valorCuota.toString());
        coutaIngresar=(cuotarecolectada*cuotaRegistro);
        otra = false; 
        clave= false;
        // if(cuotarecolectada >= 5){
        //   clave = true;
        // }else{
        //   clave= false;
        // }
      });
    }else if(newValue=="Otra"){
      setState(() {
        dropdownCuotas =newValue.toString();
        otra = true;   
        clave= false;
      });
      
    }else if(newValue=="No pago"){
      setState(() {
        dropdownCuotas =newValue.toString();
        reportar = true;   
        otra = false;
        clave= false;
      });
    }else if(newValue=="Bloqueado"){
      setState(() {
        dropdownCuotas =newValue.toString();
        bloqueo = true;
        clave = true;
      });
    }else if(newValue=="Eliminar"){
      setState(() {
        dropdownCuotas =newValue.toString();
        eliminar = true;
        clave= false;
      });
    }
    else{
      setState(() {
        dropdownCuotas =newValue.toString();
        otra = false; 
        clave= false;
      });
    }
  }

  // void _alCambiarNovedad(newValue){
  //   if(newValue!="Reportar Novedad")
  //   {
  //     setState(() {
  //       dropdown =newValue.toString();
  //     });
  //   }else{
  //     setState(() {
  //       dropdown =newValue.toString();
  //     });
  //   }
  // }
  
  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
  }

  Future<List<HistorialVenta>> ventas(){
    var insertar = Insertar();
    return insertar.historialRecoleccion(widget.data.idVenta);
  }

  Widget cardCuenta(HistorialVenta item){
    return 
    Card(
      child:
      ListTile(
        leading:item.novedad=="abono"||item.novedad=="pago"?Icon(Icons.thumb_up, size:30,color:Colors.green):Icon(Icons.thumb_down_sharp, size:30,color:Colors.red),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(format.format((DateTime.fromMillisecondsSinceEpoch(item.fechaRecoleccion,isUtc:false))).toString(),style: TextStyle(
              fontSize: 18,)
            ),
            Text("Novedad : "+item.novedad,style: TextStyle(fontSize:18,)),
          ],
        ),
        subtitle:Row(
          children: [
            Text("Valor : "+item.valorCuota.toString(),style: TextStyle(fontSize:18,)),
            Text(" / ",style: TextStyle(fontSize:18,)),
            Text("Saldo : "+item.saldo.toString(),style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:18,)),
          ],
        ), 
        onTap: () {
          
        },
      )
    );
  }

  Widget tabla(){
    return FutureBuilder<List<HistorialVenta>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: ventas(),
      builder: (BuildContext context, AsyncSnapshot<List<HistorialVenta>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              HistorialVenta item = snapshot.data[index];
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

  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Nombre :"+" " +widget.data.nombre+' '+widget.data.primerApellido,style: textStyleDataCell,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:Row(
            children: [
              Text("Teléfono :"+" " +widget.data.telefono,style: textStyleDataCell,),
              //Center(child:
                IconButton(
                  onPressed: (){
                    _launchURL(widget.data.telefono);
                  },icon: Icon(Icons.phone,color: Colors.blueGrey,size: 30,),
                ),
              //),
            ],
          ), 
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Documento :"+" " +widget.data.documento,style: textStyleDataCell,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Dirección :"+" "+widget.data.direccion,style: textStyleDataCell,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Saldo :"+" "+widget.data.saldo.toString(),style: textStyleDataCell,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Valor Cuota :"+" " +widget.data.valorCuota.toString(),style: textStyleDataCell,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Total cuotas :"+" "+widget.data.cuotas.toString(),style: textStyleDataCell,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Fecha prestamo :"+" "+format.format((DateTime.fromMillisecondsSinceEpoch(widget.data.fecha,isUtc:false))).toString(),style: textStyleDataCell,),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Frecuencia :"+" " +widget.data.frecuencia.toString(),style: textStyleDataCell,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Día :"+" " +widget.data.diaRecoleccion.toString(),style: textStyleDataCell,),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
          child: Text("Cuotas restantes :"+" "+(widget.data.saldo/widget.data.valorCuota).toStringAsFixed(1),style: textStyleDataCell,),
        ),
        diferencia>1?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Dias de mora :"+" " +diferencia.toString(),style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.red),),
        ):Container(),
        //reportar?Container():
        formItemsDesign(
          Icons.check,
          DropdownSoatView(texto:dropdownCuotas ,documentosLista:cantidadCuotas,alCambiar: _alCambiar,dropdownValor: dropdownCuotas),
        ),
        otra?
        formItemsDesign(
          Icons.person_add,
          TextFormField(
            controller: couta,
            decoration: new InputDecoration(
              labelText: 'Valor recibido',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el valor recibido';
              }
            },
          ),
        )
        :Container(),
        clave?
        formItemsDesign(
          Icons.lock_open_rounded,
          TextFormField(
            controller: clavePago,
            decoration: new InputDecoration(
              labelText: 'Clave',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor la clave';
              }
            },
          ),
        )
        :Container(),
        // eliminar?
        // formItemsDesign(
        //   Icons.lock_open_rounded,
        //   TextFormField(
        //     controller: claveEliminar,
        //     decoration: new InputDecoration(
        //       labelText: 'Clave Eliminar',
        //     ),
        //     validator:(value){
        //       if (value.isEmpty) {
        //         return 'Por favor la clave';
        //       }
        //     },
        //   ),
        // )
        // :Container(),
        // reportar?formItemsDesign(
        //   Icons.check,
        //   DropdownSoatView(texto:dropdown ,documentosLista:novedad,alCambiar: _alCambiarNovedad,dropdownValor: dropdown),
        // ):Container(),
        eliminar?Container():Boton(onPresed: _crearRecoleccion,texto:'Aceptar',),
        eliminar?Boton(onPresed: _eliminarVenta,texto:'Eliminar',):Container(),
        Expanded(
          child: SizedBox(
            //height: 200.0,
            child:tabla(),
          ),
        )  
      ]
    );
  }

  @override
  void dispose() {
    couta.dispose();
    clavePago.dispose();
    super.dispose();
  }
}

class Ball {
}