import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCategoriesMain extends StatefulWidget {
  SubCategoriesMain({Key? key}) : super(key: key);

  @override
  _SubCategoriesMainState createState() => _SubCategoriesMainState();
}

class _SubCategoriesMainState extends State<SubCategoriesMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Color(0xFF007251),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image(
                          width: MediaQuery.of(context).size.width * 0.10,
                          image: AssetImage("assets/images/study.png"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Text("SUB CATEGORY",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            )));
  }
}
