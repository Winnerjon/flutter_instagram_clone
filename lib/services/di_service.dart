import 'package:flutter_instagram_clone/contollers/home_controller.dart';
import 'package:flutter_instagram_clone/contollers/likes_controller.dart';
import 'package:flutter_instagram_clone/contollers/main_controller.dart';
import 'package:flutter_instagram_clone/contollers/profile_controller.dart';
import 'package:flutter_instagram_clone/contollers/search_controller.dart';
import 'package:flutter_instagram_clone/contollers/sign_in_controller.dart';
import 'package:flutter_instagram_clone/contollers/sign_up_controller.dart';
import 'package:flutter_instagram_clone/contollers/upload_controller.dart';
import 'package:get/get.dart';

class DIService {
  static Future<void> init() async {
    Get.lazyPut(() => SignInController(),fenix: true);
    Get.lazyPut(() => SignUpController(),fenix: true);
    Get.lazyPut(() => MainController(),fenix: true);
    Get.lazyPut(() => HomeController(),fenix: true);
    Get.lazyPut(() => SearchController(),fenix: true);
    Get.lazyPut(() => UploadController(),fenix: true);
    Get.lazyPut(() => LikesController(),fenix: true);
    Get.lazyPut(() => ProfileController(),fenix: true);
  }
}