class Ciudad {
  
  String id;
  String nombre;
  String departamento;
  String _tableName='Ciudad';

  Ciudad ({
    this.id,
    this.nombre,
    this.departamento,
  });

  Map<String, dynamic>toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "departamento":departamento,
    };
  }

  factory Ciudad.fromMap(Map<String ,dynamic>json)=> new Ciudad(
    id:json["id"],
    nombre:json["nombre"],
    departamento:json["departamento"],
  );

  String getTableName(){
     return this._tableName;
  }
}