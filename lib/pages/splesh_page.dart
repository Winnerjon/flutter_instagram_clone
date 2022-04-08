import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/animations/fade_animation.dart';
import 'package:flutter_instagram_clone/pages/main_page.dart';
import 'package:flutter_instagram_clone/pages/sign_in_page.dart';
import 'package:flutter_instagram_clone/services/shared_preferences.dart';
import 'package:flutter_instagram_clone/services/theme_service.dart';

class SpleshPage extends StatefulWidget {
  const SpleshPage({Key? key}) : super(key: key);

  @override
  _SpleshPageState createState() => _SpleshPageState();
}

class _SpleshPageState extends State<SpleshPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _openGlobalPage() {
  if(mounted){
    Timer(Duration(seconds: 5), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return _starterPage();
      }));
    });
  }
  }


  _initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print("Token: ${token!}");
      }
      Prefs.storeUserToken(token!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openGlobalPage();
    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: ThemeService.backgraundGradient,
            child: FadeAnimation(
              2,
              Center(
                child: Text(
                  "Instagram",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45 ,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Billabong"),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "All rights reserved",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _starterPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Prefs.storeUserId(snapshot.data!.uid);
          return MainPage();
        } else {
          Prefs.remove();
          return SignInPage();
        }
      },
    );
  }
}
