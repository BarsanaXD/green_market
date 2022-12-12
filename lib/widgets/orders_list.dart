import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'orders_widget.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key, this.isInDashboard = true, required this.scrollController, required this.passText}) : super(key: key);
  final bool isInDashboard;
  final ScrollController scrollController;
  final TextEditingController passText;

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  bool searchOn = false;
  String searchTexts = '';
  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> documentss = [];
  final StreamController<List<DocumentSnapshot>> _streamController = StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {

        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if(isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();

    super.initState();
    widget.scrollController.addListener(() {
      double maxScroll = widget.scrollController.position.maxScrollExtent;
      double currentScroll = widget.scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        requestNextPage();
      }
    });
    searchTexts = widget.passText.text;
    widget.passText.addListener(() {
      setState((){
        searchTexts = widget.passText.text;
        if (searchTexts.length >= 0) {
          searchOn = true;
        } else {
          searchOn = false;
        }
      });

    });


  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return searchOn ? StreamBuilder<QuerySnapshot>(
      //there was a null error just add those lines
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) { // if snapshot has no data this is going to run
          return Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator());
        }
        else{
          documents = snapshot.data!.docs.toList();
          if (searchTexts.length > 0) {

            documents = documents.where((element) {
              return element
                  .get('userName')
                  .toString()
                  .toLowerCase()
                  .contains(searchTexts.toLowerCase());
            }).toList();


          }else{
            searchOn = false;
          }


          documents.sort((a,b) {
            var bdate = b.get('orderDate');
            var adate = a.get('orderDate'); //before -> var adate = a.expiry;
            //var bdate = b.expiry;
            return -adate.compareTo(bdate);
          }
          );
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text('Your store is empty'),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              );
            }
          }
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    OrdersWidget(
                      userId: documents[index]['userId'],
                      orderDate: documents[index]['orderDate'],
                      orderId: documents[index]['orderId'],
                      userName: documents[index]['userName'],
                      cancelled: documents[index]['cancelled'],
                      delivered: documents[index]['delivered'],
                      shipping: documents[index]['shippingAddress'],
                      deliveryOption: documents[index]['deliveryOption'],
                      total: documents[index]['totalPrice'],
                      totalCart: documents[index]['totalCart'],
                      orderRecieved: documents[index]['orderRecieved'],
                      totalSavings: documents[index]['totalSavings'],
                      deliveryfee: documents[index]['deliveryFee'],

                    ),
                  ],
                );
              }
          );
        }

      },
    ) :NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {


            /*  if (!snapshot.hasData) { // if snapshot has no data this is going to run

    }
    else{
    documents = snapshot.data!.docs.toList();
    if (searchTexts.length > 0) {
    documents = documents.where((element) {
    return element
        .get('title')
        .toString()
        .toLowerCase()
        .contains(searchTexts.toLowerCase());
    }).toList();*/
            /*    documents = _products;
  if (searchTexts.length > 0) {
    searchOn = true;
    documents = _products.where((element) {
      return element
          .get('title')
          .toString()
          .toLowerCase()
          .contains(searchTexts.toLowerCase());
    }).toList();
  }else{

    searchOn = false;
  }*/

            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {

              case ConnectionState.waiting:
                return Container(
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator());
              default:
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, index) {

                      return Column(
                        children: [
                          OrdersWidget(
                            userId: snapshot.data![index]['userId'],
                            orderDate:snapshot.data![index]['orderDate'],
                            orderId: snapshot.data![index]['orderId'],
                            userName: snapshot.data![index]['userName'],
                            cancelled: snapshot.data![index]['cancelled'],
                            delivered: snapshot.data![index]['delivered'],
                            shipping: snapshot.data![index]['shippingAddress'],
                            deliveryOption: snapshot.data![index]['deliveryOption'],
                            total: snapshot.data![index]['totalPrice'],
                            totalCart: snapshot.data![index]['totalCart'],
                            orderRecieved: snapshot.data![index]['orderRecieved'],
                            totalSavings: snapshot.data![index]['totalSavings'],
                            deliveryfee: snapshot.data![index]['deliveryFee'],
                          ),

                        ],
                      );
                    }
                );
            /*GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:  snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.crossAxisCount,
                      childAspectRatio: widget.childAspectRatio,
                      crossAxisSpacing: defaultPadding,
                      mainAxisSpacing: defaultPadding,
                    ),
                    itemBuilder: (context, index) {
                      return ProductWidget(
                        id:  snapshot.data![index]['id'],
                      );
                    }
                );*/
            }
          },
        )
    );
  }

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (_products.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .limit(8)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .startAfterDocument(_products[_products.length - 1])
            .limit(8)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        }  else {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }
 /* @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator());
        }
        else{
          var list = snapshot.data!.docs.toList();
          list.sort((a,b) {
            var adate = a.get('orderRecieved');
            var bdate = b.get('orderRecieved');
            return -adate.compareTo(bdate);
          });
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(

                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                ),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.isInDashboard && snapshot.data!.docs.length > 4
                        ? 4
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          OrdersWidget(
                            price: list[index]['price'],
                            totalPrice: list[index]['totalPrice'],
                            productId: list[index]['productId'],
                            userId: list[index]['userId'],
                            quantity: list[index]['quantity'],
                            orderDate: list[index]['orderDate'],
                            orderId: list[index]['orderId'],
                            imageUrl: list[index]['imageUrl'],
                            userName: list[index]['userName'],
                            cancelled: list[index]['cancelled'],
                            delivered: list[index]['delivered'],
                          ),
                          const Divider(
                            thickness: 3,
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
    );
  }*/
}
