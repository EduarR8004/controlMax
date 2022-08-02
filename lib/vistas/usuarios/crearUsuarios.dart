import 'package:controlmax/modelos/Proyecto.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/utiles/Utils.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/vistas/usuarios/listarUsuario.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class RegisterPage extends StatefulWidget {
  final bool editar;
  final data;
  final Usuario usuario;
 
  RegisterPage(this.editar,{this.data,this.usuario}): assert(editar == true || usuario ==null);
 @override
 _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var usuarioId;
  FocusNode usuario;
  FocusNode nombre;
  FocusNode correo;
  FocusNode telefono;
  FocusNode documento;
  FocusNode pass;
  dynamic usuarioSeleccionado;
  String selectedRegion;
  String dropdownInicial;
  List<Proyecto> users=[];
  List<Proyecto>pasoParametro=[];
  var codParametro;
  List<Proyecto> _users=[];
  List <String> activo=['Activo','Inactivo'];
  String emailUsuario='El campo Email es obligatorio.';
  String nombreUsuario='El campo Nombre es obligatorio.';
  String validarUsuario='El campo Usuario es obligatorio.';
  String documentoUsuario='El campo Documento es obligatorio.';
  String contrasenaUsuario='El campo contraseña es obligatorio';
  String telefonoUsuario='El campo Número de teléfono es obligatorio.';
  String creacion="Usuario creado correctamente\n""Desea crear un nuevo usuario?";
  @override
  void initState() {
    super.initState();
    nombre = FocusNode();
    usuario = FocusNode();
    correo = FocusNode();
    documento = FocusNode();
    telefono = FocusNode();
    pass = FocusNode();
    if(widget.editar == true){
      user.text =widget.usuario.usuario; 
      nombreCompleto.text =widget.usuario.nombreCompleto; 
      direccion.text =widget.usuario.direccion; 
      telefono1.text =widget.usuario.telefono; 
      usuarioId=widget.usuario.usuarioId;
      dropdownInicial = widget.usuario.estado=="Activo"?"Activo":"Inactivo";
      codParametro= widget.editar?widget.usuario.proyecto:"";
      claveAcceso.text=widget.usuario.contrasena;
    }
  }
 
 GlobalKey<FormState> keyForm = new GlobalKey();
 TextEditingController  user = new TextEditingController();
 TextEditingController  nombreCompleto = new TextEditingController();
 TextEditingController  direccion = new TextEditingController();
 TextEditingController  claveAcceso = new TextEditingController();
 TextEditingController  telefono1 = new TextEditingController();
 
  crearUsuario()async{  
    var session= Insertar();
    // for ( var par in usuarioSeleccionado)
    // {
    //   pasoParametro.add(par);
    // }
    // var codParametro;
    // pasoParametro.map((Proyecto map) {
    //   codParametro=map.proyecto;
    // }).toList();
        
    // if(selectedRegion =='Seleccione un Proyecto')
    // {
    //   codParametro='Por definir';
    // }
    session.crearUsuario(user.text,claveAcceso.text,nombreCompleto.text,direccion.text,telefono1.text,codParametro).then((_) {
      successDialog(
        context, 
        creacion,
        negativeText: "Si",
        negativeAction: (){
          user.text =''; 
          nombreCompleto.text =''; 
          telefono1.text =''; 
          claveAcceso.text='';
          direccion.text =''; 
          usuarioId='';
        },
        neutralText: "No",
        neutralAction: (){
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DataTableUsuarios(parametro:'')));
        },
      );
      // if(session.validar == true){
      //   //token=session.get_session();
      // }else{
      //   String mensaje=session.mensaje; 
      //   if (mensaje!=null)
      //   {
      //     //confirm (mensaje); 
                                  
      //   }else{
      //     //confirm ("Sin conexión al servidor");
      //   }                        
      // }            
    }).catchError( (onError){

    if(onError is SessionNotFound){
    return 'Usuario o Contraseña Incorrecta';
                            
    }else if(onError is ConnectionError){
                              
    }else{
                            
    }
                                                    
    });
  }

  editarUsuario()async{
    var session= Insertar();
    for ( var par in usuarioSeleccionado)
    {
      pasoParametro.add(par);
    }
    
    pasoParametro.map((Proyecto map) {
      codParametro=map.proyecto;
    }).toList();
        
    if(selectedRegion =='Seleccione un Proyecto')
    {
      codParametro='Por definir';
    }
    session.editarUsuario(usuarioId,user.text,claveAcceso.text,nombreCompleto.text,direccion.text,telefono1.text,dropdownInicial,codParametro).then((_){
      successDialog(
        context, 
        'Usuario Editado con Éxito',
        neutralText: "Aceptar",
        neutralAction: (){
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DataTableUsuarios(parametro:'')));
        },
      );
    });
  }
  Future <List<Proyecto>> listarProyectos()async{
    var insertar = Insertar();
    users=[];
    if(users.length > 0)
    {
      return users;
    }
    else
    {
      await insertar.listarProyectos().then((_){
        var preUsuarios=insertar.obtenerProyectos();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      users.toSet().toList();
      return users;
    }
  }

  Widget dataBody() {
    return FutureBuilder<List<Proyecto>>(
      future:listarProyectos(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          _users=[];
          _users = (users).toSet().toList();
          return  Container(
            height: 50,
            width:200,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(10, 5, 10,10),
            decoration: BoxDecoration(
              border: Border(bottom:BorderSide(width: 1,
                color: Color.fromRGBO(83, 86, 90, 1.0),
              ),),
            ),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                hint:Text(widget.editar?widget.usuario.proyecto:'Seleccione un Proyecto', textAlign: TextAlign.left,style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Karla',
                  ),
                ), 
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
                onChanged: (String newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    if(newValue !='Seleccione un Proyecto'){
                      users.toSet();
                      usuarioSeleccionado=users.where((a) => a.proyecto==newValue);
                    }
                  });
                },
                items: _users.map((Proyecto map) {
                  return new DropdownMenuItem<String>(
                    value: map.proyecto,
                    //child: Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0,2),
                      child:
                      new Text(map.proyecto,textAlign: TextAlign.left,
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
  @override
  void dispose() {
    nombre.dispose();
    usuario.dispose();
    correo.dispose();
    documento.dispose();
    telefono.dispose();
    claveAcceso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text(widget.editar?"Editar Usuario":'Crear Usuario',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
          ),
          //drawer: menu,
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
  _onPressed(){
    if(user.text==''){
      usuario.requestFocus();
        warningDialog(
          context, 
          validarUsuario,
          negativeAction: (){
          },
        );
        return;
    }
    if(nombreCompleto.text==''){
      nombre.requestFocus();
      warningDialog(
        context, 
        nombreUsuario,
        negativeAction: (){
        },
      );
      return;
    }
    if(direccion.text==''){
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
      correo.requestFocus();
      warningDialog(
        context, 
        telefonoUsuario,
        negativeAction: (){
        },
      );
      return;
    }

    if(claveAcceso.text==''&& widget.editar != true){
      pass.requestFocus();
      warningDialog(
        context, 
        contrasenaUsuario,
        negativeAction: (){
        },
      );
      return;
    }

    if (!keyForm.currentState.validate()){
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data'))
      );                            
    }else{
      save();
    } 
  }

  Widget estado(){
    return Container(
      height: 40,
      width: 150,
      //alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
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
          Icons.person,
          TextFormField(
            enabled:widget.editar?false:true, 
            controller: user,
            focusNode: usuario,
            //autofocus: true,
            decoration: new InputDecoration(
              labelText: 'Usuario',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Usuario';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person_add,
          TextFormField(
            controller: nombreCompleto,
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
          Icons.home,
          TextFormField(
            controller: direccion,
            focusNode: documento,
            decoration: new InputDecoration(
              labelText: 'Direccion',
            ),
            validator: (value){
              if (value.isEmpty) {
                
                return 'Por favor Ingrese la dirección';
              }
            },
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
          Icons.https,
          TextFormField(
            controller: claveAcceso,
            focusNode: pass,
            obscureText: true,
            //autofocus: true,
            decoration: new InputDecoration(
              labelText: 'Contraseña',
            ),
            validator: (value){
              if (value.isEmpty && widget.editar != true) {
                return 'Por favor Ingrese el Contraseña';
              }
            },
          )
        ),
        widget.editar?formItemsDesign(
            Icons.check,
            widget.editar?estado():Container(),
        ):Container(),
        // formItemsDesign(
        //   Icons.account_tree_rounded,
        //   dataBody(),
        // ),
        Boton(onPresed: _onPressed,texto:'Aceptar',),                       
      ],
    );
  }
//flutter build apk --release --target-platform=android-arm64
//  String validatePassword(String value) {
//    print("valorrr $value passsword ${passwordCtrl.text}");
//    if (value != passwordCtrl.text) {
//      return "Las contraseñas no coinciden";
//    }
//    return null;
//  }

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
    //String patttern = r'(^[0-9]*$)';
    //RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Por favor ingrese el número de teléfono";
    } else if (value.length != 10) {
      return "El número debe tener 10 digitos";
    }
    return null;
  }

  String validatePass(String value) {
    //String patttern = r'(^[0-9]*$)';
    //RegExp regExp = new RegExp(patttern);
    if (value.length == 0 && widget.editar==false) {
      return "La contraseña es necesaria";
    }else{
      if (value.length < 8) {
        return "Minimo 8 Caracteres";
      } else {
        return null;
      }
    }
  }

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

  save() {
    if(widget.editar == true){
      editarUsuario();
    }else{
      crearUsuario();
    } 
  }
  
}