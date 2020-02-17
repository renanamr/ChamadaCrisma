import 'package:flutter/material.dart';

import 'ListaPresencaEncontro.dart';
import 'helpers/CrismandoHelpers.dart';


class ListaEncontros extends StatefulWidget {
  @override
  _ListaEncontrosState createState() => _ListaEncontrosState();
}

class _ListaEncontrosState extends State<ListaEncontros> {

  var _db = CrismandoHelpers();
  List<Map> _dataEncontros = List<Map>();


  _listarEncontros() async {

    List dataRec = await _db.listarDatasEncontros();
    List<Map> listTemporaria = List<Map>();

    for (var item in dataRec) {
      Map<String,dynamic> map = {
        "data" : item["data"],
        "tema" : item["tema"]
      };
      listTemporaria.add(map);
    }
    setState(() {
      _dataEncontros = listTemporaria;
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
                  itemCount: _dataEncontros.length, itemBuilder: (context,index) {

                final encontro = _dataEncontros[index];

                return Card(
                  child: ListTile(
                    onTap: () {
                      _opcoesEncontros(context, index,encontro);
                      },
                    title: Text("${encontro["data"]} - ${encontro["tema"]}",style: TextStyle(color: Colors.black),),
                  ),
                );
              }))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _opcoesEncontros(BuildContext context, int index,Map encontro){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Visualizar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ListaPresencaEncontro(data: encontro["data"], tema: encontro["tema"],editar: false,)));
                          },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListaPresencaEncontro(data: encontro["data"], tema: encontro["tema"],editar: true,)));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          setState(() {
                            Navigator.pop(context);
                            _db.removerEncontro(encontro["data"]);
                            _listarEncontros();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

}
