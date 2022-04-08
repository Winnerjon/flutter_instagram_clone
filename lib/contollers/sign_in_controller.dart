import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/pages/main_page.dart';
import 'package:flutter_instagram_clone/pages/sign_up_page.dart';
import 'package:flutter_instagram_clone/services/auth_service.dart';
import 'package:flutter_instagram_clone/services/shared_preferences.dart';
import 'package:flutter_instagram_clone/services/utils.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> doSignIn() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if(email.isEmpty || password.isEmpty){
      Utils.fireSnackBar("Please complete al the fields");
      return;
    }

    isLoading = true;
    update();

    await AuthService.signInUser(email, password).then((response) => _getFirebaseUser(response));
  }

  void _getFirebaseUser(Map<String, User?> map) async {
    isLoading = false;
    update();

    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("user-not-found")) Utils.fireSnackBar("No user found for that email.");
      if(map.containsKey("wrong-password")) Utils.fireSnackBar("Wrong password provided for that user.");
      if(map.containsKey("ERROR")) Utils.fireSnackBar("Check Your Information.");
      return;
    }

    User? user = map["SUCCESS"];
    if(user == null) return;

    Prefs.storeUserId(user.uid) ;
    Get.offAll(MainPage.id);

  }

  void getSignUp() {
    Get.offAll(SignUpPage.id);
  }
}