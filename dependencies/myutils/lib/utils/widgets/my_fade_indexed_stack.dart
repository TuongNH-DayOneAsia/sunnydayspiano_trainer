import 'package:flutter/material.dart';

class MyFadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const MyFadeIndexedStack({
    Key? key,
    required this.index,
    required this.children,
    this.duration = const Duration(
      milliseconds: 200,
    ),
  }) : super(key: key);

  @override
  State<MyFadeIndexedStack> createState() => _MyFadeIndexedStackState();
}

class _MyFadeIndexedStackState extends State<MyFadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(MyFadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
