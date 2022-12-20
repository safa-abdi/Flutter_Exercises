import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:tp5_flutter/models/scol_list.dart';
import 'package:tp5_flutter/models/list_etudiants.dart';

class dbuse {
  final int version = 1;
  Database? db;

  static final dbuse _dbuseHelper = dbuse._internal();
  dbuse._internal();

  factory dbuse() {
    return _dbuseHelper;
  }
  Future<Database?> openDB() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'maBase.db'),
        onCreate: (database, version) {
          database.execute(
              'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT,nbreEtud INTEGER)');
          database.execute(
              'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER,nom TEXT, prenom TEXT, datNais TEXT, ' +
                  'FOREIGN KEY(codClass) REFERENCES classes(codClass))');
        }, version: version);
    return db;
  }


  // ---- Classroom methods
  Future<ScolList> createClassroom(String name,String nbr) async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot create a classroom, database is null!");
    }
    final int id = await db!.insert("classes", {
      "nomClass": name,
      "nbreEtud":nbr
    });
    return ScolList(id, name,nbr);
  }

  Future<List<ScolList>> getClassrooms() async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot get classrooms list, database is null!");
    }
    final List<Map<String, dynamic>> rawResult =
    await db!.query("classes");
    return List.generate(
      rawResult.length,
          (idx) => ScolList.fromMap(
        rawResult[idx],
      ),
    );
  }

  Future<ScolList> updateClassroom(int id, String name,String nbr) async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot update classroom, database is null!");
    }
    await db!.update(
      "classes",
      {"nomClass": name ,
      "nbreEtud":nbr},
      where: "codClass = ?",
      whereArgs: [id],
    );
    return ScolList(id, name ,nbr);
  }

  Future<void> deleteClassroom(int id) async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot delete classroom, database is null!");
    }
    await db!.delete(
      "classes",
      where: "codClass = ?",
      whereArgs: [id],
    );
    // -- On delete CASCADE
    await db!.delete(
      "etudiants",
      where: "codClass = ?",
      whereArgs: [id],
    );
  }
  // ---- get etudiants
  Future<List<ListEtudiants>> getEtudiants(code) async {
    final List<Map<String, dynamic>> maps =
    await db!.query('etudiants', where: 'codClass = ?', whereArgs:
    [code]);
    return List.generate(maps.length, (i) {
      return ListEtudiants(
        maps[i]['id'],
        maps[i]['codClass'],
        maps[i]['nom'],
        maps[i]['prenom'],
        maps[i]['datNais'],
      );
    });
  }

  // ---- Student methods
  Future<List<ListEtudiants>> getStudents(int classroomId) async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot get students list, database is null!");
    }
    final List<Map<String, dynamic>> rawResult = await db!.query(
      "etudiants",
      where: "codClass = ?",
      whereArgs: [classroomId],
    );
    return List.generate(
      rawResult.length,
          (idx) => ListEtudiants.fromMap(
        rawResult[idx],
      ),
    );
  }

  Future<ListEtudiants> createStudent(
      String nom,
      String prenom,
      String datNais,
      int codClass,
      ) async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot create a student, database is null!");
    }
    final int id = await db!.insert("etudiants", {
      "nom": nom,
      "prenom": prenom,
      "datNais": datNais,
      "codClass": codClass
    });
    return ListEtudiants(id, codClass, nom,prenom, datNais);
  }

  Future<ListEtudiants> updateStudent(
      int id,
      String nom,
      String prenom,
      String datNais,
      int codClass,
      ) async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot update student, database is null!");
    }
    await db!.update(
      "etudiants",
      {
        "nom": nom,
        "prenom": prenom,
        "datNais": datNais,
        "codClass": codClass
      },
      where: "id = ?",
      whereArgs: [id],
    );
    return ListEtudiants(id, codClass, nom,prenom, datNais);
  }

  Future<void> deleteStudent(int id) async {
    await openDB();
    if (db == null) {
      return Future.error("Cannot delete student, database is null!");
    }
    await db!.delete(
      "etudiants",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> testDB() async {
    await openDB();
    try {
      await db?.execute("INSERT INTO classes VALUES(0, 'DSI-33',54);");
    } catch (e) {
      log("Cannot add the test classroom");
    }

    try {
      await db?.execute(
          "INSERT INTO etudiants VALUES(0, 'Doe', 'John', '15/04/1995', 0)");
    } catch (e) {
      log("Cannot insert the test student");
    }
    List? lists = await db?.rawQuery("SELECT * FROM classes");
    List? items = await db?.rawQuery("SELECT * FROM etudiants");
    log(lists?[0]);
    log(items?[0]);
  }
  Future<String> getDBPath(String dbname) async {
    return p.join(await getDatabasesPath(), dbname);
  }
}
