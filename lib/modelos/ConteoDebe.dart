
class ConteoDebe {
  int documentos;
  double venta;
  double valorCuotas;
  double saldo;
  String frecuencia;

  ConteoDebe({
    this.documentos,
    this.venta,
    this.valorCuotas,
    this.saldo,
    this.frecuencia,
  });


  Map<String, dynamic> toMap() {
    return {
      'documentos': documentos,
      'venta': venta,
      'valorCuotas': valorCuotas,
      'saldo': saldo,
      'frecuencia': frecuencia,
    };
  }

  factory ConteoDebe.fromMap(Map<String ,dynamic>json)=> new ConteoDebe(
    documentos: json['documentos']==null?0:json['documentos'],
    venta: json['venta']==null?0.0:json['venta'],
    valorCuotas: json['valorCuotas']==null?0.0:json['valorCuotas'],
    saldo: json['saldo']==null?0.0:json['saldo'],
    frecuencia: json['frecuencia']==null?'':json['frecuencia'],
  );

}
