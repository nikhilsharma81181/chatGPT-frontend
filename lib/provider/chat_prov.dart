import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  String chatResult = "";
  String baseUrl = "http://10.0.2.2:3000";

  List<Map> qnA = [];

  bool isLoading = false;

  Future askQuestion(String text) async {
    qnA.add({
      'isUser': true,
      'text': text,
    });
    isLoading = true;
    notifyListeners();
    try {
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      var response = await dio.post(baseUrl, data: {
        "prompt": text,
      });
      if (response.statusCode == 200) {
        String rawRes = response.data["response"];
        rawRes = rawRes.split('\n\n')[1];
        log(rawRes);
        chatResult = rawRes;
        qnA.add({
          'isUser': false,
          'text': rawRes,
        });
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
