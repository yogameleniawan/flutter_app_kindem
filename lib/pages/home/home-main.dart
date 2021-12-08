import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/categories/categories-main.dart';
import 'package:flutter_app_stulish/pages/scores/score-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class HomeMain extends StatefulWidget {
  HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  PageController pageController = new PageController();
  bool isTest = false;
  User user = new User();

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 6.0);
    getUser();
  }

  void getUser() async {
    final String uri = "https://stulish-rest-api.herokuapp.com/api/v1/user";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      var users = User.toString(jsonResponse);
      setState(() {
        user = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF007251),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "STULISH",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 20),
                              child: Text(
                                "Helo \n" + user.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Logout",
                                style: TextStyle(color: Color(0xFF007251))),
                          ),
                        ),
                      )
                    ],
                  ),
                  Center(child: StudyCard(isTest: false)),
                  Center(child: TestCard(isTest: true)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ScoreMain(
                              id_user: user.id,
                            );
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image(
                                  width: 150,
                                  image: AssetImage("assets/images/score.jpg"),
                                ),
                                Text(
                                  "View Your Score",
                                  style: TextStyle(
                                      color: Color(0xFF007251),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Lihat Skor Kamu"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StudyCard extends StatelessWidget {
  const StudyCard({Key? key, required this.isTest}) : super(key: key);
  final bool isTest;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 2000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return CategoriesMain(isTest: this.isTest);
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Hero(
        tag: "imageStudy",
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: const EdgeInsets.only(
                top: 40, bottom: 20, right: 100, left: 100),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Flexible(
              child: Column(
                children: [
                  Image(image: AssetImage("assets/images/study.png")),
                  Text(
                    "STUDY",
                    style: TextStyle(
                        color: Color(0xFF007251),
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                  Text(
                    "Belajar",
                    style: TextStyle(color: Color(0xFF007251), fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  const TestCard({Key? key, required this.isTest}) : super(key: key);
  final bool isTest;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return CategoriesMain(isTest: this.isTest);
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          padding:
              const EdgeInsets.only(top: 40, bottom: 20, right: 100, left: 100),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Flexible(
            child: Column(
              children: [
                Image(image: AssetImage("assets/images/test.png")),
                Text(
                  "TEST",
                  style: TextStyle(
                      color: Color(0xFF007251),
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
                Text(
                  "Ujian",
                  style: TextStyle(color: Color(0xFF007251), fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
