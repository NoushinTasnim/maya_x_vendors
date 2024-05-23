import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/order.dart';

Future<void> updateOrder(String userId, Orders order) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  print(userId);
  CollectionReference ordersRef = firestore.collection('vendor').doc(userId).collection('orders');

  try {
    await ordersRef.doc(order.id).update(order.toJson());
    print("Order updated successfully!");
  } catch (e) {
    print("Failed to update order: $e");
  }
}