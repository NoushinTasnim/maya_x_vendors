import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/order.dart';
import '../model/product.dart';

Future<List<Orders>> loadCheckouts(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  print("ss"+userId);
  CollectionReference usersRef = firestore.collection('vendor').doc(userId).collection('orders');

  List<Orders> orders = [];
  try{
    QuerySnapshot ordersSnapshot = await usersRef.get();
    print("Fetched checkout documents: ${ordersSnapshot.docs.length}"); // Debug statement

      for (var orderDetailDoc in ordersSnapshot.docs) {
        Map<String, dynamic> orderData = orderDetailDoc.data() as Map<String, dynamic>;
        Orders order = Orders(
          id: orderData['id'],
          name: orderData['name'],
          quantity: orderData['quantity'],
          image: orderData['image'],
          date: (orderData['date'] as Timestamp).toDate(),
          amount: orderData['amount'],
          vendor: orderData['vendor'],
          status: orderData['status'],
          username: orderData['userName'],
          userPhone: orderData['userPhoneNumber'],
        );
        print("Order fetched: ${order.name}"); // Debug statement
        orders.add(order);
      }
    print("Orders loaded successfully!");
  } catch (e) {
    print("Failed to load orders: $e");
  }

  return orders;
}


Future<List<Product>> loadMyOrders(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  print("ss"+userId);
  CollectionReference usersRef = firestore.collection('vendors').doc(userId).collection('products');

  List<Product> msgs = [];

  try {
    QuerySnapshot messagesSnapshot = await usersRef.get();
    print("Fetched message documents: ${messagesSnapshot.docs.length}"); // Debug statement

    for (var messageDoc in messagesSnapshot.docs) {
      Map<String, dynamic> messageData = messageDoc.data() as Map<String, dynamic>;
      print("Fetched message: ${messageData['id']}"); // Debug statement

      Product msg = Product.fromJson(messageData);

      msgs.add(msg);
      print("Message Date: ${msg.amount}"); // Debug statement
    }
  } catch (e) {
    print("Failed to load messages: $e");
  }
  return msgs;
}