import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import 'message.dart';



class chatpage extends StatefulWidget {
  chatpage({Key? key,required this.email,required this.reciever,required this.id}): super(key: key);
 final String email;
  final String reciever,id;
  @override
  _chatpageState createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  final fs = FirebaseFirestore.instance;
  final TextEditingController message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: messages(
                email: widget.email,
                reciever: widget.reciever,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _isDark ? Theme.of(context).cardColor : Color(
                          0xFFBFE5B6),
                      hintText: 'Type your message here',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: _isDark ? Theme.of(context).cardColor : Color(
                            0xFFBFE5B6)),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: _isDark ? Theme.of(context).cardColor : Color(
                            0xFFBFE5B6),),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs.collection('Messages').doc().set({
                        'message': message.text.trim(),
                        'request': '${widget.reciever}${widget.email}',
                        'time': DateTime.now(),
                        'email': widget.email,
                      });
                      FirebaseFirestore.instance.collection('users')
                          .doc(widget.id)
                          .update({
                        'lastMessage': message.text.trim(),
                        'lastMessageDate': DateTime.now()
                      });
                      message.clear();
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ],
        ),

    );
  }
}
