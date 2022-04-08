import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/contollers/main_controller.dart';
import 'package:flutter_instagram_clone/pages/home_page.dart';
import 'package:flutter_instagram_clone/pages/likes_page.dart';
import 'package:flutter_instagram_clone/pages/profile_page.dart';
import 'package:flutter_instagram_clone/pages/search_page.dart';
import 'package:flutter_instagram_clone/pages/upload_page.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  static const String id = "/main_page";

  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      builder: (mainController) {
        return Scaffold(
          body: PageView(
            controller: mainController.controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              SearchPage(),
              UploadPage(),
              LikesPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: itemBottomNavigationBar(mainController),
        );
      }
    );
  }

  /// #bottomNavigationBar
  Widget itemBottomNavigationBar(MainController mainController) {
    return CupertinoTabBar(
      onTap: (index) => mainController.getPage(index),
      currentIndex: mainController.currentTap,
      activeColor: Color.fromRGBO(193, 53, 132, 1),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              size: 32,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 32,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32,
            ),
            label: ""),
      ],
    );
  }
}
