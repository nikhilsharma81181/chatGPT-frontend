import 'package:chat_gpt_frontend/provider/chat_prov.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/dot_loading.dart';
import '../Chat/chat_bubble.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _textController = TextEditingController();

  _handleSubmission(String text) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 200), () {
      _textController.clear();
    });
    await context.read<ChatProvider>().askQuestion(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF343542),
          ),
          // padding: const EdgeInsets.all(10),
          child: chatListView(),
        ),
      ),
      bottomSheet: _textComposerWidget(),
    );
  }

  Widget chatListView() {
    double width = MediaQuery.of(context).size.width;
    List qnA = context.watch<ChatProvider>().qnA;
    return qnA.isNotEmpty
        ? ListView(
            reverse: true,
            children: [
              SizedBox(height: width * 0.15),
              Column(
                children: [
                  ...qnA
                      .map((e) =>
                          ChatBubble(isMe: e['isUser'], message: e['text']))
                      .toList(),
                ],
              )
            ],
          )
        : const Center(
            child: Text(
              'Always ready to help...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          );
  }

  Widget _textComposerWidget() {
    double width = MediaQuery.of(context).size.width;
    bool isLoading = context.watch<ChatProvider>().isLoading;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          color: const Color(0xFF343542),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 79, 81, 100),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration.collapsed(
                      hintText: "Ask Something",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.025),
                isLoading
                    ? const LoadingBar()
                    : GestureDetector(
                        onTap: () {
                          _handleSubmission(_textController.text);
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
