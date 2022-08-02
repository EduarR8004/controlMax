class ReporteDiario {
  String asignado;
  String baseRuta;
  String gasto;
  String ventas;
  String usuario;
  String fecha;
  String recolectado;
  String hora;
  String nombre;
  String retiro;
  String idBase;
  ReporteDiario({
    this.recolectado,
    this.gasto,
    this.ventas,
    this.usuario,
    this.fecha,
    this.asignado,
    this.hora,
    this.nombre,
    this.retiro,
    this.baseRuta,
    this.idBase,
  });

  Map<String, dynamic> toMap() {
    return {
      'recolectado': recolectado,
      'gasto': gasto,
      'ventas': ventas,
      'usuario': usuario,
      'fecha': fecha,
      'asignado':asignado,
      'entrega':hora,
      'nombre':nombre,
      'retiro':retiro,
      'baseRuta':baseRuta,
      'idBase':idBase,
    };
  }

  factory ReporteDiario.fromJson(Map<String, dynamic> json) {
    return ReporteDiario(
      recolectado: json['recolectado']==null?json['recolectado']='0':json['recolectado'],
      gasto: json['gasto']==null?json['gasto']='0':json['gasto'],
      ventas: json['ventas']==null?json['ventas']='0':json['ventas'],
      usuario: json['usuario']==null?json['usuario']='0':json['usuario'],
      fecha: json['fecha']==null?json['fecha']='0':json['fecha'],
      asignado:json['asignado']==null?json['asignado']='0':json['asignado'],
      hora:json['hora']==null?json['hora']='0':json['hora'],
      nombre:json['nombre']==null?json['nombre']='0':json['nombre'],
      retiro:json['retiro']==null?json['retiro']='0':json['retiro'],
      baseRuta:json['baseRuta']==null?json['baseRuta']='0':json['baseRuta'],
      idBase:json['idBase']==null?json['idBase']='0':json['idBase'],
    );
  }

}
