import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../inner_screens/all_products.dart';
import '../inner_screens/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String tips = '';
  String description = '';
  String productCat = '';
  String? imageUrl;
  String stocks = '';
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;
  bool isBestSeller = false;

  @override
  void initState() {
    getProductsData();
    super.initState();
  }
/* void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }*/
  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        // Add if mounted here
        if (mounted) {
          setState(() {
            title = productsDoc.get('title');
            productCat = productsDoc.get('productCategoryName');
            tips = productsDoc.get('tips');
            description = productsDoc.get('description');
            imageUrl = productsDoc.get('imageUrl');
            price = productsDoc.get('price');
            stocks = productsDoc.get('stocks');
            salePrice = productsDoc.get('salePrice');
            isOnSale = productsDoc.get('isOnSale');
            isPiece = productsDoc.get('isPiece');
            isBestSeller = productsDoc.get('isBestSeller');
          });
        }
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  id: widget.id,
                  title: title,
                  price: price,
                  description: description,
                  tips: tips,
                  salePrice: salePrice,
                  stocks: stocks,
                  productCat: productCat,
                  imageUrl: imageUrl == null
                      ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                      : imageUrl!,
                  isOnSale: isOnSale,
                  isPiece: isPiece,
                  isBestSeller: isBestSeller,
                ),
              ),
            );
          },
          child: Card(
            color: Theme.of(context).canvasColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     /* Row(

                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const AllProductsScreen()));
                                  },
                                  child: const Text('Edit'),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  value: 2,
                                ),
                              ]),
                        ],
                      ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Image.network(
                              imageUrl == null
                                  ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                                  : imageUrl!,
                              fit: BoxFit.fill,
                              // width: screenWidth * 0.12,
                              height: size.width < 760 ? size.width * 0.23 :size.width * 0.09,
                            ),

                          ),

                        ],
                      ),

                      Row(
                        children: [
                          TextWidget(
                            text: isOnSale
                                ? '\₱${salePrice.toStringAsFixed(2)}'
                                : '\₱$price',
                            color: color,
                            textSize: 18,
                          ),

                          Visibility(
                              visible: isOnSale,
                              child: Text(
                                '\₱$price',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: color),
                              )),
                          const Spacer(),
                          TextWidget(
                            text: isPiece ? 'Piece' : '1Kg',
                            color: color,
                            textSize: 18,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              child:  Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(
                                  fontSize:20,
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    /*  TextWidget(
                        text: ,
                        color: color,
                        textSize: size.width * 0.02,
                        isTitle: true,
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
