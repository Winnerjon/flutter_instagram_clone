import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/animations/fade_animation.dart';
import 'package:flutter_instagram_clone/contollers/sign_in_controller.dart';
import 'package:flutter_instagram_clone/pages/main_page.dart';
import 'package:flutter_instagram_clone/pages/sign_up_page.dart';
import 'package:flutter_instagram_clone/services/auth_service.dart';
import 'package:flutter_instagram_clone/services/shared_preferences.dart';
import 'package:flutter_instagram_clone/services/theme_service.dart';
import 'package:flutter_instagram_clone/services/utils.dart';
import 'package:flutter_instagram_clone/views/button_widget.dart';
import 'package:flutter_instagram_clone/views/textfield_widget.dart';

class SignInPage extends StatelessWidget {
  static const String id = "/sign_in_page";

  SignInPage({Key? key}) : super(key: key);
  SignInController controller = SignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: ThemeService.backgraundGradient,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /// #text
                      FadeAnimation(1, Text(
                        "Instagram",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Billabong"),
                      )),
                      SizedBox(
                        height: 20,
                      ),

                      /// #email
                      FadeAnimation(3, textField(hintText: "Email", controller: controller.emailController)),
                      SizedBox(
                        height: 15,
                      ),

                      /// #password
                      FadeAnimation(4, textField(hintText: "Password", controller: controller.passwordController)),
                      SizedBox(
                        height: 15,
                      ),

                      /// #sign in
                      FadeAnimation(5, button(title: "Sign In", onPressed: controller.doSignIn)),
                    ],
                  ),
                ),
              ),
              FadeAnimation(6,  RichText(text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        controller.getSignUp();
                      },
                    )
                  ]
              ),)),
            ],
          ),
        ),
      ),
    );
  }
}
