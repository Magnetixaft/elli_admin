import 'dart:html';

import 'package:elli_admin/tabs/config_tab.dart';
import 'package:elli_admin/tabs/analytics_tab.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/tabs/home_view.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const AnalyticsTab(),
    const ConfigTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _destinations = <AdaptiveScaffoldDestination>[
    const AdaptiveScaffoldDestination(title: "Home", icon: Icons.home),
    const AdaptiveScaffoldDestination(
        title: "Analytics", icon: Icons.bar_chart),
    const AdaptiveScaffoldDestination(title: "Config", icon: Icons.settings)
  ];
  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigationScaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        destinations: _destinations,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped);
  }
}
