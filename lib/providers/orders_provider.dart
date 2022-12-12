import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import '../models/orderModel.dart';


class OrdersProvider with ChangeNotifier {

  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .where('userId')
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
         0,
          OrderModel(
            orderId: element.get('orderId'),
            userId: element.get('userId'),
            productId: element.get('productId'),
            userName: element.get('userName'),
            price: element.get('price').toString(),
            imageUrl: element.get('imageUrl'),
            quantity: element.get('quantity').toString(),
            cancelled: element.get('cancelled'),
            delivered: element.get('delivered'),
            orderDate: element.get('orderDate'),
            orderRecieved: element.get('orderRecieved'),
          ),
        );
      });
    });
    _orders.sort((a,b) {
      var adate = a.orderDate; //before -> var adate = a.expiry;
      var bdate = b.orderDate;//var bdate = b.expiry;
      return -adate.compareTo(bdate);
    });
    notifyListeners();
  }

  OrderModel findOrderById(String orderId) {
    return _orders.firstWhere((element) => element.orderId == orderId);
  }
 /* Future<void> cancel() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userCart': [],
    });
    _cartItems.clear();
    notifyListeners();
  }
*/

}
