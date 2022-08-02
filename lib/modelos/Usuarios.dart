class Usuario {

  String contrasena;
  String nombreCompleto;
  String telefono;
  String usuario;
  String usuarioId;
  String direccion;
  String estado;
  String fecha;
  String proyecto;

  Usuario({
    this.contrasena,
    this.nombreCompleto,
    this.telefono,
    this.usuario,
    this.usuarioId,
    this.direccion,
    this.fecha,
    this.estado,
    this.proyecto,
  });

  factory Usuario.fromJson(Map<String, dynamic> json){
    return new Usuario(
      contrasena:json['contrasena'],
      nombreCompleto:json['nombre'],
      telefono:json['telefono'],
      usuario:json['usuario'],
      usuarioId:json['id'],
      direccion:json['direccion'],
      estado:json['estado'],
      fecha:json['fecha'],
      proyecto:json['proyecto'],
    );
  }
  Map<String, dynamic> toMap() =>
  {
    "contrasena":contrasena,
    "nombre":nombreCompleto,
    "telefono":telefono,
    "usuario":usuario,
    "id":usuarioId,
    "direccion":direccion,
    "fecha":fecha,
    "estado":estado,
    "proyecto":proyecto,
  };
  
}

class UsuarioList {
  final List<Usuario> usuarios;

  UsuarioList({
    this.usuarios,
  });

   factory UsuarioList.fromJson(List<dynamic> parsedJson) {

    List<Usuario> usuarios;
    usuarios = parsedJson.map((i)=>Usuario.fromJson(i)).toList();

    return new UsuarioList(
      usuarios: usuarios
    );
  }
}