import 'package:flutter/src/material/dropdown.dart';

class ScolList {
  int codClass;
  String nomClass;
  String nbreEtud ;

  ScolList(this.codClass, this.nomClass ,this.nbreEtud);

  Map<String, dynamic> toMap() => {'codClass': codClass, 'nomClass': nomClass ,'nbreEtud':nbreEtud};

  factory ScolList.fromMap(Map<String, dynamic> map) =>
      ScolList(map['codClass'], map['nomClass'], map['nbreEtud']);

  fromMap(Map<String, dynamic> map) {
    ScolList(map['codClass'], map['nomClass'], map['nbreEtud']);
  }

  map(DropdownMenuItem<String> Function(String value) param0) {}



}
