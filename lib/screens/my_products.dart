import 'package:flutter/material.dart';
import 'package:maya_x_vendors/colors.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import 'package:maya_x_vendors/utils/load_orders.dart';

import '../model/Vendor_model.dart';
import '../model/order.dart';
import '../model/product.dart';
import '../utils/language_map.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  Usermodel user= Usermodel();
  late Future<List<Product>> _futuremsg;

  @override
  void initState() {
    super.initState();
    _futuremsg = loadMyOrders(user.getUserID()).then((msgs) {
      return msgs;
    });
  }
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
      body: FutureBuilder<List<Product>>(
        future: _futuremsg,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('আপনার কোন নোটিফিকেশন আসে নি'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('আপনার কোন নোটিফিকেশন আসে নি'));
          }
          final msgs = snapshot.data!;
          return ListView.builder(
            itemCount: msgs.length,
            itemBuilder: (context, index) {
              final msg = msgs[index];
              return Card(
                color: Colors.white,
                margin: EdgeInsets.all(FetchPixels.getScale()*8.0),
                child: Padding(
                  padding: EdgeInsets.all(FetchPixels.getScale()*16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'অর্ডার আইডিঃ ${englishToBangla(msg.index.toString())}',
                        style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kSecondaryColor,
                        ),
                      ),
                      SizedBox(
                        height: FetchPixels.getPixelHeight(8),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage(msg.image),
                            height: FetchPixels.getScale()*100,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${msg.name}',
                                  style: TextStyle(
                                    fontFamily: 'Kalpurush',
                                    fontSize: 16,
                                    color: kSecondaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'মূল্যঃ ${msg.amount}',
                                  style: TextStyle(
                                    fontFamily: 'Kalpurush',
                                    fontSize: 16,
                                    color: kSecondaryColor.withOpacity(0.64),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
