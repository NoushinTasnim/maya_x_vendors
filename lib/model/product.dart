class Product {
  final String id;
  final int index;
  final String name;
  final String amount;
  final String image;
  final String vendor;
  final String details;

  Product({
    required this.id,
    required this.index,
    required this.name,
    required this.amount,
    required this.image,
    required this.vendor,
    required this.details,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      index: json['index'],
      name: json['name'],
      amount: json['amount'],
      image: json['image'],
      vendor: json['vendor'],
      details: json['details'],
    );
  }
}