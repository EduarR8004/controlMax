class Cliente {
  String idCliente;
  String idVenta;
  String nombre;
  String primerApellido;
  String segundoApellido;
  String alias;
  String direccion;
  String ciudad;
  String departamento;
  String telefono;
  String actividadEconomica;
  String documento;
  int fecha;
  String estado;
  String usuario;
  double valor;
  String _tableName='Cliente';

  Cliente({
    this.nombre,
    this.idVenta,
    this.primerApellido,
    this.segundoApellido,
    this.alias,
    this.direccion,
    this.ciudad,
    this.telefono,
    this.actividadEconomica,
    this.idCliente,
    this.documento,
    this.departamento,
    this.estado,
    this.fecha,
    this.usuario,
    this.valor,
  });


  //Insertar datos,convertir en un Map

  Map<String, dynamic>toMap() {
    return {
      "documento":documento,
      "idVenta":idVenta,
      "nombre": nombre,
      "direccion":direccion,
      "telefono":telefono,
      "ciudad":ciudad,
      "primerApellido":primerApellido,
      "segundoApellido":segundoApellido,
      "alias":alias,
      "actividadEconomica":actividadEconomica,
      "idCliente":idCliente,
      "departamento":departamento,
      "fecha":fecha,
      "estado":estado,
      "usuario":usuario,
      "valor":valor,
    };
  }

  // recibir lo datos pasar de Map a json
  factory Cliente.fromMap(Map<String ,dynamic>json)=> new Cliente(
    nombre:json["nombre"],
    idVenta:json["idVenta"],
    direccion:json["direccion"],
    telefono:json["telefono"],
    ciudad:json["ciudad"],
    departamento:json["departamento"],
    primerApellido:json["primerApellido"],
    segundoApellido:json["segundoApellido"],
    alias:json["alias"],
    actividadEconomica:json["actividadEconomica"],
    idCliente:json["idCliente"],
    documento:json["documento"],
    fecha:json["fecha"],
    estado:json["estado"],
    usuario:json["usuario"],
    valor:json["valor"]
  );

  String getTableName(){
     return this._tableName;
  }
  
}
