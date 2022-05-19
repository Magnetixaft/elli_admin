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
  double fieldDistance = 10;

  callback() {
    setState(() {});
  }

  ///Returns true if the text string provided could be an email
  bool isEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  /*
  ///Encrypts users [email] and return encrypted, needs .base64 to get String of encrypted
  Encrypted encryptEmail(String email) {
    final key = Key.fromUtf8('testkeytestkeytestkeytestkeytest');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(email, iv: iv);
  }
  */

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

  /*
  //Hopefully a new and improved version
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
              title: const Text("Administrators"),
              content: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                      child: Column(
                        children: [
                          _adminDropDown(snapshot.data!),
                          _buildAddNewAdmin(context),
                          _buildDeleteSelectedAdmin(context),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _adminDropDown(List<Admin> adminList) {
    List<String> names = _getAdminNames;
    
  }

  List<String>  _getAdminNames(List<Admin> adminList){
    List<String> names = [];
    for(Admin admin in  adminList){
      names.add(admin.getName());
    }
    return names;
  }; 
  */

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

  ///The delete admin button. Deletes the selected administrator.
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
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _deleteAdminCheck(context, selectedAdmin));
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

  ///Builds a popup double checking if the selected admin should be deleted.
  Widget _deleteAdminCheck(BuildContext context, String admin) {
    return AlertDialog(
      title: Text("Delete " + admin + " ?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Are you sure you want to delete " + admin + " ?"),
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
              FirebaseHandler.getInstance().removeAdmin(selectedAdmin);
              selectedAdmin = null;
            });
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yes, delete that mofo'),
        ),
      ],
    );
  }

  ///Builds the button for adding a new administrator.
  Widget _buildAddNewAdmin(BuildContext context) {
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
      title: const Text("Add administrator"),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Column(
              children: [
                SizedBox(height: fieldDistance),
                SizedBox(
                  width: 800,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (name.text.isNotEmpty && isEmail(email.text)) {
                        await FirebaseHandler.getInstance()
                            .addAdmin(email.text, "all", name.text);
                        Navigator.of(context).pop();
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
              ],
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
