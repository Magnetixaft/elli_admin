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
            NavigationRail(
              groupAlignment: 0.0,
              selectedIndex: _selectedIndex,
              extended: isExtended,
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
              trailing: IconButton(
                  icon: Icon(Icons.logout_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            const VerticalDivider(),
            Expanded(child: _widgetOptions.elementAt(_selectedIndex))
          ],
        ),
      );
}
