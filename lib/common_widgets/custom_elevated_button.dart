import 'package:flutter/material.dart';

@immutable
class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double height;
  final double borderRadius;
  final VoidCallback? onPressed;
  const CustomElevatedButton({
    Key? key,
    required this.child,
    this.color,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          backgroundColor: color ?? Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color textColor;
  final double height;
  final double borderRadius;
  final VoidCallback? onPressed;
  final bool enabled;
  const CustomOutlinedButton({
    Key? key,
    required this.text,
    this.textColor = Colors.white70,
    this.color,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.onPressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
        key: key,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: color ?? Theme.of(context).primaryColor,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(text, style: TextStyle(fontSize: 15.0, color: textColor)),
      ),
    );
  }
}
