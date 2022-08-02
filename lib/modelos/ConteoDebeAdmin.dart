
class ConteoDebeAdmin {
  int documentos;
  double venta;
  double valorCuotas;
  double saldo;
  String frecuencia;

  ConteoDebeAdmin({
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

  factory ConteoDebeAdmin.fromMap(Map<String ,dynamic>json)=> new ConteoDebeAdmin(
    documentos: json['documentos']==null?json['documentos']=0:int.parse(json['documentos']),
    venta: json['venta']==null?0.0:double.parse(json['venta']),
    valorCuotas: json['valorCuotas']==null?json['valorCuotas']=0.0:double.parse(json['valorCuotas'].toString()),
    saldo: json['saldo']==null?json['saldo']=0.0:double.parse(json['saldo']),
    frecuencia: json['frecuencia']==null?json['frecuencia']='':json['frecuencia'],
  );

}