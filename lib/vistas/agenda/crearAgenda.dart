import 'package:controlmax/modelos/Agendamiento.dart';
import 'package:controlmax/vistas/agenda/listarAgenda.dart';
import 'package:controlmax/vistas/ventas.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/modelos/Cliente.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CrearAgenda extends StatefulWidget {
  final Cliente cliente;
  final Agendamiento agendamiento;
  final bool editar;
 
  CrearAgenda(this.editar,{this.cliente,this.agendamiento}): assert(editar == true || cliente ==null);

  @override
  State<CrearAgenda> createState() => _CrearAgendaState();
}

class _CrearAgendaState extends State<CrearAgenda> {
  @override
  void initState() {
    super.initState();
    if(widget.editar == true){
      nombre.text =widget.cliente==null?widget.agendamiento.nombre.trim():widget.cliente.nombre.trim(); 
      telefono.text =widget.cliente==null?widget.agendamiento.telefono.trim():widget.cliente.telefono.trim(); 
      documento.text =widget.cliente==null?widget.agendamiento.documento.trim():widget.cliente.documento.trim(); 
      primerAmpellido.text = widget.cliente==null?widget.agendamiento.primerApellido.trim():widget.cliente.primerApellido.trim();
      valor.text=widget.cliente==null?widget.agendamiento.solicitado.toString():valor.text='';
      _startTimeController.text=widget.cliente==null?widget.agendamiento.fechaTexto:_startTimeController.text='';
    }
  }
  FocusNode valorFoco;
  FocusNode nombreFoco;
  Menu menu = new Menu();
  FocusNode telefonoFoco;
  FocusNode documentoFocus;
  FocusNode primerAmpellidoFoco;
  final format = DateFormat("dd/MM/yyyy");
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  valor = new TextEditingController();
  TextEditingController  nombre = new TextEditingController();
  TextEditingController  documento = new TextEditingController();
  TextEditingController  telefono = new TextEditingController();
  TextEditingController  primerAmpellido = new TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
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
                    height: 700,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          ),
          floatingActionButton: widget.editar && widget.cliente==null?FloatingActionButton(
            onPressed: () {
              if(documento.text!=''){
                var session= Insertar();
                session.borrarAgendamiento(documento.text.trim()).then((data) {
                  successDialog(
                    context, 
                    'Agendamiento eliminado',
                    neutralAction: (){
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => ListarAgenda(),)); }
                      );
                    },
                  );
                });
              }
            },
            child:const Icon(Icons.delete),
            //backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
          ):Container(),
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
  Future<List<Cliente>> clientes(filtro){
    var insertar = Insertar();
    return insertar.consultarClientes(filtro: filtro);
  }
  
  _onPressedVenta() async{
    var insertar = Insertar();
    List cliente;
    await insertar.consultarClientes(filtro: documento.text).then((data){
      cliente=data;
      if(cliente.length > 0){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => NuevaVentaView(true,true,true,cliente:cliente[0],valor: valor.text))); }
        );
      }else{
        final movimiento = Cliente(
          nombre:nombre.text,
          primerApellido: primerAmpellido.text,
          documento: documento.text,
          telefono:telefono.text,
          valor:double.parse(valor.text),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => NuevaVentaView(true,false,true,cliente:movimiento))); }
        );
      }
    });
  }
  _onPressed(){
    var session= Insertar();
    if(nombre.text!='' && primerAmpellido.text!=''&& documento.text!='' && telefono.text!='' && valor.text!=''&& _startTimeController.text!=''){
      session.insertarAgendamiento(nombre.text.trim(),primerAmpellido.text.trim(),documento.text.trim(),telefono.text.trim(),valor.text.trim(),_startTimeController.text.trim(),widget.editar)
      .then((data) {
        if(data['respuesta']==true){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => ListarAgenda(),)); }
          );
        }else{
          warningDialog(
            context, 
            data['motivo'].toString(),
            neutralAction: (){
            },
          );
        }                                 
      });
    }else{
      warningDialog(
        context, 
        "Por favor verificar la información ingresada",
        neutralAction: (){
        },
      ); 
    }
  }
  Container fechaInicial(BuildContext context) {
    return 
    Container(
      width:325,
      padding: EdgeInsets.fromLTRB(10, 10, 40, 10),
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
  Widget formUI() {
    return  Column(
      children: <Widget>[
        formItemsDesign(
          Icons.person,
          TextFormField(
            controller: nombre,
            focusNode: nombreFoco,
            //autofocus: true,
            decoration: new InputDecoration(
              labelText: 'Nombre',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el nombre';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person_add,
          TextFormField(
            controller: primerAmpellido,
            focusNode: primerAmpellidoFoco,
            decoration: new InputDecoration(
              labelText: 'Primer Apellido',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Apellido';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person,
          TextFormField(
            controller: documento,
            focusNode: documentoFocus,
            //autofocus: true,
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
          Icons.phone,
          TextFormField(
            controller: telefono,
            focusNode: telefonoFoco,
            decoration: new InputDecoration(
              labelText: 'Número de teléfono',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validateMobile,
          )
        ),
        formItemsDesign(
          Icons.money,
          TextFormField(
            controller: valor,
            focusNode: valorFoco,
            decoration: new InputDecoration(
              labelText: 'Valor',
            ),
            keyboardType: TextInputType.number,
          )
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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: widget.editar && widget.cliente==null?Container():Boton(onPresed: _onPressed,texto:'Aceptar',),
        ), 
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: widget.editar && widget.cliente==null?Boton(onPresed: _onPressedVenta,texto:'Crear venta',):Container(),
        ),                       
      ],
    );
  }
}