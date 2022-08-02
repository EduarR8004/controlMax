import 'package:flutter/material.dart';
import 'package:controlmax/modelos/Rol.dart';
import 'package:controlmax/utiles/Utils.dart';
import 'package:controlmax/vistas/menu.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/roles/rolesObjetos.dart';


class CrearRol extends StatefulWidget {
  final bool editar;
  final Rol rol;
 
  CrearRol(this.editar,{this.rol}): assert(editar == true || rol ==null);
 @override
 _CrearRolState createState() => _CrearRolState();
}

class _CrearRolState extends State<CrearRol> {
var creacion="Rol creado correctamente\nDesea crear un nuevo Rol?";
FocusNode rol;
FocusNode descripcion;
  @override
  void initState() {
    super.initState();
    rol = FocusNode();
    descripcion = FocusNode();
    if(widget.editar == true){
      role.text =widget.rol.nombre; 
      descp.text =widget.rol.descripcion; 
    
    }
  }
 
 GlobalKey<FormState> keyForm = new GlobalKey();
 TextEditingController  role = new TextEditingController();
 TextEditingController  descp = new TextEditingController();

crearRol()async{
  var session= Insertar();
  await session.crearRol(role.text,descp.text).then((_){
    successDialog(
      context, 
      creacion,
      negativeText: "Si",
      negativeAction: (){
        role.text =''; 
        descp.text ='';
      },
      neutralText: "No",
      neutralAction: (){

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfilePage())
        ); 
      },
    );
    //_showAlertDialog("Crear Rol","Rol creado correctamente\n""Desea crear un nuevo Rol?");
  }).catchError( (onError){
     onError.toString();

    if(onError is SessionNotFound){
    //return 'Usuario o Contraseña Incorrecta';
                      
    }else if(onError is ConnectionError){
    errorDialog(
      context, 
      "Sin conexión al servidor",
      negativeAction: (){
      },
    ); 
    //_showAlert("Error de conexión ","Sin conexión al servidor");
                        
    }else{                  
    }                                          
  });
}
 
editar_rol()async{
  // var session= Conexion();
  // session.set_token(widget.data.token);
  // var rol= Roles(session);
  // await rol.editar_rol(widget.rol.id,role.text,descp.text).then((_){
  //   successDialog(
  //     context, 
  //     "Rol editado correctamente",
  //     neutralText: "Aceptar",
  //     neutralAction: (){
  //       final data = Data(
  //         token:widget.data.token ,
  //         obj: widget.data.obj,
  //         usuario_actual:widget.data.usuario_actual, 
  //         parametro:''
  //       );
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => ProfilePage(data:data))); 
  //     },
  //   );
  // }).catchError( (onError){
  //    'Error interno '+ onError.toString();
  //    if(onError is SessionNotFound){
  //     //return 'Usuario o Contraseña Incorrecta';                
  //   }else if(onError is ConnectionError){
  //   errorDialog(
  //     context, 
  //     "Sin conexión al servidor",
  //     negativeAction: (){
  //     },
  //   );              
  //   }else{
                         
  //   }                                           
  // });
}
 
@override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    role.dispose(); 
    descp.dispose();
    super.dispose();
  }


@override
  Widget build(BuildContext context) {
    var menu = new Menu();
    return WillPopScope(
    onWillPop:null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar: new AppBar(
            title: Text(widget.editar?"Editar Rol":'Crear Rol',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    height: 800,
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
 
  _onPressed() {
    if(role.text==''){
      warningDialog(
        context, 
        "Por favor diligencie el campo Rol",
        negativeAction: (){
        },
      );
      rol.requestFocus();
      return;
    }
    if(descp.text==''){
      warningDialog(
        context, 
        "Por favor diligencie el campo Descripción",
        negativeAction: (){
        },
      );
      descripcion.requestFocus();
      return;
    }                   
    if (!keyForm.currentState.validate()){
    //   warningDialog(
    //   context, 
    //   "Por favor revise la información ingresada",
    //   negativeAction: (){
    //   },
    // );
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data'))
      );
                                
    }else{
      save();
    }
  }
  
  Widget formUI() {
    return  Column(
      children: <Widget>[
        // Container(
        //  height: 60,
        //   width: 600,
        //   margin: EdgeInsets.only(top:21),
        //   decoration: BoxDecoration(
        //     color: Colors.white,  
        //       //borderRadius: BorderRadius.circular(20),
        //     image: DecorationImage(
        //       image: AssetImage('images/titulop.png'),
        //       fit: BoxFit.cover
        //     ),
        //   ),
        //   child:Row(
        //     children:<Widget>[
        //       Container(
        //         child:IconButton(
        //           icon: Icon(
        //             Icons.arrow_back,
        //             color: Colors.white,
        //           ),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
                
        //       ),
        //       Center(
        //         child:Text(widget.editar?"Editar Rol":'Crear Rol',style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold
        //         ),),
        //       )
        //     ],
        //   ) ,
        //   //padding: EdgeInsets.symmetric(horizontal:10),
        // ),
        formItemsDesign(
          Icons.accessibility_outlined,
          TextFormField(
            controller: role,
            focusNode: rol,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: 'Rol',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Rol';
              }
            },
            //validator: validateName,
          )
        ),
        formItemsDesign(
          Icons.list_alt_outlined,
          TextFormField(
            controller: descp,
            focusNode: descripcion,
            autofocus: false,
            decoration: new InputDecoration(
              labelText: 'Descripción',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese la Descripción';
              }
            },
            //validator: validateName,
          )
        ),
        Boton(onPresed: _onPressed,texto:'Aceptar',),  
      ],
    );
  }
  save() {
    if(widget.editar == true){
      editar_rol();
    }else{
      crearRol();
    } 
  }
}
