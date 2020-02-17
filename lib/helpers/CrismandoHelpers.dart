import 'package:crisma/model/Crismando.dart';
import 'package:crisma/model/Encontro.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CrismandoHelpers {
  static final String nomeTabela = "crismando";
  static final String nomeTabelaEncontro = "encontros";
  static final CrismandoHelpers _crismandoHelpers = CrismandoHelpers._internal();
  Database _db;


  factory CrismandoHelpers(){
    return _crismandoHelpers;
  }

  CrismandoHelpers._internal(){}

  get db async{

    if(_db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async{

    String sql= "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY, nome VARCHAR, data DATETIME)";

    String sql2= "CREATE TABLE $nomeTabelaEncontro (id INTEGER PRIMARY KEY AUTOINCREMENT, tema VARCHAR, idCrismando INTEGER, data VARCHAR, presenca BOOLEAN)";

    await db.execute(sql);

    await db.execute(sql2);

  }

  inicializarDB() async{
    final caminhoBancoDeDados = await getDatabasesPath();
    final localBancoDeDados = join(caminhoBancoDeDados,"banco_crismandos.db");

    var db = await openDatabase(
        localBancoDeDados, version: 1, onCreate: _onCreate
    );
    return db;
  }

  //Crismando

  Future<int> salvarCrismando(Crismando crismando) async{
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, crismando.toMap());
    return resultado;
  }

  listarCrismando() async{
    var bancoDados = await db;
    String sql="SELECT * FROM $nomeTabela ORDER BY UPPER(nome) DESC";
    List crismandos = await bancoDados.rawQuery(sql);
    return crismandos;

  }

  Future<int> atualizarCrismando(Crismando crismando) async{
    var bancoDados = await db;
    return await bancoDados.update(nomeTabela, crismando.toMap(), where: "id = ?", whereArgs : [crismando.id]);
  }

  Future<int> removerCrismando(int id) async{
    var bancoDados = await db;
    return await bancoDados.delete(nomeTabela,where: "id = ?", whereArgs:[id]);
  }

  listarEncontrosCrismando(int id) async{
    var bancoDados = await db;
    String sql= "SELECT tema FROM $nomeTabelaEncontro WHERE idCrismando = $id AND presenca = 1";
    List encontros = await bancoDados.rawQuery(sql);
    return encontros;
  }

  //Encontros

  Future<int> salvarEncontro(Encontro encontro) async{
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabelaEncontro, encontro.toMap());
    return resultado;
  }

  listarDatasEncontros() async{
    var bancoDados = await db;
    String sql="SELECT tema,data FROM $nomeTabelaEncontro GROUP BY data";
    List encontros = await bancoDados.rawQuery(sql);
    return encontros;
  }

  listarPresencaEncontros(String data) async{
    var bancoDados = await db;
    String sql= "SELECT encontros.id,encontros.presenca,encontros.idCrismando,crismando.nome as nomeCrismando FROM $nomeTabelaEncontro,$nomeTabela WHERE encontros.data = '$data' AND encontros.idCrismando = crismando.id";
    List encontros = await bancoDados.rawQuery(sql);
    return encontros;
  }

  Future<int> removerEncontro(String data) async{
    var bancoDados = await db;
    return await bancoDados.delete(nomeTabelaEncontro,where: "data= ?", whereArgs:[data]);
  }

  Future<int> atualizarEncontro(Encontro encontro,int id) async{
    var bancoDados = await db;
    return await bancoDados.update(nomeTabelaEncontro, encontro.toMap(), where: "id = ?", whereArgs : [id]);
  }
}