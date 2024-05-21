class Product {
  final int index;
  final String name;
  final String amount;
  final String image;

  Product({
    required this.index,
    required this.name,
    required this.amount,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      index: json['index'],
      name: json['name'],
      amount: json['amount'],
      image: json['image'],
    );
  }
}