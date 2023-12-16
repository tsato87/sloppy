import 'package:flutter/material.dart';

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inProgress;
  final double opacity;
  final Color color;
  final String firstText;
  final String? secondText;
  final Animation<Color>? valueColor;

  const ProgressHUD({
    Key? key,
    required this.child,
    required this.inProgress,
    this.opacity = 0.3,
    this.color = Colors.grey,
    required this.firstText,
    this.secondText,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inProgress) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
            child: Material(
              color: Colors.black.withOpacity(0.8),
              child: Container(
                padding: const EdgeInsets.all(38.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: valueColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        firstText,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              ),
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
