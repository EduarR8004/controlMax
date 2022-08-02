import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Ciudad.dart';
import 'package:controlmax/modelos/RutaAdmin.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/modelos/Departamento.dart';
import 'package:controlmax/vistas/widgets/dropdown.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/administracion/RutaAdministrador.dart';

class EditarVentaView extends StatefulWidget {
  final RutaAdmin cliente;
  EditarVentaView({this.cliente});
 @override
 _EditarVentaViewState createState() => _EditarVentaViewState();
}
class _EditarVentaViewState extends State<EditarVentaView> {
  FocusNode cuota;
  FocusNode tipos;
  FocusNode nombre;
  FocusNode vender;
  FocusNode usuario;
  FocusNode telefono;
  FocusNode pApellido;
  FocusNode sApellido;
  FocusNode documento;
  FocusNode ventaFocus;
  FocusNode claveVerificar;
  String dropdownInicial;
  double numeroCuota;
  double valorCuota;
  String frecuencia="Frecuencia";
  List <String> activo=['Activo','Inactivo'];
  String cuotasError="Ingrese el numero de cuotas";
  String ventaError="Ingrese el valor de la venta";
  String emailUsuario='El campo Email es obligatorio.';
  String nombreUsuario='El campo Nombre es obligatorio.';
  String validarUsuario='El campo Usuario es obligatorio.';
  String documentoUsuario='El campo Documento es obligatorio.';
  String telefonoUsuario='El campo Número de teléfono es obligatorio.';
  String claveVenta='Por favor ingrese la clave de autorización';
  List<String> frecuencias=["Frecuencia","Diario","Semanal","Quincenal"];
  String creacion="Usuario creado correctamente\n""Desea crear un nuevo usuario?";

  @override
  void initState() {
    super.initState();
    //_getStateList();
    nombre = FocusNode();
    usuario = FocusNode();
    documento = FocusNode();
    telefono = FocusNode();
    ventaFocus = FocusNode();
    claveVerificar = FocusNode();
    List procesar=widget.cliente.solicitado.toString().split('.');
    nombreCliente.text =widget.cliente.nombre; 
    documentoNumero.text =widget.cliente.documento; 
    telefono1.text =widget.cliente.telefono; 
    ciudad.text = widget.cliente.ciudad;
    primerApellido.text = widget.cliente.primerApellido;
    segundoApellido.text = widget.cliente.segundoApellido;
    alias.text = widget.cliente.alias;
    direccion.text = widget.cliente.direccion;
    actividadEconomica.text = widget.cliente.actividadEconomica;
    cuotas.text=widget.cliente.cuotas.toString();
    valorCuota=widget.cliente.valorCuota;
    numeroCuota=widget.cliente.numeroCuota;
    venta.text=procesar[0].toString().trim();
    //_myCity=widget.cliente.ciudad;
    //_myState=widget.cliente.departamento;
    
  }
 
  bool clave=false;
  List <Ciudad>citiesList;
  List <Departamento> statesList;
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  ciudad= new TextEditingController();
  TextEditingController  alias = new TextEditingController();
  TextEditingController  tipo = new TextEditingController();
  TextEditingController  venta = new TextEditingController();
  TextEditingController  cuotas = new TextEditingController();
  TextEditingController  cliente = new TextEditingController();
  TextEditingController  clavePago = new TextEditingController();
  TextEditingController  telefono1 = new TextEditingController();
  TextEditingController  direccion = new TextEditingController();
  TextEditingController  nombreCliente= new TextEditingController();
  TextEditingController  documentoNumero = new TextEditingController();
  TextEditingController  primerApellido = new TextEditingController();
  TextEditingController  segundoApellido = new TextEditingController();
  TextEditingController  actividadEconomica = new TextEditingController();

  crearCliente()async{  
    var session= Insertar();
    double abonado=valorCuota*numeroCuota;
    session.editarVenta(
      nombre:nombreCliente.text,
      direccion:direccion.text,
      cuotas: cuotas.text,
      valorVenta:venta.text,
      telefono: telefono1.text,
      primerApellido:primerApellido.text,
      segundoApellido:segundoApellido.text,
      alias: alias.text,
      actividadEconomica:actividadEconomica.text,
      documento: documentoNumero.text,
      frecuencia: frecuencia,
      fecha:widget.cliente.fecha,
      id:widget.cliente.id,
      saldo:widget.cliente.saldo,
      usuario: widget.cliente.usuario,
      ventaAnterior:widget.cliente.solicitado,
      numeroCuota:widget.cliente.numeroCuota,
      abonado:abonado,
    ).then((_) {
      warningDialog(
        context, 
        'Venta editada de forma exitosa',
        neutralAction: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RutaAdminView())
            );
        },
      ); 
    });
  }
   
  @override
  void dispose() {
    ciudad.dispose();
    alias.dispose();
    tipo.dispose();
    venta.dispose();
    cuotas.dispose();
    cliente.dispose();
    clavePago.dispose();
    telefono1.dispose();
    direccion.dispose();
    nombreCliente.dispose();
    documentoNumero.dispose();
    primerApellido.dispose();
    segundoApellido.dispose();
    actividadEconomica.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var menu = new Menu();
    return WillPopScope(
    onWillPop: null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar: new AppBar(
            title: Text("Nueva venta",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
            //flexibleSpace:encabezado,
            //backgroundColor:Colors.blue
            // Colors.transparent,
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
                    height: 1000,
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

  void _frecuencias(newValue){
    if(newValue!="Frecuencia")
    {
      setState(() {
        frecuencia = newValue.toString();
      });
    }else{
      setState(() {
        frecuencia = newValue.toString();
      });
    }
  }

  Widget estado(){
    return Container(
      height: 40,
      width: 150,
      //alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(5, 10, 0, 10),
      //margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(bottom:BorderSide(width: 1,
          color: Color.fromRGBO(83, 86, 90, 1.0),
        ),
        ),
      ),
      child:
        DropdownButtonHideUnderline(
          child:DropdownButton<String>(
            hint: Padding(
              padding: const EdgeInsets.all(0),
              child:Text(dropdownInicial, 
                textAlign: TextAlign.left,style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: 'Karla',
                ),
              ),
            ),
            value: dropdownInicial,
            // icon: Icon(Icons.arrow_circle_down_rounded),
            // iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black,fontSize: 15),
            underline: Container(
              height: 2,
              color: Colors.green,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownInicial= newValue;
              });
            },
            items:activo.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2,2,2),
                  child:new Text(value,textAlign: TextAlign.left,
                  style: new TextStyle(color: Colors.black)),
                ),
              );
            }).toList(),
          ),
        ),
    );
  }
  Widget formUI() {
    return  Column(
      children: <Widget>[
        formItemsDesign(
          Icons.money,
          TextFormField(
            controller: venta,
            focusNode: ventaFocus,
            decoration: new InputDecoration(
              labelText: 'Venta',
            ),
            keyboardType: TextInputType.phone,
            //maxLength: 10,
            //validator: validateMobile,
          )
        ),
        formItemsDesign(
          Icons.check_box,
          TextFormField(
            controller: cuotas,
            focusNode: cuota,
            decoration: new InputDecoration(
              labelText: 'Cuotas',
            ),
            keyboardType: TextInputType.phone,
            //maxLength: 10,
            //validator: validateMobile,
          )
        ),
        formItemsDesign(
          Icons.check,
          DropdownSoatView(texto:frecuencia ,documentosLista:frecuencias,alCambiar: _frecuencias,dropdownValor: frecuencia),
        ),
        formItemsDesign(
          Icons.person,
          TextFormField(
            controller: nombreCliente,
            focusNode: nombre,
            decoration: new InputDecoration(
              labelText: 'Nombre',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Nombre';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person_add,
          TextFormField(
            controller: primerApellido,
            focusNode: pApellido,
            decoration: new InputDecoration(
              labelText: 'Primer Apellido',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Nombre';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person_add_alt,
          TextFormField(
            controller: segundoApellido,
            focusNode: sApellido,
            decoration: new InputDecoration(
              labelText: 'Segundo Apellido',
            ),
          )
        ),
        formItemsDesign(
          Icons.attribution_rounded,
          TextFormField(
            controller: documentoNumero,
            focusNode: documento,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Documento',
            ),
            validator: (value){
              if (value.isEmpty) {
                
                return 'Por favor Ingrese el Documento';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person_add_sharp,
          TextFormField(
            controller: alias,
            decoration: new InputDecoration(
              labelText: 'Alias',
            ),
            keyboardType: TextInputType.text,
            //maxLength: 10,
          )
        ),
        // formItemsDesign(
        //   Icons.add_location_alt,
        //   Container(
        //     padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        //     color: Colors.white,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         Expanded(
        //           child: DropdownButtonHideUnderline(
        //             child: ButtonTheme(
        //               alignedDropdown: true,
        //               child: DropdownButton<String>(
        //                 value: _myState,
        //                 iconSize: 30,
        //                 icon: (null),
        //                 style: TextStyle(
        //                   color: Colors.black54,
        //                   fontSize: 16,
        //                 ),
        //                 hint: Text(widget.cliente.departamento,textAlign:TextAlign.left),
        //                 onChanged: (String newValue) {
        //                   setState(() {
        //                     _myState = newValue;
        //                     _getCitiesList();
        //                     print(_myState);
        //                   });
        //                 },
        //                 items: statesList?.map((item) {
        //                   return new DropdownMenuItem(
        //                     child: new Text(item.nombre),
        //                     value: item.nombre,
        //                   );
        //                 })?.toList() ??
        //                 [],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // formItemsDesign(
        //   Icons.add_location_rounded,
        //   Container(
        //     padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        //     color: Colors.white,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         Expanded(
        //           child: DropdownButtonHideUnderline(
        //             child: ButtonTheme(
        //               alignedDropdown: true,
        //               child: DropdownButton<String>(
        //                 value: _myCity,
        //                 iconSize: 30,
        //                 icon: (null),
        //                 style: TextStyle(
        //                   color: Colors.black54,
        //                   fontSize: 16,
        //                 ),
        //                 hint: Text(widget.cliente.ciudad,textAlign:TextAlign.left,),
        //                 onChanged: (String newValue) {
        //                   setState(() {
        //                     _myCity = newValue;
        //                     print(_myCity);
        //                   });
        //                 },
        //                 items: citiesList?.map((item) {
        //                   return new DropdownMenuItem(
        //                     child: new Text(item.nombre),
        //                     value: item.nombre,
        //                   );
        //                 })?.toList() ??
        //                 [],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // formItemsDesign(
        //   Icons.email,
        //   TextFormField(
        //     controller: ciudad,
        //     focusNode: correo,
        //     decoration: new InputDecoration(
        //       labelText: 'Ciudad',
        //     ),
        //     keyboardType: TextInputType.text,
        //     maxLength: 60,
        //     //validator: validateEmail,
        //   )
        // ),
        formItemsDesign(
          Icons.home,
          TextFormField(
            controller: direccion,
            //focusNode: correo,
            decoration: new InputDecoration(
              labelText: 'Dirección',
            ),
            keyboardType: TextInputType.text,
            //validator: validateEmail,
          )
        ),
         formItemsDesign(
          Icons.phone,
          TextFormField(
            controller: telefono1,
            focusNode: telefono,
            decoration: new InputDecoration(
              labelText: 'Número de teléfono',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validateMobile,
          )
        ),
        formItemsDesign(
          Icons.miscellaneous_services,
          TextFormField(
            controller: actividadEconomica,
            //focusNode: telefono,
            decoration: new InputDecoration(
              labelText: 'Actividad Economica',
            ),
            keyboardType: TextInputType.text,
          )
        ),
        // widget.editar?formItemsDesign(
        //     Icons.check,
        //     widget.editar?estado():Container(),
        // ):Container(),
        Boton(onPresed: _onPressed,texto: 'Aceptar',),                            
      ],
    );
  }

  _onPressed (){
    //int valor=int.parse(venta.text);
    //double  saldo =widget.cliente.venta - widget.cliente.saldo;
    // if(valor < saldo){
    //   ventaFocus.requestFocus();
    //   warningDialog(
    //     context, 
    //     'La nueva venta debe se superior al saldo del usuario',
    //     negativeAction: (){
    //     },
    //   );
    //   return;
    // }
    if(venta.text==''){
      ventaFocus.requestFocus();
      warningDialog(
        context, 
        ventaError,
        negativeAction: (){
        },
      );
      return;
    }
    if(nombreCliente.text==''){
      nombre.requestFocus();
        warningDialog(
          context, 
          validarUsuario,
          negativeAction: (){
          },
        );
        return;
    }
    if(documentoNumero.text==''){
      documento.requestFocus();
      warningDialog(
        context, 
        documentoUsuario,
        negativeAction: (){
        },
      );
      return;
    }
    if(telefono1.text==''){
      telefono.requestFocus();
      warningDialog(
        context, 
        telefonoUsuario,
        negativeAction: (){
        },
      );
      return;
    }
    if(cuotas.text==''){
      cuota.requestFocus();
      warningDialog(
        context, 
        cuotasError,
        negativeAction: (){
        },
      );
      return;
    }
    if(clave==true && clavePago.text==''){
      warningDialog(
        context, 
        claveVenta,
        neutralAction: (){
          claveVerificar.requestFocus();
        },
      );
      return;
    }
    if(frecuencia=='Frecuencia'){
      warningDialog(
        context, 
        'Por favor determine la frecuencia',
        neutralAction: (){
          
        },
      );
      return;
    }
    if (!keyForm.currentState.validate()){
      Scaffold.of(context).showSnackBar(
        SnackBar(content: const Text('Processing Data'))
      );                            
    }else{
      //if(widget.cliente.numeroCuota==0){
      crearCliente();
      // }else{
      //   warningDialog(
      //     context, 
      //     'La venta ya tiene cuotas recolectadas, no se puede editar',
      //     negativeAction: (){
      //     },
      //   );
      // }
      
    } 
  }
  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Este es un campo obligatorio";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateMobile(String value) {
    // String patttern = r'(^[0-9]*$)';
    // RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Por favor ingrese el número de teléfono";
    } else if (value.length != 10) {
      return "El número debe tener 10 digitos";
    }
    return null;
  }

  // String validatePass(String value) {
  //   String patttern = r'(^[0-9]*$)';
  //   RegExp regExp = new RegExp(patttern);
  //   if (value.length == 0 && widget.editar==false) {
  //     return "La contraseña es necesaria";
  //   }else{
  //     if (value.length < 8) {
  //       return "Minimo 8 Caracteres";
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Por favor ingrese el email";
    } else if (!regExp.hasMatch(value)) {
      return "Correo inválido";
    } else {
      return null;
    }
  }

  String validateEmailOptional(String value) {
   String pattern =
       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
   RegExp regExp = new RegExp(pattern);
   if (value.length > 0) {
      if (!regExp.hasMatch(value)) {
      return "Correo invalido";
       } else {
        return null;
      }
   } else {
     return null;
   }
  }
}