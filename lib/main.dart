import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

const url = "https://api.hgbrasil.com/finance?key=2805e1ae";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.indigo[400],
      primaryColor: Colors.indigo[200],
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    if (text.isEmpty)
      return;

    if (double.tryParse(text) != null) {
      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);

      return;
    }
    realController.text = validNumber(text);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty)
      return;

    if (double.tryParse(text) != null) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

      return;
    }

    dolarController.text = validNumber(text);
  }

  void _euroChanged(String text) {
    if (text.isEmpty)
      return;

    if (double.tryParse(text) != null) {
      double euro = double.parse(text);
      realController.text = (this.euro * euro).toStringAsFixed(2);
      dolarController.text = (this.euro * euro / dolar).toStringAsFixed(2);

      return;
    }

    euroController.text = validNumber(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Conversor",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple[900],
        centerTitle: true,
      ),
      body: Container(
        height: 1000.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
            stops: [0.1, 0.4, 0.7],
            colors: [
              Colors.indigo[200],
              Colors.indigo[100],
              Colors.indigo[50],
            ],
          ),
        ),
        child: FutureBuilder<Map>(
            future: GetData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Loading(
                        indicator: BallPulseIndicator(),
                        size: 40.0,
                        color: Colors.deepPurple[900]),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar",
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset(
                            "images/coin_image.png",
                            height: 200.0,
                          ),
                          buildTextField(
                              "Real", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField(
                              "Dólar", "RS\$", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField(
                              "Euro", "€", euroController, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            }),
      ),
    );
  }
}

Future<Map> GetData() async {
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

Widget buildTextField(
    String label, String prefix, TextEditingController control, Function func) {
  return TextField(
    controller: control,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.indigo[300],
      ),
      border: OutlineInputBorder(),
      prefixText: "${prefix} ",
    ),
    style: TextStyle(
      color: Colors.indigo[600],
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
    ),
    onChanged: func,
    keyboardType: TextInputType.number,
  );
}

String validNumber(String number) {
  String aux = "";

  for (int i = 0; i < number.length; i++) {
    if (number[i] == "," || number[i] == "," || int.tryParse(number[i]) != null)
      aux += number[i];
  }

  return aux;
}
