import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:tp7_flu/Formation.dart';

class dbuse {
  static final dbuse _dbuseHelper = dbuse._internal();
  dbuse._internal();

  factory dbuse() {
    return _dbuseHelper;
  }

  Future<List<Formation>> getFormations() async {
    final _formKey = GlobalKey<FormState>();
    Formation form = Formation(0,"",0);
    String url = "http://192.168.43.143:8080/allF";
    var res = await http.get(Uri.parse(url));
    print(res.body);
    return
      json.decode(res.body)['embedded']['listforms'];
  }
}
