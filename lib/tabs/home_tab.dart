import 'package:flutter/material.dart';

import '../firebase_handler.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _HomeViewState extends State<HomeView> {
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
    FirebaseHandler backend = FirebaseHandler.getInstance();
    return FutureBuilder<void>(
        future: backend.buildStaticModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _renderView();
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _renderView() {
    return SingleChildScrollView(
      /// The "Home" header
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
                      _buildAddNewCompany(),
                      _buildCompanyCard(
                          firstCompany,
                          87,
                          'Drottningtorget',
                          9,
                          3,
                          6), // TODO remove temporary items and connect to database
                    ],
                  ),
                ),
                Container(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddNewOffice(),
                      _buildOfficeCard(firstOffice,
                          'Drottningtorget 5, 411 03 Göteborg', 4, 35, 19)
                    ],
                  ),
                ),
                Container(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddNewSpace(),
                      _buildSpacesCard(firstSpace, 5, 3)
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

  /// This creates a card item for adding a new company
  Widget _buildAddNewCompany() {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO add new company to the database
                    },
                    label: const Text(
                      'Add new company',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// This creates a card item for adding a new office
  Widget _buildAddNewOffice() {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO add new office to the database
                    },
                    label: const Text(
                      'Add new office',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// This creates a card item for adding a new space
  Widget _buildAddNewSpace() {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO add new space to the database
                    },
                    label: const Text(
                      'Add new space',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// This creates a card item for company specifications
  Widget _buildCompanyCard(String name, int orgNr, String address, int offices,
      int numberOfSpaces, int availableSpaces) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 40,
                        child: TextButton(
                          onPressed: () {
                            // TODO add function to edit
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Org.nr: [$orgNr]'),
                  const SizedBox(height: 24),
                  Text('[$address]'),
                  const SizedBox(height: 12),
                  Text('Offices: [$offices]'),
                  const SizedBox(height: 12),
                  Text('Total number of work spaces: [$numberOfSpaces]'),
                  const SizedBox(height: 12),
                  Text('Available work spaces: [$availableSpaces]'),
                  const SizedBox(height: 12)
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// This creates a card item for office specifications
  Widget _buildOfficeCard(String name, String address, int spaces,
      int numberOfSpaces, int availableSpaces) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 40,
                        child: TextButton(
                          onPressed: () {
                            // TODO add function to edit
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('[$address]'),
                  const SizedBox(height: 24),
                  Text('Spaces: [$spaces]'),
                  const SizedBox(height: 12),
                  Text('Total number of work spaces: [$numberOfSpaces]'),
                  const SizedBox(height: 12),
                  Text('Available work spaces: [$availableSpaces]'),
                  const SizedBox(height: 12)
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// This creates a card item for space specifications
  Widget _buildSpacesCard(
      String name, int numberOfSpaces, int availableSpaces) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 40,
                        child: TextButton(
                          onPressed: () {
                            // TODO add function to edit
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Total number of work spaces: [$numberOfSpaces]'),
                  const SizedBox(height: 12),
                  Text('Available work spaces: [$availableSpaces]'),
                  const SizedBox(height: 12)
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
