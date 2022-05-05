import 'package:elli_admin/tabs/config_tab.dart';
import 'package:elli_admin/tabs/analytics_tab.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/tabs/home_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _SideBar();
}

class _SideBar extends State<Home> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(),
    );
  }
}
