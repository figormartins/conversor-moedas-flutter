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
        //height: MediaQuery.of(context).size.height,
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
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Real",
                              labelStyle: TextStyle(
                                color: Colors.indigo[300],
                              ),
                              border: OutlineInputBorder(),
                              prefixText: "R\$ ",
                            ),
                            style: TextStyle(
                              color: Colors.indigo[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Divider(),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Dólar",
                              labelStyle: TextStyle(
                                color: Colors.indigo[300],
                              ),
                              border: OutlineInputBorder(),
                              prefixText: "RS\$ ",
                            ),
                            style: TextStyle(
                              color: Colors.indigo[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Divider(),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Euro",
                              labelStyle: TextStyle(
                                color: Colors.indigo[300],
                              ),
                              border: OutlineInputBorder(),
                              prefixText: "€ ",
                            ),
                            style: TextStyle(
                              color: Colors.indigo[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),                          
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
