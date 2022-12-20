import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tp5_flutter/models/scol_list.dart';
import 'package:tp5_flutter/util/dbuse.dart';
import 'package:tp5_flutter/widgets/classroom_dialog.dart';
import 'package:tp5_flutter/widgets/classrooms_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final dbuse _dbuse = dbuse();
  List<ScolList>? classrooms;
  late double _numberFrom;

  var fromUnits = [
    'Meters',
    'Kilometer',
    'Grams',
    'Kilograms (kg)',
    'Feet',
    'Miles',
    'Pounds (lbs)',
    'ounces'
  ];
  @override
  void initState() {
    _numberFrom = 0;
    super.initState();
  }
  onClassroomsChange(List<ScolList> newList) {
    setState(() {
      classrooms = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    logDBPpath();
    var fruits = ['Orange', 'Apple', 'Strawberry', 'Banana'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion classes"),
      ),
      body: FutureBuilder(
        future: _dbuse.getClassrooms(),
        builder: (context, AsyncSnapshot<List<ScolList>> snapshot) {
          if (snapshot.hasData) {
            classrooms = classrooms ?? snapshot.data!;
            return ClassroomsList(
              classrooms: classrooms!,
              child: Column(
                children: [
                  TextField(
                    onChanged: (text) {
                      var rv = double.tryParse(text);
                      if (rv != null) {
                        setState(() {
                          _numberFrom = rv;
                        });
                      }
                    },
                  ),
                  Text((_numberFrom == null) ? '' : _numberFrom.toString())
                ],
              ),
              notifyParentToChanges: onClassroomsChange,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ClassroomDialog(
              onChanged: (e) {
                setState(() {
                  classrooms!.add(e);
                });
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future logDBPpath() async {
    String dbpath = await _dbuse.getDBPath("maBase.db");
    log(dbpath);
  }
}
