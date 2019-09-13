class Concursos {
  List<Concurso> concursos;

  Concursos({this.concursos});

  Concursos.fromJson(Map<String, dynamic> json) {
    this.concursos = (json['concursos'] as List) != null
        ? (json['concursos'] as List).map((i) => Concurso.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concursos'] = this.concursos != null
        ? this.concursos.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class Concurso {
  String name;
  String color;
  bool enabled;
  int position;
  int totalSize;
  int minSize;
  int maxSize;

  Concurso(
      {this.name,
      this.color,
      this.enabled,
      this.position,
      this.totalSize,
      this.minSize,
      this.maxSize});

  Concurso.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.color = json['color'];
    this.enabled = json['enabled'];
    this.position = json['position'];
    this.totalSize = json['totalSize'];
    this.minSize = json['minSize'];
    this.maxSize = json['maxSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['color'] = this.color;
    data['enabled'] = this.enabled;
    data['position'] = this.position;
    data['totalSize'] = this.totalSize;
    data['minSize'] = this.minSize;
    data['maxSize'] = this.maxSize;
    return data;
  }
}
