import 'package:flutter/material.dart';
import 'package:pashu_dhan/Core/Constants/color_constants.dart';


class TextInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool? obscure;
  const TextInputField(
      {super.key, required this.label, required this.hint, required this.controller, this.prefixIcon, this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(),
      obscureText: (obscure != null)?obscure!:false,
      decoration: InputDecoration(
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 15,),
            Icon(prefixIcon, color: ColorConstants.c999999),
            Container(
              height: 24,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
          ],
        ),
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: ColorConstants.c999999),
        hintStyle: TextStyle(color: ColorConstants.c999999),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstants.c999999,width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstants.ebddc8,width: 2),
        ),
      ),
    );
  }
}
