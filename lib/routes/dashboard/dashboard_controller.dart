import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/message.dart';

class DashboardController extends ChangeNotifier {
  List<String> logs = [];
  bool isLoading = true;

  Future<void> init() async {
    try {
      http.Response response = await http.get(
        Uri.parse('http://lease-it.herokuapp.com/api/v1/messages'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer 4659b57f584b5d376515d903c1c06488",
        },
      );

      String string = response.body;
      final data = await json.decode(string);

      final messages = data["messages"] as List;

      for (int i = 0; i < messages.length; i++) {
        final message = Message.fromMap(messages[i]);

        await BackgroundSms.sendMessage(
          phoneNumber: message.number,
          message: message.message,
          simSlot: 2,
        ).then((value) async {
          if (value == SmsStatus.sent) {
            logs.add("${DateTime.now().toIso8601String()} message sent");
          } else {
            logs.add("${DateTime.now().toIso8601String()} message failed");
          }
          await http.patch(
            Uri.parse('http://lease-it.herokuapp.com/api/v1/messages'),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer 4659b57f584b5d376515d903c1c06488",
            },
            body: {
              "id": message.id,
              "status": value == SmsStatus.sent ? "sent" : "failed",
            },
          );
        });
      }
    } catch (ex) {
      log(ex.toString());
    }
  }

  DashboardController() {
    init();
    final dummyFuture = Future<void>.delayed(const Duration(seconds: 1));
    dummyFuture.then((_) {
      isLoading = false;
      notifyListeners();
    });
  }
}
