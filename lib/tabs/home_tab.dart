
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A tab for viewing offices, rooms and booking
/// 
/// Allows the user to add and remove offices, rooms, timeslots and workspaces
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _HomeViewState extends State<HomeView> {

  var selectedDivision;
  var selectedOffice;
  var selectedRoom;

  callback() {
    setState(() {});
  }


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

  /// Renders the layout of the whole homepage
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

                      Row(
                        children: [
                          _buildCompanyMenu(),
                          const SizedBox(width: 16),
                        ],
                      ),

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

                      Row(
                        children: [
                          _buildOfficesMenu(),
                          const SizedBox(width: 16)
                        ],
                      ),

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

                      Row(
                        children: [
                          _buildRoomMenu(),
                          const SizedBox(width: 16),
                        ],
                      ),

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

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("Divisions").snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        if (selectedDivision == null) {
                                          return Container();
                                        }
                                        else {
                                          if (selectedDivision == snapshot.data!.docs[index].id) {
                                            return _buildCompanyCard(selectedDivision, 'info');
                                          }
                                          else {
                                            return Container();
                                          }
                                        }
                                      },
                                    );
                                  } else if (snapshot.connectionState == ConnectionState.done &&
                                      !snapshot.hasData) {
                                    return const Text('Not Found');
                                  }
                                  else {
                                    return Container();
                                  }
                                }),
                          ),
                        ],
                      )

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

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("Divisions").doc(selectedDivision).collection('Offices').snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        if (selectedOffice == null) {
                                          return Container();
                                        }
                                        else {
                                          if (selectedOffice == snapshot.data!
                                              .docs[index].id) {
                                            return _buildOfficeCard(selectedOffice, snapshot.data!.docs[index]['Address'], snapshot.data!.docs[index]['Description']);
                                          }
                                          else {
                                            return Container();
                                          }
                                        }
                                      }
                                    );

                                  } else if (snapshot.connectionState == ConnectionState.done &&
                                      !snapshot.hasData) {
                                    return const Text('Not Found');
                                  }
                                  else {
                                    return Container();
                                  }
                                }),
                          ),
                        ],
                      )
                        ],
                      ),

                ),
                Container(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _buildAddNewRoom(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('Rooms_2').where('Office', isEqualTo: selectedOffice).snapshots(),
                                builder: (context, snapshot) {
                                    if (snapshot.hasData && selectedOffice != null) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          if (selectedOffice == null) {
                                            return Container();
                                          }
                                          else {
                                            if (selectedRoom == snapshot.data!
                                                .docs[index].id) {
                                              return _buildRoomCard(selectedRoom, 4, 3);
                                            }
                                            else {
                                              return Container();
                                            }
                                          }
                                        },
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                        !snapshot.hasData) {
                                      return const Text('Not Found');
                                    }
                                    else {
                                      return Container();
                                    }
                                  }
                                ),
                          ),
                        ],
                      )

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



  /// This creates the dropdown menu for companies
  Widget _buildCompanyMenu() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Divisions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Text("Loading.....");
          } else {
            List<DropdownMenuItem<String>> companyItems = [];
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
                      selectedDivision = company!;
                      selectedOffice = null;
                      selectedRoom = null;
                    });
                  },
                  value: selectedDivision,
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

  /// This creates a card item for adding a new company
  Widget _buildAddNewCompany() {
    final divisionName = TextEditingController();
    final info = TextEditingController();

    return Container(
      width: double.infinity,

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
                                    controller: divisionName,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Organization number',
                                    ),
                                    controller: info,
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () async {
                                      if (divisionName.text.isNotEmpty &&
                                          info.text.isNotEmpty) {
                                        FirebaseHandler.getInstance().saveDivision(divisionName.text, info.text);
                                        Navigator.of(context).pop();
                                      }
                                      else {
                                        return;
                                      }
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
  }


  /// This creates a card item for company specifications
  Widget _buildCompanyCard(String name, String info) {

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
                        child: TextButton(
                          child: const Text(
                              'Delete',
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                          onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete $selectedDivision'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Are you sure you want to delete $selectedDivision?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          setState(() {
                                            FirebaseHandler.getInstance().removeDivision(selectedDivision);
                                            selectedDivision = null;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Org.nr: [$info]')
                ],
              )),
          color: Colors.white,

        ),
      ),
    );
  }



  /// This creates the dropdown menu for offices
  Widget _buildOfficesMenu() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Divisions").doc(selectedDivision).collection('Offices').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Text("Loading.....");
          } else {
            List<DropdownMenuItem<String>> companyItems = [];
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
                      selectedRoom = null;
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

  /// This creates a card item for adding a new office
  Widget _buildAddNewOffice() {
    final officeName = TextEditingController();
    final officeAddress = TextEditingController();
    final officeDescription = TextEditingController();
    final contactInfo = TextEditingController();

    return Container(
      width: double.infinity,

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
                                        hintText: 'Enter office name',
                                      ),
                                      controller: officeName,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter address',
                                      ),
                                      controller: officeAddress,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter description',
                                      ),
                                      controller: officeDescription,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter contact info',
                                      ),
                                      controller: contactInfo,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (officeName.text.isNotEmpty &&
                                            officeAddress.text.isNotEmpty &&
                                            officeDescription.text.isNotEmpty &&
                                            contactInfo.text.isNotEmpty) {

                                          Navigator.of(context).pop();
                                          Office office = Office(
                                              officeAddress.text,
                                              officeDescription.text);
                                          FirebaseHandler.getInstance()
                                              .saveOffice(
                                              selectedDivision, officeName.text,
                                              office);
                                        }
                                        else {
                                          return;
                                        }
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


  /// This creates a card item for office specifications
  Widget _buildOfficeCard(String name, String address, String description) {

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
                        child: TextButton(
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.grey
                            ),
                          ),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete $selectedOffice'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Are you sure you want to delete $selectedOffice?')
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        setState(() {
                                          FirebaseHandler.getInstance().removeOffice(selectedDivision, selectedOffice);
                                          selectedOffice = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent

                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(address),
                  const SizedBox(height: 24),
                  Text('Description: $description'),
                ],
              )),
          color: Colors.white,

        ),
      ),
    );
  }



  /// This creates the dropdown menu for spaces
  Widget _buildRoomMenu() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Rooms_2').where('Office', isEqualTo: selectedOffice).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Text("Loading.....");
          } else {
            List<DropdownMenuItem<String>> companyItems = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              if (selectedOffice != null) {
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

  /// This creates a card item for adding a new space
  Widget _buildAddNewRoom() {
    final roomNameInput = TextEditingController();
    final roomNr = TextEditingController();
    final description = TextEditingController();
    final workspaces = TextEditingController();
    final equipment = TextEditingController();


    return Container(
      width: double.infinity,

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
                              title: const Text('Add new room'),
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
                                      hintText: 'Enter room number',
                                    ),
                                    controller: roomNr,
                                  ),

                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Description',
                                    ),
                                    controller: description,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Workspaces',
                                    ),
                                    controller: workspaces,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter equipment with "," between each',
                                    ),
                                    controller: equipment,
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () async {
                                      if (roomNameInput.text.isNotEmpty &&
                                          roomNr.text.isNotEmpty &&
                                          description.text.isNotEmpty &&
                                          workspaces.text.isNotEmpty &&
                                          equipment.text.isNotEmpty) {
                                        equipment.text.split(',');
                                        /*
                                        Room room = Room(workspaces, timeslots, description.text, selectedOffice, roomNameInput.text);
                                        FirebaseHandler.getInstance().saveRoom(selectedRoom, room);
                                        // TODO save room

                                         */

                                        Navigator.of(context).pop();
                                      }
                                      else {
                                        return;
                                      }
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
  }

  /// This creates a card item for space specifications

  Widget _buildRoomCard(

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
                        child: TextButton(
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('AlertDialog Title'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Are you sure you want to delete $selectedRoom?')
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        setState(() {
                                          FirebaseHandler.getInstance().removeRoom(int.parse(selectedRoom.toString()));
                                          selectedRoom = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent

                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text('Total number of work spaces: $numberOfSpaces'),
                  Text('Available work spaces: $availableSpaces'),
                ],
              )),
          color: Colors.white,

        ),
      ),
    );
  }



}

