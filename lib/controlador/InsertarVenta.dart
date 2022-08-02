import 'dart:core';
import 'dart:convert';
import 'package:controlmax/modelos/Cartera.dart';
import 'package:controlmax/modelos/ControlPrestamo.dart';
import 'package:controlmax/modelos/Proyecto.dart';
import 'package:controlmax/modelos/UsuarioAdministrador.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:controlmax/modelos/Rol.dart';
import 'package:controlmax/bd/Basedatos.dart';
import 'package:controlmax/modelos/Venta.dart';
import 'package:controlmax/modelos/Gasto.dart';
import 'package:controlmax/utiles/Globals.dart';
import 'package:controlmax/modelos/Claves.dart';
import 'package:controlmax/modelos/Objeto.dart';
import 'package:controlmax/modelos/Ventas.dart';
import 'package:controlmax/modelos/Ciudad.dart';
import 'package:controlmax/modelos/Cliente.dart';
import 'package:controlmax/modelos/Asignar.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/modelos/Produccion.dart';
import 'package:controlmax/modelos/RutaAdmin.dart';
import 'package:controlmax/modelos/ConteoDebe.dart';
import 'package:controlmax/modelos/ListarCaja.dart';
import 'package:controlmax/modelos/AsignarAdmin.dart';
import 'package:controlmax/modelos/CajaInicial.dart';
import 'package:controlmax/modelos/ReporteGasto.dart';
import 'package:controlmax/modelos/HistorialPago.dart';
import 'package:controlmax/modelos/CuadresSemana.dart';
import 'package:universal_io/prefer_universal/io.dart';
import 'package:controlmax/modelos/Agendamiento.dart';
import 'package:controlmax/modelos/Departamento.dart';
import 'package:controlmax/modelos/ReporteDiario.dart';
import 'package:controlmax/modelos/TotalBloquedos.dart';
import 'package:controlmax/modelos/ConteoDebeAdmin.dart';
import 'package:controlmax/modelos/HistorialVenta.dart';
import 'package:controlmax/modelos/TotalRutaAdmin.dart';
import 'package:controlmax/modelos/ClienteBloqueado.dart';

class Insertar {
  List _login;
  List _roles;
  List _objetos;
  List _bloquedos;
  List _noObjetos;
  List _noRoles;
  List _usuarios;
  bool validacion;
  dynamic consulta;
  List _claves=[];
  List _gastos=[];
  List _ciudades=[];
  List _enviados=[];
  List _proyectos=[];
  List _agendados=[];
  List _enviarGastos=[];
  List<Cartera> _cartera=[];
  List _enviarClientes=[];
  List _enviarProduccion=[];
  List _objetosSeguridad;
  List _enviarBaseRuta=[];
  List <Cliente> clientes;
  List<Asignar> _asignado=[];
  List _parametrosEnviados=[];
  List<ListarCaja> _listarCaja;
  List<Control> _controlPrestamo;
  List<RutaAdmin> _rutaAdmin=[];
  List<ListarCaja> _totalCaja;
  List<ReporteDiario> _produccion;
  List<ConteoDebe> _nuevaVenta=[];
  List<CajaInicial> _asignadoInicial=[];
  List<ReporteGasto> _reporteGasto;
  List<ConteoDebe> _recolectado=[];
  List <Agendamiento> agendamientos;
  List<ConteoDebe> _porRecolectar=[];
  List<ReporteDiario> _totalProduccion;
  List<AsignarAdmin> _asignadoAdmin=[];
  List<CuadreSemana> _listarCuadreSemana;
  List <TotalBloqueados> _totalBloqueado;
  List<RutaAdminTotal> _totalRutaAdmin=[];
  List<ConteoDebe> _recolectadoMismoDia=[];
  List <ClienteBloqueado> _clienteBloqueado;
  List<ConteoDebeAdmin> _porRecolectarAdmin=[];
  List<ConteoDebeAdmin> _ventasHoyUsuario=[];
  List<ConteoDebeAdmin> _ventasHoyGeneral=[];
  List<ConteoDebeAdmin> _recolectadosAdmin=[];
  String urlOrigen='https://controlproyectos.com.co/webservice';
  String urlAntioquia='https://controlproyectos.com.co/webserviceAnt';
  String pruebas='https://aceitereciclar.000webhostapp.com/webservice';
  String brasil='https://controlproyectos.com.co/webserviceBrasil';
  String ecuador='https://controlproyectos.com.co/webserviceEcuador';
  Map mapaFinal;
  var params;
  Map cronMap;
  var contador= 0;
  DateTime now = new DateTime.now();
  final format = DateFormat("yyyy-MM-dd");
  
  vibrar(){
    HapticFeedback.heavyImpact();
  }
  Future<Map>insertar ({
    idVenta,
    idCliente,
    nombre,
    direccion,
    telefono,
    departamento,
    ciudad,
    primerApellido,
    segundoApellido,
    alias,
    actividadEconomica,
    documento,
    valorVenta,
    cuotas,
    frecuencia,
    bool tipo,
    String clave,
    day,
    diaRecoleccion,
    bool historial
  })async{  
    if(clave!='Continuar'){
      var consultaClave =await DatabaseProvider.db.rawQuery("SELECT clave FROM Claves WHERE clave= ? AND valor = ? ",[clave,valorVenta]);
      if(consultaClave.length <= 0){
        Map repuesta={
          "respuesta":true,
          "clave":false,
          "motivo":"Por favor verificar la clave ingresada",
        };
        return repuesta;
      }else{
        await DatabaseProvider.db.rawQuery(
          " DELETE FROM Claves"
          " WHERE clave = ? ",[clave]                                        
        );
      }
    }
    double cuota=double.parse(cuotas);
    String fechaConsulta = format.format(now);
    double interes = 10;
    String intereses ='10';
    double equivaleInteres;
    double totalVenta;
    double coutaPagar;
    double valorNeto;
    var fechaPagara;
    
    if(cuota > 11 && frecuencia=='Diario'){
      interes =20;
      intereses ='20';
      equivaleInteres = (double.parse(valorVenta)*interes)/100;
      totalVenta = double.parse(valorVenta)+equivaleInteres;
      coutaPagar=totalVenta/cuota;
      valorNeto=double.parse(valorVenta);
      fechaPagara = new DateTime.now().add(new Duration(days:int.parse(cuotas)));
    }

    if(cuota <= 11 && frecuencia=='Diario'){
      equivaleInteres = (double.parse(valorVenta)*interes)/100;
      totalVenta = double.parse(valorVenta)+equivaleInteres;
      coutaPagar=totalVenta/cuota;
      valorNeto=double.parse(valorVenta);
      fechaPagara = new DateTime.now().add(new Duration(days:int.parse(cuotas)));
    }

    if(frecuencia=='Semanal'){
      interes =20;
      intereses ='20';
      equivaleInteres = (double.parse(valorVenta)*interes)/100;
      totalVenta = double.parse(valorVenta)+equivaleInteres;
      coutaPagar=totalVenta/cuota;
      valorNeto=double.parse(valorVenta);
      double cuotaSemana= cuota*7;
      String semana=cuotaSemana.toString();
      List procesar=semana.split('.');
      fechaPagara = new DateTime.now().add(new Duration(days:int.parse(procesar[0])));
    }

    if(frecuencia=='Quincenal'){
      interes =20;
      intereses ='20';
      equivaleInteres = (double.parse(valorVenta)*interes)/100;
      totalVenta = double.parse(valorVenta)+equivaleInteres;
      coutaPagar=(totalVenta/cuota);
      valorNeto=double.parse(valorVenta);
      double cuotaSemana= cuota*14;
      String mes=cuotaSemana.toString();
      List procesar=mes.split('.');
      fechaPagara = new DateTime.now().add(new Duration(days:int.parse(procesar[0])));
    }

    contador++;
    //DateTime fecha1 =  DateTime.parse('2021-07-20');
    //DateTime fecha2 =  DateTime.parse('2021-07-24 ');
    //DateTime horaTotal= fecha1.add(Duration(hours: fecha2.hour, minutes: fecha2.minute));
    //print(horaTotal);
    String estado ="Bloqueado";
    
    var resBloqueo =await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente WHERE documento = ? AND estado = ?",[documento,estado]);
    if(resBloqueo.length>0){
      var mapa = {
        "respuesta":this.validacion = true,
        "motivo":"Cliente bloqueado, por favor cumuniquese con el supervisor"
      };
      return mapa;
    }else{
      var res =await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente WHERE documento = ?",[documento]);
      if(res.length <= 0 && tipo==false && historial==false)
      { 
        String nuevoIdVenta=now.millisecondsSinceEpoch.toString().trim();
        final movimiento = Cliente(
          idCliente:now.millisecondsSinceEpoch.toString().trim(),
          idVenta:nuevoIdVenta,
          nombre:nombre,
          direccion:direccion,
          telefono:telefono,
          ciudad:ciudad,
          departamento:departamento,
          primerApellido:primerApellido,
          segundoApellido:segundoApellido,
          alias:alias,
          actividadEconomica:actividadEconomica,
          documento:documento,
          fecha:
          //1633441525000,
          now.millisecondsSinceEpoch,
          estado:"debe",
          usuario:usuarioGlobal, 
        );
        await DatabaseProvider.db.addToDatabase(movimiento);
        final venta = Venta(
          idVenta: nuevoIdVenta,
          documento:documento,
          venta:totalVenta,
          cuotas:cuota,
          fecha:
          //1649658030000,
          now.millisecondsSinceEpoch,
          fechaPago: fechaPagara.millisecondsSinceEpoch,
          interes:intereses,
          numeroCuota:0,
          valorCuota: coutaPagar,
          saldo:totalVenta, 
          estado:"debe",
          usuario:usuarioGlobal, 
          frecuencia:frecuencia,
          solicitado:valorNeto,
          valorTemporal: totalVenta,
          cuotasTemporal:0,
          estadoTemporal:"debe",
          motivo:"Prestamo",
          orden: now.millisecondsSinceEpoch,
          fechaTexto:fechaConsulta.trim(),
          ruta:"no",
          actualizar:'si',
          day: day,
          diaRecoleccion: diaRecoleccion,
          valorDia:0
        );
        await DatabaseProvider.db.addToDatabase(venta);
        var agenda =await DatabaseProvider.db.rawQuery("SELECT * FROM Agendamiento WHERE documento = ?",[documento]);
        if(agenda.length>0){
          await DatabaseProvider.db.rawQuery(
            " DELETE FROM Agendamiento"
            " WHERE documento = ? ",[documento]                                        
          );
          await DatabaseProvider.db.rawQuery(
            " DELETE FROM Cliente"
            " WHERE documento = ? AND estado = ? ",[documento,'pago']                                        
          );
        }
        
        var mapa = {
          "respuesta":this.validacion = true,
          "motivo":"Cliente creado correctamente"
        };
        return mapa; 

      }else if(res.length >0 && tipo==true && historial==false){
        // var contarCliente=await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente WHERE documento = ? AND estado = ?",[documento,"debe"]);
        // if(contarCliente.length <= 0 && tipo==false)
        // { 
        await DatabaseProvider.db.rawQuery(
          "UPDATE venta SET "
          "documento=?,"
          "venta=?,"
          "solicitado=?,"
          "cuotas=?,"
          "fecha=?,"
          "fechaTexto=?,"
          "fechaPago=?,"
          "interes=?,"
          "numeroCuota=?,"
          "valorCuota=?,"
          "saldo=?,"
          "estado=?,"
          "frecuencia=?,"
          "motivo=?,"
          "valorTemporal=?,"
          "cuotasTemporal=?,"
          "estadoTemporal=?,"
          "orden=?,"
          "ruta=?,"
          "actualizar=?,"
          "diaRecoleccion=?,"
          "day=?,"
          "usuario=?"
          "WHERE idVenta=?"
          ,[
            documento, 
            totalVenta,
            valorNeto,
            cuota,
            now.millisecondsSinceEpoch,
            fechaConsulta,
            fechaPagara.millisecondsSinceEpoch,
            intereses,
            0,
            coutaPagar,
            totalVenta,
            'debe',
            frecuencia,
            "Prestamo",
            totalVenta,
            0,
            'debe',
            now.millisecondsSinceEpoch,
            'no',
            'si',
            diaRecoleccion,
            day,
            usuarioGlobal,
            idVenta,
          ]                                        
        );
        await DatabaseProvider.db.rawQuery(
          "UPDATE Cliente "
          "SET nombre=?,"
          "primerApellido=?,"
          "segundoApellido=?,"
          "alias=?,"
          "direccion=?,"
          "ciudad=?,"
          "departamento=?,"
          "telefono=?,"
          "actividadEconomica=?,"
          "documento=?,"
          "fecha=?,"
          "estado=?,"
          "usuario=? "
          "WHERE idCliente=? "
          ,[
            nombre,
            primerApellido,
            segundoApellido,
            alias,
            direccion,
            ciudad,
            departamento,
            telefono,
            actividadEconomica,
            documento,
            now.millisecondsSinceEpoch,
            'debe',
            usuarioGlobal,
            idCliente,
          ]
        );
        var agenda =await DatabaseProvider.db.rawQuery("SELECT * FROM Agendamiento WHERE documento = ?",[documento]);
        if(agenda.length>0){
          await DatabaseProvider.db.rawQuery(
            " DELETE FROM Agendamiento"
            " WHERE documento = ? ",[documento]                                        
          );
        }
        var mapa = {
          "respuesta":this.validacion = true,
          "motivo":"Venta creada correctamente"
        };
        return mapa; 
        // }else{
        //   var mapa = {
        //     "respuesta":this.validacion = true,
        //     "motivo":"El cliente tiene un credito activo"
        //   };
        //   return mapa; 
        // }
      }else if(res.length >0 && tipo==true && historial){
        String nuevoIdVenta=now.millisecondsSinceEpoch.toString().trim();
        await DatabaseProvider.db.rawQuery(
          "UPDATE Cliente "
          "SET nombre=?,"
          "primerApellido=?,"
          "segundoApellido=?,"
          "alias=?,"
          "direccion=?,"
          "ciudad=?,"
          "departamento=?,"
          "telefono=?,"
          "actividadEconomica=?,"
          "documento=?,"
          "fecha=?,"
          "estado=?,"
          "usuario=?,"
          "idVenta=? "
          "WHERE idCliente=? "
          ,[
            nombre,
            primerApellido,
            segundoApellido,
            alias,
            direccion,
            ciudad,
            departamento,
            telefono,
            actividadEconomica,
            documento,
            now.millisecondsSinceEpoch,
            'debe',
            usuarioGlobal,
            nuevoIdVenta,
            idCliente,
          ]
        );
        final venta = Venta(
          idVenta: nuevoIdVenta,
          documento:documento,
          venta:totalVenta,
          cuotas:cuota,
          fecha:
          //1649658030000,
          now.millisecondsSinceEpoch,
          fechaPago: fechaPagara.millisecondsSinceEpoch,
          interes:intereses,
          numeroCuota:0,
          valorCuota: coutaPagar,
          saldo:totalVenta, 
          estado:"debe",
          usuario:usuarioGlobal, 
          frecuencia:frecuencia,
          solicitado:valorNeto,
          valorTemporal: totalVenta,
          cuotasTemporal:0,
          estadoTemporal:"debe",
          motivo:"Prestamo",
          orden: now.millisecondsSinceEpoch,
          fechaTexto:fechaConsulta.trim(),
          ruta:"no",
          actualizar:'si',
          day: day,
          diaRecoleccion: diaRecoleccion,
          valorDia:0
        );
        var agenda =await DatabaseProvider.db.rawQuery("SELECT * FROM Agendamiento WHERE documento = ?",[documento]);
        if(agenda.length>0){
          await DatabaseProvider.db.rawQuery(
            " DELETE FROM Agendamiento"
            " WHERE documento = ? ",[documento]                                        
          );
          await DatabaseProvider.db.rawQuery(
            " DELETE FROM Cliente"
            " WHERE documento = ? AND estado = ? ",[documento,'pago']                                        
          );
        }
        await DatabaseProvider.db.addToDatabase(venta);
        var mapa = {
          "respuesta":this.validacion = true,
          "motivo":"Venta creada correctamente"
        };
        return mapa; 
      }else{
        var mapa = {
          "respuesta":this.validacion = false,
          "motivo":"Ya existe un cliente con este documento"
        };
        return mapa; 
      }
    }
  }

  verificarClave(clave) async{
    String tipo="Copia de seguridad";
    var consultaClave =await DatabaseProvider.db.rawQuery("SELECT clave FROM Claves WHERE clave= ? AND tipo = ? ",[clave,tipo]);
    if(consultaClave.length <= 0){
      Map repuesta={
        "respuesta":false,
        "clave":false,
        "motivo":"Por favor verificar la clave ingresada",
      };
      return repuesta;
    }else{
      Map repuesta={
        "respuesta":true,
        "clave":false,
        "motivo":"Por favor verificar la clave ingresada",
      };
      await DatabaseProvider.db.rawQuery(
        " DELETE FROM Claves"
        " WHERE clave = ? ",[clave]                                        
      );
      return repuesta;
    }
    
  }
  

  consultarBloqueado(documento) async {
    String estado ="Bloqueado";
    List res =await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente WHERE documento = ? AND estado = ?",[documento,estado]);
    List<Cliente> list = res.map((c) => Cliente.fromMap(c)).toList();
    return _bloquedos=list;
  }

  obtenerBloqueados(){
    return this._bloquedos;
  }

  editarVenta  ({
    nombre,
    direccion,
    telefono,
    primerApellido,
    segundoApellido,
    alias,
    actividadEconomica,
    documento,
    valorVenta,
    cuotas,
    saldo,
    frecuencia,
    int fecha,
    id,
    usuario,
    ventaAnterior,
    numeroCuota,
    abonado
  })async{  
    double totalVenta;
    double cuota=double.parse(cuotas);
    List procesar=cuotas.split('.');
    double interes = 10;
    String intereses ='10';
    if(cuota > 11){
      interes =20;
      intereses ='20';
    }
    String fechaConsulta = format.format(DateTime.fromMillisecondsSinceEpoch(fecha,isUtc: false));
    double equivaleInteres = (double.parse(valorVenta)*interes)/100;
    totalVenta = (double.parse(valorVenta)+equivaleInteres);
    double saldo = totalVenta-abonado;
    String estado='';
    if( abonado >= totalVenta ){
      estado ='pago';
    }else{
      estado ='debe';
    }
    double coutaPagar=totalVenta/cuota;
    double numeroCuota=abonado/coutaPagar;
    double valorNeto=double.parse(valorVenta);
    DateTime  fechaPagara = DateTime.fromMillisecondsSinceEpoch(fecha);
    final format1 = DateFormat("yyyy-MM-dd");
    String  fecha1 = format1.format(fechaPagara);
    DateTime cambiar=DateTime.parse(fecha1 +' 00:00:00');
    DateTime nuevaFecha=cambiar.add(new Duration(days:int.parse(procesar[0].toString())));
    Map mapa={
      'token':tokenGlobal,
      'documento':documento,
      'venta':totalVenta,
      'cuotas':cuota,
      'fecha':fecha,
      'fechaPago': nuevaFecha.millisecondsSinceEpoch,
      'interes':intereses,
      'numeroCuota':numeroCuota,
      'valorCuota': coutaPagar,
      'saldo':saldo, 
      'estado':estado,
      'usuario':usuario, 
      'frecuencia':frecuencia,
      'solicitado':valorNeto,
      'valorTemporal': 0,
      'cuotasTemporal':0,
      'motivo':"Prestamo",
      'fechaTexto':fechaConsulta,
      'id':id,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/editarVenta.php',parametro);
    return 'vacio';

  }

  eliminarVentaAdmin({id})async{  
    Map mapa={
      'token':tokenGlobal,
      'id':id,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/eliminarVenta.php',parametro);
  }

  Future <List> consultarDeptos()async{
    List res = await DatabaseProvider.db.rawQuery("SELECT * FROM Departamento",[]);
    List<Departamento> list = res.map((c) => Departamento.fromMap(c)).toList();
    return list;
    //var map1 = Map.fromIterable(list, key: (e) => e.id, value: (e) => e.nombre);
    //return map1;
  }

  Future <List<Cliente>> consultarClientes({filtro=''})async{
    String estado = 'pago';
    List res = await DatabaseProvider.db.rawQuery(
      "SELECT idCliente,"
      "nombre,"
      "primerApellido,"
      "segundoApellido,"
      "alias,"
      "direccion,"
      "ciudad,"
      "departamento,"
      "telefono ,"
      "actividadEconomica,"
      "documento,"
      "fecha,"
      "estado,"
      "usuario FROM Cliente WHERE estado = ? AND (nombre LIKE ? or documento LIKE ? or alias LIKE ?) ",[estado,'%'+filtro+'%','%'+filtro+'%','%'+filtro+'%']
    );
    List<Cliente> list = res.map((c) => Cliente.fromMap(c)).toList();
    this.clientes= list;
    return list;
  }

  copiaVentas()async{
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM CopiaVenta",[]                                        
    );
    await DatabaseProvider.db.rawQuery(
      "INSERT INTO "
      "CopiaVenta ("
        "idVenta,"
        "documento,"
        "venta,"
        "solicitado,"
        "cuotas,"
        "fecha,"
        "fechaTexto,"
        "fechaPago,"
        "interes,"
        "numeroCuota,"
        "valorCuota,"
        "saldo,"
        "estado,"
        "frecuencia,"
        "motivo ,"
        "valorTemporal,"
        "cuotasTemporal,"
        "estadoTemporal,"
        "orden,"
        "ruta ,"
        "actualizar,"
        "diaRecoleccion,"
        "day,"
        "usuario"
        ")"
      "SELECT "
        "idVenta,"
        "documento,"
        "venta,"
        "solicitado,"
        "cuotas,"
        "fecha,"
        "fechaTexto,"
        "fechaPago,"
        "interes,"
        "numeroCuota,"
        "valorCuota,"
        "saldo,"
        "estado,"
        "frecuencia,"
        "motivo,"
        "valorTemporal,"
        "cuotasTemporal,"
        "estadoTemporal,"
        "orden,"
        "ruta,"
        "actualizar,"
        "diaRecoleccion,"
        "day,"
        "usuario"
        " FROM Venta ",[]
    );
  }

  copiaCliente()async{
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM CopiaCliente",[]                                        
    );
    await DatabaseProvider.db.rawQuery(
      "INSERT INTO "
      "CopiaCliente ("
        "idCliente,"
        "idVenta,"
        "nombre,"
        "primerApellido,"
        "segundoApellido,"
        "alias,"
        "direccion,"
        "ciudad,"
        "departamento,"
        "telefono,"
        "actividadEconomica,"
        "documento ,"
        "fecha,"
        "estado,"
        "valor,"
        "usuario"
        ")"
      "SELECT " 
      "idCliente,"
      "idVenta,"
      "nombre,"
      "primerApellido,"
      "segundoApellido,"
      "alias,"
      "direccion,"
      "ciudad,"
      "departamento,"
      "telefono,"
      "actividadEconomica,"
      "documento ,"
      "fecha,"
      "estado,"
      "valor,"
      "usuario"
      " FROM Cliente ",[]
    );
  }

  copiaHistorialMovimiento()async{
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM CopiaHistorialVenta",[]                                        
    );
    await DatabaseProvider.db.rawQuery(
      "INSERT INTO "
      "CopiaHistorialVenta ("
        "idVenta,"
        "documento,"
        "fechaRecoleccion,"
        "fecha,"
        "numeroCuota,"
        "valorCuota,"
        "saldo,"
        "novedad,"
        "usuario"
        ")"
      "SELECT " 
      "idVenta,"
      "documento,"
      "fechaRecoleccion,"
      "fecha,"
      "numeroCuota,"
      "valorCuota,"
      "saldo,"
      "novedad,"
      "usuario"
    " FROM HistorialVenta",[]
    );
  }

  copiaGasto()async{
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM CopiaGastos",[]                                        
    );
    await DatabaseProvider.db.rawQuery(
      "INSERT INTO "
      "CopiaGastos ("
      "idGasto,"
      "usuario,"
      "fecha,"
      "valor,"
      "tipo,"
      "observaciones"
      ")"
      "SELECT " 
      "idGasto,"
      "usuario,"
      "fecha,"
      "valor,"
      "tipo,"
      "observaciones"
      " FROM Gastos ",[]
    );
  }

  Future <List<Agendamiento>> consultarAgendamiento({filtro=''})async{
    List res = await DatabaseProvider.db.rawQuery(
      "SELECT nombre,"
      "primerApellido,"
      "documento,"
      "solicitado,"
      "fechaTexto,"
      "telefono FROM Agendamiento WHERE nombre LIKE ? or documento LIKE ? or primerApellido LIKE ? ",['%'+filtro+'%','%'+filtro+'%','%'+filtro+'%']
    );
    List<Agendamiento> list = res.map((c) => Agendamiento.fromMap(c)).toList();
    this.agendamientos= list;
    return list;
  }
  obtenerAgendamiento(){
    return this.agendamientos;
  }
  obtenerClientes(){
    return this.clientes;
  }

  Future <List<Ciudad>> consultarCiudad (myState)async{  
    var res =await DatabaseProvider.db.rawQuery("SELECT * FROM Ciudad WHERE departamento =?",[myState]);
    List<Ciudad> list = res.map((c) => Ciudad.fromMap(c)).toList();
    return list;
  }

  Future <List<Venta>> consultarVentas ()async{  
    var res =await DatabaseProvider.db.rawQuery("SELECT * FROM Venta",[]);
    List<Venta> list = res.map((c) => Venta.fromMap(c)).toList();
    return list;
  }

    obtenerCliente(documento)async{
    var res =await DatabaseProvider.db.rawQuery(
      "SELECT Cliente.nombre,"
      "Cliente.idCliente,"
      "Cliente.primerApellido,"
      "Cliente.segundoApellido,"
      "Cliente.alias,"
      "Cliente.direccion,"
      "Cliente.ciudad,"
      "Cliente.departamento,"
      "Cliente.telefono,"
      "Cliente.actividadEconomica,"
      "Cliente.documento,"
      "Venta.idVenta,"
      "Venta.venta,"
      "Venta.cuotas,"
      "Venta.fecha,"
      "Venta.fechaPago,"
      "Venta.interes,"
      "Venta.numeroCuota,"
      "Venta.valorCuota,"
      "Venta.valorTemporal,"
      "Venta.saldo,"
      "Venta.motivo,"
      "Venta.usuario,"
      "Venta.ruta,"
      "Venta.solicitado,"
      "Venta.diaRecoleccion,"
      "Venta.day,"
      "Venta.frecuencia"
      " FROM Cliente "
      " INNER JOIN Venta on Cliente.documento = Venta.documento"
      " WHERE Venta.usuario = ? AND Cliente.documento = ?  ORDER BY Venta.orden",[usuarioGlobal,documento,]                                        
    );
    List<Ventas> list = res.map((c) => Ventas.fromMap(c)).toList();
    return list[0];
  }
  Future <List<Ventas>> consultarRecoleccion({filtro='',bool ruta, String orden})async{  
    String dia=DateFormat('EEEE, d').format(now);
    List partirDia=dia.split(",");
    dia=partirDia[0];
    //String estado = "Bloqueado";
    if(ruta){
      var res =await DatabaseProvider.db.rawQuery(
      " SELECT Cliente.nombre,"
        "Cliente.idCliente,"
        "Cliente.idVenta,"
        "Cliente.primerApellido,"
        "Cliente.segundoApellido,"
        "Cliente.alias,"
        "Cliente.direccion,"
        "Cliente.ciudad,"
        "Cliente.departamento,"
        "Cliente.telefono,"
        "Cliente.actividadEconomica,"
        "Cliente.documento,"
        "Venta.idVenta,"
        "Venta.venta,"
        "Venta.cuotas,"
        "Venta.fecha,"
        "Venta.fechaPago,"
        "Venta.interes,"
        "Venta.numeroCuota,"
        "Venta.valorCuota,"
        "Venta.valorTemporal,"
        "Venta.saldo,"
        "Venta.motivo,"
        "Venta.usuario,"
        "Venta.ruta,"
        "Venta.solicitado,"
        "Venta.diaRecoleccion,"
        "Venta.valorDia,"
        "Venta.day,"
        "Venta.frecuencia"
        " FROM Cliente "
        " INNER JOIN Venta on Cliente.documento = Venta.documento"
        " WHERE Venta.usuario = ? AND Venta.estado !=? AND (Cliente.nombre LIKE ? or Cliente.documento LIKE ? or Cliente.alias LIKE ?) ORDER BY $orden",[usuarioGlobal,'cancelado','%'+filtro+'%','%'+filtro+'%','%'+filtro+'%']                                        
      );
      List<Ventas> list = res.map((c) => Ventas.fromMap(c)).toList();
      return list;
    }else{
      var res =await DatabaseProvider.db.rawQuery(
      " SELECT Cliente.nombre,"
        "Cliente.idCliente,"
        "Cliente.primerApellido,"
        "Cliente.segundoApellido,"
        "Cliente.alias,"
        "Cliente.direccion,"
        "Cliente.ciudad,"
        "Cliente.departamento,"
        "Cliente.telefono,"
        "Cliente.actividadEconomica,"
        "Cliente.documento,"
        "Venta.venta,"
        "Venta.idVenta,"
        "Venta.cuotas,"
        "Venta.fecha,"
        "Venta.fechaPago,"
        "Venta.interes,"
        "Venta.numeroCuota,"
        "Venta.valorCuota,"
        "Venta.valorTemporal,"
        "Venta.saldo,"
        "Venta.usuario,"
        "Venta.motivo,"
        "Venta.ruta,"
        "Venta.solicitado,"
        "Venta.diaRecoleccion,"
        "Venta.valorDia,"
        "Venta.frecuencia"
        " FROM Cliente "
        "INNER JOIN Venta on Cliente.documento = Venta.documento"
        " WHERE Venta.usuario = ? AND Venta.ruta = ? AND Venta.estado !=? AND (Cliente.nombre LIKE ? or Cliente.documento LIKE ? or Cliente.alias LIKE ?) ORDER BY $orden",[usuarioGlobal,'si','cancelado','%'+filtro+'%','%'+filtro+'%','%'+filtro+'%']
        //" WHERE Venta.usuario = ? AND Venta.ruta = ? AND (Venta.day=? OR Venta.day=?) AND (Cliente.nombre LIKE ? or Cliente.documento LIKE ? or Cliente.alias LIKE ?) ORDER BY Venta.orden",[usuarioGlobal,'si',dia,'Diario','%'+filtro+'%','%'+filtro+'%','%'+filtro+'%']                                       
      );
      List<Ventas> list = res.map((c) => Ventas.fromMap(c)).toList();
      return list;
    }
    
  }
  Future <List<Ventas>> historicoVentas({filtro=''})async{  
    var res =await DatabaseProvider.db.rawQuery(
    " SELECT Cliente.nombre,"
      "Cliente.idCliente,"
      "Cliente.primerApellido,"
      "Cliente.segundoApellido,"
      "Cliente.alias,"
      "Cliente.direccion,"
      "Cliente.ciudad,"
      "Cliente.departamento,"
      "Cliente.telefono,"
      "Cliente.actividadEconomica,"
      "Cliente.documento,"
      "HistoricoVenta.idVenta,"
      "HistoricoVenta.venta,"
      "HistoricoVenta.cuotas,"
      "HistoricoVenta.fecha,"
      "HistoricoVenta.fechaPago,"
      "HistoricoVenta.interes,"
      "HistoricoVenta.numeroCuota,"
      "HistoricoVenta.valorCuota,"
      "HistoricoVenta.valorTemporal,"
      "HistoricoVenta.saldo,"
      "HistoricoVenta.motivo,"
      "HistoricoVenta.usuario,"
      "HistoricoVenta.ruta,"
      "HistoricoVenta.solicitado,"
      "HistoricoVenta.diaRecoleccion,"
      "HistoricoVenta.day,"
      "HistoricoVenta.frecuencia"
      " FROM Cliente "
      " INNER JOIN HistoricoVenta on Cliente.documento = HistoricoVenta.documento"
      " WHERE HistoricoVenta.usuario = ? AND (Cliente.nombre LIKE ? or Cliente.documento LIKE ? or Cliente.alias LIKE ?) ORDER BY HistoricoVenta.solicitado",[usuarioGlobal,'%'+filtro+'%','%'+filtro+'%','%'+filtro+'%']                                        
    );
    List<Ventas> list = res.map((c) => Ventas.fromMap(c)).toList();
    return list;
  }

  Future <List<HistorialVenta>> historialRecoleccion(idVenta)async{  
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT HistorialVenta.documento,"
        "HistorialVenta.fechaRecoleccion,"
        "HistorialVenta.numeroCuota,"
        "HistorialVenta.valorCuota,"
        "HistorialVenta.saldo,"
        "HistorialVenta.novedad,"
        "HistorialVenta.usuario "
        "FROM HistorialVenta "
        " WHERE HistorialVenta.idVenta = ? ORDER BY HistorialVenta.fechaRecoleccion DESC ",[idVenta]                                          
    );
    List<HistorialVenta> list = res.map((c) => HistorialVenta.fromMap(c)).toList();
    return list;
  }

  Future<List<ConteoDebe>> clientesVisitar()async{
    // String dia=DateFormat('EEEE, d').format(now);
    // List partirDia=dia.split(",");
    // dia=partirDia[0];
    // var formatterDia =  DateFormat("dd");
    // var formatterAgno =  DateFormat("yyyy");
    // var formatterMes =  DateFormat("MM");
    // String fomatoDia = formatterDia .format(now);
    // String fomatoMes = formatterMes.format(now);
    // String fomatoAgno= formatterAgno  .format(now);
    // int diaAnterior= int.parse(fomatoDia)-1;
    // String diaConsulta=fomatoAgno+fomatoMes+diaAnterior.toString();
    // int resultadoDia=DateTime.parse(diaConsulta).millisecondsSinceEpoch;
    // String dia = format.format((DateTime.fromMillisecondsSinceEpoch(resultadoDia,isUtc:false))).toString();

    //String estado= "debe";
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT count(Cliente.documento) as documentos,"
        "Venta.venta,"
        "sum(Venta.valorCuota) as valorCuotas,"
        "Venta.saldo,"
        "Venta.frecuencia"
        " FROM Cliente "
        " INNER JOIN Venta on Cliente.documento = Venta.documento"
        " WHERE Venta.usuario = ? AND Venta.fechaTexto !=? ",[usuarioGlobal,fechaConsulta]                                        
    );
    List<ConteoDebe> list = res.map((c) => ConteoDebe.fromMap(c)).toList();
    return this._porRecolectar = list;
  }

  Future<List<ConteoDebe>>ventasNuevas()async{
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT count(distinct Cliente.documento) as documentos,"
        "sum(Venta.solicitado) as venta,"
        "sum(Venta.valorCuota) as valorCuotas,"
        "Venta.saldo,"
        "Venta.frecuencia"
        " FROM Cliente "
        " INNER JOIN Venta on Cliente.documento = Venta.documento"
        " WHERE Venta.fechaTexto =? AND Venta.estado !=?",[fechaConsulta,'cancelado']                                        
    );
    List<ConteoDebe> list = res.map((c) => ConteoDebe.fromMap(c)).toList();
    return this._nuevaVenta=list;
  }

  Future<List<ConteoDebe>>clientesNoPago()async{
    _porRecolectar=[];
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT count(distinct Cliente.documento) as documentos,"
        "sum(Venta.solicitado) as venta,"
        "sum(Venta.valorCuota) as valorCuotas,"
        "Venta.saldo,"
        "Venta.frecuencia"
        " FROM Cliente "
        " INNER JOIN Venta on Cliente.documento = Venta.documento"
        " WHERE Venta.estado !=? AND Venta.motivo =?",['cancelado','No pago']                                        
    );
    List<ConteoDebe> list = res.map((c) => ConteoDebe.fromMap(c)).toList();
    return this._porRecolectar=list;
  }

  Future<List<ConteoDebe>> clientesVisitados()async{
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT count(distinct HistorialVenta.documento) as documentos ,"
        "HistorialVenta.numeroCuota,"
        "sum(HistorialVenta.valorCuota) as valorCuotas"
        " FROM HistorialVenta "
        " WHERE HistorialVenta.fecha = ? ",[fechaConsulta]                                        
    );
    List<ConteoDebe> list = res.map((c) => ConteoDebe.fromMap(c)).toList();
    return this._recolectado=list;
  }

  Future<List<ConteoDebe>> recoleccionVentaMismoDia()async{
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT count(DISTINCT HistorialVenta.documento) as documentos ,"
        "HistorialVenta.numeroCuota,"
        "sum(DISTINCT HistorialVenta.valorCuota) as valorCuotas"
        " FROM HistorialVenta "
        " WHERE HistorialVenta.idVenta IN(SELECT idVenta FROM Venta WHERE fechaTexto = ? ) ",[fechaConsulta]                                        
    );
    List<ConteoDebe> list = res.map((c) => ConteoDebe.fromMap(c)).toList();
    return this._recolectadoMismoDia=list;
  }

  obtenerClientesVisitados(){
    return this._recolectado;
  }
  obtenerClientesVisitadosMismoDia(){
    return this._recolectadoMismoDia;
  }

  obtenerclientesVisitar(){
    return this._porRecolectar;
  }

  obtenerNuevasVentas(){
    return this._nuevaVenta;
  }

  insertarAgendamiento(nombre,primerApellido,documento,telefono,solicitado,fechaTexto,bool editar) async{
    String estado ="Bloqueado";
    double valorNeto=double.parse(solicitado);
    var resBloqueo =await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente WHERE documento = ? AND estado = ?",[documento,estado]);
    if(resBloqueo.length>0){
      var mapa = {
        "respuesta":false,
        "motivo":"Cliente bloqueado, por favor cumuniquese con el supervisor"
      };
      return mapa;
    }else{
      var res =await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente WHERE documento = ?",[documento]);
      if(res.length <= 0 && editar==false )
      { 
        final movimiento = Agendamiento(
          nombre:nombre,
          telefono:telefono,
          primerApellido:primerApellido,
          documento:documento,
          fechaTexto:fechaTexto,
          solicitado:valorNeto,
          usuario:usuarioGlobal, 
        );
        await DatabaseProvider.db.addToDatabase(movimiento);
        var mapa = {
          "respuesta": true,
        };
        return mapa; 
      }else if(res.length > 0 && editar==true ){
        final movimiento = Agendamiento(
          nombre:nombre,
          telefono:telefono,
          primerApellido:primerApellido,
          documento:documento,
          fechaTexto:fechaTexto,
          solicitado:valorNeto,
          usuario:usuarioGlobal, 
        );
        await DatabaseProvider.db.addToDatabase(movimiento);
        var mapa = {
          "respuesta": true,
        };
        return mapa; 
      }else{
        var mapa = {
          "respuesta":false,
          "motivo":"Ya existe un cliente con este documento"
        };
        return mapa; 
      }
    }
  }

  insertarVenta(Ventas item,double coutaIngresar,double cantidadCuotas,bool bloqueo, {String clave})async{
    double saldo;
    int diffHours;
    DateTime fechaOrden;
    double numeroCuota;
    double valorIngresar;
    double valorTemporal;
    double nuevoSaldo;
    double cantidadCuota;
    String estadoTemporal;
    String fecha = format.format(now);
    if(clave!='Continuar' && bloqueo == false){
      var consultaClave =await DatabaseProvider.db.rawQuery("SELECT clave FROM Claves WHERE clave = ? AND valor = ?",[clave,coutaIngresar.toString()]);
      if(consultaClave.length <= 0){
        Map repuesta={
          "respuesta":false,
          "mensaje":"Por favor verificar la clave ingresada",
        };
        return repuesta;
      }else{
        await DatabaseProvider.db.rawQuery(
          " DELETE FROM Claves"
          " WHERE clave = ? ",[clave]                                        
        );
      }
    }else if(clave!='Continuar' && bloqueo == true){
      var consultaClave =await DatabaseProvider.db.rawQuery("SELECT clave FROM Claves WHERE clave = ? AND tipo = ?",[clave,'Bloqueado']);
      if(consultaClave.length <= 0){
        Map repuesta={
          "respuesta":false,
          "mensaje":"Por favor verificar la clave ingresada",
        };
        return repuesta;
      }else{
        await DatabaseProvider.db.rawQuery(
          " DELETE FROM Claves"
          " WHERE clave = ? ",[clave]                                        
        );
      }
    }
    var consulta =await DatabaseProvider.db.rawQuery("SELECT estado FROM Venta WHERE documento = ? AND estado = ? OR estado = ?",[item.documento,'debe','Bloqueado']);
    if(bloqueo==false){
      if(consulta.length > 0 )
      {
        var res = await DatabaseProvider.db.rawQuery(
        " SELECT "
          "Venta.venta,"
          "Venta.cuotas,"
          "Venta.fecha,"
          "Venta.fechaPago,"
          "Venta.interes,"
          "Venta.estado,"
          "Venta.numeroCuota,"
          "Venta.valorCuota,"
          "Venta.ruta,"
          "Venta.orden,"
          "Venta.valorTemporal,"
          "Venta.cuotasTemporal,"
          "Venta.saldo"
          " FROM Venta "
          " WHERE Venta.idVenta = ? ",[item.idVenta]                                          
        );
      
        List<Venta> list = res.map((c) => Venta.fromMap(c)).toList();
        numeroCuota=list[0].cuotasTemporal;
        valorIngresar=coutaIngresar;
        cantidadCuota=numeroCuota+cantidadCuotas;
        valorTemporal=list[0].valorTemporal;
        nuevoSaldo =valorTemporal-valorIngresar;
        estadoTemporal=list[0].estado;
        saldo =list[0].saldo;
        fechaOrden= DateTime.fromMillisecondsSinceEpoch(list[0].orden);
        diffHours = now.difference(fechaOrden).inHours;
        if(valorIngresar <= saldo){
          if(diffHours < 14){
            await DatabaseProvider.db.rawQuery(
              " UPDATE Venta SET numeroCuota = ?,"
              "saldo = ?, "
              "motivo = ?,"
              "actualizar = ?,"
              "valorDia = ?,"
              "ruta = ?"
              " WHERE idVenta  = ? ",[cantidadCuota,nuevoSaldo,"abono","si",valorIngresar,"no",item.idVenta]                                      
            );
          }else{
            await DatabaseProvider.db.rawQuery(
              " UPDATE Venta SET numeroCuota = ?,"
              "saldo = ?, "
              "motivo = ?,"
              "orden = ?,"
              "actualizar = ?,"
              "valorDia = ?,"
              "ruta = ?"
              " WHERE idVenta = ? ",[cantidadCuota,nuevoSaldo,"abono",now.millisecondsSinceEpoch,"si",valorIngresar,"no",item.idVenta]                                      
            );
          }
          
          await DatabaseProvider.db.rawQuery(
            "DELETE FROM HistorialVenta WHERE idVenta = ? AND fecha = ?",[item.idVenta,fecha]                                      
          );

          final historial = HistorialVenta(
            idVenta:item.idVenta,
            documento:item.documento,
            fechaRecoleccion:now.millisecondsSinceEpoch,
            fecha:format.format(now),
            numeroCuota:numeroCuota,
            valorCuota: valorIngresar,
            saldo:nuevoSaldo, 
            usuario:usuarioGlobal,
            novedad:"abono" 
          );
          await DatabaseProvider.db.addToDatabase(historial);
          // res = await DatabaseProvider.db.rawQuery(
          //   " SELECT "
          //     "Venta.venta,"
          //     "Venta.cuotas,"
          //     "Venta.fecha,"
          //     "Venta.fechaPago,"
          //     "Venta.interes,"
          //     "Venta.numeroCuota,"
          //     "Venta.valorCuota,"
          //     "Venta.saldo"
          //     " FROM Venta "
          //     " WHERE Venta.idVenta = ? ",[item.idVenta]                        
          // );
          saldo =list[0].saldo-valorIngresar;
          if(saldo == 0){
            await DatabaseProvider.db.rawQuery(
              " UPDATE Venta SET estado = ?, "
                "estadoTemporal =?,"
                "motivo = ?,"
                "actualizar = ?,"
                "ruta = ?,"
                "valorDia = ?,"
                "saldo = ?"
                " WHERE idVenta = ? ",["pago",estadoTemporal,"pago","si","no",valorIngresar,saldo,item.idVenta]                                            
            );

            await DatabaseProvider.db.rawQuery(
              " UPDATE Cliente SET estado = ?"
              " WHERE documento = ? ",["pago",item.documento]                                        
            );
            await DatabaseProvider.db.rawQuery(
              "DELETE FROM HistorialVenta WHERE idVenta = ? AND fecha = ?",[item.idVenta,fecha]                                      
            );

            final historialPago = HistorialVenta(
              idVenta:item.idVenta,
              documento:item.documento,
              fechaRecoleccion:now.millisecondsSinceEpoch,
              fecha:format.format(now),
              numeroCuota:numeroCuota,
              valorCuota: valorIngresar,
              saldo:nuevoSaldo, 
              usuario:usuarioGlobal,
              novedad:"pago" 
            );
            await DatabaseProvider.db.addToDatabase(historialPago);
            
          }
          Map repuesta={
            "respuesta":true,
          };
          return repuesta; 
        }
      }else{
        Map repuesta={
          "respuesta":true,
          "mensaje":"Por favor verificar la información ingresada",
        };
        return repuesta;
      }
    }else{
      await DatabaseProvider.db.rawQuery(    
        " UPDATE Venta SET "
          "estado = ?,"
          "ruta = ?,"
          "actualizar = ?,"
          "orden = ?"
          " WHERE idVenta = ? ",["Bloqueado","no","si",now.millisecondsSinceEpoch,item.idVenta]                                            
      );
      await DatabaseProvider.db.rawQuery(
        " UPDATE Cliente SET estado = ?"
        " WHERE documento = ? ",["Bloqueado",item.documento]                                        
      );
      await DatabaseProvider.db.rawQuery(
        "DELETE FROM HistorialVenta WHERE idVenta = ? AND fecha = ?",[item.idVenta,fecha]                                      
      );
      final ventaBloqueo = HistorialVenta(
        idVenta:item.idVenta,
        documento:item.documento,
        fechaRecoleccion:now.millisecondsSinceEpoch,
        fecha:format.format(now),
        numeroCuota:numeroCuota,
        valorCuota: valorIngresar,
        saldo:saldo, 
        usuario:usuarioGlobal,
        novedad:"Bloqueado" 
      );
      await DatabaseProvider.db.addToDatabase(ventaBloqueo);
      Map repuesta={
        "respuesta":true,
      };
      return repuesta; 
    }
    
  }
  
  reportarMotivo(Ventas item,String novedad)async{
     String fecha = format.format(now);
     DateTime fechaOrden;
     int diffHours;
    // await DatabaseProvider.db.rawQuery(
    //   "UPDATE Venta SET motivo =?,"
    //   "ruta =?,"
    //   "orden = ?,"
    //   "valorTemporal = ?,"
    //   " WHERE documento =? ",[novedad,'no',now.millisecondsSinceEpoch,0,item.documento]                                      
    // );
    await DatabaseProvider.db.rawQuery(
      "DELETE FROM HistorialVenta WHERE idVenta = ? AND fecha = ?",[item.idVenta,fecha]                                      
    );
    var res = await DatabaseProvider.db.rawQuery(
      " SELECT "
      "Venta.venta,"
      "Venta.cuotas,"
      "Venta.fecha,"
      "Venta.fechaPago,"
      "Venta.interes,"
      "Venta.numeroCuota,"
      "Venta.valorCuota,"
      "Venta.ruta,"
      "Venta.valorTemporal,"
      "Venta.cuotasTemporal,"
      "Venta.estadoTemporal,"
      "Venta.orden,"
      "Venta.saldo"
      " FROM Venta "
      " WHERE Venta.idVenta = ? ",[item.idVenta]                                          
    );
    List<Venta> list = res.map((c) => Venta.fromMap(c)).toList();
    double numeroCuota;
    numeroCuota=list[0].cuotasTemporal;
    fechaOrden= DateTime.fromMillisecondsSinceEpoch(list[0].orden);
    diffHours = now.difference(fechaOrden).inHours;
    double nuevoSaldo =list[0].valorTemporal;
    if(diffHours < 14){
      await DatabaseProvider.db.rawQuery(
        "UPDATE Venta SET numeroCuota = ?,"
        "saldo = ?, "
        "motivo = ?,"
        "estado = ?,"
        "actualizar = ?,"
        "ruta = ?"
        " WHERE idVenta = ? ",[numeroCuota,nuevoSaldo,novedad,'debe',"si","no",item.idVenta]                                      
      );
    }else{
      await DatabaseProvider.db.rawQuery(
        "UPDATE Venta SET numeroCuota = ?,"
        "saldo = ?, "
        "motivo = ?,"
        "orden = ?,"
        "estado = ?,"
        "actualizar = ?,"
        "ruta = ?"
        " WHERE idVenta = ? ",[numeroCuota,nuevoSaldo,novedad,now.millisecondsSinceEpoch,'debe',"si","no",item.idVenta]                                      
      );
    }
    // await DatabaseProvider.db.rawQuery(
    //   " UPDATE Cliente SET estado = ?"
    //   " WHERE documento = ? ",['debe',item.documento]                                        
    // );
    final ventaMotivo = HistorialVenta(
      idVenta:item.idVenta,
      documento:item.documento,
      fechaRecoleccion:now.millisecondsSinceEpoch,
      fecha:fecha,
      numeroCuota:0,
      valorCuota: 0,
      saldo:item.saldo, 
      usuario:usuarioGlobal, 
      novedad:novedad,
    );
    await DatabaseProvider.db.addToDatabase(ventaMotivo);
  }
  eliminarGasto(id)async{
    await DatabaseProvider.db.rawQuery(
      "DELETE FROM Gastos WHERE idGasto = ?",[id]                                      
    );
  }
  eliminarVenta(Ventas item)async{
    // if(clave!='Continuar'){
    //   var consultaClave =await DatabaseProvider.db.rawQuery("SELECT clave FROM Claves WHERE clave= ? ",[clave]);
    //   if(consultaClave.length <= 0){
    //     Map repuesta={
    //       "respuesta":false,
    //       "mensaje":"Por favor verificar la clave ingresada",
    //     };
    //     return repuesta;
    //   }
    // }
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM HistorialVenta"
      " WHERE idVenta = ? ",[item.idVenta]                                        
    );

    await DatabaseProvider.db.rawQuery(
      " UPDATE Venta SET estado = ?"
      " WHERE idVenta  = ? ",["cancelado",item.idVenta]                                      
    );
    await DatabaseProvider.db.rawQuery(
      " UPDATE Cliente SET estado = ?"
      " WHERE documento  = ? ",["pago",item.documento]                                      
    );
    // await DatabaseProvider.db.rawQuery(
    //   " DELETE FROM Claves"
    //   " WHERE clave = ? ",[clave]                                        
    // );
    var mapa = {
      "respuesta":this.validacion = true,
      "motivo":"Venta eliminada correctamente"
    };
    return mapa; 
  }
  crearGasto(double valor,String tipo,String observaciones,String idGasto,bool editar)async{
   if(editar){
      await DatabaseProvider.db.rawQuery(
        " UPDATE Gastos SET valor = ?,"
        "tipo = ?,"
        "observaciones = ?"
        " WHERE idGasto = ? ",[valor,tipo,observaciones,idGasto]                                      
      );
   }else{
     var fecha = format.format(now);
      final gasto = Gasto(
        idGasto: now.millisecondsSinceEpoch.toString(),
        fecha: fecha,
        usuario: usuarioGlobal,
        valor: valor,
        tipo: tipo,
        observaciones:observaciones, 
      );
      await DatabaseProvider.db.addToDatabase(gasto);
   }
  }

  asignarDinero(double valor)async{
    final format = DateFormat("yyyy-MM-dd");
    String fecha = format.format(now);
    final gasto = Asignar(
      fecha: fecha,
      usuario: usuarioGlobal,
      valor: valor, 
    );
    await DatabaseProvider.db.addToDatabase(gasto);
  }

  editarAsignarDinero(double valor)async{

    var total=await DatabaseProvider.db.rawQuery(
      " SELECT valor,usuario,fecha FROM Asignacion"
      " WHERE usuario = ? ",[usuarioGlobal]                                            
    );

    List<Asignar> list = total.map((c) => Asignar.fromMap(c)).toList();
    double base=list[0].valor+valor;
    await DatabaseProvider.db.rawQuery(
      " UPDATE Asignacion SET valor = ?"
        " WHERE usuario = ? ",[base,usuarioGlobal]                                            
    );
  }

  restarAsignarDinero(double valor)async{
    var total=await DatabaseProvider.db.rawQuery(
      " SELECT valor FROM Asignacion"
      " WHERE usuario = ? ",[usuarioGlobal]                                            
    );

    List<Asignar> list = total.map((c) => Asignar.fromMap(c)).toList();
    double base=list[0].valor-valor;
    await DatabaseProvider.db.rawQuery(
      " UPDATE Asignacion SET valor = ?"
        " WHERE usuario = ? ",[base,usuarioGlobal]                                            
    );
  }

  asignarDineroInicial()async{
    var fecha = format.format(now);
    //var consultaClave =await DatabaseProvider.db.rawQuery("SELECT valor FROM Asignacion WHERE usuario= ? ",[usuarioGlobal]);
    //List<Asignar> list = consultaClave.map((c) => Asignar.fromMap(c)).toList();
    //double base=list[0].valor;
    //if(base == 0){
      final gasto = Asignar(
        fecha: fecha,
        usuario: usuarioGlobal,
        valor: 0.0, 
      );
      await DatabaseProvider.db.addToDatabase(gasto);
    //}
  }

  Future<List<Asignar>> consultarDineroAsignado()async{
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT sum(Asignacion.valor) as valor"
        " FROM Asignacion "
        " WHERE fecha = ? ",[fechaConsulta]                                        
    );
    List<Asignar> list = res.map((c) => Asignar.fromMap(c)).toList();
    return this._asignado=list;
  }

  Future<List<CajaInicial>> consultarDineroAsignadoInicial()async{
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT sum(CajaInicial.valor) as valor"
        " FROM CajaInicial "
        " WHERE fecha = ? ",[fechaConsulta]                                        
    );
    List<CajaInicial> list = res.map((c) => CajaInicial.fromMap(c)).toList();
    return this._asignadoInicial=list;
  }
  obtenerDineroAsignadoInicial(){
    return this._asignadoInicial;
  }

  Future<List<Gasto>> consultarGasto()async{
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT sum(Gastos.valor) as valor"
      " FROM Gastos "
      " WHERE Gastos.fecha = ? ",[fechaConsulta]                                        
    );
    List<Gasto> list = res.map((c) => Gasto.fromMap(c)).toList();
    return this._gastos=list;
  }

  Future<List<Agendamiento>> consultarAgendado()async{
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT sum(Agendamiento.solicitado) as solicitado"
      " FROM Agendamiento ",[]                                        
    );
    List<Agendamiento> list = res.map((c) => Agendamiento.fromMap(c)).toList();
    return this._agendados=list;
  }
  obtenerAgendado(){
    return this._agendados;
  }
  borrarAgendamiento(documento)async{
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM Agendamiento"
      " WHERE documento = ? ",[documento]                                        
    );
  }
  Future<List<Gasto>> listarGasto()async{
    var fechaConsulta = format.format(now);
    var res =await DatabaseProvider.db.rawQuery(
      " SELECT valor,"
      "idGasto,"
      "fecha,"
      "tipo,"
      "observaciones"
      " FROM Gastos "
      " WHERE Gastos.fecha = ? ",[fechaConsulta]                                        
    );
    List<Gasto> list = res.map((c) => Gasto.fromMap(c)).toList();
    return this._gastos=list;
  }

   obtenerDineroAsignado(){
    return this._asignado;
  }
  
  obtenerGastos(){
    return this._gastos;
  }
  enviarGastos()async{
    var res = await DatabaseProvider.db.rawQuery("SELECT * FROM Gastos",[]);
    for (var registro in res) {
      Map consulta={
        "tipo":registro['tipo'],
        "fecha":registro['fecha'],
        "valor":registro['valor'],
        "usuario":registro['usuario'],
        "observaciones":registro['observaciones'],
      };
       _enviarGastos.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'gastos':_enviarGastos,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/insertarGastos.php',parametro);
  }
  baseConsulta()async{
    _enviarGastos=[];
    final format = DateFormat("yyyy-MM-dd");
    String fecha = format.format(now); 
    List<dynamic> res =await DatabaseProvider.db.rawQuery(
      " SELECT sum(Asignacion.valor) as base,"
      "fecha,"
      "usuario"
      " FROM Asignacion "
      " WHERE fecha = ? ",[fecha]                                        
    );
    for (var registro in res) {
      Map consulta={
        "base":registro['base'],
        "fecha":registro['fecha'],
        "usuario":registro['usuario'],
      };
       _enviarGastos.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'base':_enviarGastos,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    await callMethodOne('/insertarBaseRutaAdmin.php',parametro);
  }
  enviarGastosCopia()async{
    var res = await DatabaseProvider.db.rawQuery("SELECT * FROM CopiaGastos",[]);
    for (var registro in res) {
      Map consulta={
        "tipo":registro['tipo'],
        "fecha":registro['fecha'],
        "valor":registro['valor'],
        "usuario":registro['usuario'],
        "observaciones":registro['observaciones'],
      };
       _enviarGastos.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'gastos':_enviarGastos,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodList('/insertarGastos.php',parametro);
    DatabaseProvider.db.deleteAll(new Gasto());
  }
  enviarClientes({bool actualizar})async{
    var res = await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente",[]);
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "alias":registro["alias"],
        "fecha":registro["fecha"],
        "nombre":registro["nombre"],
        "ciudad":registro["ciudad"],
        "estado":registro["estado"],
        "idVenta":registro["idVenta"],
        "usuario":registro["usuario"],
        "telefono":registro["telefono"],
        "documento":registro["documento"],
        "idCliente":registro["idCliente"], 
        "direccion":registro["direccion"],
        "departamento":registro["departamento"],
        "primerApellido":registro["primerApellido"],
        "segundoApellido":registro["segundoApellido"],
        "actividadEconomica":registro["actividadEconomica"],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'clientes':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    
    var map =await callMethodOne('/insertarClientes.php',parametro);
    return map;
  }

  enviarHistorial({bool actualizar})async{
    var res = await DatabaseProvider.db.rawQuery("SELECT * FROM HistorialVenta",[]);
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "fecha":registro["fecha"],
        "saldo":registro["saldo"],
        "novedad":registro["novedad"],
        "usuario":registro["usuario"],
        "idVenta":registro["idVenta"],
        "documento":registro["documento"],
        "valorCuota":registro["valorCuota"],
        "numeroCuota":registro["numeroCuota"],
        "fechaRecoleccion":registro["fechaRecoleccion"],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'clientes':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/insertarHistorial.php',parametro);
  }

  enviarHistorialCopia({bool actualizar})async{
    var res = await DatabaseProvider.db.rawQuery("SELECT * FROM CopiaHistorialVenta",[]);
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "fecha":registro["fecha"],
        "saldo":registro["saldo"],
        "novedad":registro["novedad"],
        "usuario":registro["usuario"],
        "idVenta":registro["idVenta"],
        "documento":registro["documento"],
        "valorCuota":registro["valorCuota"],
        "numeroCuota":registro["numeroCuota"],
        "fechaRecoleccion":registro["fechaRecoleccion"],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'clientes':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/insertarHistorial.php',parametro);
  }

  enviarClientesCopia({bool actualizar})async{
    var res = await DatabaseProvider.db.rawQuery("SELECT * FROM CopiaCliente",[]);
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "alias":registro["alias"],
        "nombre":registro["nombre"],
        "fecha":registro["fecha"],
        "estado":registro["estado"],
        "ciudad":registro["ciudad"],
        "idVenta":registro["idVenta"],
        "usuario":registro["usuario"],
        "telefono":registro["telefono"],
        "documento":registro["documento"],
        "idCliente":registro["idCliente"], 
        "direccion":registro["direccion"],
        "departamento":registro["departamento"],
        "primerApellido":registro["primerApellido"],
        "segundoApellido":registro["segundoApellido"],
        "actividadEconomica":registro["actividadEconomica"],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'clientes':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/insertarClientes.php',parametro);
  }

  copiaReporteDiario()async{
    var res = await DatabaseProvider.db.rawQuery("SELECT * FROM Produccion",[]);
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        'usuario':usuarioGlobal,
        'fecha':registro['fecha'],
        'hora': registro['hora'], 
        'gasto':registro['gasto'],
        'ventas':registro['ventas'],
        'entrega':registro['entrega'],
        'asignado':registro['asignado'],
        'recolectado':registro['recolectado'],
        'retiro':registro['valorBaseDia']==null?0:registro['valorBaseDia'],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'clientes':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    
    await callMethodOne('/copiaProduccion.php',parametro);
    DatabaseProvider.db.deleteAll(new Clave());
    DatabaseProvider.db.deleteAll(new Departamento());
    DatabaseProvider.db.deleteAll(new Ciudad());
    DatabaseProvider.db.deleteAll(new Venta());
    DatabaseProvider.db.deleteAll(new Cliente());
    DatabaseProvider.db.deleteAll(new Asignar());
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM HistorialVenta"
      " WHERE novedad = ? ",['pago']                                        
    );
  }

  listarClientes()async{
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM Cliente",[]);
    if(respuesta.length == 0){
      List map;
      Map mapa={
        'token':tokenGlobal, 
        'usuario':usuarioGlobal,
        'proyecto':proyectoGlobal
      };
      _enviados=[];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      map=await callMethodList('/listarClientes.php',parametro);
      for (var registro in map) {
        consulta={
          "valor":0.0,
          "alias":registro["alias"],
          "idCliente":registro["id"], 
          "idVenta":registro["idVenta"], 
          "nombre":registro["nombre"],
          "ciudad":registro["ciudad"],
          "estado":registro["estado"],
          "usuario":registro["usuario"],
          "telefono":registro["telefono"],
          "direccion":registro["direccion"],
          "documento":registro["documento"],
          "fecha":int.parse(registro["fecha"])  ,
          "departamento":registro["departamento"],
          "primerApellido":registro["primerApellido"],
          "segundoApellido":registro["segundoApellido"],
          "actividadEconomica":registro["actividadEconomica"],
        };
        var p = Cliente.fromMap(consulta);
        await DatabaseProvider.db.addToDatabase(p);
      }
    }
  }

  enviarVentas({bool actualizar})async{
    var res = await DatabaseProvider.db.rawQuery(
      "SELECT "
      "documento,"
      "idVenta,"
      "venta,"
      "solicitado,"
      "cuotas,"
      "fecha,"
      "fechaTexto ,"
      "fechaPago,"
      "interes,"
      "numeroCuota,"
      "valorCuota,"
      "saldo,"
      "estado,"
      "frecuencia ,"
      "motivo ,"
      "valorTemporal,"
      "cuotasTemporal,"
      "estadoTemporal,"
      "orden,"
      "ruta ,"
      "actualizar,"
      "diaRecoleccion,"
      "day,"
      "cuotaDia,"
      "usuario"
      " FROM Venta GROUP BY documento",[]
    );
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "day":registro["day"],
        "ruta":registro["ruta"],
        "venta":registro["venta"],
        "saldo":registro["saldo"],
        "fecha":registro["fecha"],
        "orden":registro["orden"], 
        "cuotas":registro["cuotas"],
        "motivo":registro["motivo"],
        "estado":registro["estado"],
        "interes":registro["interes"],
        "usuario":registro["usuario"],
        "documento":registro["documento"],
        "solicitado":registro["solicitado"],
        "fechaTexto":registro["fechaTexto"],
        "fechaPago":registro["fechaPago"],
        "numeroCuota":registro["numeroCuota"],
        "valorCuota":registro["valorCuota"],
        "frecuencia":registro["frecuencia"],
        "valorTemporal":registro["saldo"], 
        "cuotasTemporal":registro["cuotasTemporal"],
        "diaRecoleccion":registro["diaRecoleccion"],
        "cuotaDia":registro["cuotaDia"],
        "estadoTemporal":registro["estado"]=='pago'?registro["estado"]:registro["estadoTemporal"]
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'ventas':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/actualizarVenta.php',parametro);
  }

  actualizarVentas()async{
    var res = await DatabaseProvider.db.rawQuery(
      "SELECT "
      "documento,"
      "idVenta,"
      "venta,"
      "solicitado,"
      "cuotas,"
      "fecha,"
      "fechaTexto ,"
      "fechaPago,"
      "interes ,"
      "numeroCuota,"
      "valorCuota,"
      "saldo,"
      "estado ,"
      "frecuencia ,"
      "motivo ,"
      "valorTemporal,"
      "cuotasTemporal,"
      "estadoTemporal ,"
      "orden,"
      "ruta ,"
      "actualizar ,"
      "diaRecoleccion ,"
      "day ,"
      "valorDia,"
      "usuario"
      " FROM Venta",[]
    );
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "day":registro["day"],
        "ruta":registro["ruta"], 
        "orden":registro["orden"], 
        "venta":registro["venta"],
        "fecha":registro["fecha"],
        "saldo":registro["saldo"],
        "cuotas":registro["cuotas"],
        "motivo":registro["motivo"],
        "estado":registro["estado"],
        "idVenta":registro["idVenta"],
        "usuario":registro["usuario"],
        "interes":registro["interes"],
        "documento":registro["documento"],
        "solicitado":registro["solicitado"],
        "fechaTexto":registro["fechaTexto"],
        "fechaPago":registro["fechaPago"],
        "numeroCuota":registro["numeroCuota"],
        "valorCuota":registro["valorCuota"],
        "frecuencia":registro["frecuencia"],
        "valorTemporal":registro["saldo"], 
        "cuotasTemporal":registro["cuotasTemporal"],
        "estadoTemporal":registro["estadoTemporal"],
        "valorDia":registro["valorDia"],
        "diaRecoleccion":registro["diaRecoleccion"],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'ventas':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/actualizarVenta.php',parametro);
  }

  actualizarVentasCierre()async{
    var res = await DatabaseProvider.db.rawQuery(
      "SELECT "
      "documento,"
      "idVenta,"
      "venta,"
      "solicitado,"
      "cuotas,"
      "fecha,"
      "fechaTexto ,"
      "fechaPago,"
      "interes ,"
      "numeroCuota,"
      "valorCuota,"
      "saldo,"
      "estado ,"
      "frecuencia ,"
      "motivo ,"
      "valorTemporal,"
      "cuotasTemporal,"
      "estadoTemporal ,"
      "orden,"
      "ruta ,"
      "actualizar ,"
      "diaRecoleccion ,"
      "day ,"
      "valorDia,"
      "usuario"
      " FROM Venta GROUP BY documento",[]
    );
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "day":registro["day"],
        "ruta":registro["ruta"], 
        "fecha":registro["fecha"],
        "venta":registro["venta"],
        "saldo":registro["saldo"],
        "orden":registro["orden"], 
        "cuotas":registro["cuotas"],
        "estado":registro["estado"],
        "motivo":registro["motivo"],
        "usuario":registro["usuario"],
        "idVenta":registro["idVenta"],
        "interes":registro["interes"],
        "fechaPago":registro["fechaPago"],
        "documento":registro["documento"],
        "solicitado":registro["solicitado"],
        "fechaTexto":registro["fechaTexto"],
        "valorCuota":registro["valorCuota"],
        "numeroCuota":registro["numeroCuota"],
        "frecuencia":registro["frecuencia"],
        "valorTemporal":registro["saldo"], 
        "cuotasTemporal":registro["cuotasTemporal"],
        "estadoTemporal":registro["estadoTemporal"],
        "valorDia":0.0,
        "diaRecoleccion":registro["diaRecoleccion"],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'ventas':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/actualizarVenta.php',parametro);
  }

  actualizarVentasCierreCopia()async{
    var res = await DatabaseProvider.db.rawQuery(
      "SELECT "
      "idVenta,"
      "documento,"
      "venta,"
      "valorDia,"
      "solicitado,"
      "cuotas,"
      "fecha,"
      "fechaTexto,"
      "fechaPago,"
      "interes,"
      "numeroCuota,"
      "valorCuota,"
      "saldo,"
      "estado,"
      "frecuencia,"
      "motivo,"
      "valorTemporal,"
      "cuotasTemporal,"
      "estadoTemporal,"
      "orden,"
      "ruta,"
      "actualizar,"
      "diaRecoleccion,"
      "day,"
      "usuario"
      " FROM CopiaVenta GROUP BY documento",[]
    );
    _enviarClientes=[];
    for (var registro in res) {
      Map consulta={
        "day":registro["day"],
        "ruta":registro["ruta"], 
        "fecha":registro["fecha"],
        "venta":registro["venta"],
        "saldo":registro["saldo"],
        "orden":registro["orden"], 
        "estado":registro["estado"],
        "cuotas":registro["cuotas"],
        "motivo":registro["motivo"],
        "usuario":registro["usuario"],
        "idVenta":registro["idVenta"],
        "interes":registro["interes"],
        "documento":registro["documento"],
        "fechaPago":registro["fechaPago"],
        "solicitado":registro["solicitado"],
        "fechaTexto":registro["fechaTexto"],
        "valorCuota":registro["valorCuota"],
        "frecuencia":registro["frecuencia"],
        "numeroCuota":registro["numeroCuota"],
        "valorTemporal":registro["valorTemporal"], 
        "cuotasTemporal":registro["cuotasTemporal"],
        "estadoTemporal":registro["estadoTemporal"],
        "valorDia":registro["valorDia"],
        "diaRecoleccion":registro["diaRecoleccion"],
      };
       _enviarClientes.add(consulta);
    }
    Map mapa={
      'token':tokenGlobal, 
      'ventas':_enviarClientes,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/actualizarVenta.php',parametro);
  }

  listarVentas()async{
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM Venta",[]);
    if(respuesta.length == 0){
      var fechaConsulta = format.format(now);
      List map;
      Map mapa={
        'token':tokenGlobal, 
        'usuario':usuarioGlobal,
        'fecha':fechaConsulta,
        'proyecto':proyectoGlobal
      };
      _enviados=[];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      map=await callMethodList('/listarVentas.php',parametro);
      for (var registro in map) {
      Map<String, dynamic> consulta={
        "day":registro["day"],
        "estado":registro["estado"],
        "motivo":registro["motivo"],
        "ruta":registro["ruta"]='si',
        "usuario":registro["usuario"],
        "idVenta":registro["idVenta"],
        "interes":registro["interes"],
        "documento":registro["documento"],
        "editado":registro["editado"]='si', 
        "frecuencia":registro["frecuencia"],
        "fechaTexto":registro["fechaTexto"],
        "orden":int.parse(registro["orden"]), 
        "fecha":int.parse(registro["fecha"]),
        "actualizado":registro["editado"]='si', 
        "saldo":double.parse(registro["saldo"]) ,
        "venta":double.parse(registro["venta"])  ,
        "cuotas":double.parse(registro["cuotas"]),
        "estadoTemporal":registro["estadoTemporal"],
        "diaRecoleccion":registro["diaRecoleccion"],
        "fechaPago":int.parse(registro["fechaPago"]),
        "valorTemporal":double.parse(registro["saldo"]), 
        "cuotasTemporal":double.parse(registro["numeroCuota"]),
        "solicitado":double.parse(registro["solicitado"]),
        "valorCuota":double.parse(registro["valorCuota"]) ,
        "numeroCuota":double.parse(registro["numeroCuota"]) ,
        "valorDia":double.parse(registro["valorDia"]) ,
      };
        var p = Venta.fromMap(consulta);
        await DatabaseProvider.db.addToDatabase(p);
      }
    }
  }

  listarHistoricoVentas()async{
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM HistoricoVenta",[]);
    if(respuesta.length == 0){
      List map;
      Map mapa={
        'token':tokenGlobal, 
        'usuario':usuarioGlobal,
        'proyecto':proyectoGlobal
      };
      _enviados=[];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      map=await callMethodList('/historialVenta.php',parametro);
      for (var registro in map) {
      Map<String, dynamic> consulta={
        "day":registro["day"],
        "estado":registro["estado"],
        "motivo":registro["motivo"],
        "ruta":registro["ruta"]='si',
        "usuario":registro["usuario"],
        "idVenta":registro["idVenta"],
        "interes":registro["interes"],
        "documento":registro["documento"],
        "editado":registro["editado"]='si', 
        "frecuencia":registro["frecuencia"],
        "fechaTexto":registro["fechaTexto"],
        "orden":int.parse(registro["orden"]), 
        "fecha":int.parse(registro["fecha"]),
        "actualizado":registro["editado"]='si', 
        "saldo":double.parse(registro["saldo"]) ,
        "venta":double.parse(registro["venta"])  ,
        "cuotas":double.parse(registro["cuotas"]),
        "estadoTemporal":registro["estadoTemporal"],
        "diaRecoleccion":registro["diaRecoleccion"],
        "fechaPago":int.parse(registro["fechaPago"]),
        "valorTemporal":registro["valorTemporal"]=0.0, 
        "cuotasTemporal":registro["cuotasTemporal"]=0.0,
        "solicitado":double.parse(registro["solicitado"]),
        "valorCuota":double.parse(registro["valorCuota"]) ,
        "numeroCuota":double.parse(registro["numeroCuota"]) ,
      };
        var p = HistoricoVenta.fromMap(consulta);
        await DatabaseProvider.db.addToDatabase(p);
      }
    }
  }

  listarHistorial()async{
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM HistorialVenta",[]);
    if(respuesta.length == 0){
      List map;
      Map mapa={
        'token':tokenGlobal, 
        'usuario':usuarioGlobal,
        'proyecto':proyectoGlobal
      };
      _enviados=[];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      map=await callMethodList('/listarHistorialVentas.php',parametro);
      for (var registro in map) {
      Map<String, dynamic> consulta={
        "fecha":registro["fecha"],
        "idVenta":registro["idVenta"],
        "novedad":registro["novedad"],
        "usuario":registro["usuario"],
        "documento":registro["documento"],
        "saldo":double.parse(registro["saldo"]) ,
        "valorCuota":double.parse(registro["valorCuota"]) ,
        "numeroCuota":double.parse(registro["numeroCuota"]) ,
        "fechaRecoleccion":int.parse(registro["fechaRecoleccion"]),
      };
        var p = HistorialVenta.fromMap(consulta);
        await DatabaseProvider.db.addToDatabase(p);
      }
    }
  }

  Future <List<RutaAdmin>>descargarRuta(usuario,filtro)async{
    var fechaConsulta = format.format(now);
    _rutaAdmin=[];
    List map;
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuario,
      'fecha':fechaConsulta,
      'filtro':filtro,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    map = await callMethodList('/listarRuta.php',parametro);
    List<RutaAdmin> ruta=[];
    for ( var usuario in map)
    {
      ruta.add(RutaAdmin.fromJson(usuario));
    }
    return this._rutaAdmin= ruta;
  }

  Future <List<RutaAdmin>>descargarRutaNoPago(usuario)async{
    _rutaAdmin=[];
    List map;
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuario,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    map = await callMethodList('/listarRutaNoPago.php',parametro);
    List<RutaAdmin> ruta=[];
    for ( var usuario in map)
    {
      ruta.add(RutaAdmin.fromJson(usuario));
    }
    return this._rutaAdmin= ruta;
  }

  Future <List<RutaAdminTotal>>descargarTotalRuta(fechaInicial,fechaFinal,usuario)async{
    List map;
    Map mapa={
      'token':tokenGlobal, 
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    map = await callMethodList('/totalBaseActualizada.php',parametro);
    List<RutaAdminTotal> ruta=[];
    for ( var usuario in map)
    {
      ruta.add(RutaAdminTotal.fromJson(usuario));
    }
    return this._totalRutaAdmin= ruta;
  }

  obtenerTotalRuta(){
    return this._totalRutaAdmin;
  }
  obtenerRuta(){
    return this._rutaAdmin;
  }

  listarCiudad()async{
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM Ciudad",[]);
    if(respuesta.length == 0){
      List map;
      Map mapa={
        'token':tokenGlobal, 
      };
      _enviados=[];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      map=await callMethodList('/listarCiudades.php',parametro);
      for (var registro in map) {
        consulta={
          "id":registro["id"].toString(), 
          "nombre":registro["nombre"],
          "departamento":registro["departamento"],
        };
        var p = Ciudad.fromMap(consulta);
        await DatabaseProvider.db.addToDatabase(p);
      }
    }
  }
  listarCiudadWeb()async{
    List<Ciudad> list=[];
    Map mapa={
      'token':tokenGlobal, 
    };
    _enviados=[];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map=await callMethodList('/listarCiudades.php',parametro);
   
      for ( var ciudad in map)
      {
        list.add(Ciudad.fromMap(ciudad));
      }
    
    return this._ciudades=list;
  }

  obtenerCiudadesWeb(){
    return this._ciudades;
  }
  listarDepartamento()async{
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM Departamento",[]);
    if(respuesta.length == 0){
      List map;
      Map mapa={
        'token':tokenGlobal, 
      };
      _enviados=[];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      map=await callMethodList('/listarDepartamentos.php',parametro);
      for (var registro in map) {
        consulta={
          "id":registro["id"].toString(), 
          "nombre":registro["nombre"],
        };
        var p = Departamento.fromMap(consulta);
        await DatabaseProvider.db.addToDatabase(p);
      }
    }
  }

  generarClaves(String claves,String usuario,String tipo,String valor)async{
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuario,
      'claves':claves,
      'tipo':tipo,
      'valor':valor
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodOne('/crearClaves.php',parametro);
  }

  listarClaves()async{
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM Claves",[]);
    if(respuesta.length == 0){
      Map mapa={
        'token':tokenGlobal, 
        'usuario':usuarioGlobal
      };
      _enviados= [];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      var map = await callMethodList('/listarClaves.php',parametro);
      if(Platform.isAndroid){
        DatabaseProvider.db.deleteAll(new Clave());
        for (var registro in map) {
          consulta={ 
            "clave":registro["clave"].toString(),
            "tipo":registro["tipo"].toString(),
            "usuario":registro["usuario"].toString(),
            "valor":registro["valor"].toString(),
          };
          var p = Clave.fromMap(consulta);
          await DatabaseProvider.db.addToDatabase(p);
        }
      }
    }
  }

  Future<List<Clave>>listarClavesAdmin()async{
    this._claves=[];
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuarioGlobal
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map = await callMethodList('/listarClavesAdmin.php',parametro);
    List<Clave> clave=[];
    for ( var usuario in map)
    {
      clave.add(Clave.fromMap(usuario));
    }
    return this._claves= clave;
  }

  Future<List<Proyecto>>listarProyectos()async{
    this._proyectos=[];
    Map mapa={
      'token':tokenGlobal,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map = await callMethodList('/listarProyectos.php',parametro);
    List<Proyecto> clave=[];
    for ( var usuario in map)
    {
      clave.add(Proyecto.fromJson(usuario));
    }
    return this._proyectos = clave;
  }
  obtenerProyectos(){
   return this._proyectos;
  }
  listarClavesUsuario()async{
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuarioGlobal
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map = await callMethodList('/listarClaves.php',parametro);
    if(Platform.isAndroid){
      DatabaseProvider.db.deleteAll(new Clave());
      for (var registro in map) {
        consulta={ 
          "clave":registro["clave"].toString(),
          "tipo":registro["tipo"].toString(),
          "usuario":registro["usuario"].toString(),
          "valor":registro["valor"].toString(),
        };
        var p = Clave.fromMap(consulta);
        await DatabaseProvider.db.addToDatabase(p);
      }
    }
  }
  Future<List<Clave>> consultarListaClaves() async {
    List<Clave> list=[];
    List res =await DatabaseProvider.db.rawQuery("SELECT * FROM Claves",[]);
    list = res.map((c) => Clave.fromMap(c)).toList();
    return this._claves=list;
  }
  Future<List<Clave>> consultarClaves()async{
    List<Clave> list=[];
    if(Platform.isAndroid){
      var res =await DatabaseProvider.db.rawQuery(
        " SELECT clave"
        " FROM Claves ",[]                                        
      );
      list = res.map((c) => Clave.fromMap(c)).toList();
      
    }else{
      Map mapa={
        'token':tokenGlobal, 
      };
      _enviados= [];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      var map = await callMethodList('/listarClaves.php',parametro);
      for ( var clave in map)
      {
        list.add(Clave.fromMap(clave));
      }
    }
    return this._claves=list;
  }

  obtenerClaves(){
    return this._claves;
  }

  crearUsuario(usuario,contrasena,nombre,direccion,telefono,proyecto)async{
    var fecha = format.format(now);
    Map mapa={
      'usuario':usuario,
      'contrasena':contrasena,
      'nombre':nombre,
      'direccion':direccion,
      'telefono':telefono,
      'fecha':fecha,
      'proyecto':proyecto,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    if(_enviados.length > 0)
    {
      await callMethodOne('/crearUsuario.php',parametro);
    }else{
      return "Vacio";
    }
  }

  editarUsuario(id,usuario,contrasena,nombre,direccion,telefono,estado,proyecto)async{
    Map mapa={
      'id':id,
      'usuario':usuario,
      'contrasena':contrasena,
      'nombre':nombre,
      'direccion':direccion,
      'telefono':telefono,
      'estado':estado,
      'proyecto':proyecto
    };
    _enviados= [];
    _enviados.add(mapa);
    
    Map parametro={
      "lista":_enviados
    };
    if(_enviados.length > 0)
    {
      await callMethodOne('/editarUsuario.php',parametro);
    }else{
       return "Vacio";
    }
  }

  Future <List<Usuario>>descargarUsuarios()async{
    List map;
    this._usuarios=[];
    Map mapa={
      'token':tokenGlobal,
      'proyecto':proyectoGlobal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    map = await callMethodList('/listarUsuarios.php',parametro);
    List<Usuario> usuarios=[];
    for ( var usuario in map)
    {
      usuarios.add(Usuario.fromJson(usuario));
    }
    return this._usuarios= usuarios;
  }

  Future <List<UsuarioAdmin>>descargarAdministrador()async{
    List map;
    this._usuarios=[];
    Map mapa={
      'token':tokenGlobal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    map = await callMethodList('/listarAdministrdor.php',parametro);
    List<UsuarioAdmin> usuarios=[];
    for ( var usuario in map)
    {
      usuarios.add(UsuarioAdmin.fromJson(usuario));
    }
    return this._usuarios= usuarios;
  }

  crearProyecto(admin,proyecto)async{
    var fecha = format.format(now);
    Map mapa={
      'token':tokenGlobal,
      'usuario':usuarioGlobal,
      'administrador':admin,
      'proyecto':proyecto,
      'fecha':fecha,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map=await callMethodOne('/crearProyecto.php',parametro);
    return map;

  }

  Future <List<Control>>listarControlPrestamo(filtro)async{
    _listarCaja=[];
    Map mapa={
      'token':tokenGlobal,
      'filtro':filtro
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarControlPrestamo.php',parametro);
    _controlPrestamo=[];
    List<Control> listarCaja=[];
    for ( var prod in map)
    {
      if (double.parse(prod['maximo']) > double.parse(prod['promedio'])){
        listarCaja.add(Control.fromJson(prod));
      }
    }
    return this._controlPrestamo= listarCaja;
  }

  obtenerControlPrestamo(){
    return this._controlPrestamo;
  }

  obtenerUsuarios(){
    return this._usuarios;
  }

  obtenerLogin(){
    return this._login;
  }

  crearRol(rol,descripcion)async{
    Map mapa={
      'nombre':rol,
      'descripcion':descripcion, 
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    if(_enviados.length > 0)
    {
      await callMethodOne('/crearRol.php',parametro);
    }else{
       return "Vacio";
    }
  }

  login(usuario,contrasena)async{

    Map mapa={
      'usuario':usuario,
      'contrasena':contrasena, 
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    if(_enviados.length > 0)
    {
      var map = await callMethodList('/login.php',parametro);
      return map;
    }else{
       return "Vacio";
    }
  }

  activarUsuario(usuario)async{
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuario,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodList('/activarUsuario.php',parametro);
  }
  inActivarUsuario(usuario)async{
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuario,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodList('/inactivarUsuario.php',parametro);
  }
  Future <List<Objeto>>descargarObjetosAsignados(rol,token)async{
    Map mapa={
      'rol':rol,
      'token':token, 
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map = await callMethodList('/objetosAsignados.php',parametro);
    List<Objeto> objetos=[];
    for ( var objeto in map)
    {
      objetos.add(Objeto.fromJson(objeto));
    }
    return this._objetos= objetos;
  }

  obtenerAsignados(){
    return this._objetos;
  }

  Future <List<Objeto>>descargarObjetosNoAsignados(rol,token)async{
    Map mapa={
      'rol':rol,
      'token':token, 
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map = await callMethodList('/objetosNoAsignados.php',parametro);
    List<Objeto> objetos=[];
    for ( var objeto in map)
    {
      objetos.add(Objeto.fromJson(objeto));
    }
    return this._noObjetos= objetos;
  }

  asignarObjeto(rol,token,objetos)async{
    Map mapa={
      'rol':rol,
      'token':token, 
      'objetos':objetos,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodList('/asignarObjetos.php',parametro);
  }

  removerObjeto(rol,token,objetos)async{
    Map mapa={
      'rol':rol,
      'token':token, 
      'objetos':objetos,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodList('/removerObjetos.php',parametro);
  }


  obtenerNoAsignados(){
    return this._noObjetos;
  }

  Future <List<Rol>>descargarRolesAsignados(usuario)async{
    Map mapa={
      'usuario':usuario,
      'token':tokenGlobal, 
    };
    _enviados = [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map = await callMethodList('/rolesAsignados.php',parametro);
    List<Rol> roles=[];
    for ( var rol in map)
    {
      roles.add(Rol.fromJson(rol));
    }
    return this._roles= roles;
  }

  Future <List<Rol>>descargarRolesNoAsignados(usuario,token)async{
    Map mapa={
      'usuario':usuario,
      'token':token, 
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    var map = await callMethodList('/rolesNoAsignados.php',parametro);
    List<Rol> roles=[];
    for ( var objeto in map)
    {
      roles.add(Rol.fromJson(objeto));
    }
    return this._noRoles= roles;
  }

  asignarRol(roles,token,usuario)async{
    Map mapa={
      'roles':roles,
      'token':token, 
      'usuario':usuario,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodList('/asignarRoles.php',parametro);
  }

  removerRol(roles,token,usuario)async{
    Map mapa={
      'roles':roles,
      'token':token, 
      'usuario':usuario,
    };
    _enviados= [];
    _enviados.add(mapa);
    Map parametro={
      "lista":_enviados
    };
    await callMethodList('/removerRol.php',parametro);
  }

  obtenerRolesAsignados(){
    return this._roles;
  }

  obtenerRolesNoAsignados(){
    return this._noRoles;
  }

  objetosUsuario(token,usuario)async{
    Map mapa={
      'token':token, 
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethod('/objetosUsuario.php',parametro);
    this._objetosSeguridad = map;
  }

  obtnerObjetos(){
    return this._objetosSeguridad;
  }

  reporteDiario(recolectado,gasto,ventas,asignado,entrega,valorBaseDia)async{
    final format = DateFormat("yyyy-MM-dd");
    var outputFormat = DateFormat('hh:mm a');
    var fecha = format.format(now);
    var hora = outputFormat.format(now);
    copiaVentas();
    copiaCliente();
    copiaGasto();
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM Produccion",[]                                        
    );
    final movimiento = Produccion(
      id: hora,
      hora: hora,
      fecha:fecha ,
      gasto:double.parse(gasto),
      retiro: double.parse(valorBaseDia),
      ventas: double.parse(ventas),
      usuario:usuarioGlobal, 
      entrega:double.parse(entrega) ,
      asignado: double.parse(asignado),
      recolectado: double.parse(recolectado),
    );
    await DatabaseProvider.db.addToDatabase(movimiento);
    Map mapa={
      'fecha':fecha,
      'hora': hora,
      'token':tokenGlobal, 
      'recolectado':recolectado,
      'gasto':gasto,
      'ventas':ventas,
      'usuario':usuarioGlobal,
      'asignado':asignado,
      'entrega':entrega,
      'retiro':valorBaseDia,
    };
     _enviarProduccion.add(mapa);

    Map parametro={
      "lista":_enviarProduccion
    };
    await callMethodOne('/produccion.php',parametro);
    DatabaseProvider.db.deleteAll(new Clave());
    DatabaseProvider.db.deleteAll(new Ciudad());
    DatabaseProvider.db.deleteAll(new Venta());
    DatabaseProvider.db.deleteAll(new Cliente());
    DatabaseProvider.db.deleteAll(new Asignar());
    DatabaseProvider.db.deleteAll(new HistorialVenta());
    DatabaseProvider.db.deleteAll(new Departamento());
    DatabaseProvider.db.deleteAll(new HistoricoVenta());
    DatabaseProvider.db.deleteAll(new CajaInicial());
    await DatabaseProvider.db.rawQuery(
      " DELETE FROM HistorialVenta"
      " WHERE novedad = ? ",['pago']                                        
    );
    return true;
  }

  reporteDiarioAdmin(recolectado,gasto,ventas,asignado,entrega,valorBaseDia,usuario)async{
    final format = DateFormat("yyyy-MM-dd");
    var outputFormat = DateFormat('hh:mm a');
    var fecha = format.format(now);
    var hora = outputFormat.format(now);
    Map mapa={
      'fecha':fecha,
      'hora': hora,
      'token':tokenGlobal, 
      'recolectado':recolectado,
      'gasto':gasto,
      'ventas':ventas,
      'usuario':usuario,
      'asignado':asignado,
      'entrega':entrega,
      'retiro':'0',
    };
     _enviarProduccion.add(mapa);

    Map parametro={
      "lista":_enviarProduccion
    };
    await callMethodOne('/produccion.php',parametro);
  }

  borrarTablas()async{
    DatabaseProvider.db.deleteAll(new Clave());
    DatabaseProvider.db.deleteAll(new Ciudad());
    DatabaseProvider.db.deleteAll(new Venta());
    DatabaseProvider.db.deleteAll(new Cliente());
    DatabaseProvider.db.deleteAll(new Asignar());
    DatabaseProvider.db.deleteAll(new HistorialVenta());
    DatabaseProvider.db.deleteAll(new Departamento());
    DatabaseProvider.db.deleteAll(new HistoricoVenta());
    DatabaseProvider.db.deleteAll(new CajaInicial());
    return true;
  }

  baseSiguiente(double  base)async{
    if(base > 0){
      
      final format = DateFormat("yyyy-MM-dd");
      var newDate = new DateTime(now.year, now.month, now.day+1);
      var fecha = format.format(newDate);
      
      Map mapa={
        'token':tokenGlobal, 
        'fecha':fecha,
        'base':base,
        'usuario':usuarioGlobal,
      };
      _parametrosEnviados=[];
      _parametrosEnviados.add(mapa);

      Map parametro={
        "lista":_parametrosEnviados
      };
      await callMethodOne('/insertarBase.php',parametro);
    }
  }

  baseSiguienteAdmin(double  base,usuario)async{
    if(base > 0){
      
      final format = DateFormat("yyyy-MM-dd");
      var newDate = new DateTime(now.year, now.month, now.day+1);
      var fecha = format.format(newDate);
      
      Map mapa={
        'token':tokenGlobal, 
        'fecha':fecha,
        'base':base,
        'usuario':usuario,
      };
      _parametrosEnviados=[];
      _parametrosEnviados.add(mapa);

      Map parametro={
        "lista":_parametrosEnviados
      };
      await callMethodOne('/insertarBase.php',parametro);
    }
  }
  
  copiaBaseSiguiente(double  base)async{
    if(base > 0){
      
      final format = DateFormat("yyyy-MM-dd");
      var newDate = new DateTime(now.year, now.month, now.day);
      var fecha = format.format(newDate);
      
      Map mapa={
        'token':tokenGlobal, 
        'fecha':fecha,
        'base':base,
        'usuario':usuarioGlobal,
      };
      _parametrosEnviados=[];
      _parametrosEnviados.add(mapa);

      Map parametro={
        "lista":_parametrosEnviados
      };
      await callMethodOne('/insertarBase.php',parametro);
    }
  }
  listarBase()async{
    final format = DateFormat("yyyy-MM-dd");
    var respuesta =await DatabaseProvider.db.rawQuery("SELECT * FROM Asignacion",[]);
    List<Asignar> list = respuesta.map((c) => Asignar.fromMap(c)).toList();
    if(list.length < 1){
      DatabaseProvider.db.deleteAll(new Asignar());
      List map;
      var fecha = format.format(now); 
      Map mapa={
        'token':tokenGlobal, 
        'usuario':usuarioGlobal,
        'fecha':fecha,
      };
      _enviados=[];
      _enviados.add(mapa);
      Map parametro={
        "lista":_enviados
      };
      map=await callMethodList('/listarBase.php',parametro);
      if(map.length >0){
        for (var registro in map) {
          Map<String, dynamic> consulta={
            "fecha":registro["fecha"],
            "valor":double.parse(registro["base"]) ,
            "usuario":registro["usuario"],
          };
          var p = Asignar.fromMap(consulta);
          var a = CajaInicial.fromMap(consulta);
          await DatabaseProvider.db.addToDatabase(p);
          await DatabaseProvider.db.addToDatabase(a);
        }
      }else{
        asignarDineroInicial();
      }
    }
  }
  
  Future <List<ReporteDiario>>descargarProduccion(fechaInicial,fechaFinal,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarProduccion.php',parametro);
    List<ReporteDiario> produccion=[];
    for ( var prod in map)
    {
      produccion.add(ReporteDiario.fromJson(prod));
    }
    return this._produccion= produccion;
  }

  Future <List<ReporteDiario>>descargarProduccionTodos(fechaInicial,fechaFinal)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarProduccionTodos.php',parametro);
    List<ReporteDiario> produccion=[];
    for ( var prod in map)
    {
      produccion.add(ReporteDiario.fromJson(prod));
    }
    return this._produccion= produccion;
  }

  Future <List<ReporteGasto>>descargarGastos(fechaInicial,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fecha':fechaInicial,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarGastos.php',parametro);
    List<ReporteGasto> reporteGasto=[];
    for ( var prod in map)
    {
      reporteGasto.add(ReporteGasto.fromJson(prod));
    }
    return this._reporteGasto = reporteGasto;
  }
  Future <List<ReporteGasto>>gastosRutaAdmin(usuario)async{
    String fechaConsulta = format.format(now);
    this._reporteGasto=[];
    Map mapa={
      'token':tokenGlobal,
      'fecha':fechaConsulta,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarSumaGasto.php',parametro);
    List<ReporteGasto> reporteGasto=[];
    for ( var prod in map)
    {
      reporteGasto.add(ReporteGasto.fromJson(prod));
    }
    return this._reporteGasto = reporteGasto;
  }
  enviarBaseRuta(String usuarioRuta,double valor, bool editar,{String fechaEditar,String idBase,String fecha})async{
    Map mapa;
    _enviarBaseRuta=[];
    if(editar){
      mapa={
        'fecha':editar?fechaEditar:fecha,
        'token':tokenGlobal, 
        'usuario':usuarioGlobal,
        'base_ruta':valor,
        'usuario_ruta':usuarioRuta,
        'idBase':idBase,
        'momento':now.millisecondsSinceEpoch.toString(),
      };
    }else{
      mapa={
        'fecha':editar?fechaEditar:fecha,
        'token':tokenGlobal, 
        'usuario':usuarioGlobal,
        'base_ruta':valor,
        'usuario_ruta':usuarioRuta,
      };
    }
     _enviarBaseRuta.add(mapa);

    Map parametro={
      "lista":_enviarBaseRuta
    };
    if(editar){
      await callMethodOne('/editarBaseRuta.php',parametro);
    }else{
      await callMethodOne('/asignarBaseRuta.php',parametro);
    }
    
    
  }
  Future <List<ListarCaja>>listarCaja(fechaInicial,fechaFinal)async{
    _listarCaja=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarCaja.php',parametro);
    List<ListarCaja> listarCaja=[];
    for ( var prod in map)
    {
      listarCaja.add(ListarCaja.fromJson(prod));
    }
    return this._listarCaja= listarCaja;
  }
  
  Future <List<ListarCaja>>listarCajaGeneralRuta(fechaInicial,fechaFinal)async{
    _listarCaja=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarCajaGeneralRuta.php',parametro);
    List<ListarCaja> listarCaja=[];
    for ( var prod in map)
    {
      listarCaja.add(ListarCaja.fromJson(prod));
    }
    return this._listarCaja= listarCaja;
  }

  Future <List<ListarCaja>>listarCajaUsuario(fechaInicial,fechaFinal,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarCajaUsuario.php',parametro);
    List<ListarCaja> listarCaja=[];
    for ( var prod in map)
    {
      listarCaja.add(ListarCaja.fromJson(prod));
    }
    return this._listarCaja= listarCaja;
  }

  Future <List<ListarCaja>>totalCajaGeneral()async{
    _listarCaja=[];
    Map mapa={
      'token':tokenGlobal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarTotalGeneral.php',parametro);
    List<ListarCaja> listarCaja=[];
    for ( var prod in map)
    {
      listarCaja.add(ListarCaja.fromJson(prod));
    }
    return this._listarCaja= listarCaja;
  }


  Future <List<CuadreSemana>>listarCierreSemanal(fechaInicial,fechaFinal,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
      'administrador':usuarioGlobal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/cierreSemanal.php',parametro);
    List<CuadreSemana> listarCaja=[];
    for ( var prod in map)
    {
      listarCaja.add(CuadreSemana.fromJson(prod));
    }
    return this._listarCuadreSemana= listarCaja;
  }

  List<CuadreSemana>obtenerCierreSemanal(){
    return this._listarCuadreSemana;
  }

//   SELECT  a.`usuario`, a.`fecha`, a.`asignado`,b.baseRuta
// FROM `produccion` as a 
// LEFT JOIN base_ruta as b on a.usuario=b.usuario AND a.fecha = b.fecha
// WHERE a.usuario='eramirez' AND a.fecha='2022-03-18'
  
  crearCuadreSemanal(String usuarioRuta,double entrada,double salida)async{
    final format = DateFormat("yyyy-MM-dd");
    var fecha = format.format(now);
    _enviarBaseRuta=[];
    Map mapa={
      'token':tokenGlobal, 
      'usuario':usuarioGlobal,
      'entrada':entrada,
      'salida':salida,
      'usuario_ruta':usuarioRuta,
      'fecha':fecha,
    };
     _enviarBaseRuta.add(mapa);

    Map parametro={
      "lista":_enviarBaseRuta
    };
    await callMethodOne('/crearCierreSemanal.php',parametro);
  }

  salidaBasePrincipal(double valor,String fecha, String ruta)async{
    _enviarBaseRuta=[];
    Map mapa={
      'fecha':fecha,
      'token':tokenGlobal, 
      'usuario':usuarioGlobal,
      'baseRuta':valor,
      'ruta':ruta,
    };
     _enviarBaseRuta.add(mapa);

    Map parametro={
      "lista":_enviarBaseRuta
    };
    await callMethodOne('/salidaBasePrincipal.php',parametro);
    
  }

  ingresoBasePrincipal(double valor,tipo)async{
    _enviarBaseRuta=[];
    final format = DateFormat("yyyy-MM-dd");
    var fecha = format.format(now);
    Map mapa={
      'fecha':fecha,
      'token':tokenGlobal, 
      'usuario':usuarioGlobal,
      'ingreso':valor,
      'tipo':tipo,
    };
     _enviarBaseRuta.add(mapa);

    Map parametro={
      "lista":_enviarBaseRuta
    };
    await callMethodOne('/ingresoBase.php',parametro);
    
  }

  retiroBasePrincipal(double valor,tipo)async{
    _enviarBaseRuta=[];
    final format = DateFormat("yyyy-MM-dd");
    var fecha = format.format(now);
    Map mapa={
      'fecha':fecha,
      'token':tokenGlobal, 
      'usuario':usuarioGlobal,
      'retiro':valor,
      'tipo':tipo
    };
     _enviarBaseRuta.add(mapa);

    Map parametro={
      "lista":_enviarBaseRuta
    };
    await callMethodOne('/retiroBase.php',parametro);
    
  }

  Future <List<ListarCaja>>listarTotalCajaUsuario(fechaInicial,fechaFinal,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarTotalCajaGeneralUsuario.php',parametro);
    List<ListarCaja> listarTotalCaja=[];
    for ( var prod in map)
    {
      listarTotalCaja.add(ListarCaja.fromJson(prod));
    }
    return this._totalCaja= listarTotalCaja;
  }

  Future <List<ListarCaja>>listarTotalCaja(fechaInicial,fechaFinal)async{
    _totalCaja=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarTotalCajaGeneral.php',parametro);
    List<ListarCaja> listarTotalCaja=[];
    for ( var prod in map)
    {
      listarTotalCaja.add(ListarCaja.fromJson(prod));
    }
    return this._totalCaja= listarTotalCaja;
  }

  Future <List<ListarCaja>>listarTotalCajaGeneral(fechaInicial,fechaFinal)async{
    _totalCaja=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/totalCajaGeneral.php',parametro);
    List<ListarCaja> listarTotalCaja=[];
    for ( var prod in map)
    {
      listarTotalCaja.add(ListarCaja.fromJson(prod));
    }
    return this._totalCaja= listarTotalCaja;
  }


  List<ListarCaja>obtnerListarCaja(){
    return this._listarCaja;
  }
  obtnerTotalCaja(){
    return this._totalCaja;
  }
  Future <List<ReporteDiario>>descargarTotalProduccion(fechaInicial,fechaFinal,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarTotalProduccion.php',parametro);
    List<ReporteDiario> totalProduccion=[];
    for ( var prod in map)
    {
      totalProduccion.add(ReporteDiario.fromJson(prod));
    }
    return this._totalProduccion= totalProduccion;
  }

  Future <List<ReporteDiario>>descargarTotalProduccionTodos(fechaInicial,fechaFinal)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarTotalProduccionTodos.php',parametro);
    List<ReporteDiario> totalProduccion=[];
    for ( var prod in map)
    {
      totalProduccion.add(ReporteDiario.fromJson(prod));
    }
    return this._totalProduccion= totalProduccion;
  }

  Future <List<TotalBloqueados>>descargarTotalBloqueados(fechaInicial,fechaFinal,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarTotalBloqueados.php',parametro);
    List<TotalBloqueados> totalProduccion=[];
    for ( var prod in map)
    {
      totalProduccion.add(TotalBloqueados.fromMap(prod));
    }
    return this._totalBloqueado= totalProduccion;
  }
  obtenerTotalBloqueados(){
    return this._totalBloqueado;
  }
   Future<List<ConteoDebeAdmin>> clientesVisitarAdmin(usuario)async{
    var fechaConsulta = format.format(now);
    _porRecolectarAdmin=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaConsulta,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/totalClientesPorVisitarUsuario.php',parametro);
    List<ConteoDebeAdmin> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(ConteoDebeAdmin.fromMap(prod));
    }
    return this._porRecolectarAdmin= totalProduccionAdmin;
  }
  Future<List<Cartera>> listarCartera(usuario)async{
    _cartera=[];
    Map mapa={
      'token':tokenGlobal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarCartera.php',parametro);
    List<Cartera> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(Cartera.fromMap(prod));
    }
    return this._cartera= totalProduccionAdmin;
  }

  Future<List<Cartera>> listarCarteraFechas(fechaIni,fechaFin,usuario)async{
    _cartera=[];
    Map mapa={
      'token':tokenGlobal,
      'usuario':usuario,
      'fechaInicial':fechaIni,
      'fechaFinal':fechaFin
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/totalCarteraFechas.php',parametro);
    List<Cartera> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(Cartera.fromMap(prod));
    }
    return this._cartera= totalProduccionAdmin;
  }

  Future<List<Cartera>> listarNoPago(usuario)async{
    _cartera=[];
    Map mapa={
      'token':tokenGlobal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarNoPago.php',parametro);
    List<Cartera> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(Cartera.fromMap(prod));
    }
    return this._cartera= totalProduccionAdmin;
  }

   Future<List<ConteoDebeAdmin>> valoresRecolectadosAdmin(fechaInicial,fechaFinal,usuario)async{
    String fechaConsulta = format.format(now);
    _recolectadosAdmin=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaTexto':fechaConsulta,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/totalClientesVisitadosUsuario.php',parametro);
    List<ConteoDebeAdmin> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(ConteoDebeAdmin.fromMap(prod));
    }
    return this._recolectadosAdmin= totalProduccionAdmin;
  }

  Future<List<ConteoDebeAdmin>> consultarBaseAdmin(fechaInicial,fechaFinal,usuario)async{
    var fechaConsulta = format.format(now);
    _recolectadosAdmin=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaTexto':fechaConsulta,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/totalClientesVisitadosUsuario.php',parametro);
    List<ConteoDebeAdmin> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(ConteoDebeAdmin.fromMap(prod));
    }
    return this._recolectadosAdmin= totalProduccionAdmin;
  }

  Future<List<ConteoDebeAdmin>> totalValoresVentasAdmin()async{
    var fechaConsulta = format.format(now);
    _recolectadosAdmin=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaTexto':fechaConsulta,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/totalVentaHoy.php',parametro);
    List<ConteoDebeAdmin> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(ConteoDebeAdmin.fromMap(prod));
    }
    return this._ventasHoyGeneral= totalProduccionAdmin;
  }

  Future<List<AsignarAdmin>> dineroAsignadoAdmin(usuario)async{
    var fechaConsulta = format.format(now);
    _recolectadosAdmin=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaTexto':fechaConsulta,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarBaseRutaAdmin.php',parametro);
    List<AsignarAdmin> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(AsignarAdmin.fromMap(prod));
    }
    return this._asignadoAdmin= totalProduccionAdmin;
  }


  Future<List<ConteoDebeAdmin>> valoresVentasHoyUsuarioAdmin(usuario)async{
    var fechaConsulta = format.format(now);
    _ventasHoyGeneral=[];
    Map mapa={
      'token':tokenGlobal,
      'fechaTexto':fechaConsulta,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/totalVentasHoyUsuario.php',parametro);
    List<ConteoDebeAdmin> totalProduccionAdmin=[];
    for ( var prod in map)
    {
      totalProduccionAdmin.add(ConteoDebeAdmin.fromMap(prod));
    }
    return this._ventasHoyUsuario= totalProduccionAdmin;
  }
  obtenerBaseAdmin(){
    return this._asignadoAdmin;
  }
  obtenerClientesVisitarAdmin(){
    return this._porRecolectarAdmin;
  }
  obtenerCartera(){
    return this._cartera;
  }
  obtenervaloresVentasHoyAdmin(){
    return this._ventasHoyUsuario;
  }
  obtenerTotalValoresVentasHoyAdmin(){
    return this._ventasHoyGeneral;
  }
  obtenerClientesRecolectadosAdmin(){
    return this._recolectadosAdmin;
  }

  Future <List<ClienteBloqueado>>descargarBloqueados(fechaInicial,fechaFinal,usuario)async{
    Map mapa={
      'token':tokenGlobal,
      'fechaInicial':fechaInicial,
      'fechaFinal':fechaFinal,
      'usuario':usuario,
    };
    _parametrosEnviados=[];
    _parametrosEnviados.add(mapa);

    Map parametro={
      "lista":_parametrosEnviados
    };
    var map = await callMethodList('/listarBloqueados.php',parametro);
    List<ClienteBloqueado> totalProduccion=[];
    for ( var prod in map)
    {
      totalProduccion.add(ClienteBloqueado.fromMap(prod));
    }
    return this._clienteBloqueado= totalProduccion;
  }
  obtenerClientesBloqueados(){
    return this._clienteBloqueado;
  }
  obtenerGastosFecha(){
    return this._reporteGasto;
  }

  obtnerTotalProduccion(){
    return this._totalProduccion;
  }

  obtnerProduccion(){
    return this._produccion;
  }

  callMethodOne(String webservice,params)async {
    Response response;
    try{
        response = await http.post(Uri.parse(urlOrigen+webservice), headers: {
      "Content-Type": "application/json; charset=utf-8",
      }, body: jsonEncode(params));
    }catch(e){
      //return ConnectionError(e.toString());
      return e;
    }
    try{
      var data;
      data = jsonDecode(response.body);
      return data;
      // if (response.statusCode == 200) {
      //     //throw new Exception(status.message);
      // }
    }catch(e){
      return e;
    }

  }

  callMethodList( String webservice,params)async {
    //var sess=this._token;
    Response response;
    try{
      response = await http.post(Uri.parse(urlOrigen+webservice), headers: {
       "Content-Type": "application/json; charset=utf-8",
      }, body: jsonEncode(params));
      var data;
      data = jsonDecode(response.body);
      List<Map> lis = new List<Map>.from( data);
      return lis;

    }catch(e){
      //return ConnectionError(e.toString());
      return e;
    }
  }

  callMethod( String webservice,params)async {
    //var sess=this._token;
    Response response;
    try{
      
        response = await http.post(Uri.parse(urlOrigen+webservice), headers: {
       "Content-Type": "application/json; charset=utf-8",
      }, body: jsonEncode(params));
      var data;
      data = jsonDecode(response.body);
      List<String> lis = new List<String>.from(data);
      return lis;

    }catch(e){
      //return ConnectionError(e.toString());
      return e;
    }
  }
}

//SELECT documento,CAST(FROM_UNIXTIME(truncate(fecha/1000,0)) AS DATE) AS fechai,CAST(FROM_UNIXTIME(truncate(orden/1000,0)) AS DATE) AS fechaf,TIMESTAMPDIFF(DAY,CAST(FROM_UNIXTIME(truncate(fecha/1000,0)) AS DATE), CAST(FROM_UNIXTIME(truncate(orden/1000,0)) AS DATE)) AS dias,cuotas,TRUNCATE(AVG(TIMESTAMPDIFF(DAY,CAST(FROM_UNIXTIME(truncate(fecha/1000,0)) AS DATE), CAST(FROM_UNIXTIME(truncate(orden/1000,0)) AS DATE))-cuotas),0) as diferencia,GROUP_CONCAT(cuotas ORDER BY fecha DESC) as venta FROM venta WHERE estado = 'pago' GROUP BY documento ORDER BY fechaTexto;
