import 'package:flutter/material.dart';
import 'package:maya_x_vendors/colors.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAccentColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
        title: const Text(
          'আমার পণ্য',
          style: TextStyle(
            fontFamily: 'Kalpurush',
            color: kPrimaryColor,
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: Column(
      ),
    );
  }
}
