import 'package:flutter/material.dart';
import 'package:tp5_flutter/models/list_etudiants.dart';
import 'package:tp5_flutter/util/dbuse.dart';
import 'package:tp5_flutter/widgets/ListStudentDialog.dart';

class StudentsList extends StatefulWidget {
  final List<ListEtudiants> students;
  final Function notifyParentToChanges;
  const StudentsList({
    Key? key,
    required this.students,
    required this.notifyParentToChanges,
  }) : super(key: key);

  @override
  StudentsListState createState() => StudentsListState();
}

class StudentsListState extends State<StudentsList> {
  final dbuse _dbService = dbuse();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.students.length,
      itemBuilder: (BuildContext context, int index) {
        ListEtudiants student = widget.students[index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) async {
            List<ListEtudiants> newStudents = widget.students
                .where(
                  (stdt) => stdt.id != student.id ,
                )
                .toList();
            await _dbService.deleteStudent(student.id);
            widget.notifyParentToChanges(newStudents);
          },
          child: ListTile(
            title: Text(
              '${student.prenom} ${student.nom}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('date naissance :  ${student.datNais}'),
             trailing: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
              IconButton(
               icon: const Icon(Icons.edit),
                onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ListStudentDialog(
                    student: student,
                    classroomId: student.codClass,
                    onChanged: (respStudent) {
                      List<ListEtudiants> students = widget.students.map(
                        (stud) {
                          if (stud.id == respStudent.id) {
                            stud = respStudent;
                          }
                          return stud;
                        },
                      ).toList();
                      widget.notifyParentToChanges(students);
                    },
                  ),
                );
              },
            ),
               IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  String strName = student.nom;
                  await _dbService.deleteStudent(student.id);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$strName deleted"),backgroundColor: Colors.deepOrange,));
                List<ListEtudiants> students = widget.students
                    .where(
                      (studenr) => studenr.id != student.id,
                )
                    .toList();
                widget.notifyParentToChanges(students);
              },
            ),
            ],
             ),
          ),
        );
      },
    );
  }
}
