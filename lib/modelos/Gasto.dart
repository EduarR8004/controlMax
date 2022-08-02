class Gasto {
  String idGasto;
  String usuario;
  String fecha;
  double valor;
  String tipo;
  String observaciones;
  String _tableName='Gastos';
  Gasto({
    this.idGasto,
    this.usuario,
    this.fecha,
    this.valor,
    this.tipo,
    this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'idGasto':idGasto,
      'usuario': usuario,
      'fecha': fecha,
      'valor': valor,
      'tipo': tipo,
      'observaciones':observaciones,
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> json) {
    return Gasto(
      idGasto:json['idGasto'],
      usuario: json['usuario'],
      fecha: json['fecha'],
      valor: json['valor']==null?0.0:json['valor'],
      tipo: json['tipo'],
      observaciones:json['observaciones'],
    );
  }

  String getTableName(){
    return this._tableName;
  }

}
