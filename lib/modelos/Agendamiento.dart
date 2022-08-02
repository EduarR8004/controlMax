class Agendamiento {
  String nombre;
  String primerApellido;
  String documento;
  double solicitado;
  String fechaTexto;
  String telefono;
  String usuario;
  String _tableName='Agendamiento';
  Agendamiento({
    this.nombre,
    this.primerApellido,
    this.documento,
    this.solicitado,
    this.fechaTexto,
    this.telefono,
    this.usuario,
  });

  factory Agendamiento.fromMap(Map<String, dynamic> json){
    return new Agendamiento(
      nombre:json['nombre'],
      telefono:json['telefono'],
      usuario:json['usuario'],
      primerApellido:json['primerApellido'],
      fechaTexto:json['fechaTexto'],
      solicitado:json['solicitado'],
      documento:json['documento'],
    );
  }
  Map<String, dynamic> toMap() =>
  {
    "nombre":nombre,
    "telefono":telefono,
    "usuario":usuario,
    "primerApellido":primerApellido,
    "fechaTexto":fechaTexto,
    "solicitado":solicitado,
    "documento":documento,
  };
  String getTableName(){
     return this._tableName;
  }
}