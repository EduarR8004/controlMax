class UsuarioAdmin {

  String nombreCompleto;
  String usuario;
  String usuarioId;


  UsuarioAdmin({
    this.nombreCompleto,
    this.usuario,
    this.usuarioId,
  });

  factory UsuarioAdmin.fromJson(Map<String, dynamic> json){
    return new UsuarioAdmin(
      nombreCompleto:json['nombre'],
      usuario:json['usuario'],
      usuarioId:json['id'],
    );
  }
  Map<String, dynamic> toMap() =>
  {
    "nombre":nombreCompleto,
    "usuario":usuario,
    "id":usuarioId,
  };
  
}

class UsuarioList {
  final List<UsuarioAdmin> usuarios;

  UsuarioList({
    this.usuarios,
  });

   factory UsuarioList.fromJson(List<dynamic> parsedJson) {

    List<UsuarioAdmin> usuarios;
    usuarios = parsedJson.map((i)=>UsuarioAdmin.fromJson(i)).toList();

    return new UsuarioList(
      usuarios: usuarios
    );
  }
}