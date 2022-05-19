import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../theme.dart';

/// A tab for viewing the admin config settings for ELLI
///
/// Allows an admin to edit the Admin priviliges, and view the about section.
//TODO implement hashing for the admin emails.
//TODO apply notifications for blocked actions
class ConfigTab extends StatefulWidget {
  const ConfigTab({Key? key}) : super(key: key);

  @override
  State<ConfigTab> createState() => _ConfigTabState();
}

class _ConfigTabState extends State<ConfigTab> {
  var selectedAdmin;
  double fieldDistance = 20;

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
                                _buildAdminEdit2(context));
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
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text('😭 $error');
            }
            return AlertDialog(
              title: Text("Administrators"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _adminDropDown(snapshot.data!),
                  const SizedBox(height: 20),
                  _buildAddNewAdmin(context),
                  _buildDeleteSelectedAdmin(context, snapshot.data!),
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
          return const Center(child: CircularProgressIndicator());
        });
  }

  ///Returns the drop down menu for
  Widget _adminDropDown(List<Admin> adminList) {
    List<DropdownMenuItem<String>> adminItems = [];

    for (Admin admin in adminList) {
      adminItems.add(
        DropdownMenuItem(
          child: Text(
            admin.name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          value: admin.name,
        ),
      );
    }
    return DropdownButton(
      items: adminItems,
      onChanged: (admin) {
        setState(() {
          selectedAdmin = admin.toString();
        });
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildAdminEdit2(context));
      },
      value: selectedAdmin,
      isExpanded: false,
      hint: const Text(
        "Choose Admin",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  /*
  ///Builds pop up for editing administrators.
  ///The window adapts fills the screen vertically and adapts itself to the buttons horizontally.
  ///All buttons and text fields used here should have width: 800.
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
  */

  ///The delete admin button. Deletes the selected administrator.
  Widget _buildDeleteSelectedAdmin(BuildContext context, List<Admin> list) {
    return SizedBox(
      width: 600,
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
                      if (selectedAdmin != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _deleteAdminCheck(
                                    context, _getAdminHash(list), list));
                      }
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

  ///Returns the id of an admin with a given name as a String.
  String _getAdminHash(List<Admin> adminList) {
    for (Admin admin in adminList) {
      if (admin.name == selectedAdmin) {
        return admin.adminHashId;
      }
    }
    return "😭 error!";
  }

  ///Builds a popup double checking if the selected admin should be deleted.
  Widget _deleteAdminCheck(
      BuildContext context, String admin, List<Admin> list) {
    return AlertDialog(
      title: Text("Delete " + selectedAdmin + " ?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Are you sure you want to remove " +
              selectedAdmin +
              "'s admin priviliges?"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              FirebaseHandler.getInstance().removeAdmin(admin);
              selectedAdmin = null;
            });
            print(selectedAdmin);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yes'),
        ),
      ],
    );
  }

  ///Builds the button for adding a new administrator.
  Widget _buildAddNewAdmin(BuildContext context) {
    return SizedBox(
      width: 600,
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
                          builder: (BuildContext context) =>
                              _addNewAdminForm(context));
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

  ///Builds the form for adding a new administrator.
  Widget _addNewAdminForm(BuildContext context) {
    final name = TextEditingController();
    final email = TextEditingController();

    return AlertDialog(
      title: Text("Add administrator"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: fieldDistance),
          SizedBox(
            width: 600,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (name.text.isNotEmpty && isEmail(email.text)) {
                  await FirebaseHandler.getInstance()
                      .addAdmin(email.text.toLowerCase(), "all", name.text);
                  selectedAdmin = null;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildAdminEdit2(context));
                } else {
                  return;
                }
              },
              icon: const Icon(Icons.save),
              label: const Text("Save"),
            ),
          ),
          SizedBox(height: fieldDistance),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Enter admin name'),
            ),
            controller: name,
          ),
          SizedBox(height: fieldDistance),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Email'),
            ),
            controller: email,
          ),
          SizedBox(height: fieldDistance),
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
                                "About:",
                                "DAT257 Agile Software Project Management\n\n\nElli is a office space booking app created as part of the course DAT257 at Chalmers University of Technology. \nIt consists of a web-based admin console, and a smartphone application."));
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
