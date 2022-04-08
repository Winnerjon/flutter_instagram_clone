import 'package:flutter/material.dart';

Container textField({required String hintText,bool? isHidden, required TextEditingController controller}){
  return Container(
    height: 60,
    padding: EdgeInsets.symmetric(horizontal: 15),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white12,
    ),
    child: TextField(
      controller: controller,
      obscureText: isHidden ?? false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54,fontSize: 16),
      ),
    ),
  );
}