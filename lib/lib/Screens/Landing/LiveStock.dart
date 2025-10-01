
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Core/Constants/assets_constants.dart';
import '../../Core/Constants/color_constants.dart';

class Livestock extends StatefulWidget {
  const Livestock({super.key});

  @override
  State<Livestock> createState() => _LivestockState();
}

class _LivestockState extends State<Livestock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.c1C5D43,
        leading: IconButton(
          icon: Image.asset(
            AssetsConstants.left_arrow,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Livestock"),
      ),
    );
  }
}
