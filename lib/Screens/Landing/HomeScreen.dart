import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'Dashboard.dart';
import 'Help.dart';
import 'LiveStock.dart';
import 'Settings.dart';




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      Dashboard(
        goToLivestock: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      Livestock(onBack: () {
        setState(() => _currentIndex = 0);
      }),
      const Settings(),
      const Help(),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _screens[_currentIndex],

      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.pets),
            title: const Text("Livestock"),
            selectedColor: Colors.teal,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.help_outline),
            title: const Text("Help"),
            selectedColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

