
class Cartera {
  int documentos;
  double venta;
  double solicitado;
  double saldo;
  double valorCuota;

  Cartera({
    this.documentos,
    this.venta,
    this.solicitado,
    this.saldo,
    this.valorCuota,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentos': documentos,
      'venta': venta,
      'solicitado': solicitado,
      'saldo': saldo,
      'frecuencia': valorCuota,
    };
  }

  factory Cartera.fromMap(Map<String ,dynamic>json)=> new Cartera(
    documentos: json['documentos']==null?json['documentos']=0:int.parse(json['documentos']),
    venta: json['venta']==null?0.0:double.parse(json['venta']),
    solicitado: json['solicitado']==null?json['solicitado']=0.0:double.parse(json['solicitado'].toString()),
    saldo: json['saldo']==null?json['saldo']=0.0:double.parse(json['saldo']),
    valorCuota: json['valorCuota']==null?json['valorCuota']=0.0:double.parse(json['valorCuota']),
  );

}