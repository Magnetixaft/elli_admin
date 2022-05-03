import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            const Text("    Home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                )),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(width: 80),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Company'),
                      _buildCompanyMenu(companies),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Office'),
                      _buildOfficesMenu(offices),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Space'),
                      _buildSpacesMenu(spaces),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 50),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCard('Smack', 'boom'),
                        _buildCard('Smack', 'boom'),
                        _buildCard('Smack', 'boom'),
                        _buildCard('Smack', 'boom'),
                        _buildCard('Smack', 'boom'),
                        _buildCard('Smack', 'boom'),
                        _buildCard('Smack', 'boom'),
                      ],
                    ),
                  ),
                    Container(width: 12),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCard('Smack', 'boom'),
                          _buildCard('Smack', 'boom'),
                          _buildCard('Smack', 'boom'),
                          _buildCard('Smack', 'boom'),
                          _buildCard('Smack', 'boom'),
                        ],
                      ),
                    ),
                  Container(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCard('Smack', 'boom'),
                      ],
                    ),
                  ),
                  Container(width: 50)
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _buildCard(String header, String subtitle) {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(header),
                SizedBox(height: 4),
                Text(subtitle)
              ],
            )
          ),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildCompanyMenu(List<String> list) {
    return DropdownButton(
      // Initial Value
      value: firstCompany,

      style: const TextStyle(
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

      style: const TextStyle(
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

      style: const TextStyle(
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