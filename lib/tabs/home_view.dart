import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../models/space.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        SizedBox(height: 10),
        Text("Home",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
      ],
    );
  }
}

