class CajaInicial {
  String usuario;
  String fecha;
  double valor;
  String _tableName='CajaInicial';
  CajaInicial({
    this.usuario,
    this.fecha,
    this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'fecha': fecha,
      'valor': valor,
    };
  }

  factory CajaInicial.fromMap(Map<String, dynamic> json) {
    return CajaInicial(
      usuario: json['usuario']==null?'':json['usuario'],
      fecha: json['fecha']==null?'':json['fecha'],
      valor: json['valor']==null?0.0:json['valor'],
    );
  }

  String getTableName(){
     return this._tableName;
  }
}