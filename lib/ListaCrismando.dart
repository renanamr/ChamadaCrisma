import 'package:flutter/material.dart';

import 'CrismandoExpandido.dart';
import 'helpers/CrismandoHelpers.dart';
import 'model/Crismando.dart';

class ListaCrismando extends StatefulWidget {
  @override
  _ListaCrismandoState createState() => _ListaCrismandoState();
}

class _ListaCrismandoState extends State<ListaCrismando> {
  TextEditingController _nomeController = TextEditingController();

  var _db = CrismandoHelpers();
  List<Crismando> _crismando = List<Crismando>();

  _exibirTelaCadastro() {
    _nomeController.text = "";

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adicionar Crismando"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nomeController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Nome", hintText: "Digite o nome..."),
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
                    _salvarCrismando();
                    Navigator.pop(context);
                  },
                  child: Text("Adicionar"))
            ],
          );
        });
  }

  _listarCrismandos() async {
    List cismandoRec = await _db.listarCrismando();
    List<Crismando> listTemporaria = List<Crismando>();

    for (var item in cismandoRec) {
      Crismando crismando = Crismando.fromMap(item);
      listTemporaria.add(crismando);
    }
    setState(() {
      _crismando = listTemporaria;
    });

    listTemporaria = null;
  }

  _salvarCrismando() async {
    String nome = _nomeController.text;

    Crismando crismando = Crismando((_crismando.length+1),
        nome, DateTime.now().toString());
    int resultado = await _db.salvarCrismando(crismando);

    _nomeController.clear();

    _listarCrismandos();
  }

  @override
  void initState() {
    super.initState();
    _listarCrismandos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey, opacity: 1),
        backgroundColor: Colors.white,
        centerTitle: true,
        title:Image.asset("assets/imagens/cmslogo.jpg"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: _exibirTelaCadastro),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _crismando.length, itemBuilder: (context,index) {

                final crismando = _crismando[index];

                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CrismandoExpandido(id: crismando.id,)));
                    },
                    title: Text("${index+1} - ${crismando.nome}", style: TextStyle(color: Colors.black),),
                  ),
                );
              }))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
