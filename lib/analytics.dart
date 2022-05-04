import 'package:elli_admin/tabs/admin_tab.dart';
import 'package:elli_admin/tabs/analytics_view.dart';
import 'package:elli_admin/tabs/temp_tab.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/tabs/home_view.dart';



class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const AnalyticsView(),
    const TempTab(),
    const AdminTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10,0,0,0),
          child: Image.asset('assets/images/elicit_logo.png'),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Temp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: elicitGreen,
        onTap: _onItemTapped,
      ),
    );
  }
}
