import 'package:flutter/material.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import '../colors.dart';
import '../components/text_input.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: FetchPixels.getScale()*32),
                  child: Text(
                    "সাইন আপ",
                    style: TextStyle(
                        fontFamily: "Kalpurush",
                        color: kSecondaryColor,
                        fontSize: FetchPixels.getTextScale()*32,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                TextInputFiledsWidget(
                    phoneController: phoneController,
                    userController: userController,
                    passwordController: passwordController
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPScreen(),
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
                      borderRadius: BorderRadius.circular(FetchPixels.getScale()*16),
                    ),
                    child: Text(
                      'সাইন আপ',
                      style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kPrimaryColor,
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
                      'অ্যাকাউন্ট আছে? ',
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
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'লগ ইন করুন',
                        style: TextStyle(
                            fontFamily: 'Kalpurush',
                            color: kAccentColor,
                            fontSize: FetchPixels.getTextScale()*16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
