import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId, userId, productId, userName, price, imageUrl, quantity;
  final Timestamp orderDate,orderRecieved;
  final bool cancelled, delivered;

  OrderModel(
      {required this.orderId,
        required this.userId,
        required this.productId,
        required this.userName,
        required this.price,
        required this.imageUrl,
        required this.cancelled,
        required this.delivered,
        required this.quantity,
        required this.orderDate,
        required this.orderRecieved});
}
