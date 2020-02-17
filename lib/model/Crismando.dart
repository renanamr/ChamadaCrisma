class Crismando{

  int id;
  String nome;
  String data;

  Crismando(this.id,this.nome,this.data);

  Crismando.fromMap(Map map){
    this.id = map["id"];
    this.nome = map["nome"];
    this.data = map["data"];

  }

  Map toMap(){
    Map<String,dynamic> map = {
      "id" : this.id,
      "nome" : this.nome,
      "data" : this.data
    };
    return map;
  }

}