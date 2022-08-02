class HistorialVenta {
  String idVenta;
  String documento;
  int fechaRecoleccion;
  String fecha;
  double numeroCuota;
  double valorCuota;
  double saldo;
  String novedad;
  String usuario;
  String _tableName='HistorialVenta';

  HistorialVenta({
    this.idVenta,
    this.documento,
    this.numeroCuota,
    this.valorCuota,
    this.saldo,
    this.usuario,
    this.fechaRecoleccion,
    this.novedad,
    this.fecha,
  });

  Map<String, dynamic>toMap() {
    return {
    "idVenta":idVenta,
    "documento":documento,
    "numeroCuota":numeroCuota,
    "valorCuota":valorCuota,
    "saldo":saldo,
    "usuario":usuario,
    "fechaRecoleccion":fechaRecoleccion,
    "novedad":novedad,
    "fecha":fecha,
    };
  }

  factory HistorialVenta.fromMap(Map<String ,dynamic>json)=> new HistorialVenta(
    idVenta:json["idVenta"],
    documento:json["documento"],
    numeroCuota:json["numeroCuota"],
    valorCuota:json["valorCuota"],
    saldo:json["saldo"],
    usuario:json["usuario"],
    fechaRecoleccion:json["fechaRecoleccion"],
    novedad:json["novedad"],
    fecha:json["fecha"],
  );



  String getTableName(){
     return this._tableName;
  }
}