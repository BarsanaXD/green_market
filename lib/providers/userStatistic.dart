import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserStats {
  final int users;
  final DateTime createdAt;


  UserStats(
      {
        required this.users,
        required this.createdAt
      });
}
