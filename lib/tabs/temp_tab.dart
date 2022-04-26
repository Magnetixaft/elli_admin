import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../models/space.dart';

class TempTab extends StatefulWidget {
  const TempTab({Key? key}) : super(key: key);

  @override
  State<TempTab> createState() => _TempTabState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _TempTabState extends State<TempTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        SizedBox(height: 10),
        Text("Temp",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
      ],
    );
  }
}

