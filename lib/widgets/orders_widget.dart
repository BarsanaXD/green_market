import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:intl/intl.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '../services/global_method.dart';
import 'bundledWidget.dart';
import 'text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget(
      {Key? key,
        required this.orderId,
        required this.userId,
        required this.total,
        required this.totalCart,
        required this.totalSavings,
        required this.deliveryfee,
        required this.deliveryOption,
        required this.userName,
        required this.shipping,
        required this.cancelled,
        required this.delivered,
        required this.orderDate,
        required this.orderRecieved,

      })
      : super(key: key);
  final String orderId, userId, userName,shipping,deliveryOption;
  final Timestamp orderDate,orderRecieved;
  final double total, totalSavings,deliveryfee,totalCart;
  final bool cancelled, delivered;
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}
class _OrdersWidgetState extends State<OrdersWidget> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();
  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateStr = '${DateFormat.yMEd().add_jms().format(postDate)} ';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    bool pending = false;
    if(widget.cancelled == false && widget.delivered == false){
  pending=true;
    }else{
      pending = false;
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ExpansionTileCard(
        key: cardA,
        title: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  child:  Text(
                    '${widget.orderId}',
                    style:  TextStyle(
                      fontSize:queryData.size.width /120,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: color,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  child:  Text(
                    '${widget.userName}',
                    style:  TextStyle(
                      fontSize:queryData.size.width /120,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: color,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  child:  Text(
                    '${widget.deliveryOption}',
                    style:  TextStyle(
                      fontSize:queryData.size.width /120,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: color,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  child:  Text(
                    '${widget.shipping}',
                    style:  TextStyle(
                      fontSize:queryData.size.width /120,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: color,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  child:  Text(
                    '₱${widget.total}',
                    style:  TextStyle(
                      fontSize:queryData.size.width /120,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: color,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  child:  Text(
                    '${orderDateStr}',
                    style:  TextStyle(
                      fontSize:queryData.size.width /120,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: color,
              ),
              Visibility(
                visible: widget.cancelled ? true:false,
                child:   Flexible(
                  child: Container(
                    color: Colors.red,
                    width: double.infinity,
                    child:  Text(
                      'Cancelled',
                      style:  TextStyle(
                        fontSize:queryData.size.width /120,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.delivered ? true:false,
                child:   Flexible(
                  child: Container(
                    color: Colors.blue,
                    width: double.infinity,
                    child:  Text(
                      'Delivered',

                      style:  TextStyle(
                        fontSize:queryData.size.width /120,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: pending? true:false,
                child:   Flexible(
                  child: Container(
                    color: Colors.yellow,
                    width: double.infinity,
                    child:  Text(
                      'Pending',

                      style:  TextStyle(
                        fontSize:queryData.size.width /120,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: color,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  child:  Visibility(
                    visible: widget.cancelled || widget.delivered ? false:true,
                    child: Material(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 20,color: color),
                        ),
                        onPressed: () async {
                          GlobalMethods.warningDialog(
                              title: 'Deliver?',
                              subtitle: 'Press okay to confirm',
                              fct: () async {
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(widget.orderId)
                                    .update(
                                    {
                                      'orderRecieved':Timestamp.now(),
                                      'delivered': true,
                                      'cancelled': false,
                                    }
                                );
                                await Fluttertoast.showToast(
                                  msg: "Order has been Delivered",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                );
                                while (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              context: context);

                        },
                        child: TextWidget(text:'Deliver', color: color, textSize: 20),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child:StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        alignment: FractionalOffset.center,
                        child: CircularProgressIndicator());
                  }
                  else{
                    int arrayLength = snapshot.data!['bundle'].length;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        return Container(
                       
                          decoration: BoxDecoration(

                            borderRadius: const BorderRadius.all(Radius.circular(0)),
                          ),
                          child: ListView.builder(
                              controller: ScrollController(),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: arrayLength,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    bundleWidget(
                                      imageUrl: snapshot.data!['bundle'][index]['imageUrl'],
                                      title: snapshot.data!['bundle'][index]['title'],
                                      price: snapshot.data!['bundle'][index]['price'],
                                      quantity: snapshot.data!['bundle'][index]['quantity'],
                                      productId: snapshot.data!['bundle'][index]['productId'],
                                      isOnSale: snapshot.data!['bundle'][index]['isOnSale'],
                                    ),

                                    const Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              }
                          ),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text('Your store is empty'),
                          ),
                        );
                      }
                    }
                    return const Center(
                      child: Text(
                        'Something went wrong',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    );
                  }

                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    TextWidget(
                      text:
                      '${widget.deliveryOption}',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                    ),
                    Spacer(),
                    TextWidget(
                      text:
                      '₱${widget.deliveryfee.toStringAsFixed(2)}',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextWidget(
                      text:
                      'Cart Total',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                    ),
                    Spacer(),
                    TextWidget(
                      text:
                      '₱${widget.totalCart.toStringAsFixed(2)}',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextWidget(
                      text:
                      'Savings',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                    ),
                    Spacer(),
                    TextWidget(
                      text:
                      '-₱${widget.totalSavings.toStringAsFixed(2)}',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextWidget(
                      text:
                      'Final Price',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                      isTitle: true,
                    ),
                    Spacer(),
                    TextWidget(
                      text:
                      '₱${widget.total.toStringAsFixed(2)}',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                      isTitle: true,
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
