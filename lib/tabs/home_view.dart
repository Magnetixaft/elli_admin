import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../firebase_handler.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _HomeViewState extends State<HomeView> {
  var selectedCompany;
  var selectedOffice;
  var selectedRoom;


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
    getData();
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
                      _buildCompanyMenu() // TODO change parameter to database
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
                      _buildOfficesMenu(), // TODO change parameter to database
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
                      _buildSpacesMenu(), // TODO change parameter to database
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
                       // TODO Add cards
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
                      // TODO Add cards
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
                      // TODO Add cards
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
    final nameInput = TextEditingController();
    final orgInput = TextEditingController();
    final addressInput = TextEditingController();
    final officesInput = TextEditingController();
    final totalSpacesInput = TextEditingController();
    final availableSpacesInput = TextEditingController();

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
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Add new company'),
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter company name',
                                    ),
                                    controller: nameInput,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Organization number',
                                    ),
                                    controller: orgInput,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Address',
                                    ),
                                    controller: addressInput,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Offices',
                                    ),
                                    controller: officesInput,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Total number of work spaces',
                                    ),
                                    controller: totalSpacesInput,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Available work spaces',
                                    ),
                                    controller: availableSpacesInput,
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () async {
                                      // TODO add to database
                                      addCompany(nameInput.text, officesInput.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Add')),
                              ],
                            );
                          });
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
  } // TODO get done

  /// This creates a card item for adding a new office
  Widget _buildAddNewOffice() {
    final officeNameInput = TextEditingController();
    final officeAddressInput = TextEditingController();
    final roomInput = TextEditingController();
    final officeTotalSpacesInput = TextEditingController();
    final officeAvailableSpacesInput = TextEditingController();

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
                          showDialog(
                          context: context,
                          builder: (context)
                          {
                            return AlertDialog(
                                title: const Text('Add new office'),
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter Office name',
                                      ),
                                      controller: officeNameInput,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Address',
                                      ),
                                      controller: officeAddressInput,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Number of rooms',
                                      ),
                                      controller: roomInput,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Total number of work spaces',
                                      ),
                                      controller: officeTotalSpacesInput,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Available work spaces',
                                      ),
                                      controller: officeAvailableSpacesInput,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () async {
                                        // TODO add to database
                                        addOffice(officeNameInput.text, officeAddressInput.text, roomInput.text, officeTotalSpacesInput.text, officeAvailableSpacesInput.text);
                                        _buildOfficeCard(officeNameInput.text, officeAddressInput.text, roomInput.text, officeTotalSpacesInput.text, officeAvailableSpacesInput.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Add')),
                                ],
                            );
                          });
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
    final roomNameInput = TextEditingController();
    final roomTotalSpacesInput = TextEditingController();
    final roomAvailableSpacesInput = TextEditingController();

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
                      showDialog(
                          context: context,
                          builder: (context)
                          {
                            return AlertDialog(
                              title: const Text('Add new company'),
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter room name',
                                    ),
                                    controller: roomNameInput,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Total number of work spaces',
                                    ),
                                    controller: roomTotalSpacesInput,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Available work spaces',
                                    ),
                                    controller: roomAvailableSpacesInput,
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () async {
                                      // TODO add to database

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Add')),
                              ],
                            );
                          });
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
  } // TODO get done

  /// This creates the dropdown menu for companies
  Widget _buildCompanyMenu() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Divisions").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Text("Loading.....");
          } else {
            List<DropdownMenuItem> companyItems = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              companyItems.add(
                DropdownMenuItem(
                  child: Text(
                    snap.id,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  value: snap.id,
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  items: companyItems,
                  onChanged: (company) {
                    final snackBar = SnackBar(
                      content: Text(
                        'You have selected $company',
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                    setState(() {
                      selectedCompany = company;
                    });
                  },
                  value: selectedCompany,
                  isExpanded: false,
                  hint: const Text(
                    "Choose company",
                    style: TextStyle(
                        color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        });
}

  /// This creates the dropdown menu for offices
  Widget _buildOfficesMenu() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Divisions").doc(selectedCompany).collection('Offices').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Text("Loading.....");
          } else {
            List<DropdownMenuItem> companyItems = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              companyItems.add(
                DropdownMenuItem(
                  child: Text(
                    snap.id,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  value: snap.id,
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  items: companyItems,
                  onChanged: (office) {
                    final snackBar = SnackBar(
                      content: Text(
                        'You have selected $office',
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                    setState(() {
                      selectedOffice = office;
                    });
                  },
                  value: selectedOffice,
                  isExpanded: false,
                  hint: const Text(
                    "Choose office",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }

  /// This creates the dropdown menu for spaces
  Widget _buildSpacesMenu() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Rooms_2').where('Office', isEqualTo: selectedOffice).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Text("Loading.....");
          } else {
            List<DropdownMenuItem> companyItems = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              companyItems.add(
                DropdownMenuItem(
                  child: Text(
                    snap.id,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  value: snap.id,
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  items: companyItems,
                  onChanged: (room) {
                    final snackBar = SnackBar(
                      content: Text(
                        'You have selected $room',
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                    setState(() {
                      selectedRoom = room;
                    });
                  },
                  value: selectedRoom,
                  isExpanded: false,
                  hint: const Text(
                    "Choose Room",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        });
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
                        height: 40,
                        width: 75,
                        child: ElevatedButton(
                          child: const Text(
                              'Delete'
                          ),
                          onPressed: () {
                            setState(() {
// TODO delete
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent
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
  Widget _buildOfficeCard(String name, String address, String spaces,
      String numberOfSpaces, String availableSpaces) {
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
                        height: 40,
                        width: 75,
                        child: ElevatedButton(
                          child: const Text(
                              'Delete'
                          ),
                          onPressed: () {
                            setState(() {
// TODO delete
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent
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
                        height: 40,
                        width: 75,
                        child: ElevatedButton(
                          child: const Text(
                              'Delete'
                          ),
                          onPressed: () {
                            setState(() {
                                  // TODO call delete
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent
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


  Future<List> getData() async {
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('Divisions');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.id).toList();
    return allData;
  }

  Future<void> addCompany(String name, String office) async {
    FirebaseFirestore.instance
        .collection('Divisions').doc(name).set({});
  }

  Future<void> addOffice(String name, String address, String rooms, String totalSpaces, String availableSpaces) async {
      FirebaseFirestore.instance
          .collection('Divisions').doc('Elicit').collection('Offices').doc(name)
          .set({'Address': address, 'Rooms': rooms, 'Total spaces': totalSpaces, 'Available spaces': availableSpaces});
  }

  Future<void> addRoom(String name, String address, String rooms, String totalSpaces, String availableSpaces, String office) async {
    FirebaseFirestore.instance
        .collection('Divisions').doc('Elicit').collection('Offices').doc(office)
        .set({'Address': address, 'Rooms': rooms, 'Total spaces': totalSpaces, 'Available spaces': availableSpaces});
  }

  Future<List<String>> getRoomsFromOffice(String office) async {
    var data = await FirebaseFirestore.instance.collection('Rooms_2').where('Office', isEqualTo: office).get();
    List<String> roomsList = [];
    for (var doc in data.docs) {
      var docData = doc.data();
      roomsList.add(docData["Name"]);
    }
    return roomsList;
  }

}