class ReporteGasto {
  String usuario;
  String nombre;
  String fecha;
  double valor;
  String tipo;
  String observaciones;
  ReporteGasto({
    this.usuario,
    this.fecha,
    this.valor,
    this.tipo,
    this.nombre,
    this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre':nombre,
      'usuario': usuario,
      'fecha': fecha,
      'valor': valor,
      'tipo': tipo,
      'observaciones':observaciones,
    };
  }

  factory ReporteGasto.fromJson(Map<String, dynamic> json) {
    return ReporteGasto(
      nombre:json["nombre"]==null?json["nombre"]='':json["nombre"],
      usuario: json['usuario']==null?json['usuario']='':json['usuario'],
      fecha: json['fecha']==null?json['fecha']='':json['fecha'],
      valor: json['valor']==null?json['valor']=0.0:double.parse(json['valor']) ,
      tipo: json['tipo']==null?json['tipo']='':json['tipo'],
      observaciones:json['observaciones']==null?json['observaciones']='':json['observaciones'],
    );
  }

}
