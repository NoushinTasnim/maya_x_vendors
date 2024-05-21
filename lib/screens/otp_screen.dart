import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../colors.dart';
import '../fetch_pixels.dart';
import 'bottom_nav_screen.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap:(){
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: kAccentColor,
            )
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ফোন নম্বর ভেরিফিকেশন',
              style: TextStyle(
                  fontFamily: 'Kalpurush',
                  color: kAccentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: FetchPixels.getTextScale()*24
              ),
            ),
            SizedBox(
              height: FetchPixels.getPixelHeight(16),
            ),
            Text(
              'আপনার মোবাইলে একটি ওটিপি কোড প্রেরণ করা হয়েছে',
              style: TextStyle(
                  fontFamily: 'Kalpurush',
                  color: kSecondaryColor,
                  fontSize: FetchPixels.getTextScale()*16
              ),
            ),
            SizedBox(
              height: FetchPixels.getPixelHeight(16),
            ),
            OtpTextField(
              numberOfFields: 4,
              enabledBorderColor: kAccent2,
              focusedBorderColor: kAccentColor,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode){
                showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    }
                );
              }, // end onSubmit
            ),
            SizedBox(
              height: FetchPixels.getPixelHeight(64),
            ),
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
                decoration: BoxDecoration(
                    color: kAccentColor,
                    borderRadius: BorderRadius.circular(FetchPixels.getScale()*16)
                ),
                padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(16), horizontal: FetchPixels.getPixelWidth(32)),
                child: Text(
                  'প্রবেশ করুন',
                  style: TextStyle(
                      fontFamily: 'Kalpurush',
                      color: kPrimaryColor,
                      fontSize: FetchPixels.getTextScale()*16
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
