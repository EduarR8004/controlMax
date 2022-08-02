class Objeto {

  String descripcion;
  String objeto;

  Objeto({
    this.descripcion,
    this.objeto,
  });

  Map<String, dynamic>toMap() =>{
    'descripcion':descripcion,
    'objeto':objeto,
  };

  factory Objeto.fromJson(Map<String, dynamic> json){
    return new Objeto(
      descripcion:json['descripcion'],
      objeto:json['objeto'],
    );
  }
}
