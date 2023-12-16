import 'package:flutter/material.dart';

class SlideContainer extends StatefulWidget {
  final Widget child;
  final void Function()? onLeftSlideEndCallback;
  final void Function()? onRightSlideEndCallback;

  const SlideContainer(
      {super.key,
      required this.child,
      this.onLeftSlideEndCallback,
      this.onRightSlideEndCallback});

  bool get canLeftSlide => onLeftSlideEndCallback != null;

  bool get canRightSlide => onRightSlideEndCallback != null;

  @override
  State<StatefulWidget> createState() {
    return SlideContainerState();
  }
}

class SlideContainerState extends State<SlideContainer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late double pageWidth;
  double dragOffset = 0.0;
  double initialDragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      dragOffset = initialDragOffset;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragOffset += details.primaryDelta!;
      if (!widget.canRightSlide && dragOffset > initialDragOffset) {
        dragOffset = initialDragOffset;
      }
      if (!widget.canLeftSlide && dragOffset < initialDragOffset) {
        dragOffset = initialDragOffset;
      }
    });
    if (dragOffset.abs() > (pageWidth * 0.5)) {
      if (dragOffset < initialDragOffset && widget.canLeftSlide) {
        widget.onLeftSlideEndCallback!();
      } else if (dragOffset > initialDragOffset && widget.canRightSlide) {
        widget.onRightSlideEndCallback!();
      }
      dragOffset = initialDragOffset;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      dragOffset = initialDragOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    pageWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Transform.translate(
          offset: Offset(dragOffset, 0),
          child: widget.child,
        ));
  }
}
