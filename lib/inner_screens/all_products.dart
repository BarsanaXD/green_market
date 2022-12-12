import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';
import 'add_prod.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  TextEditingController textControll = TextEditingController(text: "");
  ScrollController scrollController = ScrollController();

  void initState(){

    super.initState();
  }

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
                   /*   Header(

                        fct: () {
                          context.read<MenuController>().controlProductsMenu();
                        },
                      ),*/
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            ButtonsWidget(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UploadProductForm(),
                                    ),
                                  );
                                },
                                text: 'Add product',
                                icon: Icons.add,
                                backgroundColor: Colors.blue),
                          ],
                        ),
                      ),
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: false, passText: textControll,
                          scrollController: scrollController,
                        ),
                        desktop: ProductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false, passText: textControll,
                          scrollController: scrollController,
                        ),
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
