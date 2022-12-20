import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp5_flutter/models/list_etudiants.dart';
import 'package:tp5_flutter/util/dbuse.dart';

class ListStudentDialog extends StatelessWidget {
  final ListEtudiants? student;
  final int classroomId;
  final ValueChanged<ListEtudiants> onChanged;
  const ListStudentDialog({
    Key? key,
    this.student,
    required this.classroomId,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late bool isNew = student == null ? true : false;
    final firstNameController = TextEditingController(
      text: student == null ? '' : student!.nom,
    );
    final lastNameController = TextEditingController(
      text: student == null ? '' : student!.prenom,
    );
    final dateTextController = TextEditingController(
      text: student == null ? '' : student!.datNais,
    );

    final df = DateFormat('dd-MM-yyyy');
    final dbuse _dbService = dbuse();
    DateTime selectedDate = DateTime.now();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1995),
        lastDate: DateTime(2050),
      );
      if (pickedDate != null && pickedDate != selectedDate) {
        dateTextController.text = df.format(pickedDate);
      }
    }

    log("Building view!");
    return AlertDialog(
      title: Text(isNew ? 'Ajouter un étudiant' : 'modifier un étudiant'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                hintText: "prenom",
              ),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                hintText: "nom",
              ),
            ),
            TextField(
              controller: dateTextController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "date naissance",
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                late ListEtudiants myStudent;
                switch (isNew) {
                  case true: // -- Create a new student
                    if (firstNameController.text.isEmpty ||
                        lastNameController.text.isEmpty ||
                        dateTextController.text.isEmpty) {
                      // Maybe show a toast or sth
                      // Close the dialog without proceeding
                      return Navigator.pop(context);
                    }
                    myStudent = await _dbService.createStudent(
                      lastNameController.text,
                      firstNameController.text,
                      dateTextController.text,
                      classroomId,
                    );
                    break;
                  case false: // -- Update an existing student
                    myStudent = await _dbService.updateStudent(
                      student!.id,
                      lastNameController.text,
                      firstNameController.text,
                      dateTextController.text,
                      classroomId,
                    );
                    break;
                }
                // -- Forward change to parent
                onChanged(myStudent);
                // -- Close the dialog
                Navigator.pop(context);
              },
              child: Text(isNew ? 'Ajouter' : 'Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
