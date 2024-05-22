import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colors.dart';
import '../components/text_input.dart';
import 'bottom_nav_screen.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController phoneController = TextEditingController(text: "+880");
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? verificationId;

  @override
  Widget build(BuildContext context) {
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
                    "সাইন আপ",
                    style: TextStyle(
                        fontFamily: "Kalpurush",
                        color: kSecondaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                TextInputFiledsWidget(phoneController: phoneController, userController: userController,passwordController: passwordController),
                InkWell(
                  onTap: () async {
                    String phone = phoneController.text.trim();
                    if (!phone.startsWith("+880") || phone.length != 14) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ফোন নম্বরটি ১১ ডিজিটের হতে হবে এবং +880 দিয়ে শুরু করতে হবে')),
                      );
                      return;
                    }

                    // Check if the user with the same phone number already exists
                    bool userExists = await _checkUserExists(phone);
                    if (userExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('এই ফোন নম্বরটি ইতিমধ্যে নিবন্ধিত আছে, অনুগ্রহ করে একটি নতুন নম্বর ব্যবহার করুন')),
                      );
                    } else {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phone,
                        verificationCompleted: (PhoneAuthCredential credential) async {
                          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                          await _saveUserData(userCredential.user!.uid);


                        },
                        verificationFailed: (FirebaseAuthException e) {
                          print('Verification failed: ${e.message}');
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          setState(() {
                            this.verificationId = verificationId;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPScreen(
                                verificationId: verificationId,
                                phone: phoneController.text.trim(),
                                password: passwordController.text.trim(),
                                name: userController.text.trim(),
                              ),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          setState(() {
                            this.verificationId = verificationId;
                          });
                        },
                      );
                    }
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
                      'সাইন আপ',
                      style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kPrimaryColor,
                          fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'অ্যাকাউন্ট আছে? ',
                      style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kSecondaryColor,
                          fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'লগ ইন করুন',
                        style: TextStyle(
                            fontFamily: 'Kalpurush',
                            color: kAccentColor,
                            fontSize: 16,
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

  Future<bool> _checkUserExists(String phone) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('vendor')
        .where('phone', isEqualTo: phone)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _saveUserData(String uid) async {
    CollectionReference collref = FirebaseFirestore.instance.collection('vendor');
    await collref.doc(uid).set({
      'phone': phoneController.text.trim(),
      'password': passwordController.text.trim(),
      'shop name': userController.text.trim(),
      'userID': uid,
    });


  }
}
