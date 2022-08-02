class ListarCaja {

  double ingreso;
  String fecha;
  String usuario;
  double retiro;
  String salida;
  String entrada;
  String usuarioRuta;
  String administrador;
  String ruta;
  ListarCaja({
    this.ingreso,
    this.fecha,
    this.usuario,
    this.retiro,
    this.salida,
    this.entrada,
    this.usuarioRuta,
    this.administrador,
    this.ruta,
  });


  Map<String, dynamic> toMap() {
    return {
      'ingreso': ingreso,
      'fecha': fecha,
      'usuario': usuario,
      'retiro': retiro,
      'baseRuta': salida,
      'ingresoRuta': entrada,
      'usuarioRuta': usuarioRuta,
      'administrador': administrador,
      'ruta': ruta,
    };
  }

  factory ListarCaja.fromJson(Map<String, dynamic> json) => new ListarCaja(
    ingreso:json['ingreso']==null?json['ingreso']=0.0:double.parse(json['ingreso']),
    fecha: json['fecha']==null?json['fecha']='':json['fecha'],
    usuario: json['usuario']==null?json['usuario']='':json['usuario'],
    retiro: json['retiro']==null?json['retiro']=0.0:double.parse(json['retiro']),
    salida: json['salida']==null?json['salida']='0.0':json['salida'],
    entrada:json['entrada']==null?json['entrada']='0.0':json['entrada'],
    usuarioRuta: json['usuario_ruta']==null?json['usuario_ruta']='No aplica':json['usuario_ruta'],
    administrador: json['administrador'],
    ruta: json['ruta']==null?json['ruta']='No aplica':json['ruta'],
  );
  
}
