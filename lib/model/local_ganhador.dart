import 'package:palpites_da_loteria/service/format_service.dart';

class LocalGanhador {
  bool? canalEletronico;
  String? cidade;
  String? local;
  int? quantidadeGanhadores;
  String? uf;

  LocalGanhador(
      {this.canalEletronico,
      this.cidade,
      this.local,
      this.quantidadeGanhadores,
      this.uf});

  factory LocalGanhador.fromJson(Map<String, dynamic> json) {
    return LocalGanhador(
      canalEletronico: json['canal_eletronico'],
      cidade: json['cidade'],
      local: json['local'],
      quantidadeGanhadores: json['quantidade_ganhadores'],
      uf: json['uf'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canal_eletronico'] = this.canalEletronico;
    data['cidade'] = this.cidade;
    data['local'] = this.local;
    data['quantidade_ganhadores'] = this.quantidadeGanhadores;
    data['uf'] = this.uf;
    return data;
  }

  getQuantidadeGanhadoresDisplayValue() {
    return formatNumber(quantidadeGanhadores);
  }
}
