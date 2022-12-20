import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../addEtudiant.dart';
import 'listeClasses.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic>? listEtudiants;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
        primary: Theme.of(context).colorScheme.onBackground);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEtudiant()));
            },
            child: const Text('+ Add'),

          ),

        ],
      ),
      body: Center(
        child: this.listEtudiants == null
            ? CircularProgressIndicator()
            : ListView.builder(

            itemCount: (this.listEtudiants == null)
                ? 0
                : this.listEtudiants!.length,
            itemBuilder: (context, index) {
              return Card(
                  color: Colors.amber,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(this.listEtudiants![index]['nom']

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(this.listEtudiants![index]['prenom']
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>listeClasses()));
                          },
                          child: Text(
                            "Liste Classes?",
                        ),
                      )
                      ),
                    ],
                  ));
            }),
      ),
    );
  }

  void getEtudiants() {
    String url = "http://192.168.43.143:8080/etudiants";
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        this.listEtudiants = json.decode(resp.body)['_embedded']['etudiants'];
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEtudiants();
  }
}
