import 'package:flutter/material.dart';

class SwitchTile extends StatefulWidget {
  final String message;
  final bool isChecked;
  final void Function(bool)? onChanged;

  const SwitchTile({
    Key? key,
    required this.message,
    this.isChecked = false,
    this.onChanged,
  }) : super(key: key);

  @override
  SwitchTileState createState() => SwitchTileState();
}

class SwitchTileState extends State<SwitchTile> {
  late bool isChecked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                )),
            Switch(
                onChanged: (bool value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                value: isChecked)
          ]),
    );
  }

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }
}
