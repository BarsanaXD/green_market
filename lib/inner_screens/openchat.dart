import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Screens/loading_manager.dart';
import 'package:grocery_admin_panel/controllers/MenuController.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:grocery_admin_panel/widgets/header.dart';
import 'package:grocery_admin_panel/widgets/side_menu.dart';
import 'package:provider/provider.dart';
import '../message/chat_list.dart';
import '../message/chatpage.dart';
import '../responsive.dart';


class OpenChatScreen extends StatefulWidget {
  const OpenChatScreen(
      {Key? key,
      required this.email,
      required this.recieved,
        required this.id,
      })
      : super(key: key);

  final String email,recieved,id;

  @override
  _OpenChatScreenState createState() => _OpenChatScreenState();
}

class _OpenChatScreenState extends State<OpenChatScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _recieved;
  bool _isLoading = false;
  @override
  void initState() {
    _email = widget.email;
    _recieved = widget.recieved;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
     key: context.read<MenuController>().getopenMessageScaffoldKey,
     drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        if (Responsive.isDesktop(context))
        const Expanded(
        child: SideMenu(),
        ),
          Expanded(
            // It takes 5/6 part of the screen
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(50),
                controller: ScrollController(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ChatList(isInDashboard: false,)
                  ],
                ),
              )
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                chatpage(email: widget.email,reciever: widget.recieved, id: widget.id,)

              ],
            ),
          )
        ],
     ),

    ),
    );
  }

}
