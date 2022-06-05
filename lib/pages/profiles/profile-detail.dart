import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/components/perloader-page.dart';
import 'package:flutter_app_stulish/pages/friend_list/all_user-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  User user = new User();
  bool _isLoad = true;
  AssetImage getBorder(String level) {
    if (level == "Emperor") {
      return AssetImage("assets/images/1-emperor.png");
    } else if (level == "King") {
      return AssetImage("assets/images/2-king.png");
    } else if (level == "Duke") {
      return AssetImage("assets/images/3-duke.png");
    } else if (level == "Prince") {
      return AssetImage("assets/images/4-prince.png");
    } else if (level == "Knight") {
      return AssetImage("assets/images/5-knight.png");
    } else {
      return AssetImage("assets/images/6-citizen.png");
    }
  }

  void getUser() async {
    final String uri = dotenv.get('API_URL') +
        "/api/v1/getDetailUser?user_id=" +
        widget.user.id.toString();
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
        _isLoad = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoad) {
      return PreloaderPage();
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg-rounded.png"),
                    fit: BoxFit.cover)),
            child: Center(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                top: displayHeight(context) * 0.042),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              maxRadius: displayWidth(context) * 0.126,
                              backgroundImage: user.photo == null
                                  ? AssetImage(
                                      "assets/images/user_icon_big.png")
                                  : AssetImage(user.photo.toString()),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              maxRadius: displayWidth(context) * 0.215,
                              backgroundImage: getBorder(user.level),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          user.name,
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
                          user.level,
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
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 9),
                                blurRadius: 10,
                                spreadRadius: 1),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Image(
                                width: 120.0,
                                image:
                                    AssetImage("assets/images/kindem-logo.png"),
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
          ),
        ),
      );
    }
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
                user.complete_sub_category.toString(),
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
                user.point.toString(),
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
              return AllUser();
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
            int count = 2;
            Navigator.of(context).popUntil((_) => count-- <= 0);
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
