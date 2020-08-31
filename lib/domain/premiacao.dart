
class Premiacao {
  int acertos;
  String nome;
  int quantidade_ganhadores;
  double valor_total;

  Premiacao({this.acertos, this.nome, this.quantidade_ganhadores, this.valor_total});

  factory Premiacao.fromJson(Map<String, dynamic> json) {
    return Premiacao(
      acertos: json['acertos'],
      nome: json['nome'],
      quantidade_ganhadores: json['quantidade_ganhadores'],
      valor_total: json['valor_total'] != null ? json['valor_total'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acertos'] = this.acertos;
    data['nome'] = this.nome;
    data['quantidade_ganhadores'] = this.quantidade_ganhadores;
    data['valor_total'] = this.valor_total;
    return data;
  }
}