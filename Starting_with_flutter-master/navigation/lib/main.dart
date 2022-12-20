import 'package:flutter/material.dart';
import 'package:navigation/Screen1.dart';
import 'package:navigation/routes.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: PageRoutes().routeMaker(),
      initialRoute: PageRoutes.screen1_page,
    );
  }
}
