
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.isMe});

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF343542) : const Color(0xFF444654),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width * 0.1,
            height: width * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isMe ? const Color(0xFF5536DA) : const Color(0xFF12A380),
            ),
            child: Icon(
              isMe ? Icons.person_outline : Icons.smart_toy_outlined,
              color: Colors.white,
            ),
          ),
          SizedBox(width: width * 0.02),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.symmetric(vertical: width * 0.02),
            child: isMe
                ? Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  )
                : TypingAnimation(text: message),
          ),
        ],
      ),
    );
  }
}

class TypingAnimation extends StatefulWidget {
  const TypingAnimation({super.key, required this.text});

  final String text;

  @override
  _TypingAnimationState createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String displayedText = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 75),
      vsync: this,
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() async {
    for (int i = 0; i < widget.text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 75));
      setState(() {
        displayedText = displayedText + widget.text[i];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SelectableText(
          displayedText,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
          ),
        );
      },
    );
  }
}