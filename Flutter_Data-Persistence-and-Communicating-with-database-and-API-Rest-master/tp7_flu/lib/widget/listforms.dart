import 'package:flutter/material.dart';
import 'package:tp7_flu/Formation.dart';
import 'package:tp7_flu/dbuse.dart';

class FormationsList extends StatefulWidget {
  final List<Formation> forms;
  final Function notifyParentToChanges;
  const FormationsList({
    Key? key,
    required this.forms,
    required this.notifyParentToChanges,
  }) : super(key: key);

  @override
  _FormationsListListState createState() => _FormationsListListState();
}

class _FormationsListListState extends State<FormationsList> {
  @override
  Widget build(BuildContext context) {
    dbuse _dbuse = dbuse();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: widget.forms.length,
        itemBuilder: (BuildContext context, int index) {
          Formation form = widget.forms[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ListTile(

                  title: Text(form.nom),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(classroom.name),
                  //     Text(classroom.id.toString()),
                  //   ],
                  // ),
                  leading: CircleAvatar(
                    child: Text(form.nom.toString()),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
