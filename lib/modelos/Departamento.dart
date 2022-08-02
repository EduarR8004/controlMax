class Departamento {
  
  String id;
  String nombre;
  String _tableName='Departamento';

  Departamento ({
    this.id,
    this.nombre,
  });

  Map<String, dynamic>toMap() {
    return {
      "id": id,
      "nombre": nombre,
    };
  }

  factory Departamento.fromMap(Map<String ,dynamic>json)=> new Departamento(
    id:json["id"],
    nombre:json["nombre"],
  );

  factory Departamento.fromJson(Map<String ,dynamic>json)=> new Departamento (
    id:json["id"],
    nombre:json["nombre"],
  );

  String getTableName(){
     return this._tableName;
  }
}