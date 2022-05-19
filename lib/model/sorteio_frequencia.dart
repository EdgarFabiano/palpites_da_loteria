/* Generated from
{"frequencias":[{"dezena":39,"quantidade":311}],"frequencias2":[{"dezena":35,"quantidade":324}],"qtdConcursos":2366}*/

class SorteioFrequencia {
  List<Frequencia> frequencias = [];
  List<Frequencia>? frequencias2;
  int? qtdConcursos;

  SorteioFrequencia(
      {required this.frequencias, this.frequencias2, this.qtdConcursos});

  static SorteioFrequencia empty() {
    return SorteioFrequencia(frequencias: []);
  }

  SorteioFrequencia.fromJson(Map<String, dynamic> json) {
    if (json['frequencias'] != null) {
      frequencias = <Frequencia>[];
      json['frequencias'].forEach((v) {
        frequencias.add(new Frequencia.fromJson(v));
      });
    }
    if (json['frequencias2'] != null) {
      frequencias2 = <Frequencia>[];
      json['frequencias2'].forEach((v) {
        frequencias2!.add(new Frequencia.fromJson(v));
      });
    }
    qtdConcursos = json['qtdConcursos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frequencias'] = this.frequencias.map((v) => v.toJson()).toList();
    if (this.frequencias2 != null) {
      data['frequencias2'] = this.frequencias2!.map((v) => v.toJson()).toList();
    }
    data['qtdConcursos'] = this.qtdConcursos;
    return data;
  }
}

class Frequencia {
  int dezena = 0;
  int? quantidade;

  Frequencia({required this.dezena, this.quantidade});

  Frequencia.fromJson(Map<String, dynamic> json) {
    dezena = json['dezena'] == null ? 0 : json['dezena'];
    quantidade = json['quantidade'] == null ? 0 : json['quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dezena'] = this.dezena;
    data['quantidade'] = this.quantidade;
    return data;
  }
}
