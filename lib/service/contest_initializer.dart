import 'package:palpites_da_loteria/model/contest.dart';

class ContestInitializer {
  List<Contest> all() {
    Contest megaSena = Contest(
        id: 1,
        name: "MG. SENA",
        enabled: true,
        spaceStart: 1,
        spaceEnd: 60,
        minSize: 6,
        maxSize: 15,
        color: 0x209869,
        sortOrder: 0);

    Contest lotoFacil = Contest(
        id: 2,
        name: "LT. FÁCIL",
        enabled: true,
        spaceStart: 1,
        spaceEnd: 25,
        minSize: 15,
        maxSize: 20,
        color: 0x954389,
        sortOrder: 1);

    Contest quina = Contest(
        id: 3,
        name: "QN",
        enabled: true,
        spaceStart: 1,
        spaceEnd: 80,
        minSize: 5,
        maxSize: 15,
        color: 0x2d3985,
        sortOrder: 2);

    Contest lotoMania = Contest(
        id: 4,
        name: "LT. MANIA",
        enabled: true,
        spaceStart: 0,
        spaceEnd: 99,
        minSize: 50,
        maxSize: 50,
        color: 0xf7844a,
        sortOrder: 3);

    Contest timeMania = Contest(
        id: 5,
        name: "TM. MANIA",
        enabled: true,
        spaceStart: 1,
        spaceEnd: 80,
        minSize: 10,
        maxSize: 10,
        color: 0x5ee84f,
        sortOrder: 4);

    Contest duplaSena = Contest(
        id: 6,
        name: "D. SENA",
        enabled: true,
        spaceStart: 1,
        spaceEnd: 50,
        minSize: 6,
        maxSize: 15,
        color: 0xa62a31,
        sortOrder: 5);

    Contest diaDeSorte = Contest(
        id: 7,
        name: "D. DE SORTE",
        enabled: true,
        spaceStart: 1,
        spaceEnd: 31,
        minSize: 7,
        maxSize: 15,
        color: 0xcb853b,
        sortOrder: 6);

    return [
      megaSena,
      lotoFacil,
      quina,
      lotoMania,
      timeMania,
      duplaSena,
      diaDeSorte
    ];
  }
}
