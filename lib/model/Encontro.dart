class Encontro{

  int id;
  int idCrismando;
  int presenca;
  String data;
  String tema;
  String nomeCrismando;

  Encontro(this.tema,this.idCrismando,this.presenca,this.data);

  Encontro.fromMap(Map map){
    this.id = map["id"];
    this.idCrismando = map["idCrismando"];
    this.presenca = map["presenca"];
    this.data = map["data"];
    this.tema = map["tema"];
    this.nomeCrismando = map["nomeCrismando"];
  }



  Map toMap(){
    Map<String,dynamic> map = {
      "idCrismando" : this.idCrismando,
      "presenca" : this.presenca,
      "data" : this.data,
      "tema" : this.tema
    };
    return map;
  }

}