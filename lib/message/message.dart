import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../services/utils.dart';

class messages extends StatefulWidget {

  const messages({Key? key, required this.email,required this.reciever}): super(key: key);
 final String email,reciever;
  @override
  _messagesState createState() => _messagesState();
}

class _messagesState extends State<messages> {

/*  Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('Messages')
      .orderBy('time')
      .snapshots();*/
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Messages')
          .where('request',isEqualTo: '${widget.reciever}${widget.email}')
          .orderBy('time')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemBuilder: (_, index) {
            QueryDocumentSnapshot qs = snapshot.data!.docs[index];
            Timestamp t = qs['time'];
            DateTime d = t.toDate();
            String time = '${DateFormat.jm().format(d)} ';
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: widget.email == qs['email']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _isDark ? Theme.of(context).cardColor : Color(
                            0xFFBFE5B6),
                      ),
                      child: ListTile(

                        title:
                        Text(
                          qs['message'],
                          softWrap: true,
                          style: TextStyle(
                            color: color,
                            fontSize: 15,
                          ),
                        ),

                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                qs['email'],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              time,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
