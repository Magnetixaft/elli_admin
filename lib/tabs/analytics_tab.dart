import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../models/space.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({Key? key}) : super(key: key);

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _AnalyticsTabState extends State<AnalyticsTab> {
  /// Temporary list of items for the dropdown menus
  List<String> companies = ["Elicit AB", "AgileQueen", "Wickman AB"];
  List<String> offices = ["Centralen", "Stockholm", "Jönköping"];
  List<String> spaces = ["Room XYZ", "Room ABC", "Room 123"];

  /// Temporary first items that is shown in the dropdown menus
  String firstCompany = "Elicit AB";
  String firstOffice = "Centralen";
  String firstSpace = "Room XYZ";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      /// The "Analytics" header
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            const Text("    Analytics",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                )),
            const SizedBox(height: 24),

            /// The dropdown menus and small header for each
            Row(
              children: [
                Container(width: 80),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Company',
                        style: TextStyle(fontSize: 16),
                      ),
                      _buildCompanyMenu(
                          companies), // TODO change parameter to database
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Office',
                        style: TextStyle(fontSize: 16),
                      ),
                      _buildOfficesMenu(
                          offices), // TODO change parameter to database
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Space',
                        style: TextStyle(fontSize: 16),
                      ),
                      _buildSpacesMenu(
                          spaces), // TODO change parameter to database
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// The card section with all the items under each dropdown menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 50),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCard('Weekday occupancy rate (3w avg.)',
                          'Monday: [#]%),                                                                Tuesday: [#]%                                              Wednesday: [#]%                                                     Thursday: [#]%                                                          Friday: [#]%'), //
                      _buildCard('Comparisson covering % offices',
                          '[Office centralen 45 % ]'),
                      _buildCard('Most booked office', '[Office Jönköping]'),
                    ],
                  ),
                ),
                Container(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCard(
                        'Most booked space',
                        '[Space 2 Open] , ',
                      ),
                      _buildCard('Most common workday at office', '[Thursday]'),
                      _buildCard('Comparisson covering % spaces ',
                          '[Space 1  45 % ],                                                                      [Space 2 Open  65 % ],                                                   [Quiet room  55 % ]   '),
                      _buildCard('Comparisson number of bookings last 2 weeks ',
                          '[Last week  900 ],                                                              [2 weeks ago 812 ]                                                       [+88]'),
                    ],
                  ),
                ),
                Container(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCard(
                          '[Most common workday at space]', '[Monday]  '),
                      _buildCard('[Comparisson number of bookings last week]',
                          '[Last week  102]                                                             [2 weeks ago 100]                                                        [Diffrence +  39]'),
                      _buildCard(
                          '[Name of space]', 'Total number of seats: [#]'),
                    ],
                  ),
                ),
                Container(width: 50)
              ],
            )
          ],
        ),
      ),
    );
  }

  /// This creates a card item
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
                  Text(
                    header,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                  const SizedBox(height: 4),
                  Container(
                    width: 120,
                    child: TextButton(
                      onPressed: () {},
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'avg. [value] kr',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// This creates the dropdown menu for companies
  Widget _buildCompanyMenu(List<String> list) {
    return DropdownButton(
      // Initial Value
      value: firstCompany,

      style: const TextStyle(fontWeight: FontWeight.bold),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: list.map((String items) {
        // TODO change to get from database instead of static list
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

  /// This creates the dropdown menu for offices
  Widget _buildOfficesMenu(List<String> list) {
    return DropdownButton(
      // Initial Value
      value: firstOffice,

      style: const TextStyle(fontWeight: FontWeight.bold),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: list.map((String items) {
        // TODO change to get from database instead of static list
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

  /// This creates the dropdown menu for spaces
  Widget _buildSpacesMenu(List<String> list) {
    return DropdownButton(
      // Initial Value
      value: firstSpace,

      style: const TextStyle(fontWeight: FontWeight.bold),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: list.map((String items) {
        // TODO change to get from database instead of static list
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
