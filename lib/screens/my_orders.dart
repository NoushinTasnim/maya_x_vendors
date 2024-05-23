import 'package:flutter/material.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import 'package:maya_x_vendors/utils/store_orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../colors.dart';
import '../model/Vendor_model.dart';
import '../model/order.dart';
import '../utils/calculation.dart';
import '../utils/language_map.dart';
import '../utils/load_orders.dart';
import 'my_products.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  Usermodel user= Usermodel();
  late Future<List<Orders>> _futureOrders;
  late Map<String, bool> _showConfirmRowMap = {};

  @override
  void initState() {
    super.initState();
    loadCheckouts(user.getUserID()).then((orders) {
      setState(() {
        _futureOrders = Future.value(orders);
        _showConfirmRowMap = Map.fromIterable(
          orders,
          key: (order) => order.id,
          value: (_) => true,
        );
      });
    });
  }


  Future<void> updateOrderStatus(String vendorId, Orders order, String status) async {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('phone', isEqualTo: order.userPhone)
        .limit(1)
        .get();

    String userId = userSnapshot.docs.first.id;

    try {
      await FirebaseFirestore.instance
          .collection('vendor')
          .doc(vendorId)
          .collection('orders')
          .doc(order.id)
          .update({'status': status});

      QuerySnapshot checkoutsSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('checkout')
          .get();

      for (var checkoutDoc in checkoutsSnapshot.docs) {
        QuerySnapshot ordersDetailsSnapshot = await checkoutDoc.reference.collection('orders').get();

        for (var orderDetailDoc in ordersDetailsSnapshot.docs) {
          if (orderDetailDoc.id == order.id) {
            await orderDetailDoc.reference.update({'status': status});

            if (status == 'কনফার্ম') {
              await sendConfirmationMessage(userId, order);
            } else if (status == 'বাতিল') {
              await sendCancellationMessage(userId, order);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(status == 'কনফার্ম' ? 'অর্ডারটি সফলভাবে নিশ্চিত হয়েছে' : 'অর্ডারটি বাতিল করা হয়েছে'),
                duration: Duration(seconds: 2),
              ),
            );

            setState(() {
              _futureOrders = loadCheckouts(user.getUserID()).then((orders) {
                return orders;
              });
            });
            _showConfirmRowMap[order.id] = false;
            return;
          }
        }
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<void> sendConfirmationMessage(String userId, Orders order) async {
    try {
      String message = 'প্রিয় ${order.username},\n'
          'আপনার অর্ডারটি নিশ্চিত করা হয়েছে।\n'
          'অর্ডার: ${order.name}\n'
          'পরিমাণ: ${order.quantity}\n'
          'মূল্য: ${order.amount}\n'
          'বিক্রেতা: ${order.vendor}\n'
          'অর্ডার আইডি: ${order.id}\n'
          'ধন্যবাদ।';

      // Store the message in Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('messages')
          .add({
        'timestamp': FieldValue.serverTimestamp(),
        'message': message,
      });

      print('Confirmation message saved to Firestore');
    } catch (error) {
      print('Failed to save confirmation message to Firestore: $error');
    }
  }


  Future<void> sendCancellationMessage(String userId, Orders order) async {
    try {
      String message = 'প্রিয় ${order.username},\n'
          'আপনার অর্ডারটি বাতিল করা হয়েছে।\n'
          'অর্ডার: ${order.name}\n'
          'পরিমাণ: ${order.quantity}\n'
          'মূল্য: ${order.amount}\n'
          'বিক্রেতা: ${order.vendor}\n'
          'অর্ডার আইডি: ${order.id}\n'
          'ধন্যবাদ।';

      // Store the message in Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('messages')
          .add({
        'timestamp': FieldValue.serverTimestamp(),
        'message': message,
      });

      print('Cancellation message saved to Firestore');
    } catch (error) {
      print('Failed to save cancellation message to Firestore: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAccentColor,
        automaticallyImplyLeading: false,
        leading: const Icon(
          Icons.menu_rounded,
          color: kPrimaryColor,
        ),
        title: Text(
          user.getShopName(),
          style: TextStyle(
            fontFamily: 'Kalpurush',
            color: kPrimaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(FetchPixels.getScale()*16.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => MyProducts(),
                  ),
                );
              },
              child: Icon(
                Icons.assignment_outlined,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Orders>>(
          future: _futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('আপনার কোন পূর্বের অর্ডার নেই'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('আপনার কোন পূর্বের অর্ডার নেই'));
            }
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(FetchPixels.getScale()*8.0),
                  child: Padding(
                    padding: EdgeInsets.all(FetchPixels.getScale()*16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: kSecondaryColor.withOpacity(0.64),
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${englishToBangla("${order.date.day}-${order.date.month}-${order.date.year}")}',
                                  style: TextStyle(
                                    fontFamily: 'Kalpurush',
                                    fontSize: 16,
                                    color: kSecondaryColor.withOpacity(0.64),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getScale()*8, vertical: FetchPixels.getScale()*4),
                              decoration: BoxDecoration(
                                  color: kAccentColor,
                                  borderRadius: BorderRadius.circular(FetchPixels.getScale()*8)
                              ),
                              child: Text(
                                '${order.status}',
                                style: TextStyle(
                                  fontFamily: 'Kalpurush',
                                  fontSize: FetchPixels.getTextScale()*16,
                                  color: kPrimaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Image(
                                image: NetworkImage(order.image),
                                height: FetchPixels.getPixelHeight(100),
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${order.quantity}x ${order.name}',
                                    style: TextStyle(
                                      fontFamily: 'Kalpurush',
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                  Text(
                                    '#${order.id}',
                                    style: TextStyle(
                                      fontFamily: 'Kalpurush',
                                      color: kSecondaryColor.withOpacity(.64),
                                    ),
                                  ),
                                  Text(
                                    'সর্বমোট মূল্য:  ${multiplyBanglaAmounts(order.amount, order.quantity)} টাকা',
                                    style: TextStyle(
                                      fontFamily: 'Kalpurush',
                                      fontSize: FetchPixels.getTextScale()*16,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: FetchPixels.getPixelHeight(16),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'অর্ডারকারীঃ ${order.username}',
                              style: TextStyle(
                                  fontFamily: 'Kalpurush',
                                  color: kSecondaryColor.withOpacity(.64),
                                  fontSize: FetchPixels.getTextScale()*18
                              ),
                            ),
                            Text(
                              'অর্ডারকারীর ফোনঃ ${order.userPhone}',
                              style: TextStyle(
                                  fontFamily: 'Kalpurush',
                                  color: kSecondaryColor.withOpacity(.64),
                                  fontSize: FetchPixels.getTextScale()*16
                              ),
                            ),
                            if (_showConfirmRowMap[order.id] ?? false)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'অর্ডার কনফার্ম করুন?',
                                    style: TextStyle(
                                      fontFamily: 'Kalpurush',
                                      color: kSecondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: FetchPixels.getTextScale() * 16,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await updateOrderStatus(Usermodel().getUserID(), order, 'কনফার্ম');
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          'হ্যাঁ',
                                          style: TextStyle(
                                            fontFamily: 'Kalpurush',
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: FetchPixels.getTextScale() * 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await updateOrderStatus(Usermodel().getUserID(), order, 'বাতিল');
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.not_interested,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'না',
                                          style: TextStyle(
                                            fontFamily: 'Kalpurush',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: FetchPixels.getTextScale() * 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
