import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import 'package:maya_x_vendors/screens/signup_screen.dart';


import '../colors.dart';
import '../components/text_input.dart';
import '../model/Vendor_model.dart';
import 'bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController = TextEditingController(text: "+880");
  TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool _isLoading = false;

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
                const Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Text(
                    "লগ ইন",
                    style: TextStyle(
                      fontFamily: "Kalpurush",
                      color: kSecondaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextInputFiledsWidget(
                    phoneController: phoneController,
                    passwordController: passwordController),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    String phone = phoneController.text.trim();
                    String password = passwordController.text.trim();

                    // Retrieve user document from Firestore
                    var userDoc = await FirebaseFirestore.instance
                        .collection('vendor')
                        .where('phone', isEqualTo: phone)
                        .get();

                    if (userDoc.docs.isNotEmpty) {
                      var userData = userDoc.docs.first.data();
                      if (userData['password'] == password) {
                        print(userData['shop name']);
                        Usermodel user= Usermodel();
                        user.setShopName(userData['shop name']);
                        user.setUserID(userData['userID']);
                        user.setPassword(userData['password']);
                        user.setPhone(userData['phone']);

                        print(user.getShopName());
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavScreen(),
                          ),
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }
                    }
                    setState(() {
                      _isLoading = false;
                    });

                    // Display error message if authentication fails
                    setState(() {
                      errorMessage = 'ভুল নম্বর বা পাসওয়ার্ড';
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    decoration: BoxDecoration(
                      color: kAccentColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'লগ ইন',
                      style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if(_isLoading) Center(
                  child: Padding(
                    padding: EdgeInsets.all(FetchPixels.getScale()*16.0),
                    child: CircularProgressIndicator(
                      color: kAccentColor,
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
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () {
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
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
