
class Proyecto {
  String administrador;
  String fecha;
  String proyecto;
  String usuario;             
  
  Proyecto({
    this.administrador,
    this.fecha,
    this.proyecto,
    this.usuario,
  });

  Map<String, dynamic> toMap() {
    return {
    'administrador':administrador,
    'fecha':fecha,
    'proyecto':proyecto,
    'usuario':usuario,
    };
  }

  factory Proyecto.fromJson(Map<String, dynamic> json) => new Proyecto(
    administrador:json['administrador']==null?json['administrador']='Por definir':json['administrador'],
    fecha:json['fecha']==null?json['fecha']='':json['fecha'],
    proyecto:json['proyecto']==null?json['proyecto']='':json['proyecto'],
    usuario:json['usuario']==null?json['usuario']='':json['usuario'],
  );
}