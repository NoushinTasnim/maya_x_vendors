import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../colors.dart';
import 'bottom_nav_screen.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  final String password;
  final String name;

  OTPScreen({
    Key? key,
    required this.verificationId,
    required this.phone,
    required this.password,
    required this.name,
  }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otpCode = "";
  bool isOtpSent = true;
  late String _verificationId;

  void _resendOtp() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isOtpSent = true;
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 120),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ওটিপি পুনরায় পাঠানো হয়েছে')),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _saveUserData(String uid) async {
    CollectionReference collref = FirebaseFirestore.instance.collection('vendor');
    await collref.doc(uid).set({
      'phone': widget.phone,
      'password': widget.password,
      'shop name': widget.name,
      'userID': uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: kAccentColor,
          ),
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
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'আপনার মোবাইলে একটি ওটিপি কোড প্রেরণ করা হয়েছে',
              style: TextStyle(
                fontFamily: 'Kalpurush',
                color: kSecondaryColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            OtpTextField(
              numberOfFields: 6,
              enabledBorderColor: kAccent2,
              focusedBorderColor: kAccentColor,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // Handle validation or checks here
              },
              onSubmit: (String verificationCode) {
                setState(() {
                  otpCode = verificationCode;
                });
              },
            ),
            SizedBox(height: 64),
            InkWell(
              onTap: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpCode,
                  );

                  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                  await _saveUserData(userCredential.user!.uid);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('সাইন আপ সম্পন্ন হয়েছে।')),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavScreen(),
                    ),
                  );
                } catch (ex) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ওটিপি টি সঠিক নয়!')),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kAccentColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  'প্রবেশ করুন',
                  style: TextStyle(
                    fontFamily: 'Kalpurush',
                    color: kPrimaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            isOtpSent
                ? InkWell(
              onTap: _resendOtp,
              child: Text(
                'ওটিপি পুনরায় পাঠান',
                style: TextStyle(
                  fontFamily: 'Kalpurush',
                  color: kAccentColor,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
                : CircularProgressIndicator(color: kAccentColor),
          ],
        ),
      ),
    );
  }
}
