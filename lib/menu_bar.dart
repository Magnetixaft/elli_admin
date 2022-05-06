import 'package:elli_admin/tabs/config_tab.dart';
import 'package:elli_admin/tabs/analytics_tab.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/tabs/home_tab.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  int _selectedIndex = 0;
  bool isExtended = false;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const AnalyticsTab(),
    const ConfigTab()
  ];

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
                    icon: Icon(isExtended ? Icons.turn_left : Icons.turn_right),
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
                //This lets the trailing logout button be at the bottom.
                Positioned(
                    bottom: 10,
                    left: 8,
                    right: 0,
                    //The text does not fit if the navigationRail is collapsed
                    child: isExtended
                        ? ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.logout_outlined),
                            label: Text("Log out"),
                            style: ElevatedButton.styleFrom(
                                //textStyle: TextStyle(fontSize: 15),
                                ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.logout_outlined),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                //textStyle: TextStyle(fontSize: 15),
                                ),
                          ))
              ],
            ),
            const VerticalDivider(),
            //The rest of the page consists of the chosen widget
            Expanded(child: _widgetOptions.elementAt(_selectedIndex))
          ],
        ),
      );
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