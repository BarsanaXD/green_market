import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderSales {
  final num price;
  final DateTime orderDate;


  OrderSales(
      {
        required this.price,
        required this.orderDate
      });
}
