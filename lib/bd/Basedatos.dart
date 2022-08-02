//archivos flutter
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:controlmax/modelos/Ventas.dart';
import 'package:path_provider/path_provider.dart';
import 'package:controlmax/modelos/Cliente.dart';
//archivos generados

class DatabaseProvider {
  DatabaseProvider._();
  var tabla;
  static final  DatabaseProvider db = DatabaseProvider._();
  Database _database;

  //para evitar que abra varias conexciones una y otra vez podemos usar algo como esto..
  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }

  Future<Database> getDatabaseInstanace() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "controlmax6.db");
     return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS Cliente ("
             "idCliente TEXT primary key,"
             "idVenta TEXT,"
             "nombre TEXT,"
             "primerApellido TEXT,"
             "segundoApellido TEXT,"
             "alias TEXT,"
             "direccion TEXT,"
             "ciudad TEXT,"
             "departamento TEXT,"
             "telefono TEXT,"
             "actividadEconomica TEXT,"
             "documento TEXT,"
             "fecha INT,"
             "estado TEXT,"
             "valor FLOAT,"
             "usuario TEXT"
            ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS CopiaCliente ("
             "idCliente TEXT,"
             "idVenta TEXT ,"
             "nombre TEXT,"
             "primerApellido TEXT,"
             "segundoApellido TEXT,"
             "alias TEXT,"
             "direccion TEXT,"
             "ciudad TEXT,"
             "departamento TEXT,"
             "telefono TEXT,"
             "actividadEconomica TEXT,"
             "documento TEXT,"
             "fecha INT,"
             "estado TEXT,"
             "valor FLOAT,"
             "usuario TEXT"
            ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Produccion ("
          "recolectado double,"
          "gasto FLOAT,"
          "ventas FLOAT,"
          "usuario TEXT,"
          "id TEXT primary key,"
          "fecha TEXT,"
          "asignado FLOAT,"
          "entrega FLOAT,"
          "retiro FLOAT,"
          "hora TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Venta ("
            "idVenta TEXT primary key,"
            "documento TEXT,"
            "venta double,"
            "valorDia double,"
            "solicitado double,"
            "cuotas double,"
            "fecha INT,"
            "fechaTexto TEXT,"
            "fechaPago INT,"
            "interes TEXT,"
            "numeroCuota FLOAT,"
            "valorCuota FLOAT,"
            "saldo FLOAT,"
            "estado TEXT,"
            "frecuencia TEXT,"
            "motivo TEXT,"
            "valorTemporal FLOAT,"
            "cuotasTemporal double,"
            "estadoTemporal TEXT,"
            "orden INT,"
            "ruta TEXT,"
            "actualizar TEXT,"
            "diaRecoleccion TEXT,"
            "day TEXT,"
            "usuario TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS HistoricoVenta ("
            "idVenta TEXT primary key,"
            "documento TEXT,"
            "venta double,"
            "solicitado double,"
            "cuotas double,"
            "fecha INT,"
            "fechaTexto TEXT,"
            "fechaPago INT,"
            "interes TEXT,"
            "numeroCuota FLOAT,"
            "valorCuota FLOAT,"
            "saldo FLOAT,"
            "estado TEXT,"
            "frecuencia TEXT,"
            "motivo TEXT,"
            "valorTemporal FLOAT,"
            "cuotasTemporal double,"
            "estadoTemporal TEXT,"
            "orden INT,"
            "ruta TEXT,"
            "actualizar TEXT,"
            "diaRecoleccion TEXT,"
            "day TEXT,"
            "usuario TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS CopiaVenta ("
            "idVenta TEXT primary key,"
            "documento TEXT,"
            "venta double,"
            "valorDia double,"
            "solicitado double,"
            "cuotas double,"
            "fecha INT,"
            "fechaTexto TEXT,"
            "fechaPago INT,"
            "interes TEXT,"
            "numeroCuota FLOAT,"
            "valorCuota FLOAT,"
            "saldo FLOAT,"
            "estado TEXT,"
            "frecuencia TEXT,"
            "motivo TEXT,"
            "valorTemporal FLOAT,"
            "cuotasTemporal double,"
            "estadoTemporal TEXT,"
            "orden INT,"
            "ruta TEXT,"
            "actualizar TEXT,"
            "diaRecoleccion TEXT,"
            "day TEXT,"
            "usuario TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Agendamiento ("
            "nombre TEXT,"
            "primerApellido TEXT,"
            "documento TEXT,"
            "solicitado double,"
            "fechaTexto TEXT,"
            "telefono TEXT,"
            "usuario TEXT"
          ")"
        );
      
        await db.execute(
          "CREATE TABLE IF NOT EXISTS HistorialVenta ("
            "idVenta TEXT,"
            "documento TEXT,"
            "fechaRecoleccion INT,"
            "fecha TEXT,"
            "numeroCuota FLOAT,"
            "valorCuota FLOAT,"
            "saldo FLOAT,"
            "novedad TEXT,"
            "usuario TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS CopiaHistorialVenta ("
            "idVenta TEXT,"
            "documento TEXT,"
            "fechaRecoleccion INT,"
            "fecha TEXT,"
            "numeroCuota FLOAT,"
            "valorCuota FLOAT,"
            "saldo FLOAT,"
            "novedad TEXT,"
            "usuario TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Gastos ("
            "idGasto TEXT primary key,"
            "usuario TEXT,"
            "fecha TEXT,"
            "valor FLOAT,"
            "tipo TEXT,"
            "observaciones TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS CopiaGastos ("
            "idGasto TEXT primary key,"
            "usuario TEXT,"
            "fecha TEXT,"
            "valor FLOAT,"
            "tipo TEXT,"
            "observaciones TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Asignacion ("
            "usuario TEXT,"
            "fecha TEXT,"
            "valor FLOAT,"
            "tipo TEXT"
          ")"
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS CajaInicial ("
            "usuario TEXT,"
            "fecha TEXT,"
            "valor FLOAT,"
            "tipo TEXT"
          ")"
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS Ciudad ("
            "id TEXT primary key,"
            "nombre TEXT,"
            "departamento TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Departamento ("
            "id TEXT primary key," 
            "nombre TEXT"
          ")"
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Claves ("
            "clave TEXT,"
            "tipo TEXT,"
            "usuario TEXT,"
            "valor TEXT"
          ")"
        );
        
      });
  }

  // //Query
  // //muestra todos los usuarios de la base de datos
  Future<List<Cliente>> getAll(tabla) async {
    final db = await database;
    var response = await db.query(tabla);
    List<Cliente> list = response.map((c) => Cliente.fromMap(c)).toList();
    return list;
  }

  Future<List<Ventas>> getAllVenta(tabla) async {
    final db = await database;
    var response = await db.query(tabla);
    List<Ventas> list = response.map((c) => Ventas.fromMap(c)).toList();
    return list;
  }


  Future<List> query(table)async{
    final db = await database;
    var res = await db.query(table);
    return res;

  }

  //Query
  //muestra un solo por el id la base de datos
  
  Future<List> rawQuery(String sql, List parameters)async{
    final db = await database;
    var res = await db.rawQuery(sql,parameters);
    return res;

  }
  
  //Insert
  addToDatabase(data) async {
    var db = await database;
    var raw = await db.insert(
      data.getTableName(),
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;    
  }

  //Delete all users
  deleteAll(obj) async {
    final db = await database;
    //db.execute("DELETE FROM '"+obj.get_table_name()+"'");
    db.delete(obj.getTableName());
  } 


}