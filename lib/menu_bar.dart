import 'package:elli_admin/main.dart';
import 'package:elli_admin/tabs/config_tab.dart';
import 'package:elli_admin/tabs/analytics_tab.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/tabs/home_tab.dart';
import 'package:elli_admin/authentication_handler.dart';

/// The home page for the ELLI admin console.
///
/// Allows the user to navigate between the tabs [HomeView], [AnalyticsTab] and [ConfigTab]
class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  int _selectedIndex = 0;
  bool isExtended = true;

  ///The list of different widgets than can be rached from the navigation bar.
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
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
                //TODO add ELLI logo here.
                Positioned(
                    left: 10,
                    right: 0,
                    top: 100,
                    child: isExtended
                        ? const Text("This is where the elli logo should live")
                        : const Text("")),
                //This lets the trailing logout button at the bottom.
                Positioned(
                    bottom: 10,
                    left: 8,
                    right: 0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                      title: '',
                                    )));
                        logOut();
                      },
                      icon: const Icon(Icons.logout_outlined),
                      //The text does not fit if the navigationRail is collapsed
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
