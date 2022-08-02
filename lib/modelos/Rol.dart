class Rol {

  String descripcion;
  String id;
  String nombre;
  Rol({
    this.descripcion,
    this.id,
    this.nombre,
  });



  Map<String, dynamic>toMap() =>{
    'descripcion': descripcion,
    'id': id,
    'nombre': nombre,
  };

  factory Rol.fromJson(Map<String, dynamic> json){
  
    return new Rol(
      descripcion: json['descripcion'],
      id: json['id'],
      nombre: json['nombre'],
    );
  }

}