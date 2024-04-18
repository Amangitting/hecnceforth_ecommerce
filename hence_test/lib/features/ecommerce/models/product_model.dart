import 'dart:convert';

class Product {
  double price;
  String description;
  String name;
  String category;

  Product({
    required this.price,
    required this.description,
    required this.name,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      price: json['price'] ?? 0.0,
      description: json['description'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'description': description,
      'name': name,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Product{name: $name, price: $price, description: $description, category: $category}';
  }
}
