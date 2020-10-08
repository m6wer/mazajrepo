import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ShowToast {
  static void showToast(BuildContext context, String msg,
      {int duration, int gravity, Color backgroundColor, Color textColor}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: gravity,
        backgroundColor:
            backgroundColor != null ? backgroundColor : Colors.black45,
        textColor: textColor != null ? textColor : Colors.white);
  }
}