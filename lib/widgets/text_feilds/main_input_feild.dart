import 'package:flutter/material.dart';
import 'package:Mazaj/Theme/app_colors.dart';

class MainInputFeild extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function onChanged;
  final bool enabled;
  final Icon suffixIcon;
  bool number;
  MainInputFeild(
      {this.controller,
      this.hintText,
      this.number = false,
      this.onChanged,
      this.suffixIcon,
      this.enabled = true});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.03,
      ),
      child: TextField(
        style: TextStyle(fontFamily: "Arial"),
        // keyboardType: TextInputType.number,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        enabled: enabled,
        keyboardType: this.number ? TextInputType.number : TextInputType.text,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.darkGrey, width: 2.0),
            ),
            hintText: hintText,
            hintStyle: TextStyle(fontFamily: "GE_SS_Two"),
            fillColor: Color(0xFF302F2F),
            filled: true,
            suffixIcon: suffixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.never),
      ),
    );
  }
}
