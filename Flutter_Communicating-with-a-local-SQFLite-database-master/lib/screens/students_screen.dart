import 'package:flutter/material.dart';
import 'package:tp5_flutter/models/scol_list.dart';
import 'package:tp5_flutter/models/list_etudiants.dart';
import 'package:tp5_flutter/util/dbuse.dart';
import 'package:tp5_flutter/widgets/ListStudentDialog.dart';
import 'package:tp5_flutter/widgets/students_list.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;
  const StudentsScreen({Key? key, required this.scolList}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final dbuse _dbService = dbuse();
  List<ListEtudiants>? students;

  onStudentsChange(List<ListEtudiants> newStudents) {
    setState(() {
      students = newStudents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scolList.nomClass),
      ),
      body: FutureBuilder(
        future: _dbService.getStudents(widget.scolList.codClass),
        builder: (context, AsyncSnapshot<List<ListEtudiants>> snapshot) {
          if (snapshot.hasData) {
            students = students ?? snapshot.data!;
            return StudentsList(
              students: students!,
              notifyParentToChanges: onStudentsChange,
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
            builder: (context) => ListStudentDialog(
              classroomId: widget.scolList.codClass,
              onChanged: (e) {
                setState(() {
                  students!.add(e);
                });
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
