import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/commentWidget.dart';

import '../consts/constants.dart';
import 'orders_widget.dart';

class commentList extends StatelessWidget {
  const commentList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('feedback').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator());
        }
        else{
          var list = snapshot.data!.docs.toList();
          list.sort((a,b) {
            var adate = a.get('timestamp');
            var bdate = b.get('timestamp');
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
                    controller: ScrollController(),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: isInDashboard && snapshot.data!.docs.length > 4
                        ? 4
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          commentWidget(
                              comment: list[index]['comment'],
                              id: list[index]['comment'],
                              name: list[index]['name'],
                              image: list[index]['image'],
                              rating: list[index]['rating'],
                              timestamp: list[index]['timestamp'],
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
    );
  }
}
