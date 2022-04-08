import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/services/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class Utils {
  // FireSnackBar
  static fireSnackBar(String msg) {
    Get.snackbar("Message", msg);
  }

  static Future<bool> dialogCommon(BuildContext context,String title, String message, bool isSingle) async{
    return await showDialog(
      context: context,
      builder: (context) {
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            !isSingle ?
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ) : const SizedBox.shrink(),
            CupertinoDialogAction(
              child: const Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ) : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            !isSingle ?
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")
            ) : const SizedBox.shrink(),
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            },
                child: const Text("Confirm")),
          ],
        );
      },
    );
  }

  static Future<Map<String,String>> deviceParams() async {
    Map<String,String> params = {};

    var deviceInfo = DeviceInfoPlugin();
    String fcmToken = (await Prefs.loadUserToken())!;

    if(Platform.isIOS) {
      var iosDeviseInfo = await deviceInfo.iosInfo;
      params.addAll({
        "device_id" : iosDeviseInfo.identifierForVendor!,
        "device_type" : "I",
        "device_token" : fcmToken,
      });
    }else{
      var androidDeviseInfo = await deviceInfo.androidInfo;
      params.addAll({
        "device_id" : androidDeviseInfo.androidId!,
        "device_type" : "A",
        "device_token" : fcmToken,
      });
    }

    return params;
   }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    var android = const AndroidNotificationDetails('channelId', 'channelName',channelDescription: 'channelDescription');
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);
  }
}