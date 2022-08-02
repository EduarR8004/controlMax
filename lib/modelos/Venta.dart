class Venta {
  String idVenta;
  int fecha;
  String documento;
  double venta;
  double valorDia;
  double cuotas;
  String fechaTexto;
  int fechaPago;
  String interes;
  double numeroCuota;
  double valorCuota;
  double valorTemporal;
  double cuotasTemporal;
  double saldo;
  String estado;
  String usuario;
  String frecuencia;
  double solicitado;
  String estadoTemporal;
  String motivo;
  String ruta;
  String actualizar;
  String day;
  String diaRecoleccion;
  int orden;
  String _tableName='Venta';

  Venta({
    this.idVenta,
    this.documento,
    this.venta,
    this.valorDia,
    this.cuotas,
    this.fecha,
    this.interes,
    this.fechaPago,
    this.numeroCuota,
    this.valorCuota,
    this.valorTemporal,
    this.cuotasTemporal,
    this.estadoTemporal,
    this.saldo,
    this.estado,
    this.usuario,
    this.frecuencia,
    this.solicitado,
    this.motivo,
    this.fechaTexto,
    this.orden,
    this.actualizar,
    this.diaRecoleccion,
    this.day,
    this.ruta,
  });

  Map<String, dynamic>toMap() {
    return {
    "idVenta":idVenta,
    "fechaPago":fechaPago,
    "documento":documento,
    "venta":venta,
    "valorDia":valorDia,
    "cuotas":cuotas,
    "fecha":fecha,
    "interes":interes,
    "numeroCuota":numeroCuota,
    "valorCuota":valorCuota,
    "valorTemporal":valorTemporal,
    "cuotasTemporal":cuotasTemporal,
    "estadoTemporal":estadoTemporal,
    "saldo":saldo,
    "estado":estado,
    "usuario":usuario,
    "frecuencia":frecuencia,
    "solicitado":solicitado,
    "motivo":motivo,
    "ruta":ruta,
    "orden":orden,
    "actualizar":actualizar,
    "diaRecoleccion":diaRecoleccion,
    "day":day,
    "fechaTexto":fechaTexto,
    };
  }

  factory Venta.fromMap(Map<String ,dynamic>json)=> new Venta(
    idVenta:json["idVenta"],
    documento:json["documento"],
    venta:json["venta"],
    valorDia:json["valorDia"],
    cuotas:json["cuotas"],
    fecha:json["fecha"],
    fechaPago:json["fechaPago"],
    interes:json["interes"],
    numeroCuota:json["numeroCuota"],
    valorCuota:json["valorCuota"],
    valorTemporal:json["valorTemporal"],
    cuotasTemporal:json["cuotasTemporal"],
    estadoTemporal:json["estadoTemporal"],
    saldo:json["saldo"],
    estado:json["estado"],
    usuario:json["usuario"],
    frecuencia:json["frecuencia"],
    solicitado:json["solicitado"],
    motivo:json["motivo"],
    ruta:json["ruta"],
    orden:json["orden"],
    actualizar:json["actualizar"],
    fechaTexto:json["fechaTexto"],
    diaRecoleccion:json["diaRecoleccion"],
    day:json["day"],
  );

  String getTableName(){
     return this._tableName;
  }
}