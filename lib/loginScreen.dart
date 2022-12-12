
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.indigo.shade600
              ]
          )

      ),
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            color: Colors.red,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),

                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(0, 3), blurRadius: 24)
                  ]),
              height: 400,
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(text: "LOGIN", color: Colors.black,),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: TextField(
                          controller:  _emailController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              icon: Icon(Icons.email_outlined)
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              icon: Icon(Icons.lock_open)
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),

                  Padding(
                    padding: const EdgeInsets.only(right:20),
                    child: InkWell(
                      onTap: (){
                        print('NatapSiya');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextWidget(text: "Forgot password?",color: Colors.grey, ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.indigo
                      ),
                      child: FlatButton(
                        onPressed: ()async{
                          try{
                            await FirebaseFirestore.instance.collection("admin").doc("admin_login").snapshots().forEach((element) {
                              if(element.data()?['admin_email'] == _emailController.text && element.data()?['admin_password']== _passwordController.text){
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=> MainScreen()));
                              }
                            }).catchError((e){
                              showDialog(context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text("Error Message"),
                                      content: Text(e.toString()),
                                    );
                                  });
                            });
                          }catch(e){
                            Navigator.pop(context);
                          showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("Error Message"),
                                  content: Text(e.toString()),
                                );
                              });


                          }


                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:4),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget(text: "LOGIN", color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
