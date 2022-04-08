import 'package:flutter/material.dart';

MaterialButton button(
    {required String title, required void Function() onPressed}) {
  return MaterialButton(
    onPressed: onPressed,
    height: 55,
    minWidth: double.infinity,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
      side: BorderSide(
        color: Colors.white38,
        width: 2,
      ),
    ),
    child: Text(
      title,
      style: TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
    ),
  );
}
