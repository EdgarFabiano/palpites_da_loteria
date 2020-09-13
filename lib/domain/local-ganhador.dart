
class LocalGanhador {
  bool canal_eletronico;
  String cidade;
  String local;
  int quantidade_ganhadores;
  String uf;

  LocalGanhador({this.canal_eletronico, this.cidade, this.local, this.quantidade_ganhadores, this.uf});

  factory LocalGanhador.fromJson(Map<String, dynamic> json) {
    return LocalGanhador(
      canal_eletronico: json['canal_eletronico'],
      cidade: json['cidade'],
      local: json['local'],
      quantidade_ganhadores: json['quantidade_ganhadores'],
      uf: json['uf'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canal_eletronico'] = this.canal_eletronico;
    data['cidade'] = this.cidade;
    data['local'] = this.local;
    data['quantidade_ganhadores'] = this.quantidade_ganhadores;
    data['uf'] = this.uf;
    return data;
  }
}
