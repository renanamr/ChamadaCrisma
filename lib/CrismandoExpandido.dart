import 'package:flutter/material.dart';

import 'helpers/CrismandoHelpers.dart';

class CrismandoExpandido extends StatefulWidget {

  final int id;
  CrismandoExpandido({this.id});

  @override
  _CrismandoExpandidoState createState() => _CrismandoExpandidoState();
}

class _CrismandoExpandidoState extends State<CrismandoExpandido> {

  var _db = CrismandoHelpers();
  List<String> _temaEncontros = List<String>();


  _listarEncontros() async {

    List temaRec = await _db.listarEncontrosCrismando(widget.id);
    List<String> listTemporaria = List<String>();

    for (var item in temaRec) {
      listTemporaria.add(item["tema"]);
    }
    setState(() {
      _temaEncontros = listTemporaria;
    });

    listTemporaria = null;
  }

  @override
  void initState() {
    super.initState();
    _listarEncontros();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey, opacity: 1),
        backgroundColor: Colors.white,
        centerTitle: true,
        title:Image.asset("assets/imagens/cmslogo.jpg"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _temaEncontros.length, itemBuilder: (context,index) {

                final encontro = _temaEncontros[index];

                return Card(
                  child: ListTile(
                    title: Text("${encontro}", style: TextStyle(color: Colors.black),),
                  ),
                );
              }))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
