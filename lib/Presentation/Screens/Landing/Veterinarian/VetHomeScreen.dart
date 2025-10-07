import 'package:flutter/material.dart';
import 'package:pashu_dhan/Presentation/Screens/Landing/Veterinarian/ChatsPage.dart';
import 'package:pashu_dhan/Presentation/Screens/Landing/Veterinarian/HistoryPage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart'; // Make sure this package is in pubspec.yaml

class VetHomeScreen extends StatefulWidget {
  @override
  _VetHomeScreenState createState() => _VetHomeScreenState();
}

class _VetHomeScreenState extends State<VetHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ChatsPage(),
    HistoryPage(),
    Center(child: Text('Settings Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _screens[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat),
            title: const Text("Chats"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.history),
            title: const Text("History"),
            selectedColor: Colors.teal,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
