import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/services/theme_service.dart';

AppBar appBar(String title,Icon? icon,Function()? onPressed) {
  return AppBar(
    toolbarHeight: 65,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(title,style: ThemeService.appBarStyle,),
    actions: [
      if(icon != null)IconButton(onPressed: onPressed, icon: icon,),
    ],
  );
}