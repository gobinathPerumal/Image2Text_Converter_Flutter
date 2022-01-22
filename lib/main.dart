import 'package:flutter/material.dart';
import 'package:image_text_converter/controller/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Image2Text",
      home: MySplashScreen(),
    );
  }
}