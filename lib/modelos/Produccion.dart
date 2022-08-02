
class Produccion {
  String id ;
  String hora;
  String fecha;
  double gasto;              
  double retiro;
  double ventas;
  String usuario;
  double entrega;
  double asignado;
  double recolectado;   
  String _tableName='Produccion';
  
  Produccion({
    this.id,
    this.hora,
    this.fecha,
    this.gasto,
    this.retiro,
    this.ventas,
    this.usuario,
    this.entrega,
    this.asignado,
    this.recolectado,
  });

  Map<String, dynamic> toMap() {
    return {
    'id':id,
    'hora':hora,
    'fecha':fecha,
    'gasto':gasto,
    'retiro':retiro,
    'ventas':ventas,
    'usuario':usuario,
    'entrega':entrega,
    'asignado':asignado,
    'recolectado':recolectado,
    };
  }

  factory Produccion.fromJson(Map<String, dynamic> json) => new Produccion(
    id:json['id'],
    hora:json['hora'],
    fecha:json['fecha'],
    gasto:json['gasto'],
    retiro:json['retiro'],
    ventas:json['ventas'],
    usuario:json['usuario'],
    entrega:json['entrega'],
    asignado:json['asignado'],
    recolectado:json['recolectado'],
  );

  String getTableName(){
     return this._tableName;
  }

}
