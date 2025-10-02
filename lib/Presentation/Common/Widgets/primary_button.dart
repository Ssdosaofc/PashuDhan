import 'package:flutter/material.dart';

import '../../../Core/Constants/color_constants.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const PrimaryButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ColorConstants.c1C5D43)
        ),
        onPressed: onPressed,
        child: Text(text,
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),
        )
      ),
    );
  }
}
