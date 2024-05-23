import 'package:cloud_firestore/cloud_firestore.dart';

class Orders{
  final String id;
  final String username;
  final String userPhone;
  final String name;
  final String quantity;
  final String image;
  final DateTime date;
  final String amount;
  final String vendor;
  final String status;

  Orders({
    required this.username,
    required this.id,
    required this.userPhone,
    required this.name,
    required this.quantity,
    required this.image,
    required this.date,
    required this.amount,
    required this.vendor,
    required this.status,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    print(json['id']);
    return Orders(
      id: json['id'],
      username: json['username'],
      userPhone: json['userPhone'],
      name: json['name'],
      quantity: json['quantity'],
      image: json['image'],
      date: (json['date'] as Timestamp).toDate(),
      amount: json['amount'],
      vendor: json['vendor'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'image': image,
      'date': date,
      'amount': amount,
      'vendor': vendor,
      'status' : status,
    };
  }
}
