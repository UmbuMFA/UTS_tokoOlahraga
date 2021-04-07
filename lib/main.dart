import 'package:flutter/material.dart';
import 'package:uts_toko_olahraga/Home.dart';
import 'package:uts_toko_olahraga/Login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
   final routes = <String, WidgetBuilder>{
    Login.tag: (context) => Login(),
    Home.tag: (context) => Home(),
    };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Item List',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Login(),
      routes: routes,
    );
  }
}
