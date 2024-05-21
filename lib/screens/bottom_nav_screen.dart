import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import 'package:maya_x_vendors/screens/my_orders.dart';
import 'package:maya_x_vendors/screens/view_all_products.dart';
import '../colors.dart';
import 'add_products.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  int pageIndex = 0;

  List<Widget> pageList = <Widget>[
    ProductScreen(),
    MyOrders(),
  ];

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: PageTransitionSwitcher(
        transitionBuilder: (
            child,
            primaryAnimation,
            secondaryAnimation,
            ) => FadeThroughTransition(
          fillColor: kPrimaryColor,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        child: pageList[pageIndex],
      ),
      bottomNavigationBar:
      Container(
        margin: EdgeInsets.all(FetchPixels.getScale()*8),
        decoration: BoxDecoration(
          color: kAccentColor,
          borderRadius: BorderRadius.circular(FetchPixels.getScale()*48),
        ),
        child: Padding(
          padding: EdgeInsets.all(FetchPixels.getScale()*8.0),
          child: GNav(
            selectedIndex: pageIndex,
            onTabChange: (value){
              print(value);
              setState(() {
                pageIndex = value;
              });
            },
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            backgroundColor: Colors.transparent,
            tabBackgroundColor: kPrimaryColor,
            color: Colors.white,
            activeColor: kAccentColor,
            gap: 8,
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(16), vertical: FetchPixels.getPixelHeight(8)),
            tabs: const [
              GButton(
                icon: Icons.shop,
                text: 'পণ্য দেখুন',
              ),
              GButton(
                icon: Icons.local_shipping_outlined,
                text: 'আমার অর্ডার',
              ),
            ],
          ),
        ),
      ),
    );
  }
}