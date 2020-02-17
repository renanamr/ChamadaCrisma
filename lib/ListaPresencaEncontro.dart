import 'package:flutter/material.dart';

import 'helpers/CrismandoHelpers.dart';
import 'model/Encontro.dart';
import 'package:share/share.dart';

class ListaPresencaEncontro extends StatefulWidget {

  final String data;
  final String tema;
  final bool editar;
  ListaPresencaEncontro({this.data,this.tema,this.editar});

  @override
  _ListaPresencaEncontroState createState() => _ListaPresencaEncontroState();
}

class _ListaPresencaEncontroState extends State<ListaPresencaEncontro> {

  var _db = CrismandoHelpers();
  List<Encontro> _dataEncontros = List<Encontro>();

  _alertMudarEstado(int valor,Encontro encontro,int index) {

    String texto =  valor == 1 ? "colocar PRESENÇA":"colocar FALTA";

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Mudar estado"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text("Deseja realmente $texto em ${encontro.nomeCrismando}?")],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Não")),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      _dataEncontros[index].presenca = valor;
                      _db.atualizarEncontro(Encontro(widget.tema,_dataEncontros[index].idCrismando, _dataEncontros[index].presenca, widget.data),_dataEncontros[index].id);
                    });
                   Navigator.pop(context);
                  },
                  child: Text("Sim"))
            ],
          );
        });
  }


  _listarEncontros() async {

    List cismandoRec = await _db.listarPresencaEncontros(widget.data);
    List<Encontro> listTemporaria = List<Encontro>();

    for (var item in cismandoRec) {
      Encontro encontro = Encontro.fromMap(item);
      listTemporaria.add(encontro);
    }
    setState(() {
      _dataEncontros = listTemporaria;
    });

    listTemporaria = null;
  }

  String _compartilharChamada(){
    String texto="${widget.tema}^}${widget.data}^}";

    for(int i=0; i <_dataEncontros.length; i++){
      texto = texto + "${_dataEncontros[i].idCrismando},${_dataEncontros[i].presenca}";
      if ((i+1)<_dataEncontros.length)
        texto = texto +"{";
    }
    return texto;
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
        title:Text(widget.data, style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: (){
            Share.share(_compartilharChamada());
          }),
        ],
      ),
      body:  Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _dataEncontros.length, itemBuilder: (context,index) {

                return Card(
                  child: listWidget(_dataEncontros[index],index),
                );
              }))
        ],
      )
    );
  }

  Widget listWidget(Encontro encontro,int index){
    if(widget.editar){
      return CheckboxListTile(
        value: encontro.presenca ==1 ? true: false,
        onChanged: (value){
          switch(value){
            case true:
              _alertMudarEstado(1,encontro,index);
              break;
            case false:
              _alertMudarEstado(0,encontro,index);
              break;
          }
        },
        title: Text("${encontro.nomeCrismando}", style: TextStyle(color: Colors.black),),
      );
    }else{
      return ListTile(
          title: Text("${encontro.nomeCrismando}", style: TextStyle(color: Colors.black),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(right: 2),
                child: Icon(encontro.presenca ==1 ? Icons.check: Icons.cancel, color: Colors.blueAccent,),),
            ],
          )
      );
    }
  }
}
