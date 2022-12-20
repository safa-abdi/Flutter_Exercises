import 'package:flutter/material.dart';
import 'package:tp5_flutter/models/scol_list.dart';
import 'package:tp5_flutter/util/dbuse.dart';

class ClassroomDialog extends StatelessWidget {
  final ScolList? classroom;
  final ValueChanged<ScolList> onChanged;
  const ClassroomDialog({
    Key? key,
    this.classroom,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNew = classroom == null ? true : false;
    final nameController = TextEditingController(
      text: classroom == null ? '' : classroom!.nomClass,
    );
    final nbrController = TextEditingController(
      text: classroom == null ? '' : classroom!.nbreEtud,
    );
    /*
    final nbreController = TextEditingController(
      text: classroom == null ? '' : classroom!.nbreEtud.toString(),
    );
    */

    dbuse _dbService = dbuse();
    return AlertDialog(
      title: Text(isNew ? 'Ajouter un classe ' : 'Modifier un classe'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "nom du classe",
              ),
            ),
            TextField(
              controller: nbrController,
              decoration: const InputDecoration(
                hintText: "nombre des etudiants",
              ),
            ),
            /*
            TextField(
              controller: nbreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "nombre des etudiants",
              ),
            ),
            */
            ElevatedButton(
              onPressed: () async {
                late ScolList myClassroom;
                switch (isNew) {
                  case true: // -- Create a new classroom
                    if (nameController.text.isEmpty) {
                      // Maybe show a toast or sth
                      // Close the dialog without proceeding
                      return Navigator.pop(context);
                    }
                    myClassroom = await _dbService.createClassroom(nameController.text,nbrController.text);
                    break;
                  case false: // -- Update an existing classroom
                    myClassroom = await _dbService.updateClassroom(
                      classroom!.codClass,
                      nameController.text,
                        nbrController.text
                      /*int.parse(nbreController.text),*/
                    );
                    break;
                }
                // -- Forward change to parent
                onChanged(myClassroom);
                // -- Close the dialog
                Navigator.pop(context);
              },
              child: Text(isNew ? 'Ajouter ' : 'Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
