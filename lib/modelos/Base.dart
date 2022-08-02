class Base {
  String usuario;
  String fecha;
  double valor;
  String _tableName='Base';
  Base({
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

  factory Base.fromMap(Map<String, dynamic> json) {
    return Base(
      usuario: json['usuario'],
      fecha: json['fecha'],
      valor: json['valor']==null?0.0:json['valor'],
    );
  }

  String getTableName(){
     return this._tableName;
  }
}
