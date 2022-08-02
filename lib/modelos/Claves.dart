class Clave {
  
  String clave;
  String tipo;
  String usuario;
  String valor;
  String _tableName='Claves';

  Clave ({
    this.clave,
    this.tipo,
    this.usuario,
    this.valor
  });

  Map<String, dynamic>toMap() {
    return {
      "clave": clave,
      "tipo": tipo,
      "usuario": usuario,
      "valor":valor
    };
  }

  factory Clave.fromMap(Map<String ,dynamic>json)=> new Clave(
    clave:json["clave"],
    tipo:json["tipo"],
    usuario:json["usuario"],
    valor:json["valor"]==null?json["valor"]='N/A':json["valor"]
  );

  String getTableName(){
     return this._tableName;
  }
}