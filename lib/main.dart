import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:animated_splash/animated_splash.dart';
//import 'home.dart';
import 'login.dart';
//import 'register.dart';

void main() {
  Function duringSplash = () {
    return 1;
  };

  Map<int, Widget> op = {1:login()};

  runApp(MaterialApp(
    routes:<String, WidgetBuilder>{
      "/login":(BuildContext context)=>login(),
    },
    debugShowCheckedModeBanner: false,
    home: AnimatedSplash(
      imagePath: 'assets/logo2.png',
      home: login(),
      customFunction: duringSplash,
      duration: 3500,
      type: AnimatedSplashType.BackgroundProcess,
      outputAndHome: op,

    ),
  ),
  );
}