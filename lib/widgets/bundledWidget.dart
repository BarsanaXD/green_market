import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class bundleWidget extends StatefulWidget {
  const bundleWidget(
      {Key? key,
        required this.title,
        required this.productId,
        required this.imageUrl,
        required this.quantity,
        required this.price,
        required this.isOnSale,
      })
      : super(key: key);
  final String  productId,imageUrl,title;
  final int quantity;
  final double price;
  final bool isOnSale;
  @override
  _bundleWidgetState createState() => _bundleWidgetState();
}

class _bundleWidgetState extends State<bundleWidget> {

  late String orderDateStr;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    final Size _size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius:
                queryData.size.width /60,
                child: ClipOval(
                    child: /*(widget.image == null || widget.image == '') ? Image.asset('assets/images/landing/2.png',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,):*/
                    Image.network(
                      '${widget.imageUrl}',
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    )
                ),
              ),
            ),
            Container(
              child:  Text(
                '${widget.title}',
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
                  fontSize:
                  queryData.size.width /120,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Visibility(
              visible: widget.isOnSale? true:false,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                      )
                    ]
                ),

                width: 60,
                child:  Material(
                  child: Center(
                    child: Text(
                      'Sale',

                      style:  TextStyle(
                        fontSize:
                        queryData.size.width /120,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child:  Text(
                'Price: ₱${widget.price}',
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
                  fontSize:
                  queryData.size.width /120,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child:  Text(
                'Quantity: ${widget.quantity}',
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
                  fontSize: queryData.size.width /120,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),

      ],
    );
  }
}
