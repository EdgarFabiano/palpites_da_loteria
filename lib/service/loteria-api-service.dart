
class LoteriaAPIService {
  static String server = "https://apiloterias.com.br/app/resultado";
  static String token = "d8Kdf33jLdJdfK2";

  // Returns the url path for the concurso name
  static String getEndpointFor(String concursoName) {
    return server +
        "?loteria=" +
        getConcursoEnpointNameFor(concursoName) +
        "&token=" +
        token;
  }

  // Returns the name to be used on the API loterias based on the concurso's
  // name provided on the Json file "baseline.json".
  static String getConcursoEnpointNameFor(String concursoName) {
    switch (concursoName) {
      case "MEGA-SENA":
        return "megasena";
      case "LOTOFÁCIL":
        return "lotofacil";
      case "QUINA":
        return "quina";
      case "LOTOMANIA":
        return "lotomania";
      case "TIMEMANIA":
        return "timemania";
      case "DUPLA SENA":
        return "duplasena";
      case "DIA DE SORTE":
        return "diadesorte";
      default:
        return null;
    }
  }
}
