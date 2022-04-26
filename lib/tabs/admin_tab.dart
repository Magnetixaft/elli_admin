import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../models/space.dart';

class AdminTab extends StatefulWidget {
  const AdminTab({Key? key}) : super(key: key);

  @override
  State<AdminTab> createState() => _AdminTabState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _AdminTabState extends State<AdminTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        SizedBox(height: 10),
        Text("Admin",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
      ],
    );
  }
}

