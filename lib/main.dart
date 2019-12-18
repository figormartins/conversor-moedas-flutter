import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const url = "https://api.hgbrasil.com/finance?key=2805e1ae";

void main() async {
  runApp(MaterialApp(
    color: Colors.black,
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
  }
  
  class _HomeState extends State<Home> {
    @override
    Widget build(BuildContext context) {     
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Conversor"),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
      );
    }
  }

Future<Map> GetData() async {
  http.Response response = await http.get(url);
  return json.decode(response.body);
}