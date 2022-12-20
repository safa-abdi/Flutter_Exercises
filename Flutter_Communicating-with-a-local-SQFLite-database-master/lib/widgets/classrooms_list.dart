import 'package:flutter/material.dart';
import 'package:tp5_flutter/models/scol_list.dart';
import 'package:tp5_flutter/screens/students_screen.dart';
import 'package:tp5_flutter/util/dbuse.dart';
import 'package:tp5_flutter/widgets/classroom_dialog.dart';

class ClassroomsList extends StatefulWidget {
  final List<ScolList> classrooms;
  final Function notifyParentToChanges;
  const ClassroomsList({
    Key? key,
    required this.classrooms,
    required this.notifyParentToChanges, required Column child,
  }) : super(key: key);

  @override
  _ClassroomsListState createState() => _ClassroomsListState();
}
class _ClassroomsListState extends State<ClassroomsList> {
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
  @override
  Widget build(BuildContext context) {
    dbuse _dbuse = dbuse();
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: widget.classrooms.length,
        itemBuilder: (BuildContext context, int index) {
          ScolList classroom = widget.classrooms[index];
          String strc = classroom.nomClass;
          String val = classroom.nbreEtud;
          var fruits = classroom ;
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentsScreen(
                         scolList: classroom,
                        ),
                      ),
                    );
                  },
                  title: Text("$strc  nbEtud : $val"),
                  leading: CircleAvatar(
                    child: Text(classroom.codClass.toString()),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                          items: classroom.map((String value) {
                            return DropdownMenuItem<String>(
                              value: classroom.codClass.toString(),
                              child: Text(value),
                            );
                          }),
                          onChanged: (value) {}),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ClassroomDialog(
                              classroom: classroom,
                              onChanged: (respClass) {
                                List<ScolList> classrooms = widget.classrooms.map(
                                  (classr) {
                                    if (classr.codClass == respClass.codClass) {
                                      classr.nomClass = respClass.nomClass;
                                    }
                                    return classr;
                                  },
                                ).toList();
                                widget.notifyParentToChanges(classrooms);
                              },
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          String strName = classroom.nomClass;
                          await _dbuse.deleteClassroom(classroom.codClass);
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text("$strName deleted"),backgroundColor: Colors.deepOrange,));
                          List<ScolList> classrooms = widget.classrooms
                              .where(
                                (classr) => classr.codClass != classroom.codClass,
                              )
                              .toList();
                          widget.notifyParentToChanges(classrooms);
                        },
                      ),
                    ],
                  )
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
