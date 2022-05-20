import 'package:elli_admin/main.dart';
import 'package:elli_admin/tabs/config_tab.dart';
import 'package:elli_admin/tabs/analytics_tab.dart';
import 'package:elli_admin/theme.dart';
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
    AnalyticsTab(),
    const ConfigTab()
  ];

  final AuthenticationHandler authenticationHandler =
      AuthenticationHandler.getInstance();

  ///Builds the menu bar Widget and fills the ramaining space with the selected tab.
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NavigationRail(
                  backgroundColor: ElliColors.darkBlue,
                  groupAlignment: 0.0,
                  selectedIndex: _selectedIndex,
                  extended: isExtended,
                  minExtendedWidth: 180,
                  onDestinationSelected: (_selectedIndex) =>
                      setState(() => this._selectedIndex = _selectedIndex),
                  leading: IconButton(
                    icon: Icon(
                      isExtended ? Icons.arrow_back : Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () => setState(() {
                      isExtended = !isExtended;
                    }),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home, color: Colors.white),
                        label: Text('Home',
                            style: TextStyle(color: Colors.white))),
                    NavigationRailDestination(
                        icon: Icon(Icons.bar_chart, color: Colors.white),
                        label: Text('Analytics',
                            style: TextStyle(color: Colors.white))),
                    NavigationRailDestination(
                        icon: Icon(Icons.settings, color: Colors.white),
                        label: Text('Config',
                            style: TextStyle(color: Colors.white))),
                  ],
                ),
                //
                Positioned(
                    left: 0,
                    right: 0,
                    top: 100,
                    child: isExtended
                        ? SizedBox(
                            child: Image.asset('assets/images/elli_logo.png'),
                            height: 60,
                          )
                        : SizedBox(
                            child: Image.asset('assets/images/elli_E_logo.png'),
                            height: 60,
                          )),
                //This lets the trailing logout button be at the bottom.
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: TextButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage(
                                        title: '',
                                      )));
                          logOut();
                        },
                        icon: const Icon(Icons.logout_outlined,
                            color: Colors.white),
                        //The text does not fit if the navigationRail is collapsed
                        label: isExtended
                            ? const Text("Log out",
                                style: TextStyle(color: Colors.white))
                            : const Text("",
                                style: TextStyle(color: Colors.white))))
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
