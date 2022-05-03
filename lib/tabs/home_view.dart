import 'package:flutter/cupertino.dart';
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

  List<String> companies = ["Elicit AB", "company 2", "company 3"];
  List<String> offices = ["Centralen", "office 2", "office 3"];
  List<String> spaces = ["Room X", "space 2", "space 3"];

  String firstCompany = "Elicit AB";
  String firstOffice = "Centralen";
  String firstSpace = "Room X";


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Text("    Home",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              )),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company'),
                  _buildCompanyMenu(companies),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Office'),
                  _buildOfficesMenu(offices),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Space'),
                  _buildSpacesMenu(spaces),
                ],
              ),
            ],
          )



        ],
      ),
    );
  }



  Widget _buildCompanyMenu(List<String> list) {
    return DropdownButton(
      // Initial Value
      value: firstCompany,

      style: TextStyle(
        fontWeight: FontWeight.bold
      ),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: list.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          firstCompany = newValue!;
        });
      },
    );
  }

  Widget _buildOfficesMenu(List<String> list) {
    return DropdownButton(
      // Initial Value
      value: firstOffice,

      style: TextStyle(
          fontWeight: FontWeight.bold
      ),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: list.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          firstOffice = newValue!;
        });
      },
    );
  }

  Widget _buildSpacesMenu(List<String> list) {
    return DropdownButton(
      // Initial Value
      value: firstSpace,

      style: TextStyle(
          fontWeight: FontWeight.bold
      ),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: list.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          firstSpace = newValue!;
        });
      },
    );
  }

}