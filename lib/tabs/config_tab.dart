import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';

/// A tab for viewing the admin config settings for ELLI
///
/// Allows an admin to edit the FAQ and About sections, as well as add other admins
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

  @override
  Widget build(BuildContext context) {
    FirebaseHandler backend = FirebaseHandler.getInstance();
    return FutureBuilder<void>(
        future: backend.buildStaticModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildView(context);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget buildView(BuildContext context) {
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
                )),
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
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context, "About",
                                    "Lorem ipsum dolor sit amet"));
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'have a gander',
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

  Widget _buildAdminEdit(BuildContext context) {
    return AlertDialog(
      title: const Text(
          "Administrators                                                                             "),
      content: Scaffold(
          body: Center(
        child: Container(
          width: 400,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              for (int i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
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
                      _buildAddNewAdmin(context),
                      _buildDeleteSelectedAdmin(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
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
    final name = TextEditingController();
    final email = TextEditingController();

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
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Add administrator'),
                              content: Column(
                                children: <Widget>[
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
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () async {
                                      if (name.text.isNotEmpty &&
                                          email.text.isNotEmpty) {
                                        FirebaseHandler.getInstance().addAdmin(
                                            email.text, "all", name.text);
                                        Navigator.of(context).pop();
                                      } else {
                                        return;
                                      }
                                    },
                                    child: const Text('Add')),
                              ],
                            );
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
}





/*
Widget _buildAdminEdit(BuildContext context) {
    return AlertDialog(
      title: const Text("Administrators"),
      content: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Container(
              width: 700,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Name"),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Name',
                            ),
                            controller: userIdTextController,
                          ),
                          TextField(
                            controller: userPasswordTextController,
                            decoration: const InputDecoration(
                              label: Text("Email"),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () => {},
                                child: const Text(
                                  "Add",
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
*/

/*
Widget _editTitleTextField() {
  if (_isEditingText)
    return Center(
      child: TextField(
        onSubmitted: (newValue){
          setState(() {
            initialText = newValue;
            _isEditingText =false;
          });
        },
        autofocus: true,
        controller: _editingController,
      ),
    );
  return InkWell(
    onTap: () {
      setState(() {
        _isEditingText = true;
      });
    },
    child: Text(
  initialText,
  style: TextStyle(
    color: Colors.black,
    fontSize: 18.0,
  ),
 );
}
*/

/*

  */
