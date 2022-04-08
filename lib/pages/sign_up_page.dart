import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/animations/fade_animation.dart';
import 'package:flutter_instagram_clone/contollers/sign_up_controller.dart';
import 'package:flutter_instagram_clone/services/theme_service.dart';
import 'package:flutter_instagram_clone/views/button_widget.dart';
import 'package:flutter_instagram_clone/views/textfield_widget.dart';

class SignUpPage extends StatelessWidget {
  static const String id = "/sign_up_page";

  SignUpPage({Key? key}) : super(key: key);
  SignUpController controller = SignUpController();


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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
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

                    /// #fullname
                    FadeAnimation(3, textField(hintText: "Fullname", controller: controller.fullNameController)),
                    SizedBox(
                      height: 15,
                    ),

                    /// #email
                    FadeAnimation(4, textField(hintText: "Email", controller: controller.emailController)),
                    SizedBox(
                      height: 15,
                    ),

                    /// #password
                    FadeAnimation(5, textField(hintText: "Password", controller: controller.passwordController)),
                    SizedBox(
                      height: 15,
                    ),

                    /// #confirm password
                    FadeAnimation(6, textField(hintText: "Confirm Password", controller: controller.confirmPasswordController)),
                    SizedBox(
                      height: 15,
                    ),

                    /// #sign up
                    FadeAnimation(7, button(title: "Sign Up", onPressed: controller.openSignInPage)),
                  ],
                ),
              ),
              FadeAnimation(8,  RichText(text: TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        controller.getSignIn();
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
