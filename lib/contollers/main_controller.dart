import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/services/utils.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  PageController controller = PageController();
  int currentTap = 0;

  _initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message: ${message.notification.toString()}");
      Utils.showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
  }

  void getPage(int index) {
    currentTap = index;
    update();

    controller.jumpToPage(currentTap);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _initNotification();
  }
}