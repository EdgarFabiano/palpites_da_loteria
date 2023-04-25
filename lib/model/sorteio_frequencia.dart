/* Generated from
{"frequencias":[{"dezena":39,"quantidade":311}],"frequencias2":[{"dezena":35,"quantidade":324}],"qtdConcursos":2366}*/

class FrequencyDraw {
  List<Frequency> frequencies = [];
  List<Frequency>? frequencies_2;
  int contestQuantity = 0;

  FrequencyDraw(
      {required this.frequencies, this.frequencies_2, this.contestQuantity = 0});

  static FrequencyDraw empty() {
    return FrequencyDraw(frequencies: []);
  }

  FrequencyDraw.fromJson(Map<String, dynamic> json) {
    if (json['frequencias'] != null) {
      frequencies = <Frequency>[];
      json['frequencias'].forEach((v) {
        frequencies.add(new Frequency.fromJson(v));
      });
    }
    if (json['frequencias2'] != null) {
      frequencies_2 = <Frequency>[];
      json['frequencias2'].forEach((v) {
        frequencies_2!.add(new Frequency.fromJson(v));
      });
    }
    contestQuantity = json['qtdConcursos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frequencias'] = this.frequencies.map((v) => v.toJson()).toList();
    if (this.frequencies_2 != null) {
      data['frequencias2'] = this.frequencies_2!.map((v) => v.toJson()).toList();
    }
    data['qtdConcursos'] = this.contestQuantity;
    return data;
  }
}

class Frequency {
  int number = 0;
  int? quantity;

  Frequency({required this.number, this.quantity});

  Frequency.fromJson(Map<String, dynamic> json) {
    number = json['dezena'] == null ? 0 : json['dezena'];
    quantity = json['quantidade'] == null ? 0 : json['quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dezena'] = this.number;
    data['quantidade'] = this.quantity;
    return data;
  }
}
