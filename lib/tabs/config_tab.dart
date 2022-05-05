import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../models/space.dart';

class ConfigTab extends StatefulWidget {
  const ConfigTab({Key? key}) : super(key: key);

  @override
  State<ConfigTab> createState() => _ConfigTabState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _ConfigTabState extends State<ConfigTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        SizedBox(height: 10),
        Text("    Config",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
      ],
    );
  }
}
