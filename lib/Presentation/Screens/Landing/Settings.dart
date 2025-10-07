
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Core/Constants/color_constants.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppBar(
        backgroundColor: ColorConstants.cF2F2F2,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
