import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram_clone/pages/home_page.dart';
import 'package:flutter_instagram_clone/pages/likes_page.dart';
import 'package:flutter_instagram_clone/pages/main_page.dart';
import 'package:flutter_instagram_clone/pages/profile_page.dart';
import 'package:flutter_instagram_clone/pages/search_page.dart';
import 'package:flutter_instagram_clone/pages/sign_in_page.dart';
import 'package:flutter_instagram_clone/pages/sign_up_page.dart';
import 'package:flutter_instagram_clone/pages/splesh_page.dart';
import 'package:flutter_instagram_clone/pages/upload_page.dart';
import 'package:flutter_instagram_clone/pages/user_profile_page.dart';
import 'package:flutter_instagram_clone/services/di_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DIService.init();

  // notification
  var initAndroidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = IOSInitializationSettings();
  var initSetting = InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  FlutterLocalNotificationsPlugin().initialize(initSetting);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpleshPage(),
      routes: {
        SignUpPage.id: (context) => SignUpPage(),
        SignInPage.id: (context) => SignInPage(),
        HomePage.id: (context) => HomePage(),
        LikesPage.id: (context) => LikesPage(),
        ProfilePage.id: (context) => ProfilePage(),
        UploadPage.id: (context) => UploadPage(),
        SearchPage.id: (context) => SearchPage(),
        UserProfilePage.id: (context) => UserProfilePage(),
        MainPage.id: (context) => MainPage(),
      },
    );
  }
}
