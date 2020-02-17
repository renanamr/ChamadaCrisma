import 'package:flutter/material.dart';

import 'ListaCrismando.dart';
import 'ListaEncontros.dart';
import 'NovoEncontro.dart';
import 'helpers/CrismandoHelpers.dart';
import 'model/Encontro.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crisma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Crisma'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _textoController = TextEditingController();

  var _db = CrismandoHelpers();
  BuildContext contexto;

  _exibirTelaImporteChamada() {
    _textoController.text = "";

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Importar Chamada"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _textoController,
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: "Cole o código compartilhado..."),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    _importarLista();
                    Navigator.pop(context);
                  },
                  child: Text("Importar"))
            ],
          );
        });
  }

  _importarLista() async {
    int resultado;
    String texto;

    List parametros = _textoController.text.split("^}");

    List crismandos = parametros[2].toString().split("{");

    for(int i=0; i < crismandos.length;i++){
      List<String> valores = crismandos[i].toString().split(",");

      Encontro encontro = Encontro(parametros[0],int.parse(valores[0]),
          int.parse(valores[1]), parametros[1]);
      resultado = await _db.salvarEncontro(encontro);
    }


    if(resultado != null){
      texto = "Importação realizada com sucesso.";
    }else{
      texto = "Ocorreu falha ao importar.";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey, opacity: 1),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset("assets/imagens/cmslogo.jpg"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _botaoCustomizado("Crismandos",Icons.list,(){ Navigator.push(context, MaterialPageRoute(builder: (context) => ListaCrismando()));}),
                          _botaoCustomizado("Novo Encontro",Icons.add,(){Navigator.push(context, MaterialPageRoute(builder: (context) => NovoEncontro()));})
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _botaoCustomizado("Encontros",Icons.calendar_today,(){ Navigator.push(context, MaterialPageRoute(builder: (context) => ListaEncontros()));}),
                            _botaoCustomizado("Importar Lista",Icons.import_export,(){_exibirTelaImporteChamada();})
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _botaoCustomizado(String texto,IconData icon, Function function){
    return GestureDetector(
      child: Card(
          color: Color.fromRGBO(169, 26, 54, 1),
          child: Container(
              width: 120,
              height: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(icon,color: Colors.white,size: 40,),
                  ),
                  Text(texto, style: TextStyle(color: Colors.white),)
                ],
              )
          )
      ),
      onTap: (){
        function();
      },
    );
  }
}
