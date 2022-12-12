import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/inner_screens/chat_screen.dart';
import 'package:grocery_admin_panel/loginScreen.dart';
import 'package:grocery_admin_panel/providers/orders_provider.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:grocery_admin_panel/widgets/grid_products.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'controllers/MenuController.dart';
import 'inner_screens/add_prod.dart';
import 'providers/dark_theme_provider.dart';

// import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? FirebaseOptions(
      apiKey: "AIzaSyBInAJAzZewnS-CfO09jPp_puPCd68GVJ8",
      appId: "1:1060189432399:web:86dad31ad27004c7ab983a",
      messagingSenderId: "1060189432399",
      projectId: "capstone2-9e98b",
      storageBucket: "capstone2-9e98b.appspot.com",
    )
        : null,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Center(
                child: Text('App is being initialized'),
              ),
            ),
          ),

        );
      } else if (snapshot.hasError) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Center(
                child: Text('An error has been occured ${snapshot.error}'),
              ),
            ),
          ),
        );
      }
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MenuController(),
          ),
          ChangeNotifierProvider(
            create: (_) => OrdersProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) {
              return themeChangeProvider;
            },
          ),
        ],
        child: Consumer<DarkThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Green Market',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home:  LoginPage(),
                routes: {
                  UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),


                }
                );
          },

        ),
      );
    });
  }
}
