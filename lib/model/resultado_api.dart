
import 'package:palpites_da_loteria/service/format_service.dart';

class ResultadoAPI {
  String? loteria;
  String? nome;
  int? concurso;
  String? data;
  String? local;
  List<String>? dezenas;
  List<String>? dezenas_2;
  List<Premiacoes>? premiacoes;
  List<Premiacoes>? premiacoes_2;
  List<EstadosPremiados>? estadosPremiados;
  bool? acumulou;
  String? acumuladaProxConcurso;
  String? dataProxConcurso;
  int? proxConcurso;
  String? timeCoracao;
  String? mesSorte;

  ResultadoAPI(
      {this.loteria,
        this.nome,
        this.concurso,
        this.data,
        this.local,
        this.dezenas,
        this.premiacoes,
        this.estadosPremiados,
        this.acumulou,
        this.acumuladaProxConcurso,
        this.dataProxConcurso,
        this.proxConcurso,
        this.timeCoracao,
        this.mesSorte});

  ResultadoAPI.fromJson(Map<String, dynamic> json) {
    loteria = json['loteria'];
    nome = json['nome'];
    concurso = json['concurso'];
    data = json['data'];
    local = json['local'];
    dezenas = json['dezenas'].cast<String>();
    if(loteria == "dupla-sena" && dezenas != null) {
      var part1 = dezenas!.sublist(0, ((dezenas!.length)~/2) -1);
      var part2 = dezenas!.sublist((dezenas!.length)~/2, dezenas!.length -1);
      dezenas = part1;
      dezenas_2 = part2;
    }
    if (json['premiacoes'] != null) {
      premiacoes = <Premiacoes>[];
      json['premiacoes'].forEach((v) {
        premiacoes!.add(new Premiacoes.fromJson(v));
      });
      if(loteria == "dupla-sena" && premiacoes != null) {
        var part1 = premiacoes!.sublist(0, ((premiacoes!.length)~/2) -1);
        var part2 = premiacoes!.sublist((premiacoes!.length)~/2, premiacoes!.length -1);
        premiacoes = part1;
        premiacoes_2 = part2;
      }
    }
    if (json['estadosPremiados'] != null) {
      estadosPremiados = <EstadosPremiados>[];
      json['estadosPremiados'].forEach((v) {
        estadosPremiados!.add(new EstadosPremiados.fromJson(v));
      });
    }
    acumulou = json['acumulou'];
    acumuladaProxConcurso = json['acumuladaProxConcurso'];
    dataProxConcurso = json['dataProxConcurso'];
    proxConcurso = json['proxConcurso'];
    timeCoracao = json['timeCoracao'];
    mesSorte = json['mesSorte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loteria'] = this.loteria;
    data['nome'] = this.nome;
    data['concurso'] = this.concurso;
    data['data'] = this.data;
    data['local'] = this.local;
    data['dezenas'] = this.dezenas;
    if (this.premiacoes != null) {
      data['premiacoes'] = this.premiacoes!.map((v) => v.toJson()).toList();
    }
    if (this.estadosPremiados != null) {
      data['estadosPremiados'] =
          this.estadosPremiados!.map((v) => v.toJson()).toList();
    }
    data['acumulou'] = this.acumulou;
    data['acumuladaProxConcurso'] = this.acumuladaProxConcurso;
    data['dataProxConcurso'] = this.dataProxConcurso;
    data['proxConcurso'] = this.proxConcurso;
    data['timeCoracao'] = this.timeCoracao;
    data['mesSorte'] = this.mesSorte;
    return data;
  }

  String getDataConcursoDisplayValue () {
    if (data != null)
      return (data!);
    return '';
  }

  // String getArrecadacaoTotalDisplayValue () {
  //   if (arrecadacao_total != null)
  //     return formatCurrency(arrecadacao_total);
  //   return '';
  // }
  //
  // String getValorAcumuladoDisplayValue () {
  //   if (valor_acumulado != null)
  //     return formatCurrency(valor_acumulado);
  //   return '';
  // }

  String getValorEstimadoProximoConcursoDisplayValue () {
    if (acumuladaProxConcurso != null)
      return '${acumuladaProxConcurso!}';
    return '';
  }

  String getDataProximoConcursoDisplayValue () {
    if (dataProxConcurso != null)
      return (dataProxConcurso!);
    return '';
  }

  // String getValorAcumuladoEspecialDisplayValue () {
  //   if (valor_acumulado_especial != null)
  //     return formatCurrency(valor_acumulado_especial);
  //   return '';
  // }


  String getDezenasDisplayValue() {
    return getDezenasResultadoDisplayValue(dezenas!);
  }

  String getDezenas2DisplayValue() {
    return getDezenasResultadoDisplayValue(dezenas_2!);
  }

  String shareString() {
    return 'Aplicativo Palpites da loteria\n'
        ' 👉 https://rb.gy/3dcmmn 🍀\n\n'
        'Resultado $nome\n\n' +
        (acumulou! ? 'ACUMULOU' : 'TEVE GANHADOR') + '\n\n' +
        (dezenas != null && dezenas!.isNotEmpty ? getDezenasDisplayValue() + '\n\n' : '')  +
        (dezenas_2 != null && dezenas_2!.isNotEmpty ? getDezenas2DisplayValue() + '\n\n' : '') +
        ((timeCoracao != '' && timeCoracao != null) ? 'Time do coração: $timeCoracao \n\n' : '') +
        ((mesSorte != '' && mesSorte != null) ? 'Mês da sorte: $mesSorte \n\n' : '') +
        'Concurso: $concurso \n' +
            'Data de realização: ' + getDataConcursoDisplayValue() + '\n\n' +
        // 'Arrecadação total: ' + getArrecadacaoTotalDisplayValue() +'\n'
        // 'Acumulado: ' + getValorAcumuladoDisplayValue() + '\n\n'
        ((getDataProximoConcursoDisplayValue() != '') ? 'Próximo concurso dia ' + getDataProximoConcursoDisplayValue() +'\n' : '') +
        ((getValorEstimadoProximoConcursoDisplayValue() != '') ? 'Prêmio estimado: ' + getValorEstimadoProximoConcursoDisplayValue() +'\n' : '')
        //(nome_acumulado_especial != null ? 'Acumulado $nome_acumulado_especial: ' + getValorAcumuladoEspecialDisplayValue() : '')
    ;
  }
}

class Premiacoes {
  String? acertos;
  int? vencedores;
  String? premio;

  Premiacoes({this.acertos, this.vencedores, this.premio});

  Premiacoes.fromJson(Map<String, dynamic> json) {
    acertos = json['acertos'];
    vencedores = json['vencedores'];
    premio = json['premio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acertos'] = this.acertos;
    data['vencedores'] = this.vencedores;
    data['premio'] = this.premio;
    return data;
  }
}

class EstadosPremiados {
  String? nome;
  String? uf;
  String? vencedores;
  String? latitude;
  String? longitude;
  List<Cidades>? cidades;

  EstadosPremiados(
      {this.nome,
        this.uf,
        this.vencedores,
        this.latitude,
        this.longitude,
        this.cidades});

  EstadosPremiados.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    uf = json['uf'];
    vencedores = json['vencedores'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['cidades'] != null) {
      cidades = <Cidades>[];
      json['cidades'].forEach((v) {
        cidades!.add(new Cidades.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['uf'] = this.uf;
    data['vencedores'] = this.vencedores;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.cidades != null) {
      data['cidades'] = this.cidades!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cidades {
  String? cidade;
  String? vencedores;
  String? latitude;
  String? longitude;

  Cidades({this.cidade, this.vencedores, this.latitude, this.longitude});

  Cidades.fromJson(Map<String, dynamic> json) {
    cidade = json['cidade'];
    vencedores = json['vencedores'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cidade'] = this.cidade;
    data['vencedores'] = this.vencedores;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }

}