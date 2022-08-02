class ClienteBloqueado {
  String idCliente;
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
  String fecha;
  String estado;
  String usuario;
  double saldo;
  String nombreUsuario;
  double solicitado;
  double numeroCuota;
  double cuotasTemporal;
  
  ClienteBloqueado({
    this.nombre,
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
    this.saldo,
    this.nombreUsuario,
    this.solicitado,
    this.numeroCuota,
    this.cuotasTemporal,
  });


  //Insertar datos,convertir en un Map

  Map<String, dynamic>toMap() {
    return {
      "documento":documento,
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
      "saldo":saldo,
      "nombreUsuario":nombreUsuario,
      "solicitado":solicitado,
      "numeroCuota":numeroCuota,
      "cuotasTemporal":cuotasTemporal,
    };
  }

  // recibir lo datos pasar de Map a json
  factory ClienteBloqueado.fromMap(Map<String ,dynamic>json)=> new ClienteBloqueado(
    nombre:json["nombre"],
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
    fecha:json["fechaTexto"],
    estado:json["estado"],
    usuario:json["usuario"],
    saldo:double.parse(json["saldo"]),
    nombreUsuario:json["nombreUsuario"],
    solicitado:double.parse(json["solicitado"]),
    numeroCuota:double.parse(json["numeroCuota"]),
    cuotasTemporal:double.parse(json["cuotasTemporal"]),
  );
}