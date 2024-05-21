import 'package:maya_x_vendors/model/product.dart';

class Category {
  final int id;
  final String name;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List;
    List<Product> productList = productsFromJson.map((i) => Product.fromJson(i)).toList();

    return Category(
      id: json['id'],
      name: json['name'],
      products: productList,
    );
  }
}
