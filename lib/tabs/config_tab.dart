import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';

import '../theme.dart';

/// A tab for viewing the admin config settings for ELLI
///
/// Allows an admin to edit the Admin priviliges, and view the about section.
class ConfigTab extends StatefulWidget {
  const ConfigTab({Key? key}) : super(key: key);

  @override
  State<ConfigTab> createState() => _ConfigTabState();
}

class _ConfigTabState extends State<ConfigTab> {
  var selectedAdmin;

  callback() {
    setState(() {});
  }

  ///Returns true if the text string provided could be an email
  bool isEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  ///Builds the config_tab Widget.
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
            const Text("    Config",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    color: ElliColors.pink)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 50),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Build the admin card.
                      _buildAdminCard(context),
                      _buildAboutCard(context)
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

  ///Builds the Admin card from where the admin pop up can be opened.
  Widget _buildAdminCard(BuildContext context) {
    return SizedBox(
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
                  const Text(
                    "Admins",
                    style: TextStyle(fontSize: 16),
                  ),
                  //The button for editing admins
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildAdminEdit(context));
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'edit',
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

  ///Builds pop up for editing administrators.
  ///The window adapts fills the screen vertically and adapts itself to the buttons horizontally.
  ///All buttons and text fields used here should have width: 800.
  Widget _buildAdminEdit2(BuildContext context) {
    return FutureBuilder<List<Admin>>(
        future: FirebaseHandler.getInstance().getAllAdmins(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AlertDialog(
              title: const Text("Administrators"),
              content: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                      child: Column(),
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildAdminEdit(BuildContext context) {
    return AlertDialog(
      title: const Text("Administrators"),
      content: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Admins')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          const Text("Loading.....");
                        } else {
                          List<DropdownMenuItem<String>> adminItems = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            adminItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap.id,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: snap.id,
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButton(
                                items: adminItems,
                                onChanged: (admin) {
                                  setState(() {
                                    selectedAdmin = admin;
                                  });
                                  Navigator.of(context).pop();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildAdminEdit(context));
                                },
                                value: selectedAdmin,
                                isExpanded: false,
                                hint: const Text(
                                  "Choose Admin",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        }
                        return Container();
                      }),
                  const SizedBox(
                    height: 50,
                  ),
                  _buildAddNewAdmin(context),
                  _buildDeleteSelectedAdmin(context),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            selectedAdmin = null;
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDeleteSelectedAdmin(BuildContext context) {
    return SizedBox(
      width: 800,
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
                      setState(() {
                        FirebaseHandler.getInstance()
                            .removeAdmin(selectedAdmin);
                        selectedAdmin = null;
                      });

                      Navigator.of(context).pop();
                    },
                    label: const Text(
                      'Delete selected admin',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildAddNewAdmin(BuildContext context) {
    final name = TextEditingController();
    final email = TextEditingController();

    return SizedBox(
      width: 800,
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
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Add administrator"),
                              content: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 25, 25, 0),
                                      child: Column(
                                        children: [
                                          TextField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter admin name',
                                            ),
                                            controller: name,
                                          ),
                                          TextField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Email',
                                            ),
                                            controller: email,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                if (name.text.isNotEmpty &&
                                                    isEmail(email.text)) {
                                                  await FirebaseHandler
                                                          .getInstance()
                                                      .addAdmin(email.text,
                                                          "all", name.text);
                                                  Navigator.of(context).pop();
                                                } else {
                                                  return;
                                                }
                                              },
                                              child: const Text('Add')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    selectedAdmin = null;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                            /*
                            return AlertDialog(
                              title: const Text('Add administrator'),
                              content: Column(
                                children: <Widget>[
                                  
                              ],
                            );*/
                          },
                          context: context);
                    },
                    label: const Text(
                      'Add new admin',
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

  /*--- The methods used for creating the "About" - card---*/

  ///Builds the About card.
  Widget _buildAboutCard(BuildContext context) {
    return SizedBox(
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
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildPopupDialog(
                                context,
                                "About",
                                "This is a school project made in an agile fashion."));
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'behold!',
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

  ///Builds a general template pop up dialog box with a title,
  ///and one string of content.
  Widget _buildPopupDialog(BuildContext context, String title, String text) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
