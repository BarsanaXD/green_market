
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/message/chat_list.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/side_menu.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key,}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}



class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(50),
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      ChatList(isInDashboard: false,)
                    ],
                  ),
                )
            ),


          ],
        ),
      ),
    );
  }
}
