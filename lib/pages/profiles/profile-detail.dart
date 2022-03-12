import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/pages/friend_list/friend_list-main.dart';
import 'package:flutter_app_stulish/pages/home/home-main.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0074CD),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage("assets/images/user_icon_big.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "CITIZEN/RAKYAT BIASA (LVL1)",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: displayWidth(context) * 40,
                  height: displayHeight(context) * 0.60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 9),
                          blurRadius: 20,
                          spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image(
                          width: 120.0,
                          image: AssetImage("assets/images/kindem-logo.png"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 18.0,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        // color: Colors.red,
                        child: Column(
                          children: [
                            ResultDetail(),

                            //button
                            Container(
                              margin: EdgeInsets.only(top: 35),
                              child: Button(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ResultDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: displayWidth(context) * 0.35,
          height: displayHeight(context) * 0.19,
          padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.01),
          decoration: BoxDecoration(
            color: Color(0xFFF5A720),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: Offset(0, 9),
                  blurRadius: 8,
                  spreadRadius: 1),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "12",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36.2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: displayHeight(context) * 0.015),
                child: Text(
                  "Materi yang diselesaikan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    // fontSize: 36.4,
                  ),
                ),
              ),
            ],
          ),
          // Text("25"),
        ),
        Container(
          width: displayWidth(context) * 0.35,
          height: displayHeight(context) * 0.19,
          padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.01),
          decoration: BoxDecoration(
            color: Color(0xFFF5A720),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: Offset(0, 9),
                  blurRadius: 8,
                  spreadRadius: 1),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "40",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36.2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: displayHeight(context) * 0.015),
                child: Text(
                  "Exp yang didapatkan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    // fontSize: 36.4,
                  ),
                ),
              ),
            ],
          ),
          // Text("25"),
        ),
      ],
    );
  }

  Widget Button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BouncingWidget(
          duration: Duration(milliseconds: 90),
          scaleFactor: 2.0,
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return FriendList();
            }));
          },
          child: Container(
            width: displayWidth(context) * 0.35,
            padding:
                EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
            // height: displayHeight(context) * 0.04,
            // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            // margin: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xFFF5A720),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    offset: Offset(2, 6),
                    blurRadius: 7,
                    spreadRadius: 2),
              ],
            ),
            child: Text(
              "KEMBALI",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        BouncingWidget(
          duration: Duration(milliseconds: 90),
          scaleFactor: 2.0,
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return HomeMain();
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
          child: Container(
            width: displayWidth(context) * 0.35,
            // margin: EdgeInsets.symmetric(horizontal: 6),
            padding:
                EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
            decoration: BoxDecoration(
              color: Color(0xFFF5A720),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    offset: Offset(2, 6),
                    blurRadius: 7,
                    spreadRadius: 2),
              ],
            ),
            child: Text(
              "HOME",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
