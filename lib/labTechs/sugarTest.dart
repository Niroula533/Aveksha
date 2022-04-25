// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';

class SugarTestLab extends StatefulWidget {
  String pname;
  SugarTestLab({Key? key, required this.pname}) : super(key: key);

  @override
  State<SugarTestLab> createState() => _SugarTestLabState(pname);
}

class _SugarTestLabState extends State<SugarTestLab> {
  String pname;
  _SugarTestLabState(this.pname) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Sugar Test for $pname'));
  }
}
