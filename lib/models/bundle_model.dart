import 'package:flutter/cupertino.dart';

class BundleModel with ChangeNotifier {
  final String  productId,imageUrl,title;
  final int quantity;
  final double price;

  BundleModel({
    required this.title,
    required this.productId,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}
