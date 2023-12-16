import 'package:flutter/material.dart';

import '../../../common_widgets/custom_elevated_button.dart';


class SocialIconButton extends StatelessWidget {
  final String assetName;
  final VoidCallback onPressed;
  final Color color;

  const SocialIconButton({
    Key? key,
    required this.color,
    required this.assetName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
        padding: const EdgeInsets.all(11),
      ),
      child: Image.asset(assetName, height: 30, width: 30),
    );
  }
}

class SocialSignInButton extends CustomElevatedButton {
  final String assetName;
  final String text;

  SocialSignInButton(
      {Key? key,
      required this.assetName,
      required this.text,
      Color? color,
      Color? textColor,
      VoidCallback? onPressed,
      double height = 50.0})
      : super(
          key: key,
          child: SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(assetName),
                Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 15.0),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Image.asset(assetName),
                ),
              ],
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
