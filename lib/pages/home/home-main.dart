import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/pages/categories/categories-main.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  PageController pageController = new PageController();
  bool isTest = false;
  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 6.0);
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
                  Text(
                    "STULISH",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: Text(
                      "Helo User",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Center(child: StudyCard(isTest: false)),
                  Center(child: TestCard(isTest: true)),
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
