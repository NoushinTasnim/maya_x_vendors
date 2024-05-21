import 'package:flutter/material.dart';
import 'package:maya_x_vendors/screens/bottom_nav_screen.dart';
import 'package:maya_x_vendors/screens/signup_screen.dart';
import '../colors.dart';
import '../components/text_input.dart';
import '../fetch_pixels.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(FetchPixels.getScale()*32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: FetchPixels.getScale()*32),
                  child: Text(
                    "লগ ইন",
                    style: TextStyle(
                        fontFamily: "Kalpurush",
                        color: kSecondaryColor,
                        fontSize: FetchPixels.getTextScale()*32,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                TextInputFiledsWidget(phoneController: phoneController, passwordController: passwordController),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      vertical: FetchPixels.getScale()*32,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: FetchPixels.getScale()*16,
                      horizontal: FetchPixels.getScale()*32,
                    ),
                    decoration: BoxDecoration(
                      color: kAccentColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'লগ ইন',
                      style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FetchPixels.getTextScale()*16
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'অ্যাকাউন্ট নেই? ',
                      style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kSecondaryColor,
                          fontSize: FetchPixels.getTextScale()*16
                      ),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'সাইন আপ করুন',
                        style: TextStyle(
                            fontFamily: 'Kalpurush',
                            color: kAccentColor,
                            fontSize: FetchPixels.getTextScale()*16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
