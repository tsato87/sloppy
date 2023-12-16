import 'package:flutter/material.dart';

import '../../common_widgets/custom_elevated_button.dart';
import '../../const/strings.dart';

class CancelButton extends CustomOutlinedButton {
  const CancelButton({
    Key? key,
    text = Strings.cancel,
    Color? color,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          text: text,
          color: color,
          onPressed: onPressed,
        );
}

class SignButton extends CustomElevatedButton {
  SignButton({
    Key? key,
    required String text,
    Color? color,
    required VoidCallback onPressed,
    Color textColor = Colors.black,
    double height = 50.0,
  }) : super(
          key: key,
          child: Text(text, style: TextStyle(color: textColor, fontSize: 15.0)),
          color: color,
          height: height,
          onPressed: onPressed,
        );
}
