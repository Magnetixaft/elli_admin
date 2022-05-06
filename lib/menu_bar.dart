import 'package:elli_admin/tabs/config_tab.dart';
import 'package:elli_admin/tabs/analytics_tab.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/tabs/home_view.dart';

class MenuBar1 extends StatefulWidget {
  const MenuBar1({Key? key}) : super(key: key);

  @override
  _MenuBar1State createState() => _MenuBar1State();
}

class _MenuBar1State extends State<MenuBar1> {
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
              trailing: IconButton(
                  icon: Icon(Icons.logout_outlined), onPressed: () {}),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.bar_chart), label: Text('Analytics')),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text('Config'))
              ],
            ),
            const VerticalDivider(),
            Expanded(child: _widgetOptions.elementAt(_selectedIndex))
          ],
        ),
      );
}
