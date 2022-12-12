import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../consts/constants.dart';
import 'chat_widget.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator());
        }
        else{ // if snapshot has data this is going to run
          var list = snapshot.data!.docs.toList();
          list.sort((a,b) {
            var adate = a.get('lastMessageDate'); //before -> var adate = a.expiry;
            var bdate = b.get('lastMessageDate');//var bdate = b.expiry;
            return -adate.compareTo(bdate);
          });
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                    itemCount: isInDashboard && snapshot.data!.docs.length > 4
                        ? 4
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          ChatWidget(
                            name: list[index]['name'],
                            id: list[index]['id'],
                            email: list[index]['email'],
                            message: list[index]['lastMessage'],
                            date: list[index]['lastMessageDate'],
                            image: list[index]['image'],
                          ),
                          const Divider(
                            thickness: 3,
                          ),
                        ],
                      );
                    }),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text('No active user'),
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
