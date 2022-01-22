import 'package:flutter/material.dart';
import 'package:image_text_converter/controller/homeScreen.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 8,
      navigateAfterSeconds: const HomeScreen(),
      title: const Text(
        'Image2Text Converter',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.purple),
      ),
      image: Image.asset('assets/logo.png'),
      backgroundColor: Colors.white,
      photoSize: 60.0,
      loaderColor: Colors.purple,
      loadingText: const Text(
        'Please Wait....',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black45),
      ),
    );
  }
}
