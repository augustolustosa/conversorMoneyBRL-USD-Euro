import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Segundo app",
      home: HomePage(),
      //debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController realController = new TextEditingController();
  TextEditingController dolarController = new TextEditingController();
  TextEditingController euroController = new TextEditingController();

  double dolar;
  double euro;

  void _reaisChanged(String valor){
    double real= double.parse(valor);
    dolarController.text=(real/dolar).toString();
    euroController.text=(real/euro).toStringAsFixed(2);
    print("real");
  }
  void _dollarChanged(String valor){
    double dolar= double.parse(valor);
    realController.text=(dolar*this.dolar).toStringAsFixed(2);
    euroController.text=(dolar*this.dolar/euro).toStringAsFixed(2);
    print("dollar");
  }
  void _euroChanged(String valor){
    double euro= double.parse(valor);
    realController.text=(euro*this.euro).toStringAsFixed(2);
    dolarController.text=(euro*this.euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "\$ Conversor \$",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Conectando...",
                  style: TextStyle(
                      fontSize: 19,
                      fontStyle: FontStyle.italic,
                      color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Falha na conexao",
                    style: TextStyle(
                        fontSize: 19,
                        fontStyle: FontStyle.italic,
                        color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {


                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.monetization_on,
                          color: Colors.amberAccent,
                          size: 160,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 60),
                      ),
                      formi("Real R\$", realController, _reaisChanged),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      formi("Dollar U\$", dolarController,_dollarChanged),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      formi("Euro E", euroController,_euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget formi(String nome, TextEditingController ctl, Function f) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: ctl,
      decoration: InputDecoration(
        labelText: nome,
        labelStyle: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.amberAccent,
            fontSize: 24),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber, width: 1.0),
        ),
      ),
      onChanged: f,
      style: TextStyle(color: Colors.amber, fontSize: 24),
    );
  }


}

Future<Map> getData() async {
  String link = "https://api.hgbrasil.com/finance/?key=09513569";
  http.Response resposta = await http.get(link);
  return json.decode(resposta.body);
}
