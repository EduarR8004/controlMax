class AsignarAdmin {
  String usuario;
  String fecha;
  double base;
  AsignarAdmin({
    this.usuario,
    this.fecha,
    this.base,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'fecha': fecha,
      'base': base,
    };
  }

  factory AsignarAdmin.fromMap(Map<String, dynamic> json) {
    return AsignarAdmin(
      usuario: json['usuario']==null?'':json['usuario'],
      fecha: json['fecha']==null?'':json['fecha'],
      base: json['base']==null?0.0:double.parse(json['base']) ,
    );
  }
}
