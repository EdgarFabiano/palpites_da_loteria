
import 'package:palpites_da_loteria/domain/local-ganhador.dart';
import 'package:palpites_da_loteria/domain/premiacao.dart';

class Resultado {

    bool acumulou;
    double arrecadacao_total;
    bool concurso_especial;
    int concurso_proximo;
    String data_concurso;
    int data_concurso_milliseconds;
    String data_proximo_concurso;
    int data_proximo_concurso_milliseconds;
    List<String> dezenas;
    List<LocalGanhadore> local_ganhadores;
    String local_realizacao;
    String nome;
    int numero_concurso;
    List<Premiacao> premiacao;
    bool rateio_processamento;
    double valor_acumulado;
    int valor_estimado_proximo_concurso;
    String nome_acumulado_especial;
    double valor_acumulado_especial;

    //Dia de sorte
    String dezena_mes_sorte;
    String nome_mes_sorte;

    //Dupla sena
    List<String> dezenas_2;
    List<Premiacao> premiacao_2;

    //Mega sena
    int numero_final_concurso_acumulado;
    double valor_final_concurso_acumulado;

    //Time mania
    String dezena_time_coracao;
    String nome_time_coracao;

  Resultado({
    this.acumulou,
    this.arrecadacao_total,
    this.concurso_especial,
    this.concurso_proximo,
    this.data_concurso,
    this.data_concurso_milliseconds,
    this.data_proximo_concurso,
    this.data_proximo_concurso_milliseconds,
    this.dezenas,
    this.local_ganhadores,
    this.local_realizacao,
    this.nome,
    this.numero_concurso,
    this.premiacao,
    this.rateio_processamento,
    this.valor_acumulado,
    this.valor_estimado_proximo_concurso,
    this.nome_acumulado_especial,
    this.valor_acumulado_especial,
    this.dezena_mes_sorte,
    this.nome_mes_sorte,
    this.dezenas_2,
    this.premiacao_2,
    this.numero_final_concurso_acumulado,
    this.valor_final_concurso_acumulado,
    this.dezena_time_coracao,
    this.nome_time_coracao,
  });

  factory Resultado.fromJson(Map<String, dynamic> json) {
        return Resultado(
            acumulou: json['acumulou'],
            arrecadacao_total: json['arrecadacao_total'],
            concurso_especial: json['concurso_especial'],
            concurso_proximo: json['concurso_proximo'],
            data_concurso: json['data_concurso'],
            data_concurso_milliseconds: json['data_concurso_milliseconds'],
            data_proximo_concurso: json['data_proximo_concurso'],
            data_proximo_concurso_milliseconds: json['data_proximo_concurso_milliseconds'],
            dezenas: json['dezenas'] != null ? new List<String>.from(json['dezenas']) : null,
            local_ganhadores: json['local_ganhadores'] != null ? (json['local_ganhadores'] as List).map((i) => LocalGanhadore.fromJson(i)).toList() : null,
            local_realizacao: json['local_realizacao'],
            nome: json['nome'],
            numero_concurso: json['numero_concurso'],
            premiacao: json['premiacao'] != null ? (json['premiacao'] as List).map((i) => Premiacao.fromJson(i)).toList() : null,
            rateio_processamento: json['rateio_processamento'],
            valor_acumulado: json['valor_acumulado'],
            valor_estimado_proximo_concurso: json['valor_estimado_proximo_concurso'],
            nome_acumulado_especial: json['nome_acumulado_especial'],
            valor_acumulado_especial: json['valor_acumulado_especial'],
            dezena_mes_sorte: json['dezena_mes_sorte'],
            nome_mes_sorte: json['nome_mes_sorte'],
            dezenas_2: json['dezenas_2'] != null ? new List<String>.from(json['dezenas_2']) : null,
            premiacao_2: json['premiacao_2'] != null ? (json['premiacao_2'] as List).map((i) => Premiacao.fromJson(i)).toList() : null,
            numero_final_concurso_acumulado: json['numero_final_concurso_acumulado'],
            valor_final_concurso_acumulado: json['valor_final_concurso_acumulado'],
            dezena_time_coracao: json['dezena_time_coracao'],
            nome_time_coracao: json['nome_time_coracao'],
        );
    }

}
