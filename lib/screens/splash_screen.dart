import 'package:flutter/material.dart';
import '../colors.dart';
import '../fetch_pixels.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds and then navigate to the next page
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your next page widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: kAccentColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'মায়া x',
              style: TextStyle(
                fontFamily: 'Sirajee',
                fontSize: FetchPixels.getTextScale()*48,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(
            height: FetchPixels.getPixelHeight(16),
          ),
          Center(
            child: Text(
              'বিক্রেতা',
              style: TextStyle(
                fontFamily: 'Sirajee',
                fontSize: FetchPixels.getTextScale()*24,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(
            height: FetchPixels.getPixelHeight(32),
          ),
          Image.asset(
            'images/woman.png',
            height: FetchPixels.getPixelHeight(96),
          )
        ],
      ),
    );
  }
}