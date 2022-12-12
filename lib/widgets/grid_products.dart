import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/services/utils.dart';

import '../consts/constants.dart';
import 'products_widget.dart';

class ProductGridWidget extends StatefulWidget{

  ProductGridWidget(
      {Key? key, required this.passText,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true,
      required this.scrollController})
      : super(key: key);
  final int crossAxisCount;
  final TextEditingController passText;
  final double childAspectRatio;
  final bool isInMain;
  final ScrollController scrollController;

  @override
  State<ProductGridWidget> createState() => _ProductGridWidgetState();
}

class _ProductGridWidgetState extends State<ProductGridWidget> {
bool searchOn = false;
String searchTexts = '';
List<DocumentSnapshot> documents = [];
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
        .collection('products')
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
      stream: FirebaseFirestore.instance.collection('products').snapshots(),

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
                  .get('title')
                  .toString()
                  .toLowerCase()
                  .contains(searchTexts.toLowerCase());
            }).toList();
          }else{
            searchOn = false;
          }


          documents.sort((a,b) {
            var bdate = b.get('title');
            var adate = a.get('title'); //before -> var adate = a.expiry;
           //var bdate = b.expiry;
            return -bdate.compareTo(adate);
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
          return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: documents.length ,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.childAspectRatio,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
              ),
              itemBuilder: (context, index) {
                return ProductWidget(
                  id: documents[index]['id'],
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
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              return Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator());
              default:
                return GridView.builder(
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
                );
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
            .collection('products')
            .orderBy('title')
            .limit(12)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .orderBy('title')
            .startAfterDocument(_products[_products.length - 1])
            .limit(12)
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
}