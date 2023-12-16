import 'package:flutter/material.dart';

import '../const/colors.dart';



class CustomTextButton extends StatelessWidget {
  final String labelText;
  final Color color = SloppyColors.sloppyTheme;
  final void Function() onPressed;

  const CustomTextButton({
    Key? key,
    required this.labelText,
    required this.onPressed,
    color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        labelText,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: color,
        ),
      ),
    );
  }
}
