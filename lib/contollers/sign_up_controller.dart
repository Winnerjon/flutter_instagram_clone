import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/pages/sign_in_page.dart';
import 'package:flutter_instagram_clone/services/auth_service.dart';
import 'package:flutter_instagram_clone/models/user_model.dart' as model;
import 'package:flutter_instagram_clone/services/data_service.dart';
import 'package:flutter_instagram_clone/services/shared_preferences.dart';
import 'package:flutter_instagram_clone/services/utils.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  void openSignInPage() async {
    String fullname = fullNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String confirmPassword = confirmPasswordController.text.toString().trim();

    if(fullname.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword){
      Utils.fireSnackBar("Please complete al the fields");
      return;
    }

      isLoading = true;
      update();

    var modelUser = model.User(password: password,email: email,fullName: fullname);
    await AuthService.signUpUser(modelUser).then((response) {
      _getFirebaseUser(modelUser,response);
    });
  }

  void _getFirebaseUser(model.User modelUser,Map<String, User?> map) async {
      isLoading = false;
      update();

    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("weak-password")) Utils.fireSnackBar("The password provided is too weak.");
      if(map.containsKey("email-already-in-use")) Utils.fireSnackBar("The account already exists for that email.");
      if(map.containsKey("ERROR")) Utils.fireSnackBar("Check your information.");
      return;
    }

    User? user = map["SUCCESS"];
    if(user == null) return;

    await Prefs.storeUserId(user.uid);
    modelUser.uid = user.uid;

    DataService.storeUser(modelUser).then((value) {
      Get.offAll(SignInPage.id);
    });
  }

  void getSignIn() {
    Get.offAll(SignInPage.id);
  }
}