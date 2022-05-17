import 'package:elli_admin/main.dart';
import 'package:elli_admin/tabs/config_tab.dart';
import 'package:elli_admin/tabs/analytics_tab.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/tabs/home_tab.dart';
import 'package:elli_admin/handlers/authentication_handler.dart';

/// The home page for the ELLI admin console.
///
/// Allows the user to navigate between the tabs [HomeTab], [AnalyticsTab] and [ConfigTab]
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isExtended = true;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const AnalyticsTab(),
    const ConfigTab()
  ];

  final AuthenticationHandler authenticationHandler =
      AuthenticationHandler.getInstance();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NavigationRail(
                  groupAlignment: 0.0,
                  selectedIndex: _selectedIndex,
                  extended: isExtended,
                  minExtendedWidth: 150,
                  onDestinationSelected: (_selectedIndex) =>
                      setState(() => this._selectedIndex = _selectedIndex),
                  leading: IconButton(
                    icon: Icon(
                        isExtended ? Icons.arrow_back : Icons.arrow_forward),
                    onPressed: () => setState(() {
                      isExtended = !isExtended;
                    }),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(
                        icon: Icon(Icons.bar_chart), label: Text('Analytics')),
                    NavigationRailDestination(
                        icon: Icon(Icons.settings), label: Text('Config'))
                  ],
                ),
                //Place elli logo in here
                Positioned(
                    left: 10,
                    right: 0,
                    top: 100,
                    child: isExtended
                        ? const Text("This is where the elli logo should live")
                        : const Text("")),
                //This lets the trailing logout button be at the bottom.
                Positioned(
                    bottom: 10,
                    left: 8,
                    right: 0,
                    //The text does not fit if the navigationRail is collapsed
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage(
                                      title: '',
                                    )));
                        logOut();
                      },
                      icon: const Icon(Icons.logout_outlined),
                      label:
                          isExtended ? const Text("Log out") : const Text(""),
                    ))
              ],
            ),
            const VerticalDivider(),
            //The rest of the page consists of the chosen widget
            Expanded(child: _widgetOptions.elementAt(_selectedIndex))
          ],
        ),
      );
  Future<void> logOut() async {
    authenticationHandler.signOut();
  }
}

/*  The old logout button 
               
IconButton(
padding: const EdgeInsets.all(16.0),
icon: const Icon(
Icons.logout_outlined,
semanticLabel: "Log out",
),
onPressed: () {
Navigator.of(context).pop();
}),
*/

/*The old trailing logout

trailing: IconButton(
icon: const Icon(Icons.logout_outlined, semanticLabel: "Log out", ),
onPressed: () {
Navigator.of(context).pop();
}),
*/

/*  For some reason I thought this would work...
  
  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Log out!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("You sure bro!?!"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Nope!'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yeah!'),
        ),
      ],
    );
  }
  */
