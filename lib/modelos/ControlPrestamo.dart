class Control {
  String nombre;
  String primerApellido;
  String alias;
  String direccion;
  String documento;
  double promedio;
  double maximo;
  String revisar;
  String fecha;
  String venta;
  String nombreRuta;
  String cuotas;
  double diasMora;
  
  Control({
    this.nombre,
    this.primerApellido,
    this.alias,
    this.direccion,
    this.documento,
    this.promedio,
    this.maximo,
    this.revisar,
    this.fecha,
    this.venta,
    this.nombreRuta,
    this.cuotas,
    this.diasMora
  });


  //Insertar datos,convertir en un Map

  Map<String, dynamic>toMap() {
    return {
      "nombre": nombre,
      "primerApellido":primerApellido,
      "alias":alias,
      "direccion":direccion,
      "documento":documento,
      "promedio":promedio,
      "maximo":maximo,
      "revisar":revisar,
      "fecha":fecha,
      "venta":venta,
      "nombreRuta":nombreRuta,
      "cuotas":cuotas,
      "diasMora":diasMora,
      
    };
  }

  // recibir lo datos pasar de Map a json
  factory Control.fromJson(Map<String ,dynamic>json)=> new Control(
    nombre:json["nombre"],
    direccion:json["direccion"],
    primerApellido:json["primerApellido"],
    alias:json["alias"],
    documento:json["documento"],
    promedio:double.parse(json["promedio"]),
    maximo:double.parse(json["maximo"]),
    revisar:json["revisar"],
    fecha:json["fecha"],
    venta:json["venta"],
    nombreRuta:json["nombre_ruta"],
    cuotas:json["cuotas"],
    diasMora:double.parse(json["dias_mora"]),
  );
  
}