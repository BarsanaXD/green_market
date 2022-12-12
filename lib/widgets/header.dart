import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../consts/constants.dart';
import '../responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          Material(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FlutterIcons.user_alt_faw5s,size: 40,),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, Myranel 👋",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,

                            ), /*Theme.of(context).textTheme.headline6,*/
                          ),
                          Text(
                            "Welcome to your dashboard",
                            style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),
                          ),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
      ],
    );
  }
}

