import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/inner_screens/openchat.dart';
import 'package:grocery_admin_panel/message/chatpage.dart';
import 'package:grocery_admin_panel/message/message.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:intl/intl.dart';
import '../inner_screens/chat_screen.dart';
import '../services/global_method.dart';
import '../widgets/text_widget.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget(
      {Key? key,
        required this.name,
        required this.date,
        required this.message,
        required this.id,
        required this.email,
        required this.image,
      })
      : super(key: key);
  final String name,message,id,email,image;
  final Timestamp date;
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.date.toDate();
    orderDateStr = '${DateFormat.yMEd().add_jms().format(postDate)} ';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return InkWell(

      onTap: () {

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OpenChatScreen(
              email: 'admin@gmail.com',
              recieved: widget.email,
              id: widget.id,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Card(
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: CircleAvatar(
                    radius: queryData.size.width / 40,
                    backgroundColor: color,
                    child: ClipOval(
                        child: (widget.image == null || widget.image == '') ? Image.network('https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000',
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,):
                        Image.network(
                          '${widget.image}',
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        )
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              child:  Text(
                                '${widget.name}',
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(
                                  fontSize:20,
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        /*  TextWidget(text: '${widget.name}: ', color: color,textSize: 16,),
                          TextWidget(
                            text:
                            '${widget.message}',
                            *//*   '${widget.quantity}X For \₱${widget.price.toStringAsFixed(2)}',*//*
                            color: color,
                            textSize: 16,
                            isTitle: true,
                          ),*/
                          Flexible(
                            child: Container(
                              child:  Text(
                                '${orderDateStr}',
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(
                                  fontSize:20,
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                         /* TextWidget(text: , color: color,textSize: 20)*/
                        ],
                      ),
                      Text(
                        '${widget.message}',
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          fontSize: 18,
                          color: color,
                        ),
                      ),


                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
