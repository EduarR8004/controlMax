class RutaAdminTotal {
  
  double total;
  double solicitado;

  RutaAdminTotal ({
    this.total,
    this.solicitado,
  });

  Map<String, dynamic>toMap() {
    return {
      "total": total,
      "solicitado":solicitado,
    };
  }

  factory RutaAdminTotal.fromJson(Map<String ,dynamic>json)=> new RutaAdminTotal(
    total:json["total"]==null?json["total"]=0.0:double.parse(json["total"]),
    solicitado:json["solicitado"]==null?json["solicitado"]=0.0:double.parse(json["solicitado"]),
  );

}