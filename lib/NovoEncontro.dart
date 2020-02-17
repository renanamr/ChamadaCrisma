import 'package:flutter/material.dart';

import 'helpers/CrismandoHelpers.dart';
import 'model/Crismando.dart';
import 'model/Encontro.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NovoEncontro extends StatefulWidget {
  @override
  _NovoEncontroState createState() => _NovoEncontroState();
}

class _NovoEncontroState extends State<NovoEncontro> {
  var _db = CrismandoHelpers();
  bool existe = false;

  TextEditingController _temaController = TextEditingController();

  List<Crismando> _crismando = List<Crismando>();
  List<bool> presenca = List<bool>();

  _listarCrismandos() async {
    List cismandoRec = await _db.listarCrismando();
    List<Crismando> listTemporaria = List<Crismando>();

    for (var item in cismandoRec) {
      Crismando crismando = Crismando.fromMap(item);
      presenca.add(false);
      listTemporaria.add(crismando);
    }
    setState(() {
      _crismando = listTemporaria;
    });

    listTemporaria = null;
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");

    //var formatador = DateFormat("y/MM/d");
    var formatador = DateFormat.yMd("pt_BR");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

   _presencaExistente() async {
    List data = await _db.listarPresencaEncontros(_formatarData(DateTime.now().toString()));
    if(data.length>0){
      setState(() {
        existe = true;
      });
    }


    return data.length;
  }

  _alertChamada() {

    String titulo =  existe ? "Já existe uma chamada nesta data!":"Confirmar Chamada";

    titulo = _temaController.text.isEmpty ? "Tema não definido!":titulo;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text("Deseja realmente finalizar chamada?")],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Não")),
              FlatButton(
                  onPressed: () {
                    _salvarChamada();
                    Navigator.pop(context);
                  },
                  child: Text("Sim"))
            ],
          );
        });
  }

  _salvarChamada() async {
    int resultado;

    for (int i = 0; i <= _crismando.length; i++) {
      Encontro encontro = Encontro(_temaController.text, _crismando[i].id,
          presenca[i] ? 1 : 0, _formatarData(DateTime.now().toString()));
      resultado = await _db.salvarEncontro(encontro);
    }

  }

  @override
  void initState() {
    super.initState();
    _listarCrismandos();
    _presencaExistente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey, opacity: 1),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset("assets/imagens/cmslogo.jpg"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed:_alertChamada)
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Tema",
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.blueAccent),
              controller: _temaController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _crismando.length,
                  itemBuilder: (context, index) {
                    final crismando = _crismando[index];

                    return CheckboxListTile(
                      title: Text("${crismando.nome}"),
                      value: presenca[index],
                      secondary: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        setState(() {
                          presenca[index] = value;
                        });
                      },
                    );
                  }))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
