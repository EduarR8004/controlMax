import 'dart:async';
import 'package:controlmax/vistas/administracion/ReporteRutaAdministracion.dart';
import 'package:controlmax/vistas/claves/clavesVigentes.dart';
import 'package:controlmax/vistas/portada.dart';
import 'package:controlmax/vistas/proyecto/Proyecto_view.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:controlmax/vistas/home.dart';
import 'package:workmanager/workmanager.dart';
import 'package:controlmax/vistas/ventas.dart';
import 'package:connectivity/connectivity.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/ventas/ruta.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:controlmax/vistas/claves/claves.dart';
import 'package:controlmax/vistas/widgets/subMenu.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/vistas/roles/rolesObjetos.dart';
import 'package:controlmax/vistas/gastos/ListarGastos.dart';
import 'package:controlmax/vistas/agenda/listarAgenda.dart';
import 'package:controlmax/vistas/historial/Historial.dart';
import 'package:controlmax/vistas/cerrarCaja/CerrarCaja.dart';
import 'package:controlmax/vistas/usuarios/listarUsuario.dart';
import 'package:controlmax/vistas/baseGeneral/FechasBase.dart';
import 'package:controlmax/vistas/cerrarCaja/CopiaSeguridad.dart';
import 'package:controlmax/vistas/baseGeneral/AsignarBaseRuta.dart';
import 'package:controlmax/vistas/administracion/ConsultarClaves.dart';
import 'package:controlmax/vistas/baseGeneral/FechasCuadreSemanal.dart';
import 'package:controlmax/vistas/administracion/FechasProduccion.dart';
import 'package:controlmax/vistas/baseGeneral/IngresoRetiroDinero.dart';
import 'package:controlmax/vistas/administracion/RutaAdministrador.dart';
import 'package:controlmax/vistas/historialCredito/HistorialCredito.dart';
import 'package:controlmax/vistas/administracion/ConsultarFechaBloqueados.dart';
import 'package:controlmax/vistas/administracion/CierreRutaAdministracion.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> with WidgetsBindingObserver{
  //StreamSubscription subscription;
  ProgressDialog pr;
  List<Widget> menu =[];
  List<Widget> subMenu =[];
  List<Widget> reportesSemanal =[];
  List<Widget> reportesGenereal =[];
  List<Widget> subMenuUsuarios =[];
  List<Widget> historiales =[];

  @override
  void initState() {
    //subscription = Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    agregar();
  }

  void callbackDispatcher() {
    Workmanager.executeTask((task, inputData) async {
    if(task=='_actualizar'){
        _actualizar();
    }
    ///session_p ();
    return Future.value(true);
  });
  }

  agregar(){
    setState(() {
      menu.add(header());
      if(objetosUsuario.contains('CCR002') || objetosUsuario.contains("SA000")){
        subMenuUsuarios.add(listaRoles(context));
      }
      if(objetosUsuario.contains('AU001') || objetosUsuario.contains("SA000")){
        subMenuUsuarios.add(listaUsuario(context));
      }
      if(objetosUsuario.contains('AU001') || objetosUsuario.contains("SA000")){
        subMenuUsuarios.add(listaProyecto(context));
      }
      if(objetosUsuario.contains('AU001') || objetosUsuario.contains("SA000")){
        menu.add(Configuracion(subMenuUsuarios,"Configuración",Icon(Icons.build,size:30,color: Colors.black,),));
      }
      if(objetosUsuario.contains('ADM001') || objetosUsuario.contains("SA000")){
        menu.add(Configuracion(subMenu,"Administración",Icon(Icons.miscellaneous_services,size:30,color: Colors.black,)));
      }
      if(objetosUsuario.contains('ABC004') || objetosUsuario.contains("SA000")){
        menu.add(Configuracion(reportesSemanal,"Control Caja Semanal",Icon(Icons.content_paste_rounded,size:30,color: Colors.black,)));
      }
      if(objetosUsuario.contains('ABC004') || objetosUsuario.contains("SA000")){
        menu.add(Configuracion(reportesGenereal,"Control Caja General",Icon(Icons.calculate_rounded,size:30,color: Colors.black,)));
      }
      menu.add(listaInicio(context));
      if(Platform.isAndroid){
        menu.add(listaPortada(context));
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('AD001') || objetosUsuario.contains("SA000")){
          menu.add(listaAgenda(context));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('VCVN001') || objetosUsuario.contains("SA000")){
          menu.add(listaVentas(context));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('VRC001') || objetosUsuario.contains("SA000")){
          menu.add(listaRuta(context));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('VRC001') || objetosUsuario.contains("SA000")){
          menu.add(listaClavesVigentes(context));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('HU001') || objetosUsuario.contains("SA000")){
          menu.add(Configuracion(historiales,"Historiales",Icon(Icons.date_range_rounded,size:30,color: Colors.black,)));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('HU001') || objetosUsuario.contains("SA000")){
          historiales.add(listaHistorial(context));
        }
      }
      if(objetosUsuario.contains('CC001') || objetosUsuario.contains("SA000")){
        subMenu.add(generarClaves(context));
      }
      // if(objetosUsuario.contains('CC001') || objetosUsuario.contains("SA000")){
      //   subMenu.add(listaClaves(context));
      // }
      if(objetosUsuario.contains('RA001') || objetosUsuario.contains("SA000")){
        subMenu.add(listaRutaAdmin(context));
      }
      // if(objetosUsuario.contains('RA001') || objetosUsuario.contains("SA000")){
      //   subMenu.add(estadoRutaAdmin(context));
      // }
      if(objetosUsuario.contains('CAR001') || objetosUsuario.contains("SA000")){
        subMenu.add(listaCartera(context));
      }
      if(objetosUsuario.contains('PA001') || objetosUsuario.contains("SA000")){
        reportesSemanal.add(listaProduccion(context));
      }
      if(objetosUsuario.contains('ABA003') || objetosUsuario.contains("SA000")){
        reportesSemanal.add(asignacionBaseRuta(context));
      }
      if(objetosUsuario.contains('ABI001') || objetosUsuario.contains("SA000")){
        reportesGenereal.add(ingresarBaseRuta(context));
      }
      if(objetosUsuario.contains('ABR002') || objetosUsuario.contains("SA000")){
        reportesGenereal.add(retirarBaseRuta(context));
      }
      if(objetosUsuario.contains('OCS002') || objetosUsuario.contains("SA000")){
        reportesGenereal.add(entradaBaseGeneralRuta(context));
      }
      // if(objetosUsuario.contains('ABR002') || objetosUsuario.contains("SA000")){
      //   reportesGenereal.add(salidaBaseGeneralRuta(context));
      // }
      if(objetosUsuario.contains('ABC004') || objetosUsuario.contains("SA000")){
        reportesGenereal.add(consultarBaseRuta(context));
      }
      // if(objetosUsuario.contains('AB001') || objetosUsuario.contains("SA000")){
      //   subMenu.add(listarBloqueados(context));
      // }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('VRC001') || objetosUsuario.contains("SA000")){
          menu.add(listaGasto(context));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('VRC001') || objetosUsuario.contains("SA000")){
          menu.add(listaCerrarCaja(context));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('VRC001') || objetosUsuario.contains("SA000")){
          historiales.add(listarHistorialPago(context));
        }
      }
      if(Platform.isAndroid){
        if(objetosUsuario.contains('VRC001') || objetosUsuario.contains("SA000")){
          menu.add(copiaSeguridad(context));
        }
      }
    });
  }
  _actualizar(){  
    var session= Insertar();
    session.enviarClientes(actualizar: false).then((_){
      session.actualizarVentas().then((_){
        session.enviarHistorial().then((_){
          session.baseConsulta().then((_){
            session.enviarGastos().then((_){
              });
          });
        });
      });
    });
  }
  inicio(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Home())
    );
  }
  portada(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Portada(editar: true,))
    );
  }
  produccion(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FechasProduccion())
    );
  }
  bloqueados(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ConsultarFechaBloqueados())
    );
  }
  usuarios(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DataTableUsuarios())
    );
  }
  proyecto(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProyectosView())
    );
  }

  rutaAdmin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RutaAdminView())
    );
  }

  clavesVigentes(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ClavesVigentes())
    );
  }
  cartera(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ReporteCarteraAdministrador ())
    );
  }
  
  roles(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>ProfilePage())
    );
  }

  nuevaVenta(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NuevaVentaView(false,false,false))
    );
  }
  asignarBaseRuta(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BaseRuta(false))
    );
  }
  verEstadoRuta(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CerrarCajaAdministrador())
    );
  }
  ingresoBaseGeneral(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => IngresoRetiroDinero(false))
    );
  }
  retiroBaseGeneral(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => IngresoRetiroDinero(true))
    );
  }

  entradaBaseGeneral(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FechasCuadreSemanal())
    );
  }

  salidaBaseGeneral(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => IngresoRetiroDinero(false))
    );
  }

  consultaBaseRuta(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FechasBase())
    );
  }
  historial(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Historial())
    );
  }
  historialPago(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HistorialCreditoView())
    );
  }
  ruta(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => RecoleccionView(boton: true,),));}
    );
  }
  cerrarCaja(BuildContext context) {
    if(Platform.isAndroid){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => CerrarCaja(),));}
      );
    }else{
      warningDialog(
        context, 
        "Esta funcionalidad solo esta desponible en su teléfono móvil",
        neutralAction: (){
          
        },
      );
    }
  }
  llamarCopiaSeguridad(BuildContext context) {
    if(Platform.isAndroid){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => CopiaSeguridad(),)); }
      );
    }else{
      warningDialog(
        context, 
        "Esta funcionalidad solo esta desponible en su teléfono móvil",
        neutralAction: (){
          
        },
      );
    }
  }
  agenda(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => ListarAgenda(),)); }
    );
  }
  gastos(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => DataTableGastos(),));}
    );
  }
  claves(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Claves(),)); }
    );
  }
  consultarClaves(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => ClavesView(),));}
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children:menu,
      ),
    );
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    // final message = hasInternet
    //     ? 'You have again ${result.toString()}'
    //     : 'You have no internet';
    //final color = hasInternet ? Colors.green : Colors.red;
    if(hasInternet){
      _actualizar();
    }
    
    //Utils.showTopSnackBar(context, message, color);
  }

  ListTile listaVentas(BuildContext context) {
    return ListTile(
      title: Text("Ventas",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.mobile_friendly,
        size: 30,
        color: Colors.black,
      ),
      onTap: () async{ 
        Workmanager.initialize(
          callbackDispatcher, // The top level function, aka callbackDispatcher
          isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
        nuevaVenta(context);
        final result = await Connectivity().checkConnectivity();
        showConnectivitySnackBar(result);
        
      }
    );
  }
  ListTile listaClaves(BuildContext context) {
    return ListTile(
      title: Text("Claves Generadas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.event_note_outlined,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => consultarClaves(context),
    );
  }

  ListTile asignacionBaseRuta(BuildContext context) {
    return ListTile(
      title: Text("Base diaria",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.point_of_sale,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => asignarBaseRuta(context),
    );
  }
    estadoRutaAdmin(BuildContext context) {
    return ListTile(
      title: Text("Estado-Cierre ruta",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.point_of_sale,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => verEstadoRuta(context),
    );
  }
  ListTile asignacionBaseGeneral(BuildContext context) {
    return ListTile(
      title: Text("Base general",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.point_of_sale,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => asignarBaseRuta(context),
    );
  }
  ListTile ingresarBaseRuta(BuildContext context) {
    return ListTile(
      title: Text("Ingreso caja general",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.how_to_vote_sharp,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => ingresoBaseGeneral(context),
    );
  }

  ListTile retirarBaseRuta(BuildContext context) {
    return ListTile(
      title: Text("Retiro caja general",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.money,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => retiroBaseGeneral(context),
    );
  }
  ListTile entradaBaseGeneralRuta(BuildContext context) {
    return ListTile(
      title: Text("Cuadre semanal por usuario",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => entradaBaseGeneral(context),
    );
  }

  // ListTile salidaBaseGeneralRuta(BuildContext context) {
  //   return ListTile(
  //     title: Text("Caja ingreso-retiro",
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //     leading: Icon(
  //       Icons.arrow_back_ios_outlined,
  //       size: 25,
  //       color: Colors.black,
  //     ),
  //     onTap: () => salidaBaseGeneral(context),
  //   );
  // }
  
  ListTile consultarBaseRuta(BuildContext context) {
    return ListTile(
      title: Text("Caja general",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.bar_chart_sharp,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => consultaBaseRuta(context),
    );
  }

  ListTile listaHistorial(BuildContext context) {
    return ListTile(
      title: Text("Historial",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.auto_stories,
        size: 30,
        color: Colors.black,
      ),
      onTap: () => historial(context),
    );
  }
  ListTile listarHistorialPago(BuildContext context) {
    return ListTile(
      title: Text("Historial pago",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.payment_rounded,
        size: 30,
        color: Colors.black,
      ),
      onTap: () => historialPago(context),
    );
  }

  ListTile listaAgenda(BuildContext context) {
    return ListTile(
      title: Text("Agenda",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.point_of_sale,
        size: 30,
        color: Colors.black,
      ),
      onTap: () => agenda(context),
    );
  }

  ListTile generarClaves(BuildContext context) {
    return ListTile(
      title: Text("Crear Claves",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.lock_open_rounded,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => claves (context),
    );
  }

  ListTile listaCerrarCaja(BuildContext context) {
    return ListTile(
      title: Text("Cerrar Caja",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.bar_chart_sharp,
        size: 30,
        color: Colors.black,
      ),
      onTap: () => cerrarCaja(context),
    );
  }
  ListTile listaGasto(BuildContext context) {
    return ListTile(
      title: Text("Gastos",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.money_off,
        size: 30,
        color: Colors.black,
      ),
      onTap: () => gastos(context),
    );
  }
  ListTile listaProduccion(BuildContext context) {
    return ListTile(
      title: Text("Producción",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.analytics_outlined,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => produccion(context),
    );
  }
  ListTile listarBloqueados(BuildContext context) {
    return ListTile(
      title: Text("Bloqueados",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.warning,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => bloqueados(context),
    );
  }
  ListTile listaRoles(BuildContext context) {
    return ListTile(
      title: Text("Roles y Objetos",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.security,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => roles(context),
    );
  }
  ListTile listaRuta(BuildContext context) {
    return ListTile(
      title: Text("Ruta",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.two_wheeler_rounded,
        size: 30,
        color: Colors.black,
      ),
      onTap: () async{ 
        final result = await Connectivity().checkConnectivity();
        showConnectivitySnackBar(result);
        ruta(context);
      },
    );
  }
  ListTile copiaSeguridad(BuildContext context) {
    return ListTile(
      title: Text("Copia de seguridad",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.content_copy_rounded,
        size: 30,
        color: Colors.black,
      ),
      onTap: () async{ 
        llamarCopiaSeguridad(context);
      },
    );
  }
  ListTile listaUsuario(BuildContext context) {
    return ListTile(
      title: Text("Usuarios",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.person,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => usuarios(context),
    );
  }

  ListTile listaProyecto(BuildContext context) {
    return ListTile(
      title: Text("Proyecto",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(
        Icons.account_tree_rounded,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => proyecto(context),
    );
  }

  ListTile listaRutaAdmin(BuildContext context) {
    return ListTile(
      title: Text("Rutas",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      leading: Icon(
        Icons.two_wheeler_rounded,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => rutaAdmin(context),
    );
  }

  ListTile listaClavesVigentes(BuildContext context) {
    return ListTile(
      title: Text("Claves vigentes",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      leading: Icon(
        Icons.arrow_circle_down,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => clavesVigentes(context),
    );
  }

  ListTile listaCartera(BuildContext context) {
    return ListTile(
      title: Text("Cartera",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      leading: Icon(
        Icons.business_center_rounded,
        size: 25,
        color: Colors.black,
      ),
      onTap: () => cartera(context),
    );
  }

  DrawerHeader header() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: <Color>[
            ///Colors.red,
            Colors.white,
            Colors.blueGrey,
            //
          ],
        ),
      ),
      child:Row(
        children: [
          Icon(Icons.bar_chart_sharp , size:80,color:Colors.white),
          Text("ControlMax",style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ))
        ],
      ),
    );
  }

  ListTile listaInicio(BuildContext context) {
    return ListTile(
      title: Text("Inicio",style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
      )),
      leading: Icon(Icons.home,size:30,color: Colors.black,),
      onTap: ()=> inicio(context),
    );
  }
  ListTile listaPortada(BuildContext context) {
    return ListTile(
      title: Text("Portada",style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
      )),
      leading: Icon(Icons.add_alert_rounded,size:30,color: Colors.black,),
      onTap: ()=> portada(context),
    );
  }
}

// SELECT a.`id`,a.`usuario`,a.`fecha`,a.`ingreso`, concat('Ingreso ',b.nombre,' : ',a.`ingreso`) as Entrada , a.`retiro`,Concat('Retiro ',b.nombre,' : ',a.`retiro`) as Salida
// FROM `base_general` as a
// INNER JOIN usuarios_control as b on a.usuario=b.usuario
// WHERE a.fecha BETWEEN '2022-04-20' AND '2022-04-23'
// UNION
// SELECT c.`id`, c.`usuario`,c.`fecha`,c.`entrada`,concat('Entrada ',d.`nombre`,' : ',c.`entrada`) as Entrada, c.`salida`,concat('Salida ',d.`nombre`,' : ',c.`salida`) as Salida
// FROM `base_general` as c
// INNER JOIN usuarios_control as d on c.usuario_ruta=d.usuario
// WHERE c.fecha BETWEEN '2022-04-20' AND '2022-04-23'