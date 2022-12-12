import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/orders_list.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  TextEditingController textControll = TextEditingController(text: "");
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
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
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller: textControll,
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: Theme.of(context).cardColor,
                          filled: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {

                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding * 0.75),
                              margin:  EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                     /* Header(showTexField: false,
                        fct: () {
                          context.read<MenuController>().controlAllOrder();
                        },
                      ),*/
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Order No.',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Customer Name',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Delivery Option',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Shipping Address',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Total Price',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Date Ordered',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Status',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child:  Text(
                                        'Actions',
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                          fontSize:queryData.size.width /120,
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                           /*     TextWidget(text:'Order No.', color: color, textSize: 20),
                                  TextWidget(text:'Customer Name', color: color, textSize: 20),
                                  TextWidget(text:'No. of Products', color: color, textSize: 20),
                                  TextWidget(text:'Total', color: color, textSize: 20),
                                  TextWidget(text:'Shipping Address', color: color, textSize: 20),
                                  TextWidget(text:'Date', color: color, textSize: 20),
                                  TextWidget(text:'Status', color: color, textSize: 20),
                                  TextWidget(text:'Actions', color: color, textSize: 20),*/



                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                      ),

                      OrdersList(
                        isInDashboard: false, scrollController: scrollController, passText: textControll,
                      ),
                    ],
                  ),
                )),

          ],
        ),
      ),
    );
  }
}
