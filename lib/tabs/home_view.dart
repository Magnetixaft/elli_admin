import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../models/space.dart';
import 'package:elli_admin/models/company_manager.dart';
import 'package:elli_admin/models/office_manager.dart';
import 'package:elli_admin/models/space_manager.dart';

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
      children:  <Widget> [
        const Text("Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30
          )
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CompanyManager(),
            const SizedBox(width: 40,),
            OfficeManager(),
            const SizedBox(width: 40),
            SpaceManager(),
          ],
        ),
      ]
      
    );

  }
}
