import 'package:palpites_da_loteria/service/format_service.dart';

class LotteryAPIResult {
  String? lotteryName;
  String? name;
  int? contestNumber;
  String? date;
  String? place;
  List<String>? numbers;
  List<String>? numbers_2;
  List<Prizes>? prizes;
  List<Prizes>? prizes_2;
  List<StateWithPrize>? winningEstates;
  bool accumulated = false;
  String? accumulatedToNextContest;
  String? nextContestDate;
  int? nextContest;
  String? teamOfTheHeartOrLuckyMonth;

  LotteryAPIResult(
      {this.lotteryName,
      this.name,
      this.contestNumber,
      this.date,
      this.place,
      this.numbers,
      this.prizes,
      this.winningEstates,
      this.accumulated = false,
      this.accumulatedToNextContest,
      this.nextContestDate,
      this.nextContest,
      this.teamOfTheHeartOrLuckyMonth});

  LotteryAPIResult.fromJson(Map<String, dynamic> json) {
    lotteryName = json['loteria'];
    name = json['nome'];
    contestNumber = json['concurso'];
    date = json['data'];
    place = json['local'];
    numbers = json['dezenas'].cast<String>();
    if (lotteryName == "dupla-sena" && numbers != null) {
      var part1 = numbers!.sublist(0, ((numbers!.length) ~/ 2) - 1);
      var part2 = numbers!.sublist((numbers!.length) ~/ 2, numbers!.length - 1);
      numbers = part1;
      numbers_2 = part2;
    }
    if (json['premiacoes'] != null) {
      prizes = <Prizes>[];
      json['premiacoes'].forEach((v) {
        prizes!.add(new Prizes.fromJson(v));
      });
      if (lotteryName == "dupla-sena" && prizes != null) {
        var part1 = prizes!.sublist(0, ((prizes!.length) ~/ 2) - 1);
        var part2 = prizes!.sublist((prizes!.length) ~/ 2, prizes!.length - 1);
        prizes = part1;
        prizes_2 = part2;
      }
    }
    if (json['estadosPremiados'] != null) {
      winningEstates = <StateWithPrize>[];
      json['estadosPremiados'].forEach((v) {
        winningEstates!.add(new StateWithPrize.fromJson(v));
      });
    }
    accumulated = json['acumulou'] != null ? json['acumulou'] : false;
    accumulatedToNextContest = json['acumuladaProxConcurso'];
    nextContestDate = json['dataProxConcurso'];
    nextContest = json['proxConcurso'];
    teamOfTheHeartOrLuckyMonth = json['timeCoracaoOuMesSorte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loteria'] = this.lotteryName;
    data['nome'] = this.name;
    data['concurso'] = this.contestNumber;
    data['data'] = this.date;
    data['local'] = this.place;
    data['dezenas'] = this.numbers;
    if (this.prizes != null) {
      data['premiacoes'] = this.prizes!.map((v) => v.toJson()).toList();
    }
    if (this.winningEstates != null) {
      data['estadosPremiados'] =
          this.winningEstates!.map((v) => v.toJson()).toList();
    }
    data['acumulou'] = this.accumulated;
    data['acumuladaProxConcurso'] = this.accumulatedToNextContest;
    data['dataProxConcurso'] = this.nextContestDate;
    data['proxConcurso'] = this.nextContest;
    data['timeCoracao'] = this.teamOfTheHeartOrLuckyMonth;
    return data;
  }

  String getContestDataDisplayValue() {
    if (date != null) return (date!);
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

  String getNextContestEstimatedPrizeDisplayValue() {
    if (accumulatedToNextContest != null) return '${accumulatedToNextContest!}';
    return '';
  }

  String getNextContestDateDisplayValue() {
    if (nextContestDate != null) return (nextContestDate!);
    return '';
  }

  // String getValorAcumuladoEspecialDisplayValue () {
  //   if (valor_acumulado_especial != null)
  //     return formatCurrency(valor_acumulado_especial);
  //   return '';
  // }

  String getGuessNumberDisplayValue() {
    return getDezenasResultadoDisplayValue(numbers!);
  }

  String getGuessNumbers2DisplayValue() {
    return getDezenasResultadoDisplayValue(numbers_2!);
  }

  String shareString() {
    return 'Aplicativo Palpites da loteria\n'
                ' 👉 https://rb.gy/3dcmmn 🍀\n\n'
                'Resultado $name\n\n' +
            (accumulated ? 'ACUMULOU' : 'TEVE GANHADOR') +
            '\n\n' +
            (numbers != null && numbers!.isNotEmpty
                ? getGuessNumberDisplayValue() + '\n\n'
                : '') +
            (numbers_2 != null && numbers_2!.isNotEmpty
                ? getGuessNumbers2DisplayValue() + '\n\n'
                : '') +
            ((teamOfTheHeartOrLuckyMonth != '' &&
                    teamOfTheHeartOrLuckyMonth != null)
                ? '$teamOfTheHeartOrLuckyMonth \n\n'
                : '') +
            'Concurso: $contestNumber \n' +
            'Data de realização: ' +
            getContestDataDisplayValue() +
            '\n\n' +
            // 'Arrecadação total: ' + getArrecadacaoTotalDisplayValue() +'\n'
            // 'Acumulado: ' + getValorAcumuladoDisplayValue() + '\n\n'
            ((getNextContestDateDisplayValue() != '')
                ? 'Próximo concurso dia ' +
                    getNextContestDateDisplayValue() +
                    '\n'
                : '') +
            ((getNextContestEstimatedPrizeDisplayValue() != '')
                ? 'Prêmio estimado: ' +
                    getNextContestEstimatedPrizeDisplayValue() +
                    '\n'
                : '')
        //(nome_acumulado_especial != null ? 'Acumulado $nome_acumulado_especial: ' + getValorAcumuladoEspecialDisplayValue() : '')
        ;
  }
}

class Prizes {
  String? hits;
  String? winners;
  String? prize;

  Prizes({this.hits, this.winners, this.prize});

  Prizes.fromJson(Map<String, dynamic> json) {
    hits = json['acertos'];
    winners = json['vencedores'];
    prize = json['premio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acertos'] = this.hits;
    data['vencedores'] = this.winners;
    data['premio'] = this.prize;
    return data;
  }
}

class StateWithPrize {
  String? name;
  String? stateAbbreviation;
  String? winners;
  String? latitude;
  String? longitude;
  List<City>? cities;

  StateWithPrize(
      {this.name,
      this.stateAbbreviation,
      this.winners,
      this.latitude,
      this.longitude,
      this.cities});

  StateWithPrize.fromJson(Map<String, dynamic> json) {
    name = json['nome'];
    stateAbbreviation = json['uf'];
    winners = json['vencedores'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['cidades'] != null) {
      cities = <City>[];
      json['cidades'].forEach((v) {
        cities!.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.name;
    data['uf'] = this.stateAbbreviation;
    data['vencedores'] = this.winners;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.cities != null) {
      data['cidades'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  String? cityName;
  String? winners;
  String? latitude;
  String? longitude;

  City({this.cityName, this.winners, this.latitude, this.longitude});

  City.fromJson(Map<String, dynamic> json) {
    cityName = json['cidade'];
    winners = json['vencedores'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cidade'] = this.cityName;
    data['vencedores'] = this.winners;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
