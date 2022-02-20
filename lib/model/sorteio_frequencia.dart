/* Generated from
{"Frequencias":[{"Dezena":14,"Quantidade":308},{"Dezena":39,"Quantidade":306},{"Dezena":33,"Quantidade":302},{"Dezena":36,"Quantidade":299},{"Dezena":45,"Quantidade":298},{"Dezena":47,"Quantidade":298},{"Dezena":19,"Quantidade":298},{"Dezena":30,"Quantidade":297},{"Dezena":49,"Quantidade":295},{"Dezena":46,"Quantidade":294},{"Dezena":31,"Quantidade":294},{"Dezena":11,"Quantidade":290},{"Dezena":4,"Quantidade":289},{"Dezena":18,"Quantidade":288},{"Dezena":25,"Quantidade":288},{"Dezena":42,"Quantidade":288},{"Dezena":3,"Quantidade":286},{"Dezena":10,"Quantidade":286},{"Dezena":20,"Quantidade":285},{"Dezena":44,"Quantidade":285},{"Dezena":26,"Quantidade":283},{"Dezena":21,"Quantidade":282},{"Dezena":32,"Quantidade":282},{"Dezena":12,"Quantidade":282},{"Dezena":6,"Quantidade":281},{"Dezena":8,"Quantidade":280},{"Dezena":5,"Quantidade":279},{"Dezena":41,"Quantidade":279},{"Dezena":15,"Quantidade":278},{"Dezena":9,"Quantidade":276},{"Dezena":35,"Quantidade":276},{"Dezena":24,"Quantidade":275},{"Dezena":28,"Quantidade":275},{"Dezena":40,"Quantidade":275},{"Dezena":38,"Quantidade":274},{"Dezena":50,"Quantidade":273},{"Dezena":34,"Quantidade":271},{"Dezena":29,"Quantidade":270},{"Dezena":23,"Quantidade":270},{"Dezena":7,"Quantidade":269},{"Dezena":16,"Quantidade":269},{"Dezena":43,"Quantidade":267},{"Dezena":17,"Quantidade":260},{"Dezena":1,"Quantidade":258},{"Dezena":13,"Quantidade":257},{"Dezena":22,"Quantidade":257},{"Dezena":2,"Quantidade":256},{"Dezena":27,"Quantidade":253},{"Dezena":37,"Quantidade":252},{"Dezena":48,"Quantidade":237}],"Frequencias2":[{"Dezena":35,"Quantidade":323},{"Dezena":36,"Quantidade":313},{"Dezena":46,"Quantidade":301},{"Dezena":49,"Quantidade":299},{"Dezena":42,"Quantidade":296},{"Dezena":30,"Quantidade":295},{"Dezena":18,"Quantidade":294},{"Dezena":13,"Quantidade":293},{"Dezena":22,"Quantidade":292},{"Dezena":2,"Quantidade":291},{"Dezena":5,"Quantidade":290},{"Dezena":43,"Quantidade":289},{"Dezena":21,"Quantidade":288},{"Dezena":9,"Quantidade":287},{"Dezena":38,"Quantidade":287},{"Dezena":48,"Quantidade":287},{"Dezena":32,"Quantidade":286},{"Dezena":12,"Quantidade":285},{"Dezena":39,"Quantidade":285},{"Dezena":45,"Quantidade":284},{"Dezena":31,"Quantidade":281},{"Dezena":23,"Quantidade":281},{"Dezena":25,"Quantidade":281},{"Dezena":37,"Quantidade":280},{"Dezena":6,"Quantidade":279},{"Dezena":47,"Quantidade":277},{"Dezena":33,"Quantidade":275},{"Dezena":7,"Quantidade":274},{"Dezena":8,"Quantidade":272},{"Dezena":11,"Quantidade":272},{"Dezena":20,"Quantidade":272},{"Dezena":50,"Quantidade":272},{"Dezena":19,"Quantidade":271},{"Dezena":3,"Quantidade":270},{"Dezena":14,"Quantidade":269},{"Dezena":10,"Quantidade":268},{"Dezena":17,"Quantidade":268},{"Dezena":44,"Quantidade":268},{"Dezena":16,"Quantidade":267},{"Dezena":24,"Quantidade":266},{"Dezena":26,"Quantidade":266},{"Dezena":27,"Quantidade":266},{"Dezena":34,"Quantidade":265},{"Dezena":29,"Quantidade":265},{"Dezena":15,"Quantidade":265},{"Dezena":40,"Quantidade":265},{"Dezena":41,"Quantidade":264},{"Dezena":28,"Quantidade":262},{"Dezena":1,"Quantidade":258},{"Dezena":4,"Quantidade":257}]}*/

class SorteioFrequencia {
  List<Frequencias>? frequencias;
  List<Frequencias>? frequencias2;

  SorteioFrequencia({this.frequencias, this.frequencias2});

  SorteioFrequencia.fromJson(Map<String, dynamic> json) {
    if (json['Frequencias'] != null) {
      frequencias = <Frequencias>[];
      json['Frequencias'].forEach((v) {
        frequencias?.add(new Frequencias.fromJson(v));
      });
    }
    if (json['Frequencias2'] != null) {
      frequencias2 = <Frequencias>[];
      json['Frequencias2'].forEach((v) {
        frequencias2?.add(new Frequencias.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.frequencias != null) {
      data['Frequencias'] = this.frequencias?.map((v) => v.toJson()).toList();
    }
    if (this.frequencias2 != null) {
      data['Frequencias2'] = this.frequencias2?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Frequencias {
  int? dezena;
  int? quantidade;

  Frequencias({this.dezena, this.quantidade});

  Frequencias.fromJson(Map<String, dynamic> json) {
    dezena = json['Dezena'];
    quantidade = json['Quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Dezena'] = this.dezena;
    data['Quantidade'] = this.quantidade;
    return data;
  }
}