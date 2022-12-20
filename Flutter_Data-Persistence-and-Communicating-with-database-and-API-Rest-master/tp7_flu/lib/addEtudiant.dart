import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'Student.dart';

class AddEtudiant extends StatefulWidget {
  const AddEtudiant({Key? key}) : super(key: key);

  @override
  _AddEtudiantState createState() => _AddEtudiantState();
}

class _AddEtudiantState extends State<AddEtudiant> {
  final _formKey = GlobalKey<FormState>();

  String? newValue;
  int? _Student;
  String? newValue1;
  Student student = Student("", "", "", "", "");
  String url = "http://192.168.43.143:8080/etudiants";

  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController date_nais = TextEditingController();
  final df = DateFormat('yyyy-MM-dd');
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1995),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      date_nais.text = df.format(pickedDate);
    }
  }
  Future save(Student) async {
    print(Student.nom);
    print(Student.prenom);
    print(Student.date_nais);
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nom': Student.nom,
          'prenom': Student.prenom,
          'dateNais': Student.date_nais,
          'classe_cod_class': '1',
          'formation_id': '1'
        }));
    print(res.body);
    if (res.body != null) {
      Navigator.pop(context);
    }
  }



  //TextEditingController classe_cod_class = TextEditingController();
  //TextEditingController formation_id = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Page')),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 570.0,
                            width: 340.0,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      "Add Student",
                                      style: GoogleFonts.acme(fontSize: 30),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                        controller: nom,
                                        decoration: InputDecoration(
                                          hintText: "Nom",
                                          border: OutlineInputBorder(),
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                        controller: prenom,
                                        decoration: InputDecoration(
                                          hintText: "Prenom",
                                          border: OutlineInputBorder(),
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                        controller: date_nais,
                                        decoration: InputDecoration(
                                          hintText: "Date Naissance",
                                          border: OutlineInputBorder(),
                                        ),onTap: () {
                                      _selectDate(context);
                                    }),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    new DropdownButton<String>(
                                        items: <String>[''].map((String value) {
                                          //La fonction crée un objet qui aura la même valeur et le même texte, à partir du tableau d'objet
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (_) {},
                                        value: 'rouge'
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState == null) {}
                                          if (_formKey.currentState!
                                              .validate()) {
                                            save(Student(nom.text, prenom.text,
                                                date_nais.text, "", ""));
                                          }
                                        },
                                        child: Text("Add"))
                                  ],
                                )),
                          ),
                        ])))));
  }
}
