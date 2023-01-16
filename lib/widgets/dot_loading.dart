
import 'package:flutter/material.dart';

class LoadingBar extends StatefulWidget {
  const LoadingBar({super.key});

  @override
  _LoadingBarState createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  int _dotCount = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _controller.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          _dotCount++;
          if (_dotCount > 3) {
            _dotCount = 0;
          }
          _controller.reset();
          _controller.forward();
        }
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedDot(
          controller: _controller,
          dotCount: _dotCount,
          index: index,
        );
      }),
    );
  }
}

class AnimatedDot extends StatelessWidget {
  final AnimationController controller;
  final int dotCount;
  final int index;

  const AnimatedDot(
      {super.key,
      required this.controller,
      required this.dotCount,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 4.5,
          height: 4.5,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index <= dotCount
                ? Color.fromARGB(255, 161, 167, 214)
                : Colors.transparent,
          ),
        );
      },
    );
  }
}