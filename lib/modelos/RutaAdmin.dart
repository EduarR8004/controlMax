class RutaAdmin {
  String idCliente;
  int id;
  String alias;
  String nombre;
  String primerApellido;
  String segundoApellido; 
  String direccion;
  String ciudad;
  String departamento;
  String telefono;
  String actividadEconomica;
  String documento;
  String motivo;
  double venta;
  double valorDia;
  double cuotas;
  double solicitado;
  int fecha;
  int fechaPago;
  int orden;
  String interes;
  double numeroCuota;
  double valorCuota;
  double saldo;
  String frecuencia;
  String colaborador;
  String usuario;
  double valorTemporal;

  RutaAdmin({
    this.idCliente,
    this.id,
    this.alias,
    this.nombre,
    this.primerApellido,
    this.direccion,
    this.ciudad,
    this.departamento,
    this.telefono,
    this.actividadEconomica,
    this.documento,
    this.venta,
    this.valorDia,
    this.cuotas,
    this.solicitado,
    this.fecha,
    this.interes,
    this.orden,
    this.fechaPago,
    this.numeroCuota,
    this.valorCuota,
    this.saldo,
    this.frecuencia,
    this.motivo,
    this.segundoApellido,
    this.colaborador,
    this.usuario,
    this.valorTemporal,
  });

  Map<String, dynamic>toMap() {
    return {
    "idCliente":idCliente,
    "id":id,
    "alias":alias,
    "nombre":nombre,
    "primerApellido":primerApellido,
    "direccion":direccion,
    "ciudad":ciudad,
    "departamento":departamento,
    "telefono":telefono,
    "actividadEconomica":actividadEconomica,
    "fechaPago":fechaPago,
    "documento":documento,
    "venta":venta,
    "valorDia":valorDia,
    "cuotas":cuotas,
    "solicitado":solicitado,
    "fecha":fecha,
    "orden":orden,
    "interes":interes,
    "numeroCuota":numeroCuota,
    "valorCuota":valorCuota,
    "saldo":saldo,
    "frecuencia":frecuencia,
    "motivo":motivo,
    "segundoApellido":segundoApellido,
    "colaborador":colaborador,
    "usuario":usuario,
    "valorTemporal":valorTemporal,
    };
  }

  factory RutaAdmin.fromJson(Map<String ,dynamic>json)=> new RutaAdmin(
    idCliente:json["idCliente"],
    id:int.parse(json["id"]),
    documento:json["documento"],
    venta:double.parse(json["venta"]),
    valorDia:double.parse(json["valorDia"]),
    cuotas:double.parse(json["cuotas"]),
    solicitado:double.parse(json["solicitado"]),
    fecha:int.parse(json["fecha"]),
    fechaPago:int.parse(json["fechaPago"]),
    interes:json["interes"],
    orden:int.parse(json["orden"]),
    numeroCuota:double.parse(json["numeroCuota"]),
    valorCuota:double.parse(json["valorCuota"]),
    saldo:double.parse(json["saldo"]),
    alias:json["alias"],
    nombre:json["nombre"],
    primerApellido:json["primerApellido"],
    direccion:json["direccion"],
    ciudad:json["ciudad"],
    departamento:json["departamento"],
    telefono:json["telefono"],
    actividadEconomica:json["actividadEconomica"],
    frecuencia:json["frecuencia"],
    motivo:json["motivo"],
    segundoApellido:json["segundoApellido"],
    colaborador:json["colaborador"],
    usuario:json["usuario"],
    valorTemporal:double.parse(json["valorTemporal"]),
  );

}