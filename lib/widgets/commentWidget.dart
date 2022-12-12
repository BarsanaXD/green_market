import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_admin_panel/inner_screens/openchat.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:intl/intl.dart';
import '../widgets/text_widget.dart';

class commentWidget extends StatefulWidget {
  const commentWidget(
      {Key? key,
       required this.comment,
        required this.id,
        required this.name,
        required this.image,
        required this.rating,
        required this.timestamp,
      })
      : super(key: key);
  final String name,comment,image,id;
  final double rating;
  final Timestamp timestamp;
  @override
  _commentWidgetState createState() => _commentWidgetState();
}

class _commentWidgetState extends State<commentWidget> {

  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.timestamp.toDate();
    orderDateStr = '${DateFormat("MMMM dd, yyyy").format(postDate)} ';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    final Size _size = MediaQuery.of(context).size;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      color: Theme.of(context).canvasColor.withOpacity(0.1),
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: CircleAvatar(
                        radius:queryData.size.width /60,
                        backgroundColor: color,
                        child: ClipOval(
                            child: /*(widget.image == null || widget.image == '') ? Image.asset('assets/images/landing/2.png',
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,):*/
                            Image.network(
                              '${widget.image}',
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child:  Text(
                        '${widget.name}',
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          fontSize: queryData.size.width /60,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                child: RatingBar.builder(
                                  initialRating: widget.rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemSize: _size.width <=1400 ? 8:18,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.blue,
                                  ),
                                  onRatingUpdate: (rating) {
                                  },
                                ),
                              ),
                            ),
                            Flexible(child: _size.width <=1400 ?Container(child: Text(
                              '${orderDateStr}',
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                fontSize: 12,
                                color: color,
                              ),
                            ),
                            ) :Container(child: TextWidget(text: '${orderDateStr}', color: color,textSize: 12))
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                width: double.infinity,
                                  child: Text(
                                    '${widget.comment}',
                                    style:  TextStyle(
                                  fontSize: queryData.size.width /60,
                                  color: color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
